using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class Signup : Page
    {
        public string CurrentRole { get; set; }

        public Signup()
        {
            CurrentRole = "influencer";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string role = Request.QueryString["role"];
            if (!string.IsNullOrEmpty(role) && role.Equals("advertiser", StringComparison.OrdinalIgnoreCase))
            {
                CurrentRole = "advertiser";
            }
            else
            {
                CurrentRole = "influencer";
            }

            if (!IsPostBack)
            {
                if (CurrentRole == "advertiser")
                {
                    pnlAdvertiser.Visible = true;
                    pnlInfluencer.Visible = false;
                }
                else
                {
                    pnlInfluencer.Visible = true;
                    pnlAdvertiser.Visible = false;
                }
            }
        }

        protected void btnInfSubmit_Click(object sender, EventArgs e)
        {
            pnlInfError.Visible = false;
            lblInfError.Text = "";

            Page.Validate("InfluencerVal");
            if (!Page.IsValid)
            {
                return;
            }

            string fullName = txtInfFullName.Text.Trim();
            string email = txtInfEmail.Text.Trim();
            string phone = txtInfPhone.Text.Trim();
            string handle = txtInfHandle.Text.Trim();
            string niche = ddlInfNiche.SelectedValue;
            string password = txtInfPassword.Text;

            try
            {
                // Check if email already exists
                object existing = DbHelper.ExecuteScalar(
                    "SELECT UserID FROM Users WHERE Email = @email",
                    new SqlParameter("@email", email)
                );

                if (existing != null && existing != DBNull.Value)
                {
                    lblInfError.Text = "⚠️ An account with this email address already exists. Please log in instead.";
                    pnlInfError.Visible = true;
                    return;
                }

                string passwordHash = AuthHelper.HashPassword(password);

                // Insert into Users table
                int newUserId = 0;
                using (SqlConnection con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        try
                        {
                            string sqlUser = "INSERT INTO Users (FullName, Email, PasswordHash, Role, Phone, Status, JoinedDate) " +
                                             "OUTPUT INSERTED.UserID VALUES (@name, @email, @hash, 'Influencer', @phone, 'Active', GETDATE())";
                            using (SqlCommand cmd = new SqlCommand(sqlUser, con, tran))
                            {
                                cmd.Parameters.AddWithValue("@name", fullName);
                                cmd.Parameters.AddWithValue("@email", email);
                                cmd.Parameters.AddWithValue("@hash", passwordHash);
                                cmd.Parameters.AddWithValue("@phone", phone);
                                newUserId = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            int newInfId = 0;
                            string sqlInf = "INSERT INTO Influencers (UserID, Name, Category, FollowerCount, Bio, SocialLinks, Phone, City, Country, EngagementRate) " +
                                            "OUTPUT INSERTED.InfluencerID VALUES (@uid, @name, @niche, 0, '', @handle, @phone, 'Ahmedabad', 'India', 3.50)";
                            using (SqlCommand cmd = new SqlCommand(sqlInf, con, tran))
                            {
                                cmd.Parameters.AddWithValue("@uid", newUserId);
                                cmd.Parameters.AddWithValue("@name", fullName);
                                cmd.Parameters.AddWithValue("@niche", niche);
                                cmd.Parameters.AddWithValue("@handle", handle);
                                cmd.Parameters.AddWithValue("@phone", phone);
                                newInfId = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            // Insert primary social account
                            string sqlSoc = "INSERT INTO SocialAccounts (InfluencerID, Platform, Handle, Followers, EngagementRate, IsVerified) " +
                                            "VALUES (@infId, 'Instagram', @handle, 0, 0.00, 0)";
                            using (SqlCommand cmd = new SqlCommand(sqlSoc, con, tran))
                            {
                                cmd.Parameters.AddWithValue("@infId", newInfId);
                                cmd.Parameters.AddWithValue("@handle", handle);
                                cmd.ExecuteNonQuery();
                            }

                            // Welcome notification
                            string sqlNote = "INSERT INTO Notifications (UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt) " +
                                             "VALUES (@uid, 'Welcome to Influish! Complete your profile to start connecting with top brands.', 'System', 0, 0, GETDATE())";
                            using (SqlCommand cmd = new SqlCommand(sqlNote, con, tran))
                            {
                                cmd.Parameters.AddWithValue("@uid", newUserId);
                                cmd.ExecuteNonQuery();
                            }

                            tran.Commit();
                        }
                        catch
                        {
                            tran.Rollback();
                            throw;
                        }
                    }
                }

                // Log user in and redirect to ProfileSetup
                AuthHelper.LoginUser(Context, newUserId, email, fullName, "Influencer", true);
                Response.Redirect("~/ProfileSetup.aspx");
            }
            catch (Exception ex)
            {
                lblInfError.Text = "⚠️ Registration error: " + Server.HtmlEncode(ex.Message);
                pnlInfError.Visible = true;
            }
        }

        protected void btnAdvSubmit_Click(object sender, EventArgs e)
        {
            pnlAdvError.Visible = false;
            lblAdvError.Text = "";

            Page.Validate("AdvertiserVal");
            if (!Page.IsValid)
            {
                return;
            }

            string brandName = txtAdvBrandName.Text.Trim();
            string contactPerson = txtAdvContactPerson.Text.Trim();
            string email = txtAdvEmail.Text.Trim();
            string phone = txtAdvPhone.Text.Trim();
            string website = txtAdvWebsite.Text.Trim();
            string industry = ddlAdvIndustry.SelectedValue;
            string password = txtAdvPassword.Text;

            try
            {
                // Check if email already exists
                object existing = DbHelper.ExecuteScalar(
                    "SELECT UserID FROM Users WHERE Email = @email",
                    new SqlParameter("@email", email)
                );

                if (existing != null && existing != DBNull.Value)
                {
                    lblAdvError.Text = "⚠️ An account with this business email address already exists. Please log in instead.";
                    pnlAdvError.Visible = true;
                    return;
                }

                string passwordHash = AuthHelper.HashPassword(password);

                int newUserId = 0;
                using (SqlConnection con = DbHelper.GetConnection())
                {
                    con.Open();
                    using (SqlTransaction tran = con.BeginTransaction())
                    {
                        try
                        {
                            string sqlUser = "INSERT INTO Users (FullName, Email, PasswordHash, Role, Phone, Status, JoinedDate) " +
                                             "OUTPUT INSERTED.UserID VALUES (@name, @email, @hash, 'Advertiser', @phone, 'Active', GETDATE())";
                            using (SqlCommand cmd = new SqlCommand(sqlUser, con, tran))
                            {
                                cmd.Parameters.AddWithValue("@name", brandName);
                                cmd.Parameters.AddWithValue("@email", email);
                                cmd.Parameters.AddWithValue("@hash", passwordHash);
                                cmd.Parameters.AddWithValue("@phone", phone);
                                newUserId = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            string sqlComp = "INSERT INTO Companies (UserID, CompanyName, ContactPerson, Email, Phone, Industry, Website, Description) " +
                                             "VALUES (@uid, @cname, @cp, @email, @phone, @industry, @website, '')";
                            using (SqlCommand cmd = new SqlCommand(sqlComp, con, tran))
                            {
                                cmd.Parameters.AddWithValue("@uid", newUserId);
                                cmd.Parameters.AddWithValue("@cname", brandName);
                                cmd.Parameters.AddWithValue("@cp", contactPerson);
                                cmd.Parameters.AddWithValue("@email", email);
                                cmd.Parameters.AddWithValue("@phone", phone);
                                cmd.Parameters.AddWithValue("@industry", industry);
                                cmd.Parameters.AddWithValue("@website", website);
                                cmd.ExecuteNonQuery();
                            }

                            // Welcome notification
                            string sqlNote = "INSERT INTO Notifications (UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt) " +
                                             "VALUES (@uid, 'Welcome to Influish! Launch your first marketing campaign to discover creators.', 'System', 0, 0, GETDATE())";
                            using (SqlCommand cmd = new SqlCommand(sqlNote, con, tran))
                            {
                                cmd.Parameters.AddWithValue("@uid", newUserId);
                                cmd.ExecuteNonQuery();
                            }

                            tran.Commit();
                        }
                        catch
                        {
                            tran.Rollback();
                            throw;
                        }
                    }
                }

                // Log user in and redirect to Advertiser Dashboard
                AuthHelper.LoginUser(Context, newUserId, email, brandName, "Advertiser", true);
                Response.Redirect("~/Advertiser/Dashboard.aspx");
            }
            catch (Exception ex)
            {
                lblAdvError.Text = "⚠️ Registration error: " + Server.HtmlEncode(ex.Message);
                pnlAdvError.Visible = true;
            }
        }
    }
}
