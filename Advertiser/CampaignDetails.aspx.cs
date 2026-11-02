using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Influish_net.Helpers;

namespace Influish_net.Advertiser
{
    public partial class CampaignDetails : Page
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

        protected int CurrentCampaignId
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
                    CurrentCampaignId = id;
                }
                else
                {
                    Response.Redirect("~/Advertiser/MyCampaigns.aspx");
                    return;
                }

                LoadCampaign(CurrentCampaignId);
                LoadApplicants(CurrentCampaignId);
            }
        }

        private void LoadCampaign(int id)
        {
            int cid = CurrentCompanyId;
            DataTable dt = DbHelper.ExecuteDataTable(
                "SELECT Title, Description, Category, Budget FROM Campaigns WHERE CampaignID = @id AND CompanyID = @cid",
                new SqlParameter("@id", id),
                new SqlParameter("@cid", cid)
            );

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                string title = r["Title"].ToString();
                lblTitle.Text = Server.HtmlEncode(title);
                litBreadcrumbTitle.Text = Server.HtmlEncode(title);
                lblDescription.Text = Server.HtmlEncode(r["Description"].ToString());
                lblCategory.Text = Server.HtmlEncode(r["Category"].ToString());

                decimal budgetVal = 0;
                if (decimal.TryParse(r["Budget"].ToString(), out budgetVal))
                {
                    lblBudget.Text = "₹" + budgetVal.ToString("N0");
                }
                else
                {
                    lblBudget.Text = Server.HtmlEncode(r["Budget"].ToString());
                }
            }
            else
            {
                Response.Redirect("~/Advertiser/MyCampaigns.aspx");
            }
        }

        private void LoadApplicants(int campaignId)
        {
            string query = @"
                SELECT a.ApplicationID, i.InfluencerID, i.Name AS InfluencerName, i.FollowerCount, i.Category, a.Status, a.AppliedAt
                FROM Applications a
                INNER JOIN Influencers i ON a.InfluencerID = i.InfluencerID
                WHERE a.CampaignID = @cid";

            DataTable dtApplicants = DbHelper.ExecuteDataTable(query, new SqlParameter("@cid", campaignId));

            // Compute summary metrics
            int total = dtApplicants.Rows.Count;
            int pendingCount = 0;
            int acceptedCount = 0;
            int rejectedCount = 0;

            foreach (DataRow row in dtApplicants.Rows)
            {
                string st = row["Status"].ToString().ToLower();
                if (st == "pending")
                {
                    pendingCount++;
                }
                else if (st == "accepted")
                {
                    acceptedCount++;
                }
                else if (st == "rejected")
                {
                    rejectedCount++;
                }
            }

            lblTotalApplied.Text = total.ToString();
            lblCountPending.Text = pendingCount.ToString();
            lblCountAccepted.Text = acceptedCount.ToString();
            lblCountRejected.Text = rejectedCount.ToString();

            // Apply Status and Sort filters
            DataView dv = new DataView(dtApplicants);
            string filterStatus = ddlStatusFilter.SelectedValue;
            if (filterStatus != "All")
            {
                dv.RowFilter = "Status = '" + filterStatus + "'";
            }

            string sortOrder = ddlSortFilter.SelectedValue;
            if (sortOrder == "FollowersAsc")
            {
                dv.Sort = "FollowerCount ASC";
            }
            else if (sortOrder == "DateDesc")
            {
                dv.Sort = "AppliedAt DESC";
            }
            else
            {
                dv.Sort = "FollowerCount DESC";
            }

            DataTable filteredTable = dv.ToTable();
            gvApplicants.DataSource = filteredTable;
            gvApplicants.DataBind();

            litShowingApplicants.Text = string.Format("Showing 1 to {0} of {1} applicants", filteredTable.Rows.Count, total);
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadApplicants(CurrentCampaignId);
        }

        protected void ddlSortFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadApplicants(CurrentCampaignId);
        }

        protected void lnkAccept_Click(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            int appId;
            if (int.TryParse(lb.CommandArgument, out appId))
            {
                UpdateApplicationStatus(appId, "Accepted");
            }
        }

        protected void lnkReject_Click(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            int appId;
            if (int.TryParse(lb.CommandArgument, out appId))
            {
                UpdateApplicationStatus(appId, "Rejected");
            }
        }

        private void UpdateApplicationStatus(int appId, string status)
        {
            int cid = CurrentCompanyId;

            // Verify ownership via join
            string checkQuery = @"
                SELECT a.ApplicationID, a.CampaignID, c.Title, i.UserID 
                FROM Applications a
                INNER JOIN Campaigns c ON a.CampaignID = c.CampaignID
                INNER JOIN Influencers i ON a.InfluencerID = i.InfluencerID
                WHERE a.ApplicationID = @appId AND c.CompanyID = @cid";

            DataTable dt = DbHelper.ExecuteDataTable(
                checkQuery,
                new SqlParameter("@appId", appId),
                new SqlParameter("@cid", cid)
            );

            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                int campaignId = Convert.ToInt32(r["CampaignID"]);
                string campaignTitle = r["Title"].ToString();
                object targetUserId = r["UserID"];

                // Update application status
                DbHelper.ExecuteNonQuery(
                    "UPDATE Applications SET Status = @s WHERE ApplicationID = @id",
                    new SqlParameter("@s", status),
                    new SqlParameter("@id", appId)
                );

                // Notify influencer
                if (targetUserId != null && targetUserId != DBNull.Value)
                {
                    int infUserId = Convert.ToInt32(targetUserId);
                    string notificationMsg = status == "Accepted"
                        ? string.Format("Congratulations! Your application for campaign \"{0}\" has been accepted.", campaignTitle)
                        : string.Format("Your application for campaign \"{0}\" was reviewed and not selected at this time.", campaignTitle);

                    DbHelper.ExecuteNonQuery(
                        @"INSERT INTO Notifications(UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt)
                          VALUES(@uid, @msg, @type, @cid, 0, GETDATE())",
                        new SqlParameter("@uid", infUserId),
                        new SqlParameter("@msg", notificationMsg),
                        new SqlParameter("@type", status == "Accepted" ? "Acceptance" : "System"),
                        new SqlParameter("@cid", campaignId)
                    );
                }
            }

            LoadApplicants(CurrentCampaignId);
        }

        public bool IsPending(object statusObj)
        {
            if (statusObj == null || Convert.IsDBNull(statusObj)) return false;
            return statusObj.ToString().Equals("pending", StringComparison.OrdinalIgnoreCase);
        }

        public string GetInitials(object nameObj)
        {
            if (nameObj == null || Convert.IsDBNull(nameObj)) return "IN";
            string[] parts = nameObj.ToString().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
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

        public string FormatFollowerCount(object countObj)
        {
            if (countObj == null || Convert.IsDBNull(countObj)) return "0";
            int count = 0;
            if (int.TryParse(countObj.ToString(), out count))
            {
                if (count >= 1000000)
                {
                    return (count / 1000000.0).ToString("0.#") + "M";
                }
                else if (count >= 1000)
                {
                    return (count / 1000.0).ToString("0.#") + "k";
                }
                else
                {
                    return count.ToString();
                }
            }
            return countObj.ToString();
        }

        public string FormatAppliedDate(object dateObj)
        {
            if (dateObj == null || Convert.IsDBNull(dateObj)) return "Recently";
            DateTime d;
            if (DateTime.TryParse(dateObj.ToString(), out d))
            {
                return d.ToString("MMM dd, yyyy");
            }
            return dateObj.ToString();
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            Response.Redirect(string.Format("~/Advertiser/CreateCampaign.aspx?id={0}", CurrentCampaignId));
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Advertiser/MyCampaigns.aspx");
        }
    }
}
