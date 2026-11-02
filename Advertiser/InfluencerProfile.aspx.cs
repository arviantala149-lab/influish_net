using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net.Advertiser
{
    public partial class InfluencerProfile : Page
    {
        protected int InfluencerId
        {
            get
            {
                object id = ViewState["InfluencerId"];
                return id != null ? Convert.ToInt32(id) : 0;
            }
            set
            {
                ViewState["InfluencerId"] = value;
            }
        }

        protected int ApplicationId
        {
            get
            {
                object aid = ViewState["ApplicationId"];
                return aid != null ? Convert.ToInt32(aid) : 0;
            }
            set
            {
                ViewState["ApplicationId"] = value;
            }
        }

        protected int CampaignId
        {
            get
            {
                object cid = ViewState["CampaignId"];
                return cid != null ? Convert.ToInt32(cid) : 0;
            }
            set
            {
                ViewState["CampaignId"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Advertiser");

            if (!IsPostBack)
            {
                string idStr = Request.QueryString["id"];
                int id = 0;
                if (int.TryParse(idStr, out id))
                {
                    InfluencerId = id;
                }

                string appIdStr = Request.QueryString["appId"];
                int aid = 0;
                if (int.TryParse(appIdStr, out aid))
                {
                    ApplicationId = aid;
                }

                string cidStr = Request.QueryString["cid"];
                int cid = 0;
                if (int.TryParse(cidStr, out cid))
                {
                    CampaignId = cid;
                    lnkBreadcrumbCampaign.NavigateUrl = "CampaignDetails.aspx?id=" + cid;
                }
                else
                {
                    lnkBreadcrumbCampaign.NavigateUrl = "MyCampaigns.aspx";
                }

                LoadInfluencer(InfluencerId);
            }
        }

        private void LoadInfluencer(int id)
        {
            string query = @"
                SELECT i.InfluencerID, i.Name, i.Category, i.FollowerCount, i.Bio, i.SocialLinks, i.City, i.Country,
                       u.Email, u.Phone
                FROM Influencers i
                LEFT JOIN Users u ON i.UserID = u.UserID
                WHERE i.InfluencerID = @id";

            DataTable dt = DbHelper.ExecuteDataTable(query, new SqlParameter("@id", id));

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                string name = r["Name"].ToString();
                lblName.Text = Server.HtmlEncode(name);
                litAvatarInitials.Text = GetInitials(name);
                lblCategory.Text = Server.HtmlEncode(r["Category"] != DBNull.Value ? r["Category"].ToString() : "Content Creator");

                int followersVal = 0;
                if (int.TryParse(r["FollowerCount"].ToString(), out followersVal))
                {
                    lblFollowers.Text = followersVal.ToString("N0");
                }
                else
                {
                    lblFollowers.Text = Server.HtmlEncode(r["FollowerCount"].ToString());
                }

                lblBio.Text = Server.HtmlEncode(r["Bio"] != DBNull.Value ? r["Bio"].ToString() : "Passionate content creator delivering engaging audience experiences.");
                lblSocial.Text = Server.HtmlEncode(r["SocialLinks"] != DBNull.Value ? r["SocialLinks"].ToString() : "@" + name.ToLower().Replace(" ", ""));
                lblEmail.Text = Server.HtmlEncode(r["Email"] != DBNull.Value ? r["Email"].ToString() : "creator@influish.com");
                lblAge.Text = "24"; // Standard college demo demographic

                // Load campaign application details if available
                if (ApplicationId > 0)
                {
                    DataTable dtApp = DbHelper.ExecuteDataTable(
                        "SELECT c.Title, a.AppliedAt FROM Applications a INNER JOIN Campaigns c ON a.CampaignID = c.CampaignID WHERE a.ApplicationID = @aid",
                        new SqlParameter("@aid", ApplicationId)
                    );
                    if (dtApp.Rows.Count > 0)
                    {
                        lblCampaignTitle.Text = Server.HtmlEncode(dtApp.Rows[0]["Title"].ToString());
                        if (dtApp.Rows[0]["AppliedAt"] != DBNull.Value)
                        {
                            lblAppliedDate.Text = Convert.ToDateTime(dtApp.Rows[0]["AppliedAt"]).ToString("MMM dd, yyyy");
                        }
                    }
                }
                else
                {
                    lblCampaignTitle.Text = "Creator Profile";
                    lblAppliedDate.Text = "N/A";
                }
            }
            else
            {
                Response.Redirect("~/Advertiser/Dashboard.aspx");
            }
        }

        protected void btnAccept_Click(object sender, EventArgs e)
        {
            UpdateStatus("Accepted");
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            UpdateStatus("Rejected");
        }

        private void UpdateStatus(string newStatus)
        {
            if (ApplicationId > 0)
            {
                // Update Application Status
                DbHelper.ExecuteNonQuery(
                    "UPDATE Applications SET Status = @s WHERE ApplicationID = @aid",
                    new SqlParameter("@s", newStatus),
                    new SqlParameter("@aid", ApplicationId)
                );

                // Notify Influencer
                DataTable dt = DbHelper.ExecuteDataTable(@"
                    SELECT i.UserID, c.Title, c.CampaignID
                    FROM Applications a
                    INNER JOIN Influencers i ON a.InfluencerID = i.InfluencerID
                    INNER JOIN Campaigns c ON a.CampaignID = c.CampaignID
                    WHERE a.ApplicationID = @aid",
                    new SqlParameter("@aid", ApplicationId)
                );

                if (dt.Rows.Count > 0)
                {
                    object userIdObj = dt.Rows[0]["UserID"];
                    string campaignTitle = dt.Rows[0]["Title"].ToString();
                    int cid = Convert.ToInt32(dt.Rows[0]["CampaignID"]);

                    if (userIdObj != null && userIdObj != DBNull.Value)
                    {
                        int infUserId = Convert.ToInt32(userIdObj);
                        string notificationMsg = newStatus == "Accepted"
                            ? string.Format("Your application for \"{0}\" was accepted by the brand!", campaignTitle)
                            : string.Format("Your application for \"{0}\" was not selected.", campaignTitle);

                        DbHelper.ExecuteNonQuery(
                            @"INSERT INTO Notifications(UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt)
                              VALUES(@uid, @msg, @type, @cid, 0, GETDATE())",
                            new SqlParameter("@uid", infUserId),
                            new SqlParameter("@msg", notificationMsg),
                            new SqlParameter("@type", newStatus == "Accepted" ? "Acceptance" : "System"),
                            new SqlParameter("@cid", cid)
                        );
                    }
                }

                lblNotice.Text = string.Format("Application successfully marked as <strong>{0}</strong>.", newStatus);
                pnlNotice.Visible = true;
            }
        }

        private string GetInitials(string name)
        {
            if (string.IsNullOrEmpty(name)) return "IN";
            string[] parts = name.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length >= 2)
            {
                return (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
            }
            else if (parts.Length == 1 && parts[0].Length >= 2)
            {
                return parts[0].Substring(0, 2).ToUpper();
            }
            return "IN";
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            if (CampaignId > 0)
            {
                Response.Redirect(string.Format("~/Advertiser/CampaignDetails.aspx?id={0}", CampaignId));
            }
            else
            {
                Response.Redirect("~/Advertiser/Dashboard.aspx");
            }
        }
    }
}
