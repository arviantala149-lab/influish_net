using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class Applications : Page
    {
        protected string CurrentFilter
        {
            get
            {
                object f = ViewState["AppFilter"];
                return f != null ? f.ToString() : "all";
            }
            set
            {
                ViewState["AppFilter"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Influencer");

            if (!IsPostBack)
            {
                CurrentFilter = "all";
                BindApplications();
            }
        }

        protected void FilterTab_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            CurrentFilter = btn.CommandArgument.ToLower();

            tabAll.CssClass = "tab-btn" + (CurrentFilter == "all" ? " active" : "");
            tabPending.CssClass = "tab-btn" + (CurrentFilter == "pending" ? " active" : "");
            tabAccepted.CssClass = "tab-btn" + (CurrentFilter == "accepted" ? " active" : "");
            tabRejected.CssClass = "tab-btn" + (CurrentFilter == "rejected" ? " active" : "");

            BindApplications();
        }

        private void BindApplications()
        {
            int infId = Session["InfluencerID"] != null ? Convert.ToInt32(Session["InfluencerID"]) : 0;
            if (infId <= 0)
            {
                rptApplications.Visible = false;
                pnlNoApps.Visible = true;
                litShowingCount.Text = "Showing 0 entries";
                return;
            }

            try
            {
                string sql = "SELECT a.ApplicationID, a.CampaignID, a.Status, a.AppliedAt, a.ProposedRate, a.CoverLetter, " +
                             "c.Title AS CampaignTitle, c.Advertiser, c.Budget, c.Category " +
                             "FROM Applications a " +
                             "INNER JOIN Campaigns c ON a.CampaignID = c.CampaignID " +
                             "WHERE a.InfluencerID = @infId ";

                if (CurrentFilter == "pending")
                {
                    sql += " AND a.Status = 'Pending' ";
                }
                else if (CurrentFilter == "accepted")
                {
                    sql += " AND a.Status = 'Accepted' ";
                }
                else if (CurrentFilter == "rejected")
                {
                    sql += " AND a.Status = 'Rejected' ";
                }

                sql += " ORDER BY a.AppliedAt DESC";

                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@infId", infId));

                if (dt.Rows.Count > 0)
                {
                    rptApplications.DataSource = dt;
                    rptApplications.DataBind();
                    rptApplications.Visible = true;
                    pnlNoApps.Visible = false;
                    litShowingCount.Text = string.Format("Showing {0} application(s)", dt.Rows.Count);
                }
                else
                {
                    rptApplications.Visible = false;
                    pnlNoApps.Visible = true;
                    litShowingCount.Text = "Showing 0 entries";
                }
            }
            catch (Exception)
            {
                rptApplications.Visible = false;
                pnlNoApps.Visible = true;
                litShowingCount.Text = "Showing 0 entries";
            }
        }

        public string GetInitials(object nameObj)
        {
            if (nameObj == null || nameObj == DBNull.Value) return "CP";
            string name = nameObj.ToString().Trim();
            string[] parts = name.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length >= 2)
            {
                return (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
            }
            else if (parts.Length == 1 && parts[0].Length > 0)
            {
                return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpper();
            }
            return "CP";
        }

        public string FormatBudget(object proposedObj, object budgetObj)
        {
            decimal rate = 0;
            if (proposedObj != null && proposedObj != DBNull.Value && decimal.TryParse(proposedObj.ToString(), out rate) && rate > 0)
            {
                return "₹" + rate.ToString("N0");
            }
            if (budgetObj != null && budgetObj != DBNull.Value && decimal.TryParse(budgetObj.ToString(), out rate) && rate > 0)
            {
                return "₹" + rate.ToString("N0");
            }
            return "₹0";
        }

        public string FormatDate(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value) return "Recently";
            DateTime dt;
            if (DateTime.TryParse(dateObj.ToString(), out dt))
            {
                return dt.ToString("MMM dd, yyyy");
            }
            return dateObj.ToString();
        }

        public string GetStatusBadgeClass(object statusObj)
        {
            if (statusObj == null || statusObj == DBNull.Value) return "badge";
            string s = statusObj.ToString().ToLower();
            if (s == "accepted") return "badge badge-accepted";
            if (s == "rejected") return "badge badge-rejected";
            return "badge badge-pending";
        }
    }
}
