using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class ProfileSetup : Page
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

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Influencer");

            if (!IsPostBack)
            {
                LoadExistingProfile();
            }
        }

        private void LoadExistingProfile()
        {
            int uid = CurrentUserId;
            if (uid <= 0) return;

            try
            {
                DataTable dt = DbHelper.ExecuteDataTable(
                    "SELECT u.FullName, i.Category, i.FollowerCount, i.Bio, i.SocialLinks " +
                    "FROM Users u " +
                    "LEFT JOIN Influencers i ON u.UserID = i.UserID " +
                    "WHERE u.UserID = @uid",
                    new SqlParameter("@uid", uid)
                );

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    txtFullName.Text = r["FullName"].ToString();

                    if (r["Category"] != DBNull.Value && !string.IsNullOrEmpty(r["Category"].ToString()))
                    {
                        string cat = r["Category"].ToString();
                        if (ddlCategory.Items.FindByValue(cat) != null)
                        {
                            ddlCategory.SelectedValue = cat;
                        }
                    }

                    if (r["FollowerCount"] != DBNull.Value)
                    {
                        txtFollowers.Text = r["FollowerCount"].ToString();
                    }

                    txtBio.Text = r["Bio"] != DBNull.Value ? r["Bio"].ToString() : "";

                    string links = r["SocialLinks"] != DBNull.Value ? r["SocialLinks"].ToString() : "";
                    if (!string.IsNullOrEmpty(links))
                    {
                        txtInstagram.Text = links.Replace("@", "");
                    }
                }
            }
            catch
            {
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            pnlStatus.Visible = false;
            lblStatus.Text = "";

            if (!Page.IsValid)
            {
                return;
            }

            int uid = CurrentUserId;
            if (uid <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string fullName = txtFullName.Text.Trim();
            string instagram = txtInstagram.Text.Trim();
            if (!string.IsNullOrEmpty(instagram) && !instagram.StartsWith("@"))
            {
                instagram = "@" + instagram;
            }

            int followers = 0;
            int.TryParse(txtFollowers.Text.Trim(), out followers);

            string category = ddlCategory.SelectedValue;
            string bio = txtBio.Text.Trim();

            try
            {
                // Update Users table
                DbHelper.ExecuteNonQuery(
                    "UPDATE Users SET FullName = @name WHERE UserID = @uid",
                    new SqlParameter("@name", fullName),
                    new SqlParameter("@uid", uid)
                );

                // Update or Insert Influencers table
                object infIdObj = DbHelper.ExecuteScalar(
                    "SELECT InfluencerID FROM Influencers WHERE UserID = @uid",
                    new SqlParameter("@uid", uid)
                );

                int infId = 0;
                if (infIdObj != null && infIdObj != DBNull.Value)
                {
                    infId = Convert.ToInt32(infIdObj);
                    DbHelper.ExecuteNonQuery(
                        "UPDATE Influencers SET Name = @name, Category = @cat, FollowerCount = @fol, Bio = @bio, SocialLinks = @ig WHERE InfluencerID = @infId",
                        new SqlParameter("@name", fullName),
                        new SqlParameter("@cat", category),
                        new SqlParameter("@fol", followers),
                        new SqlParameter("@bio", bio),
                        new SqlParameter("@ig", instagram),
                        new SqlParameter("@infId", infId)
                    );
                }
                else
                {
                    object newInfId = DbHelper.ExecuteScalar(
                        "INSERT INTO Influencers (UserID, Name, Category, FollowerCount, Bio, SocialLinks, City, Country, EngagementRate) " +
                        "OUTPUT INSERTED.InfluencerID VALUES (@uid, @name, @cat, @fol, @bio, @ig, 'Ahmedabad', 'India', 4.50)",
                        new SqlParameter("@uid", uid),
                        new SqlParameter("@name", fullName),
                        new SqlParameter("@cat", category),
                        new SqlParameter("@fol", followers),
                        new SqlParameter("@bio", bio),
                        new SqlParameter("@ig", instagram)
                    );
                    infId = Convert.ToInt32(newInfId);
                }

                Session["InfluencerID"] = infId;
                Session["FullName"] = fullName;
                Session["User"] = fullName;

                // Update SocialAccounts table
                if (!string.IsNullOrEmpty(instagram))
                {
                    object socObj = DbHelper.ExecuteScalar(
                        "SELECT SocialAccountID FROM SocialAccounts WHERE InfluencerID = @infId AND Platform = 'Instagram'",
                        new SqlParameter("@infId", infId)
                    );

                    if (socObj != null && socObj != DBNull.Value)
                    {
                        DbHelper.ExecuteNonQuery(
                            "UPDATE SocialAccounts SET Handle = @h, Followers = @f WHERE SocialAccountID = @sid",
                            new SqlParameter("@h", instagram),
                            new SqlParameter("@f", followers),
                            new SqlParameter("@sid", Convert.ToInt32(socObj))
                        );
                    }
                    else
                    {
                        DbHelper.ExecuteNonQuery(
                            "INSERT INTO SocialAccounts (InfluencerID, Platform, Handle, Followers, EngagementRate, IsVerified) " +
                            "VALUES (@infId, 'Instagram', @h, @f, 4.50, 1)",
                            new SqlParameter("@infId", infId),
                            new SqlParameter("@h", instagram),
                            new SqlParameter("@f", followers)
                        );
                    }
                }

                Response.Redirect("~/Dashboard.aspx");
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error saving profile: " + Server.HtmlEncode(ex.Message);
                pnlStatus.Visible = true;
            }
        }
    }
}
