using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Influish_net.Advertiser
{
    public partial class CampaignDetails : Page
    {
        protected int CurrentCampaignId
        {
            get
            {
                object cid = ViewState["CampaignId"];
                return cid != null ? Convert.ToInt32(cid) : 1;
            }
            set
            {
                ViewState["CampaignId"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
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
                    CurrentCampaignId = 1;
                }

                LoadCampaign(CurrentCampaignId);
                LoadApplicants(CurrentCampaignId);
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

        private void LoadCampaign(int id)
        {
            bool loaded = false;
            try
            {
                string cs = GetConnectionString();
                if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        SqlCommand cmd = new SqlCommand("SELECT Title, Description, Category, Budget FROM Campaigns WHERE CampaignID=@id", con);
                        cmd.Parameters.AddWithValue("@id", id);
                        con.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                string title = r["Title"].ToString();
                                lblTitle.Text = title;
                                litBreadcrumbTitle.Text = title;
                                lblDescription.Text = r["Description"].ToString();
                                lblCategory.Text = r["Category"].ToString();

                                decimal budgetVal = 0;
                                if (decimal.TryParse(r["Budget"].ToString(), out budgetVal))
                                {
                                    lblBudget.Text = "₹" + budgetVal.ToString("N0");
                                }
                                else
                                {
                                    lblBudget.Text = r["Budget"].ToString();
                                }
                                loaded = true;
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
            }

            if (!loaded)
            {
                // Default Figma reference representation
                lblTitle.Text = "Smart Tech Product Promotion";
                litBreadcrumbTitle.Text = "Smart Tech Product Promotion";
                lblCategory.Text = "Tech & Gadgets";
                lblBudget.Text = "₹10,000";
                lblDescription.Text = "We are launching our new flagship smart device and looking for tech-savvy creators to help us spread the word. This campaign involves creating unboxing and review content focusing on the innovative features and seamless integration into daily life.";
            }
        }

        private void LoadApplicants(int campaignId)
        {
            DataTable dtApplicants = new DataTable();
            bool hasDbData = false;

            try
            {
                string cs = GetConnectionString();
                if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        string query = "SELECT a.ApplicationID, i.InfluencerID, i.Name AS InfluencerName, i.FollowerCount, i.Category, a.Status, a.AppliedAt " +
                                       "FROM Applications a " +
                                       "INNER JOIN Influencers i ON a.InfluencerID = i.InfluencerID " +
                                       "WHERE a.CampaignID = @cid";
                        SqlDataAdapter da = new SqlDataAdapter(query, con);
                        da.SelectCommand.Parameters.AddWithValue("@cid", campaignId);
                        da.Fill(dtApplicants);
                        hasDbData = true;
                    }
                }
            }
            catch (Exception)
            {
            }

            if (!hasDbData || dtApplicants.Rows.Count == 0)
            {
                dtApplicants = GetSampleApplicants();
            }

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

        private DataTable GetSampleApplicants()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ApplicationID", typeof(int));
            dt.Columns.Add("InfluencerID", typeof(int));
            dt.Columns.Add("InfluencerName", typeof(string));
            dt.Columns.Add("Category", typeof(string));
            dt.Columns.Add("FollowerCount", typeof(int));
            dt.Columns.Add("Status", typeof(string));
            dt.Columns.Add("AppliedAt", typeof(DateTime));

            dt.Rows.Add(1, 101, "Mer Nensi", "Tech", 18500, "Pending", DateTime.Now.AddDays(-2));
            dt.Rows.Add(2, 102, "Devaliya Riddhi", "Lifestyle, Tech", 25200, "Accepted", DateTime.Now.AddDays(-3));
            dt.Rows.Add(3, 103, "Sarah Jenkins", "Tech", 12800, "Rejected", DateTime.Now.AddDays(-4));
            dt.Rows.Add(4, 104, "Alex Johnson", "Tech", 45100, "Pending", DateTime.Now.AddDays(-5));

            return dt;
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
            try
            {
                string cs = GetConnectionString();
                if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        SqlCommand cmd = new SqlCommand("UPDATE Applications SET Status=@s WHERE ApplicationID=@id", con);
                        cmd.Parameters.AddWithValue("@s", status);
                        cmd.Parameters.AddWithValue("@id", appId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception)
            {
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
