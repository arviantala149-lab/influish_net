using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Influish_net.Helpers;

namespace Influish_net.Admin
{
    public partial class ManageCampaigns : Page
    {
        protected string CurrentFilter
        {
            get
            {
                object f = ViewState["CurrentFilter"];
                return f != null ? f.ToString() : "";
            }
            set
            {
                ViewState["CurrentFilter"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                LoadCategories();
                LoadCampaigns();
            }
        }

        private void LoadCategories()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteDataTable("SELECT CategoryName FROM Categories WHERE IsActive = 1 ORDER BY DisplayOrder, CategoryName");
                foreach (DataRow row in dt.Rows)
                {
                    string cat = row["CategoryName"].ToString();
                    ddlCategoryFilter.Items.Add(new ListItem(cat, cat));
                }
            }
            catch
            {
            }
        }

        protected void FilterTab_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            CurrentFilter = btn.CommandArgument;

            btnTabAll.CssClass = "filter-tab";
            btnTabActive.CssClass = "filter-tab";
            btnTabPending.CssClass = "filter-tab";
            btnTabDeactivated.CssClass = "filter-tab";

            if (CurrentFilter.Equals("Active", StringComparison.OrdinalIgnoreCase))
            {
                btnTabActive.CssClass = "filter-tab active";
            }
            else if (CurrentFilter.Equals("Pending", StringComparison.OrdinalIgnoreCase))
            {
                btnTabPending.CssClass = "filter-tab active";
            }
            else if (CurrentFilter.Equals("Deactivated", StringComparison.OrdinalIgnoreCase))
            {
                btnTabDeactivated.CssClass = "filter-tab active";
            }
            else
            {
                btnTabAll.CssClass = "filter-tab active";
            }

            LoadCampaigns();
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            LoadCampaigns();
        }

        private void LoadCampaigns()
        {
            try
            {
                string query = @"
                    SELECT c.CampaignID, c.Title AS CampaignName, c.Advertiser, c.Category, c.Budget, 
                           ISNULL(a.AppCount, 0) AS Applicants, c.Status, c.CreatedDate
                    FROM Campaigns c
                    LEFT JOIN (SELECT CampaignID, COUNT(*) AS AppCount FROM Applications GROUP BY CampaignID) a
                        ON c.CampaignID = a.CampaignID
                    WHERE 1=1 ";

                var parameters = new System.Collections.Generic.List<SqlParameter>();

                if (!string.IsNullOrEmpty(CurrentFilter))
                {
                    if (CurrentFilter == "Active")
                    {
                        query += " AND (c.Status = 'Active' OR c.Status = 'Open') ";
                    }
                    else
                    {
                        query += " AND c.Status = @statusFilter ";
                        parameters.Add(new SqlParameter("@statusFilter", CurrentFilter));
                    }
                }

                string search = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (c.Title LIKE @search OR c.Advertiser LIKE @search) ";
                    parameters.Add(new SqlParameter("@search", "%" + search + "%"));
                }

                string category = ddlCategoryFilter.SelectedValue;
                if (!string.IsNullOrEmpty(category))
                {
                    query += " AND c.Category = @category ";
                    parameters.Add(new SqlParameter("@category", category));
                }

                query += " ORDER BY c.CreatedDate DESC, c.CampaignID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query, parameters.ToArray());
                gvCampaigns.DataSource = dt;
                gvCampaigns.DataBind();
                lblCount.Text = "Showing 1 to " + dt.Rows.Count + " of " + dt.Rows.Count + " campaigns";
                lblError.Visible = false;
            }
            catch (Exception ex)
            {
                lblError.Text = "Error loading campaigns: " + Server.HtmlEncode(ex.Message);
                lblError.Visible = true;
            }
        }

        protected void btnToggleCampaign_Command(object sender, CommandEventArgs e)
        {
            int campaignId = 0;
            if (int.TryParse(e.CommandArgument.ToString(), out campaignId))
            {
                try
                {
                    object statusObj = DbHelper.ExecuteScalar(
                        "SELECT Status FROM Campaigns WHERE CampaignID = @id",
                        new SqlParameter("@id", campaignId)
                    );

                    if (statusObj != null)
                    {
                        string currentStatus = statusObj.ToString();
                        string newStatus = (currentStatus.Equals("Active", StringComparison.OrdinalIgnoreCase) || currentStatus.Equals("Open", StringComparison.OrdinalIgnoreCase))
                            ? "Deactivated"
                            : "Active";

                        DbHelper.ExecuteNonQuery(
                            "UPDATE Campaigns SET Status = @status WHERE CampaignID = @id",
                            new SqlParameter("@status", newStatus),
                            new SqlParameter("@id", campaignId)
                        );

                        // Audit log to AdminLogs
                        int adminId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;
                        DbHelper.ExecuteNonQuery(
                            @"INSERT INTO AdminLogs(AdminUserID, Action, TargetEntity, TargetID, Details, Timestamp)
                              VALUES(@adminId, 'Campaign Status Updated', 'Campaigns', @targetId, @details, GETDATE())",
                            new SqlParameter("@adminId", adminId > 0 ? (object)adminId : DBNull.Value),
                            new SqlParameter("@targetId", campaignId),
                            new SqlParameter("@details", string.Format("Campaign ID {0} status changed from {1} to {2}", campaignId, currentStatus, newStatus))
                        );

                        lblSuccess.Text = string.Format("Campaign ID {0} status updated to <strong>{1}</strong>.", campaignId, newStatus);
                        pnlSuccess.Visible = true;
                    }

                    LoadCampaigns();
                }
                catch (Exception ex)
                {
                    lblError.Text = "Error updating campaign: " + Server.HtmlEncode(ex.Message);
                    lblError.Visible = true;
                }
            }
        }

        public string GetStatusBadge(object status)
        {
            if (status == null || status == DBNull.Value) return "badge";
            switch (status.ToString().ToLower())
            {
                case "active":
                case "open": return "badge badge-active";
                case "pending": return "badge badge-pending";
                case "deactivated":
                case "closed":
                case "ended": return "badge badge-deactivated";
                default: return "badge";
            }
        }

        public string GetCampaignIcon(object category)
        {
            if (category == null || category == DBNull.Value) return "&#128203;";
            string cat = category.ToString().ToLower();
            if (cat.Contains("fashion")) return "&#128084;";
            if (cat.Contains("tech")) return "&#128241;";
            if (cat.Contains("food")) return "&#9749;";
            return "&#128203;";
        }

        public string GetCampaignThumbClass(object category)
        {
            if (category == null || category == DBNull.Value) return "campaign-thumb ct-default";
            string cat = category.ToString().ToLower();
            if (cat.Contains("fashion")) return "campaign-thumb ct-fashion";
            if (cat.Contains("tech")) return "campaign-thumb ct-tech";
            if (cat.Contains("food")) return "campaign-thumb ct-food";
            return "campaign-thumb ct-default";
        }

        public string FormatBudget(object budget)
        {
            if (budget == null || budget == DBNull.Value) return "&#8377;0";
            decimal amount;
            string clean = budget.ToString().Replace("₹", "").Replace(",", "").Trim();
            if (decimal.TryParse(clean, out amount))
            {
                return "&#8377;" + string.Format("{0:N0}", amount);
            }
            return "&#8377;" + budget.ToString();
        }
    }
}
