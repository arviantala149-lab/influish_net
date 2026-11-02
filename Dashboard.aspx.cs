using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class Dashboard : Page
    {
        protected int CurrentInfluencerId
        {
            get
            {
                if (Session["InfluencerID"] != null)
                {
                    return Convert.ToInt32(Session["InfluencerID"]);
                }
                return 0;
            }
        }

        protected int CreatorFollowers { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Influencer");

            if (!IsPostBack)
            {
                LoadCreatorStats();
                PopulateCategoryFilter();
                LoadCampaigns();
            }
        }

        private void LoadCreatorStats()
        {
            string fullName = Session["FullName"] != null ? Session["FullName"].ToString() : "Creator";
            string firstName = fullName.Split(' ')[0];
            litCreatorName.Text = Server.HtmlEncode(firstName);

            int infId = CurrentInfluencerId;

            // Load creator's actual follower count
            try
            {
                object folObj = DbHelper.ExecuteScalar(
                    "SELECT FollowerCount FROM Influencers WHERE InfluencerID = @id",
                    new SqlParameter("@id", infId)
                );
                if (folObj != null && folObj != DBNull.Value)
                {
                    CreatorFollowers = Convert.ToInt32(folObj);
                }
            }
            catch
            {
                CreatorFollowers = 25000;
            }

            try
            {
                object sentObj = DbHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM Applications WHERE InfluencerID = @id",
                    new SqlParameter("@id", infId)
                );
                litSentCount.Text = sentObj != null ? sentObj.ToString() : "0";

                object acceptedObj = DbHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM Applications WHERE InfluencerID = @id AND Status = 'Accepted'",
                    new SqlParameter("@id", infId)
                );
                litAcceptedCount.Text = acceptedObj != null ? acceptedObj.ToString() : "0";

                object pendingObj = DbHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM Applications WHERE InfluencerID = @id AND Status = 'Pending'",
                    new SqlParameter("@id", infId)
                );
                litPendingCount.Text = pendingObj != null ? pendingObj.ToString() : "0";
            }
            catch
            {
                litSentCount.Text = "0";
                litAcceptedCount.Text = "0";
                litPendingCount.Text = "0";
            }
        }

        private void PopulateCategoryFilter()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteDataTable("SELECT CategoryName FROM Categories WHERE IsActive = 1 ORDER BY DisplayOrder");
                ddlCategoryFilter.Items.Clear();
                ddlCategoryFilter.Items.Add(new System.Web.UI.WebControls.ListItem("All Categories", "All"));
                foreach (DataRow row in dt.Rows)
                {
                    string cat = row["CategoryName"].ToString();
                    ddlCategoryFilter.Items.Add(new System.Web.UI.WebControls.ListItem(cat, cat));
                }
            }
            catch
            {
            }
        }

        private void LoadCampaigns()
        {
            try
            {
                string sql = "SELECT CampaignID, Title, Advertiser, Category, Description, Budget, MinFollowers, Status " +
                             "FROM Campaigns " +
                             "WHERE (Status = 'Active' OR Status = 'Open') ";

                string selectedCat = ddlCategoryFilter.SelectedValue;
                if (!string.IsNullOrEmpty(selectedCat) && selectedCat != "All")
                {
                    sql += " AND Category = @cat ";
                }
                sql += " ORDER BY CampaignID DESC";

                SqlParameter[] pars = null;
                if (!string.IsNullOrEmpty(selectedCat) && selectedCat != "All")
                {
                    pars = new SqlParameter[] { new SqlParameter("@cat", selectedCat) };
                }

                DataTable dt = DbHelper.ExecuteDataTable(sql, pars);
                if (dt.Rows.Count > 0)
                {
                    rptCampaigns.DataSource = dt;
                    rptCampaigns.DataBind();
                    rptCampaigns.Visible = true;
                    pnlNoCampaigns.Visible = false;
                }
                else
                {
                    rptCampaigns.Visible = false;
                    pnlNoCampaigns.Visible = true;
                }
            }
            catch
            {
                rptCampaigns.Visible = false;
                pnlNoCampaigns.Visible = true;
            }
        }

        protected void ddlCategoryFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCampaigns();
        }

        public string FormatBudget(object budgetObj)
        {
            if (budgetObj == null || budgetObj == DBNull.Value) return "₹0";
            decimal val;
            if (decimal.TryParse(budgetObj.ToString(), out val))
            {
                return "₹" + val.ToString("N0");
            }
            return "₹" + budgetObj.ToString();
        }

        public string FormatFollowers(object folObj)
        {
            if (folObj == null || folObj == DBNull.Value) return "None";
            int count;
            if (int.TryParse(folObj.ToString(), out count))
            {
                if (count == 0) return "Open to all";
                if (count >= 1000) return (count / 1000.0).ToString("0.#") + "k+";
                return count.ToString() + "+";
            }
            return folObj.ToString();
        }

        public string GetEligibilityBadge(object reqFollowersObj)
        {
            int req = 0;
            if (reqFollowersObj != null && reqFollowersObj != DBNull.Value)
            {
                int.TryParse(reqFollowersObj.ToString(), out req);
            }

            if (req == 0 || CreatorFollowers >= req)
            {
                return "✔ Eligible";
            }
            return "Reach: " + FormatFollowers(req);
        }

        public string GetCampaignImage(object categoryObj, object cidObj)
        {
            string cat = categoryObj != null ? categoryObj.ToString().ToLower() : "";
            if (cat.Contains("tech"))
                return "https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&q=80&fit=crop";
            if (cat.Contains("beauty") || cat.Contains("skincare"))
                return "https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80&fit=crop";
            if (cat.Contains("fashion") || cat.Contains("apparel"))
                return "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=600&q=80&fit=crop";
            if (cat.Contains("fitness") || cat.Contains("health"))
                return "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=600&q=80&fit=crop";
            if (cat.Contains("food") || cat.Contains("culinary"))
                return "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80&fit=crop";
            if (cat.Contains("travel"))
                return "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&q=80&fit=crop";

            return "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=600&q=80&fit=crop";
        }
    }
}
