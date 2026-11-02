using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class Campaigns : Page
    {
        protected int CreatorFollowers { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Influencer");

            LoadCreatorFollowers();

            if (!IsPostBack)
            {
                PopulateCategories();

                string searchParam = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(searchParam))
                {
                    txtSearch.Text = searchParam;
                }

                string catParam = Request.QueryString["cat"];
                if (!string.IsNullOrEmpty(catParam) && ddlCategory.Items.FindByValue(catParam) != null)
                {
                    ddlCategory.SelectedValue = catParam;
                }

                BindCampaigns();
            }
        }

        private void LoadCreatorFollowers()
        {
            int infId = Session["InfluencerID"] != null ? Convert.ToInt32(Session["InfluencerID"]) : 0;
            if (infId > 0)
            {
                try
                {
                    object fObj = DbHelper.ExecuteScalar(
                        "SELECT FollowerCount FROM Influencers WHERE InfluencerID = @id",
                        new SqlParameter("@id", infId)
                    );
                    if (fObj != null && fObj != DBNull.Value)
                    {
                        CreatorFollowers = Convert.ToInt32(fObj);
                        return;
                    }
                }
                catch
                {
                }
            }
            CreatorFollowers = 25000;
        }

        private void PopulateCategories()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteDataTable("SELECT CategoryName FROM Categories WHERE IsActive = 1 ORDER BY DisplayOrder");
                ddlCategory.Items.Clear();
                ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem("All Categories", ""));
                foreach (DataRow r in dt.Rows)
                {
                    string c = r["CategoryName"].ToString();
                    ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem(c, c));
                }
            }
            catch
            {
            }
        }

        private void BindCampaigns()
        {
            try
            {
                string sql = "SELECT CampaignID, Title, Advertiser, Category, Description, Budget, MinFollowers, Status " +
                             "FROM Campaigns " +
                             "WHERE (Status = 'Active' OR Status = 'Open') ";

                List<SqlParameter> pars = new List<SqlParameter>();

                string search = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (Title LIKE @kw OR Advertiser LIKE @kw OR Description LIKE @kw) ";
                    pars.Add(new SqlParameter("@kw", "%" + search + "%"));
                }

                string cat = ddlCategory.SelectedValue;
                if (!string.IsNullOrEmpty(cat))
                {
                    sql += " AND Category = @cat ";
                    pars.Add(new SqlParameter("@cat", cat));
                }

                string budget = ddlBudget.SelectedValue;
                if (!string.IsNullOrEmpty(budget))
                {
                    decimal bud;
                    if (decimal.TryParse(budget, out bud))
                    {
                        if (bud == 50001)
                        {
                            sql += " AND Budget >= 50000 ";
                        }
                        else
                        {
                            sql += " AND Budget <= @bud ";
                            pars.Add(new SqlParameter("@bud", bud));
                        }
                    }
                }

                sql += " ORDER BY CampaignID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(sql, pars.ToArray());

                if (dt.Rows.Count > 0)
                {
                    rptCampaigns.DataSource = dt;
                    rptCampaigns.DataBind();
                    rptCampaigns.Visible = true;
                    pnlNoResults.Visible = false;
                }
                else
                {
                    rptCampaigns.Visible = false;
                    pnlNoResults.Visible = true;
                }
            }
            catch
            {
                rptCampaigns.Visible = false;
                pnlNoResults.Visible = true;
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            BindCampaigns();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlCategory.SelectedIndex = 0;
            ddlBudget.SelectedIndex = 0;
            BindCampaigns();
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
            if (folObj == null || folObj == DBNull.Value) return "Open";
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
