using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Influish_net.Helpers;

namespace Influish_net.Advertiser
{
    public partial class Dashboard : Page
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
                LoadCompanyName();
                LoadStatistics();
                LoadCampaigns();
            }
        }

        private void LoadCompanyName()
        {
            int cid = CurrentCompanyId;
            if (cid > 0)
            {
                object name = DbHelper.ExecuteScalar(
                    "SELECT CompanyName FROM Companies WHERE CompanyID = @cid",
                    new SqlParameter("@cid", cid)
                );
                if (name != null && !string.IsNullOrWhiteSpace(name.ToString()))
                {
                    lblCompanyName.Text = Server.HtmlEncode(name.ToString().Trim());
                    return;
                }
            }

            lblCompanyName.Text = Session["User"] != null ? Server.HtmlEncode(Session["User"].ToString()) : "Brand Partner";
        }

        private void LoadStatistics()
        {
            int cid = CurrentCompanyId;

            // Active Campaigns
            object activeObj = DbHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Campaigns WHERE CompanyID = @cid AND (Status = 'Active' OR Status = 'Open')",
                new SqlParameter("@cid", cid)
            );
            lblActiveCampaigns.Text = activeObj != null ? activeObj.ToString() : "0";

            // Total Applicants
            object appObj = DbHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Applications a INNER JOIN Campaigns c ON a.CampaignID = c.CampaignID WHERE c.CompanyID = @cid",
                new SqlParameter("@cid", cid)
            );
            lblTotalApplicants.Text = appObj != null ? appObj.ToString() : "0";

            // Accepted Influencers
            object accObj = DbHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Applications a INNER JOIN Campaigns c ON a.CampaignID = c.CampaignID WHERE c.CompanyID = @cid AND a.Status = 'Accepted'",
                new SqlParameter("@cid", cid)
            );
            lblAccepted.Text = accObj != null ? accObj.ToString() : "0";

            // Pending Influencers
            object pendObj = DbHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Applications a INNER JOIN Campaigns c ON a.CampaignID = c.CampaignID WHERE c.CompanyID = @cid AND a.Status = 'Pending'",
                new SqlParameter("@cid", cid)
            );
            lblPending.Text = pendObj != null ? pendObj.ToString() : "0";
        }

        private void LoadCampaigns()
        {
            int cid = CurrentCompanyId;
            string query = @"
                SELECT TOP 10 c.CampaignID, c.Title, c.Category, c.Budget, c.Status, ISNULL(a.AppCount, 0) AS ApplicantCount
                FROM Campaigns c
                LEFT JOIN (SELECT CampaignID, COUNT(*) AS AppCount FROM Applications GROUP BY CampaignID) a
                    ON c.CampaignID = a.CampaignID
                WHERE c.CompanyID = @cid
                ORDER BY c.CampaignID DESC";

            DataTable dt = DbHelper.ExecuteDataTable(query, new SqlParameter("@cid", cid));
            gvCampaigns.DataSource = dt;
            gvCampaigns.DataBind();
        }

        public string GetStatusBadgeClass(object statusObj)
        {
            if (statusObj == null || Convert.IsDBNull(statusObj))
            {
                return "closed";
            }
            string status = statusObj.ToString().ToLower();
            if (status == "active" || status == "open")
            {
                return "open";
            }
            else if (status == "pending")
            {
                return "pending";
            }
            else if (status == "accepted")
            {
                return "accepted";
            }
            else if (status == "rejected")
            {
                return "rejected";
            }
            else
            {
                return "closed";
            }
        }

        public string FormatBudget(object budgetObj)
        {
            if (budgetObj == null || Convert.IsDBNull(budgetObj))
            {
                return "₹0";
            }
            decimal val = 0;
            if (decimal.TryParse(budgetObj.ToString(), out val))
            {
                return "₹" + val.ToString("N0");
            }
            return budgetObj.ToString();
        }

        public string FormatApplicantCount(object countObj)
        {
            if (countObj == null || Convert.IsDBNull(countObj))
            {
                return "0 applicants";
            }
            int count = 0;
            if (int.TryParse(countObj.ToString(), out count))
            {
                return count > 0 ? count + " applicant" + (count > 1 ? "s" : "") : "0 applicants";
            }
            return "0 applicants";
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Advertiser/CreateCampaign.aspx");
        }

        protected void btnProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Advertiser/CompanyProfile.aspx");
        }

        protected void lnkDelete_Click(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            int campaignId = 0;
            if (int.TryParse(lb.CommandArgument, out campaignId))
            {
                int cid = CurrentCompanyId;
                // Delete safely scoped to logged in company
                DbHelper.ExecuteNonQuery(
                    "DELETE FROM Campaigns WHERE CampaignID = @id AND CompanyID = @cid",
                    new SqlParameter("@id", campaignId),
                    new SqlParameter("@cid", cid)
                );

                LoadStatistics();
                LoadCampaigns();
            }
        }
    }
}
