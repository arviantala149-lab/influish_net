using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class Profile : Page
    {
        protected int CurrentUserId
        {
            get
            {
                if (Session["UserID"] != null)
                {
                    return Convert.ToInt32(Session["UserID"]);
                }
                return 0;
            }
        }

        protected int CurrentInfluencerId
        {
            get
            {
                if (Session["InfluencerID"] != null)
                {
                    return Convert.ToInt32(Session["InfluencerID"]);
                }
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Influencer");

            if (!IsPostBack)
            {
                LoadProfileData();
            }
        }

        private void LoadProfileData()
        {
            int uid = CurrentUserId;
            if (uid <= 0) return;

            try
            {
                DataTable dt = DbHelper.ExecuteDataTable(
                    "SELECT u.FullName, u.Email, i.InfluencerID, i.Name, i.Category, i.FollowerCount, i.Bio, i.City, i.SocialLinks " +
                    "FROM Users u " +
                    "LEFT JOIN Influencers i ON u.UserID = i.UserID " +
                    "WHERE u.UserID = @uid",
                    new SqlParameter("@uid", uid)
                );

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    string name = r["FullName"].ToString();
                    string email = r["Email"].ToString();
                    string bio = r["Bio"] != DBNull.Value ? r["Bio"].ToString() : "";
                    string city = r["City"] != DBNull.Value ? r["City"].ToString() : "";
                    string category = r["Category"] != DBNull.Value ? r["Category"].ToString() : "Lifestyle, Tech";
                    int followers = r["FollowerCount"] != DBNull.Value ? Convert.ToInt32(r["FollowerCount"]) : 0;
                    string handle = r["SocialLinks"] != DBNull.Value ? r["SocialLinks"].ToString() : "@" + name.ToLower().Replace(" ", "");

                    litCardName.Text = Server.HtmlEncode(name);
                    litCardHandle.Text = Server.HtmlEncode(handle);

                    // Category tag pills
                    litCardCategories.Text = "";
                    string[] tags = category.Split(new char[] { ',', '&', '/' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string t in tags)
                    {
                        litCardCategories.Text += string.Format("<span class=\"tag-pill\">{0}</span> ", Server.HtmlEncode(t.Trim()));
                    }

                    txtFullName.Text = name;
                    txtBio.Text = bio;
                    txtCity.Text = city;
                    txtCategory.Text = category;
                    txtFollowers.Text = followers.ToString();
                    txtSocialHandle.Text = handle;
                    txtEmail.Text = email;
                }
            }
            catch
            {
            }
        }

        protected void btnSaveBasic_Click(object sender, EventArgs e)
        {
            pnlBasicStatus.Visible = false;
            lblBasicStatus.Text = "";

            Page.Validate("BasicVal");
            if (!Page.IsValid)
            {
                return;
            }

            int uid = CurrentUserId;
            int infId = CurrentInfluencerId;

            string fullName = txtFullName.Text.Trim();
            string bio = txtBio.Text.Trim();
            string city = txtCity.Text.Trim();
            string category = txtCategory.Text.Trim();
            string handle = txtSocialHandle.Text.Trim();
            int followers = 0;
            int.TryParse(txtFollowers.Text.Trim(), out followers);

            try
            {
                // Update Users
                DbHelper.ExecuteNonQuery(
                    "UPDATE Users SET FullName = @name WHERE UserID = @uid",
                    new SqlParameter("@name", fullName),
                    new SqlParameter("@uid", uid)
                );

                // Update Influencers
                if (infId > 0)
                {
                    DbHelper.ExecuteNonQuery(
                        "UPDATE Influencers SET Name = @name, Bio = @bio, City = @city, Category = @cat, FollowerCount = @fol, SocialLinks = @handle WHERE InfluencerID = @infId",
                        new SqlParameter("@name", fullName),
                        new SqlParameter("@bio", bio),
                        new SqlParameter("@city", city),
                        new SqlParameter("@cat", category),
                        new SqlParameter("@fol", followers),
                        new SqlParameter("@handle", handle),
                        new SqlParameter("@infId", infId)
                    );
                }

                Session["FullName"] = fullName;
                Session["User"] = fullName;

                lblBasicStatus.Text = "✓ Profile information saved successfully.";
                pnlBasicStatus.Visible = true;

                LoadProfileData();
            }
            catch (Exception ex)
            {
                lblBasicStatus.Text = "Error saving changes: " + Server.HtmlEncode(ex.Message);
                pnlBasicStatus.Visible = true;
            }
        }

        protected void btnUpdateSecurity_Click(object sender, EventArgs e)
        {
            pnlSecurityStatus.Visible = false;
            pnlSecurityError.Visible = false;

            Page.Validate("SecVal");
            if (!Page.IsValid)
            {
                return;
            }

            int uid = CurrentUserId;
            string curPass = txtCurrentPassword.Text;
            string newPass = txtNewPassword.Text;

            try
            {
                object hashObj = DbHelper.ExecuteScalar(
                    "SELECT PasswordHash FROM Users WHERE UserID = @uid",
                    new SqlParameter("@uid", uid)
                );

                string storedHash = hashObj != null && hashObj != DBNull.Value ? hashObj.ToString() : "";

                bool needsUpgrade = false;
                if (!AuthHelper.VerifyPassword(curPass, storedHash, out needsUpgrade))
                {
                    lblSecurityError.Text = "Current password is incorrect.";
                    pnlSecurityError.Visible = true;
                    return;
                }

                // Update to new hashed password
                string newHash = AuthHelper.HashPassword(newPass);
                DbHelper.ExecuteNonQuery(
                    "UPDATE Users SET PasswordHash = @hash WHERE UserID = @uid",
                    new SqlParameter("@hash", newHash),
                    new SqlParameter("@uid", uid)
                );

                lblSecurityStatus.Text = "✓ Password updated successfully.";
                pnlSecurityStatus.Visible = true;

                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";
            }
            catch (Exception ex)
            {
                lblSecurityError.Text = "Error updating password: " + Server.HtmlEncode(ex.Message);
                pnlSecurityError.Visible = true;
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            LoadProfileData();
            pnlBasicStatus.Visible = false;
            pnlSecurityStatus.Visible = false;
        }
    }
}
