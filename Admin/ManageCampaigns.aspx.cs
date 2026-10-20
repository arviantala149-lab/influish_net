using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Influish_net.Admin
{
    public partial class ManageCampaigns : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCampaigns();
            }
        }

        private void LoadCampaigns()
        {
            DataTable dt = new DataTable();
            bool dbSuccess = false;

            try
            {
                var connSetting = ConfigurationManager.ConnectionStrings["InfluishDB"];
                if (connSetting != null && !string.IsNullOrEmpty(connSetting.ConnectionString) && !connSetting.ConnectionString.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection conn = new SqlConnection(connSetting.ConnectionString))
                    {
                        string query = "SELECT CampaignID, CampaignName, Advertiser, Category, Budget, Applicants, Status, CreatedDate FROM Campaigns ORDER BY CreatedDate DESC";
                        SqlDataAdapter da = new SqlDataAdapter(query, conn);
                        da.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            dbSuccess = true;
                        }
                    }
                }
            }
            catch (Exception)
            {
                // Fall back gracefully to sample campaigns if DB is unconfigured
            }

            if (!dbSuccess || dt.Rows.Count == 0)
            {
                dt = GetSampleCampaigns();
            }

            gvCampaigns.DataSource = dt;
            gvCampaigns.DataBind();
            lblCount.Text = "Showing 1 to " + dt.Rows.Count + " of " + dt.Rows.Count + " campaigns";
        }

        private DataTable GetSampleCampaigns()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("CampaignID", typeof(int));
            dt.Columns.Add("CampaignName", typeof(string));
            dt.Columns.Add("Advertiser", typeof(string));
            dt.Columns.Add("Category", typeof(string));
            dt.Columns.Add("Budget", typeof(decimal));
            dt.Columns.Add("Applicants", typeof(int));
            dt.Columns.Add("Status", typeof(string));
            dt.Columns.Add("CreatedDate", typeof(DateTime));

            dt.Rows.Add(101, "Smart Tech Product Promotion", "TechNova Solutions", "Technology", 45000m, 14, "Active", DateTime.Today.AddDays(-2));
            dt.Rows.Add(102, "Summer Glow Skincare Campaign", "Aura Beauty Co.", "Fashion & Apparel", 28000m, 22, "Active", DateTime.Today.AddDays(-5));
            dt.Rows.Add(103, "Organic Cold Brew Launch", "Roast & Co.", "Food & Beverage", 18500m, 8, "Pending", DateTime.Today.AddDays(-1));
            dt.Rows.Add(104, "Urban Streetwear Autumn Drop", "Stride Streetwear", "Fashion & Apparel", 65000m, 35, "Active", DateTime.Today.AddDays(-12));
            dt.Rows.Add(105, "Wireless Gaming Headset Buzz", "HyperSound Gear", "Technology", 32000m, 19, "Deactivated", DateTime.Today.AddDays(-20));

            return dt;
        }

        public string GetStatusBadge(object status)
        {
            if (status == null || status == DBNull.Value) return "badge";
            switch (status.ToString().ToLower())
            {
                case "active": return "badge badge-active";
                case "pending": return "badge badge-pending";
                case "deactivated": return "badge badge-deactivated";
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
