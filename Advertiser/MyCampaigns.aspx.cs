using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Influish_net.Helpers;

namespace Influish_net.Advertiser
{
    public partial class MyCampaigns : Page
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

        protected string CurrentFilter
        {
            get
            {
                object f = ViewState["CurrentFilter"];
                return f != null ? f.ToString() : "all";
            }
            set
            {
                ViewState["CurrentFilter"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Advertiser");

            if (!IsPostBack)
            {
                CurrentFilter = "all";
                LoadCampaigns();
            }
        }

        private void LoadCampaigns()
        {
            int cid = CurrentCompanyId;

            // Load counts for tabs
            object openCount = DbHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Campaigns WHERE CompanyID = @cid AND (Status = 'Open' OR Status = 'Active')",
                new SqlParameter("@cid", cid)
            );
            litOpenCount.Text = openCount != null ? openCount.ToString() : "0";

            object closedCount = DbHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Campaigns WHERE CompanyID = @cid AND (Status = 'Closed' OR Status = 'Ended' OR Status = 'Deactivated')",
                new SqlParameter("@cid", cid)
            );
            litClosedCount.Text = closedCount != null ? closedCount.ToString() : "0";

            // Query campaigns based on filter
            string query = @"
                SELECT c.CampaignID, c.Title, c.Description, c.Category, c.Budget, c.MinFollowers, c.Status,
                       ISNULL(a.AppCount, 0) AS ApplicantCount, c.CreatedDate
                FROM Campaigns c
                LEFT JOIN (SELECT CampaignID, COUNT(*) AS AppCount FROM Applications GROUP BY CampaignID) a
                    ON c.CampaignID = a.CampaignID
                WHERE c.CompanyID = @cid ";

            if (CurrentFilter == "open")
            {
                query += " AND (c.Status = 'Open' OR c.Status = 'Active') ";
            }
            else if (CurrentFilter == "closed")
            {
                query += " AND (c.Status = 'Closed' OR c.Status = 'Ended' OR c.Status = 'Deactivated') ";
            }

            query += " ORDER BY c.CampaignID DESC";

            DataTable dt = DbHelper.ExecuteDataTable(query, new SqlParameter("@cid", cid));

            if (dt.Rows.Count > 0)
            {
                rptCampaigns.DataSource = dt;
                rptCampaigns.DataBind();
                rptCampaigns.Visible = true;
                pnlEmpty.Visible = false;
                litShowingCount.Text = string.Format("Showing 1 to {0} of {0} campaigns", dt.Rows.Count);
            }
            else
            {
                rptCampaigns.Visible = false;
                pnlEmpty.Visible = true;
                litShowingCount.Text = "Showing 0 campaigns";
            }
        }

        protected void FilterTab_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            CurrentFilter = btn.CommandArgument.ToLower();

            btnTabAll.CssClass = "influish-tab-btn";
            btnTabOpen.CssClass = "influish-tab-btn";
            btnTabClosed.CssClass = "influish-tab-btn";

            if (CurrentFilter == "open")
            {
                btnTabOpen.CssClass = "influish-tab-btn active";
            }
            else if (CurrentFilter == "closed")
            {
                btnTabClosed.CssClass = "influish-tab-btn active";
            }
            else
            {
                btnTabAll.CssClass = "influish-tab-btn active";
            }

            LoadCampaigns();
        }

        public string GetStatusBadgeClass(object statusObj)
        {
            if (statusObj == null || Convert.IsDBNull(statusObj))
            {
                return "closed";
            }
            string s = statusObj.ToString().ToLower();
            if (s == "open" || s == "active")
            {
                return "open";
            }
            else if (s == "closed" || s == "ended" || s == "deactivated")
            {
                return "closed";
            }
            return "closed";
        }

        public string GetPostedText(object dateObj)
        {
            if (dateObj != null && dateObj != DBNull.Value)
            {
                DateTime d;
                if (DateTime.TryParse(dateObj.ToString(), out d))
                {
                    TimeSpan diff = DateTime.Today.Subtract(d.Date);
                    if (diff.TotalDays == 0) return "Posted today";
                    if (diff.TotalDays == 1) return "Posted yesterday";
                    if (diff.TotalDays < 30) return string.Format("Posted {0} days ago", (int)diff.TotalDays);
                    return "Posted on " + d.ToString("MMM dd, yyyy");
                }
            }
            return "Active recently";
        }

        public string TruncateDescription(object descObj)
        {
            if (descObj == null || Convert.IsDBNull(descObj))
            {
                return "No description provided.";
            }
            string text = descObj.ToString();
            if (text.Length > 120)
            {
                return text.Substring(0, 117) + "...";
            }
            return text;
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

        public string FormatFollowers(object fObj)
        {
            if (fObj == null || Convert.IsDBNull(fObj))
            {
                return "Any";
            }
            int count = 0;
            if (int.TryParse(fObj.ToString(), out count))
            {
                if (count >= 1000000)
                {
                    return (count / 1000000.0).ToString("0.#") + "M+";
                }
                else if (count >= 1000)
                {
                    return (count / 1000.0).ToString("0.#") + "k+";
                }
                else
                {
                    return count.ToString();
                }
            }
            return fObj.ToString();
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Advertiser/CreateCampaign.aspx");
        }

        protected void lnkDelete_Click(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            int id;
            if (int.TryParse(lb.CommandArgument, out id))
            {
                int cid = CurrentCompanyId;
                DbHelper.ExecuteNonQuery(
                    "DELETE FROM Campaigns WHERE CampaignID = @id AND CompanyID = @cid",
                    new SqlParameter("@id", id),
                    new SqlParameter("@cid", cid)
                );
                LoadCampaigns();
            }
        }
    }
}
