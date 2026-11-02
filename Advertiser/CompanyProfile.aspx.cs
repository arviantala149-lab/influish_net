using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net.Advertiser
{
    public partial class CompanyProfile : Page
    {
        private int CurrentCompanyId
        {
            get
            {
                if (Session["CompanyID"] != null)
                {
                    return Convert.ToInt32(Session["CompanyID"]);
                }

                if (Session["UserID"] != null)
                {
                    int userId = Convert.ToInt32(Session["UserID"]);
                    object cid = DbHelper.ExecuteScalar(
                        "SELECT CompanyID FROM Companies WHERE UserID = @uid",
                        new SqlParameter("@uid", userId)
                    );
                    if (cid != null && cid != DBNull.Value)
                    {
                        int id = Convert.ToInt32(cid);
                        Session["CompanyID"] = id;
                        return id;
                    }
                }
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Advertiser");

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            int cid = CurrentCompanyId;
            int uid = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;

            DataTable dt = DbHelper.ExecuteDataTable(
                "SELECT CompanyID, CompanyName, ContactPerson, Email, Phone, Industry, Website, Description FROM Companies WHERE CompanyID = @cid OR UserID = @uid",
                new SqlParameter("@cid", cid),
                new SqlParameter("@uid", uid)
            );

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                string cName = r["CompanyName"].ToString();
                txtName.Text = cName;
                lblHeaderCompanyName.Text = Server.HtmlEncode(cName);
                litCompanyLogoText.Text = GetInitials(cName);

                txtEmail.Text = r["Email"].ToString();
                txtPhone.Text = r["Phone"].ToString();
                txtContactPerson.Text = r["ContactPerson"] != DBNull.Value ? r["ContactPerson"].ToString() : "";

                string ind = r["Industry"].ToString();
                if (ddlIndustry.Items.FindByValue(ind) != null)
                {
                    ddlIndustry.SelectedValue = ind;
                }
                else if (ddlIndustry.Items.FindByText(ind) != null)
                {
                    ddlIndustry.Items.FindByText(ind).Selected = true;
                }
                lblHeaderIndustry.Text = !string.IsNullOrEmpty(ind) ? Server.HtmlEncode(ind) : "Technology";

                string web = r["Website"].ToString();
                txtWebsite.Text = web;
                lblHeaderWebsite.Text = !string.IsNullOrEmpty(web) ? Server.HtmlEncode(web.Replace("https://", "").Replace("http://", "")) : "brand.com";

                txtDesc.Text = r["Description"].ToString();
            }
            else
            {
                // Fallback to user session details
                string userName = Session["User"] != null ? Session["User"].ToString() : "Brand Partner";
                txtName.Text = userName;
                lblHeaderCompanyName.Text = Server.HtmlEncode(userName);
                litCompanyLogoText.Text = GetInitials(userName);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Page.Validate("CompanyGroup");
            if (!Page.IsValid)
            {
                return;
            }

            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string industry = ddlIndustry.SelectedValue;
            string website = txtWebsite.Text.Trim();
            string desc = txtDesc.Text.Trim();
            string contactPerson = txtContactPerson.Text.Trim();

            int cid = CurrentCompanyId;
            int uid = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;

            try
            {
                if (cid > 0)
                {
                    string updateQuery = @"
                        UPDATE Companies 
                        SET CompanyName = @name, ContactPerson = @cp, Email = @email, Phone = @phone, 
                            Industry = @ind, Website = @web, Description = @desc 
                        WHERE CompanyID = @id";

                    DbHelper.ExecuteNonQuery(
                        updateQuery,
                        new SqlParameter("@name", name),
                        new SqlParameter("@cp", contactPerson),
                        new SqlParameter("@email", email),
                        new SqlParameter("@phone", phone),
                        new SqlParameter("@ind", industry),
                        new SqlParameter("@web", website),
                        new SqlParameter("@desc", desc),
                        new SqlParameter("@id", cid)
                    );
                }
                else if (uid > 0)
                {
                    string insertQuery = @"
                        INSERT INTO Companies(UserID, CompanyName, ContactPerson, Email, Phone, Industry, Website, Description, CreatedAt)
                        VALUES(@uid, @name, @cp, @email, @phone, @ind, @web, @desc, GETDATE());
                        SELECT SCOPE_IDENTITY();";

                    object newCid = DbHelper.ExecuteScalar(
                        insertQuery,
                        new SqlParameter("@uid", uid),
                        new SqlParameter("@name", name),
                        new SqlParameter("@cp", contactPerson),
                        new SqlParameter("@email", email),
                        new SqlParameter("@phone", phone),
                        new SqlParameter("@ind", industry),
                        new SqlParameter("@web", website),
                        new SqlParameter("@desc", desc)
                    );
                    if (newCid != null && newCid != DBNull.Value)
                    {
                        Session["CompanyID"] = Convert.ToInt32(newCid);
                    }
                }

                // Update Users table name & phone
                if (uid > 0)
                {
                    DbHelper.ExecuteNonQuery(
                        "UPDATE Users SET FullName = @name, Phone = @phone WHERE UserID = @uid",
                        new SqlParameter("@name", name),
                        new SqlParameter("@phone", phone),
                        new SqlParameter("@uid", uid)
                    );
                    Session["User"] = name;
                }

                lblHeaderCompanyName.Text = Server.HtmlEncode(name);
                lblHeaderIndustry.Text = Server.HtmlEncode(industry);
                lblHeaderWebsite.Text = Server.HtmlEncode(website.Replace("https://", "").Replace("http://", ""));
                litCompanyLogoText.Text = GetInitials(name);

                lblStatus.Text = "Company profile details successfully saved to database!";
                pnlStatus.Visible = true;
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error saving profile: " + Server.HtmlEncode(ex.Message);
                pnlStatus.Visible = true;
            }
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            Page.Validate("SecurityGroup");
            if (!Page.IsValid)
            {
                return;
            }

            int uid = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;
            if (uid == 0)
            {
                lblSecurityStatus.Text = "Session expired. Please log in again.";
                pnlSecurityStatus.Visible = true;
                return;
            }

            string currentPass = txtCurrentPassword.Text.Trim();
            string newPass = txtNewPassword.Text.Trim();

            // Verify current password
            object hashObj = DbHelper.ExecuteScalar(
                "SELECT PasswordHash FROM Users WHERE UserID = @uid",
                new SqlParameter("@uid", uid)
            );

            string currentHash = hashObj != null ? hashObj.ToString() : "";
            if (!AuthHelper.VerifyPassword(currentPass, currentHash))
            {
                lblSecurityStatus.Text = "Current password is incorrect.";
                pnlSecurityStatus.Visible = true;
                return;
            }

            // Update to new hashed password
            string newHash = AuthHelper.HashPassword(newPass);
            DbHelper.ExecuteNonQuery(
                "UPDATE Users SET PasswordHash = @hash WHERE UserID = @uid",
                new SqlParameter("@hash", newHash),
                new SqlParameter("@uid", uid)
            );

            lblSecurityStatus.Text = "Password successfully changed!";
            pnlSecurityStatus.Visible = true;
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";
        }

        private string GetInitials(string name)
        {
            if (string.IsNullOrEmpty(name)) return "CP";
            string[] parts = name.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length >= 2)
            {
                return (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
            }
            else if (parts.Length == 1 && parts[0].Length >= 2)
            {
                return parts[0].Substring(0, 2).ToUpper();
            }
            return "CP";
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Advertiser/Dashboard.aspx");
        }
    }
}
