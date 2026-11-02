using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class Login : Page
    {
        public string RequestedRole { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // If already logged in, redirect directly to role dashboard
            if (AuthHelper.CheckAndRestoreSession(Context))
            {
                string existingRole = Session["Role"] != null ? Session["Role"].ToString() : "";
                if (!string.IsNullOrEmpty(existingRole))
                {
                    Response.Redirect(AuthHelper.GetRoleDashboardUrl(existingRole));
                    return;
                }
            }

            string roleParam = Request.QueryString["role"];
            if (!string.IsNullOrEmpty(roleParam) && roleParam.Equals("advertiser", StringComparison.OrdinalIgnoreCase))
            {
                RequestedRole = "advertiser";
            }
            else if (!string.IsNullOrEmpty(roleParam) && roleParam.Equals("admin", StringComparison.OrdinalIgnoreCase))
            {
                RequestedRole = "admin";
            }
            else
            {
                RequestedRole = "influencer";
            }

            if (!IsPostBack)
            {
                if (RequestedRole == "advertiser")
                {
                    lblRoleBadge.Text = "🏢 Brand &amp; Advertiser Login";
                    litTitle.Text = "Sign In as Advertiser";
                    litSubtitle.Text = "Manage your brand campaigns, creator partnerships, and analytics.";
                    lblEmailLabel.Text = "Work / Business Email";
                    txtEmail.Attributes["placeholder"] = "contact@technova.io";
                    btnLogin.Text = "Sign In as Advertiser →";
                    litSwitchRole.Text = "Are you a Creator? <a href='Login.aspx?role=influencer' style='font-weight:600; color:var(--purple-primary);'>Sign in as Influencer</a>";
                    litSignupLink.Text = "Don't have an account? <a href='Signup.aspx?role=advertiser' style='font-weight:600; color:var(--purple-primary);'>Join as Advertiser</a>";
                }
                else if (RequestedRole == "admin")
                {
                    lblRoleBadge.Text = "🛡️ Platform Admin Login";
                    litTitle.Text = "Admin Portal Sign In";
                    litSubtitle.Text = "Sign in with your verified administrator credentials.";
                    lblEmailLabel.Text = "Admin Email Address";
                    txtEmail.Attributes["placeholder"] = "arviantala18@gmail.com";
                    btnLogin.Text = "Sign In to Admin Portal →";
                    litSwitchRole.Text = "<a href='Login.aspx' style='font-weight:600; color:var(--purple-primary);'>← Back to Main Marketplace Login</a>";
                    litSignupLink.Text = "";
                }
                else
                {
                    lblRoleBadge.Text = "⭐ Influencer &amp; Creator Login";
                    litTitle.Text = "Sign In as Influencer";
                    litSubtitle.Text = "Explore brand deals, collaborate seamlessly, and track your revenue.";
                    lblEmailLabel.Text = "Email Address";
                    txtEmail.Attributes["placeholder"] = "riddhi.creates@example.com";
                    btnLogin.Text = "Sign In as Influencer →";
                    litSwitchRole.Text = "Are you a Brand / Advertiser? <a href='Login.aspx?role=advertiser' style='font-weight:600; color:var(--purple-primary);'>Sign in as Advertiser</a>";
                    litSignupLink.Text = "Don't have an account? <a href='Signup.aspx?role=influencer' style='font-weight:600; color:var(--purple-primary);'>Join as Influencer</a>";
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            lblError.Text = "";

            if (!Page.IsValid)
            {
                return;
            }

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            try
            {
                DataTable dt = DbHelper.ExecuteDataTable(
                    "SELECT UserID, FullName, Email, PasswordHash, Role, Status FROM Users WHERE Email = @email",
                    new SqlParameter("@email", email)
                );

                if (dt.Rows.Count == 0)
                {
                    ShowError("Invalid email or password. Please try again.");
                    return;
                }

                DataRow userRow = dt.Rows[0];
                int userId = Convert.ToInt32(userRow["UserID"]);
                string fullName = userRow["FullName"].ToString();
                string userEmail = userRow["Email"].ToString();
                string storedHash = userRow["PasswordHash"] != DBNull.Value ? userRow["PasswordHash"].ToString() : "";
                string role = userRow["Role"].ToString();
                string status = userRow["Status"].ToString();

                bool needsUpgrade = false;
                bool isPasswordValid = AuthHelper.VerifyPassword(password, storedHash, out needsUpgrade);

                if (!isPasswordValid)
                {
                    ShowError("Invalid email or password. Please try again.");
                    return;
                }

                if (!status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                {
                    ShowError("Your account is currently " + status + ". Please contact platform administration.");
                    return;
                }

                // If user had legacy plaintext password in DB, upgrade to secure SHA-256 hash automatically
                if (needsUpgrade)
                {
                    AuthHelper.UpgradePasswordHash(userId, password);
                }

                // Log user in and initialize session
                AuthHelper.LoginUser(Context, userId, userEmail, fullName, role, chkRemember.Checked);

                // Check return URL if present
                string returnUrl = Request.QueryString["returnUrl"];
                if (!string.IsNullOrEmpty(returnUrl) && !returnUrl.Contains("://") && !returnUrl.StartsWith("//"))
                {
                    Response.Redirect(returnUrl);
                    return;
                }

                // Redirect based on database role
                Response.Redirect(AuthHelper.GetRoleDashboardUrl(role));
            }
            catch (Exception ex)
            {
                ShowError("A database connection error occurred: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblError.Text = "⚠️ " + Server.HtmlEncode(message);
            pnlError.Visible = true;
        }
    }
}
