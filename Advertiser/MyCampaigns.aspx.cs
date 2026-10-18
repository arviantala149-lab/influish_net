using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Influish_net.Advertiser
{
    public partial class MyCampaigns : Page
    {
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
            if (!IsPostBack)
            {
                CurrentFilter = "all";
                LoadCampaigns();
            }
        }

        private string GetConnectionString()
        {
            try
            {
                var conn = ConfigurationManager.ConnectionStrings["InfluishConnection"];
                if (conn != null)
                {
                    return conn.ConnectionString;
                }
            }
            catch
            {
            }
            return string.Empty;
        }

        private void LoadCampaigns()
        {
            DataTable dtResult = new DataTable();
            bool dbSuccess = false;

            try
            {
                string cs = GetConnectionString();
                if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        string query = "SELECT c.CampaignID, c.Title, c.Description, c.Category, c.Budget, c.MinFollowers, c.Status, " +
                                       "ISNULL(a.AppCount, 0) AS ApplicantCount " +
                                       "FROM Campaigns c " +
                                       "LEFT JOIN (SELECT CampaignID, COUNT(*) AS AppCount FROM Applications GROUP BY CampaignID) a " +
                                       "ON c.CampaignID = a.CampaignID ";

                        if (CurrentFilter == "open")
                        {
                            query += " WHERE c.Status='Open' OR c.Status='Active' ";
                        }
                        else if (CurrentFilter == "closed")
                        {
                            query += " WHERE c.Status='Closed' OR c.Status='Ended' ";
                        }

                        query += " ORDER BY c.CampaignID DESC";

                        SqlDataAdapter da = new SqlDataAdapter(query, con);
                        da.Fill(dtResult);
                        dbSuccess = true;

                        // Count open and closed
                        SqlCommand cmdOpen = new SqlCommand("SELECT COUNT(*) FROM Campaigns WHERE Status='Open' OR Status='Active'", con);
                        SqlCommand cmdClosed = new SqlCommand("SELECT COUNT(*) FROM Campaigns WHERE Status='Closed' OR Status='Ended'", con);
                        con.Open();
                        litOpenCount.Text = cmdOpen.ExecuteScalar().ToString();
                        litClosedCount.Text = cmdClosed.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception)
            {
            }

            if (!dbSuccess || dtResult.Rows.Count == 0)
            {
                // Populate Figma sample campaigns
                DataTable dtAll = GetSampleCampaigns();

                // Set counts
                litOpenCount.Text = "2";
                litClosedCount.Text = "1";

                DataView dv = new DataView(dtAll);
                if (CurrentFilter == "open")
                {
                    dv.RowFilter = "Status = 'Open' OR Status = 'Active'";
                }
                else if (CurrentFilter == "closed")
                {
                    dv.RowFilter = "Status = 'Closed' OR Status = 'Ended'";
                }
                dtResult = dv.ToTable();
            }

            if (dtResult.Rows.Count > 0)
            {
                rptCampaigns.DataSource = dtResult;
                rptCampaigns.DataBind();
                rptCampaigns.Visible = true;
                pnlEmpty.Visible = false;
                litShowingCount.Text = string.Format("Showing 1 to {0} of {0} campaigns", dtResult.Rows.Count);
            }
            else
            {
                rptCampaigns.Visible = false;
                pnlEmpty.Visible = true;
                litShowingCount.Text = "Showing 0 campaigns";
            }
        }

        private DataTable GetSampleCampaigns()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("CampaignID", typeof(int));
            dt.Columns.Add("Title", typeof(string));
            dt.Columns.Add("Description", typeof(string));
            dt.Columns.Add("Category", typeof(string));
            dt.Columns.Add("Budget", typeof(decimal));
            dt.Columns.Add("MinFollowers", typeof(int));
            dt.Columns.Add("Status", typeof(string));
            dt.Columns.Add("ApplicantCount", typeof(int));

            dt.Rows.Add(1, "Smart Tech Wireless Earbuds Review", "Looking for tech reviewers to create unboxing and hands-on feature reels for our flagship true wireless stereo earbuds.", "Tech & Gadgets", 75000m, 100000, "Open", 89);
            dt.Rows.Add(2, "Diwali Festive Wear Collection Promotion", "Seeking fashion & lifestyle influencers to showcase our new festive collection with authentic styling guides and festive lookbooks.", "Fashion & Lifestyle", 150000m, 50000, "Open", 215);
            dt.Rows.Add(3, "Organic Skincare Routine Launch", "Reels campaign focusing on natural morning skincare routine and cruelty-free benefits.", "Beauty & Wellness", 40000m, 25000, "Closed", 312);

            return dt;
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
            else if (s == "closed" || s == "ended")
            {
                return "closed";
            }
            return "closed";
        }

        public string GetPostedText(object idObj)
        {
            if (idObj != null)
            {
                int id = 0;
                if (int.TryParse(idObj.ToString(), out id))
                {
                    if (id == 1) return "Posted 2 days ago";
                    if (id == 2) return "Posted 5 days ago";
                    if (id == 3) return "Ended Oct 15";
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
                try
                {
                    string cs = GetConnectionString();
                    if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER"))
                    {
                        using (SqlConnection con = new SqlConnection(cs))
                        {
                            SqlCommand cmd = new SqlCommand("DELETE FROM Campaigns WHERE CampaignID=@id", con);
                            cmd.Parameters.AddWithValue("@id", id);
                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                catch (Exception)
                {
                }
                LoadCampaigns();
            }
        }
    }
}
