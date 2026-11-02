using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class CampaignDetails : Page
    {
        protected int CurrentCampaignId
        {
            get
            {
                object id = ViewState["CampaignId"];
                return id != null ? Convert.ToInt32(id) : 1;
            }
            set
            {
                ViewState["CampaignId"] = value;
            }
        }

        protected int CreatorFollowers { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Influencer");

            LoadCreatorInfo();

            if (!IsPostBack)
            {
                string idStr = Request.QueryString["id"];
                int cid = 1;
                if (!string.IsNullOrEmpty(idStr) && int.TryParse(idStr, out cid))
                {
                    CurrentCampaignId = cid;
                }
                else
                {
                    CurrentCampaignId = 1;
                }

                LoadCampaignData(CurrentCampaignId);
                CheckExistingApplication(CurrentCampaignId);
            }
        }

        private void LoadCreatorInfo()
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

        private void LoadCampaignData(int cid)
        {
            try
            {
                string sql = "SELECT c.CampaignID, c.CompanyID, c.Title, c.Advertiser, c.Category, c.Description, c.Budget, " +
                             "c.MinFollowers, c.MinAge, c.MaxAge, c.Status, " +
                             "comp.Industry, comp.Description AS CompDesc, comp.UserID AS BrandUserID " +
                             "FROM Campaigns c " +
                             "LEFT JOIN Companies comp ON c.CompanyID = comp.CompanyID " +
                             "WHERE c.CampaignID = @cid";

                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@cid", cid));
                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    string title = r["Title"].ToString();
                    string advertiser = r["Advertiser"].ToString();
                    string category = r["Category"].ToString();
                    string description = r["Description"].ToString();
                    decimal budget = r["Budget"] != DBNull.Value ? Convert.ToDecimal(r["Budget"]) : 0;
                    int minFollowers = r["MinFollowers"] != DBNull.Value ? Convert.ToInt32(r["MinFollowers"]) : 0;
                    int minAge = r["MinAge"] != DBNull.Value ? Convert.ToInt32(r["MinAge"]) : 18;
                    int maxAge = r["MaxAge"] != DBNull.Value ? Convert.ToInt32(r["MaxAge"]) : 45;

                    litBreadcrumbAdv.Text = Server.HtmlEncode(advertiser);
                    litPageTitle.Text = Server.HtmlEncode(title);
                    litDetailsTitle.Text = Server.HtmlEncode(title);
                    litCampaignBy.Text = Server.HtmlEncode(advertiser);
                    litCategoryBadge.Text = Server.HtmlEncode(category);
                    litDescription.Text = Server.HtmlEncode(description);
                    litBudget.Text = "₹" + budget.ToString("N0");
                    txtProposedRate.Text = Convert.ToInt32(budget).ToString();

                    litMinFollowers.Text = minFollowers > 0 ? "Min " + minFollowers.ToString("N0") : "No minimum";
                    litAgeRange.Text = string.Format("{0} – {1} years", minAge, maxAge);

                    // Image
                    imgHero.ImageUrl = GetCampaignImage(category);

                    // Check eligibility
                    if (minFollowers == 0 || CreatorFollowers >= minFollowers)
                    {
                        pnlEligible.Visible = true;
                        pnlNotEligible.Visible = false;
                    }
                    else
                    {
                        pnlEligible.Visible = false;
                        pnlNotEligible.Visible = true;
                    }

                    // About Advertiser
                    litAdvName.Text = Server.HtmlEncode(advertiser);
                    litAdvIndustry.Text = !string.IsNullOrEmpty(r["Industry"].ToString()) ? Server.HtmlEncode(r["Industry"].ToString()) : Server.HtmlEncode(category);
                    litAdvDesc.Text = !string.IsNullOrEmpty(r["CompDesc"].ToString()) ? Server.HtmlEncode(r["CompDesc"].ToString()) : "Trusted brand partner collaborating with creative voices on the Influish marketplace.";

                    string[] advParts = advertiser.Trim().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    if (advParts.Length >= 2)
                    {
                        litAdvInitials.Text = (advParts[0][0].ToString() + advParts[1][0].ToString()).ToUpper();
                    }
                    else if (advParts.Length == 1 && advParts[0].Length > 0)
                    {
                        litAdvInitials.Text = advParts[0].Substring(0, Math.Min(2, advParts[0].Length)).ToUpper();
                    }

                    // Deliverables
                    DataTable dtDeliv = DbHelper.ExecuteDataTable(
                        "SELECT Platform, DeliverableType, Quantity, Instructions FROM CampaignDeliverables WHERE CampaignID = @cid",
                        new SqlParameter("@cid", cid)
                    );

                    if (dtDeliv.Rows.Count > 0)
                    {
                        rptDeliverables.DataSource = dtDeliv;
                        rptDeliverables.DataBind();
                    }
                    else
                    {
                        // Fallback sample deliverables
                        DataTable dtSample = new DataTable();
                        dtSample.Columns.Add("Platform", typeof(string));
                        dtSample.Columns.Add("DeliverableType", typeof(string));
                        dtSample.Columns.Add("Quantity", typeof(int));
                        dtSample.Columns.Add("Instructions", typeof(string));
                        dtSample.Rows.Add("Instagram", "Reel (60s)", 1, "High quality product unboxing showcasing key features and user experience.");
                        dtSample.Rows.Add("Instagram", "Story with Link", 2, "Swipe-up link to product landing page with campaign hashtag.");
                        rptDeliverables.DataSource = dtSample;
                        rptDeliverables.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                pnlApplyError.Visible = true;
                lblApplyError.Text = "Error loading campaign details: " + Server.HtmlEncode(ex.Message);
            }
        }

        private void CheckExistingApplication(int cid)
        {
            int infId = Session["InfluencerID"] != null ? Convert.ToInt32(Session["InfluencerID"]) : 0;
            if (infId > 0)
            {
                try
                {
                    DataTable dtApp = DbHelper.ExecuteDataTable(
                        "SELECT ApplicationID, Status, AppliedAt FROM Applications WHERE CampaignID = @cid AND InfluencerID = @infId",
                        new SqlParameter("@cid", cid),
                        new SqlParameter("@infId", infId)
                    );

                    if (dtApp.Rows.Count > 0)
                    {
                        DataRow appRow = dtApp.Rows[0];
                        string status = appRow["Status"].ToString();
                        DateTime appliedAt = Convert.ToDateTime(appRow["AppliedAt"]);

                        litAppliedStatus.Text = Server.HtmlEncode(status);
                        litAppliedDate.Text = "Applied on " + appliedAt.ToString("MMM dd, yyyy");

                        pnlAlreadyApplied.Visible = true;
                        pnlApplyForm.Visible = false;
                    }
                }
                catch
                {
                }
            }
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            pnlApplyError.Visible = false;
            lblApplyError.Text = "";

            Page.Validate("ApplyVal");
            if (!Page.IsValid)
            {
                return;
            }

            int infId = Session["InfluencerID"] != null ? Convert.ToInt32(Session["InfluencerID"]) : 0;
            if (infId <= 0)
            {
                pnlApplyError.Visible = true;
                lblApplyError.Text = "Your influencer profile is not initialized. Please set up your profile first.";
                return;
            }

            decimal proposedRate = 0;
            decimal.TryParse(txtProposedRate.Text.Trim(), out proposedRate);
            string coverLetter = txtCoverLetter.Text.Trim();

            try
            {
                // Verify campaign exists and get Brand UserID
                DataTable dtCamp = DbHelper.ExecuteDataTable(
                    "SELECT c.CompanyID, c.Title, comp.UserID AS BrandUserID " +
                    "FROM Campaigns c " +
                    "LEFT JOIN Companies comp ON c.CompanyID = comp.CompanyID " +
                    "WHERE c.CampaignID = @cid",
                    new SqlParameter("@cid", CurrentCampaignId)
                );

                if (dtCamp.Rows.Count == 0)
                {
                    pnlApplyError.Visible = true;
                    lblApplyError.Text = "Campaign not found.";
                    return;
                }

                int brandUserId = dtCamp.Rows[0]["BrandUserID"] != DBNull.Value ? Convert.ToInt32(dtCamp.Rows[0]["BrandUserID"]) : 0;
                string campTitle = dtCamp.Rows[0]["Title"].ToString();
                string creatorName = Session["FullName"] != null ? Session["FullName"].ToString() : "Creator";

                // Insert into Applications table
                DbHelper.ExecuteNonQuery(
                    "INSERT INTO Applications (CampaignID, InfluencerID, CoverLetter, ProposedRate, Status, AppliedAt) " +
                    "VALUES (@cid, @infId, @cover, @rate, 'Pending', GETDATE())",
                    new SqlParameter("@cid", CurrentCampaignId),
                    new SqlParameter("@infId", infId),
                    new SqlParameter("@cover", coverLetter),
                    new SqlParameter("@rate", proposedRate)
                );

                // Update applicant count on Campaign
                DbHelper.ExecuteNonQuery(
                    "UPDATE Campaigns SET Applicants = (SELECT COUNT(*) FROM Applications WHERE CampaignID = @cid) WHERE CampaignID = @cid",
                    new SqlParameter("@cid", CurrentCampaignId)
                );

                // Send notification to Brand if BrandUserID is available
                if (brandUserId > 0)
                {
                    string notifMsg = string.Format("{0} applied to your campaign \"{1}\".", creatorName, campTitle);
                    DbHelper.ExecuteNonQuery(
                        "INSERT INTO Notifications (UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt) " +
                        "VALUES (@uid, @msg, 'Applicant', @cid, 0, GETDATE())",
                        new SqlParameter("@uid", brandUserId),
                        new SqlParameter("@msg", notifMsg),
                        new SqlParameter("@cid", CurrentCampaignId)
                    );
                }

                pnlApplyForm.Visible = false;
                pnlApplySuccess.Visible = true;
            }
            catch (Exception ex)
            {
                pnlApplyError.Visible = true;
                lblApplyError.Text = "Failed to submit application: " + Server.HtmlEncode(ex.Message);
            }
        }

        private string GetCampaignImage(string category)
        {
            string cat = category.ToLower();
            if (cat.Contains("tech"))
                return "https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=900&q=80&fit=crop";
            if (cat.Contains("beauty") || cat.Contains("skincare"))
                return "https://images.unsplash.com/photo-1556228720-195a672e8a03?w=900&q=80&fit=crop";
            if (cat.Contains("fashion") || cat.Contains("apparel"))
                return "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=900&q=80&fit=crop";
            if (cat.Contains("fitness") || cat.Contains("health"))
                return "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=900&q=80&fit=crop";
            if (cat.Contains("food") || cat.Contains("culinary"))
                return "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=900&q=80&fit=crop";
            if (cat.Contains("travel"))
                return "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=900&q=80&fit=crop";

            return "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=900&q=80&fit=crop";
        }
    }
}
