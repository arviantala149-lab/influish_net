using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Influish_net.Helpers;

namespace Influish_net.Advertiser
{
    public partial class CreateCampaign : Page
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
                LoadCategories();

                string idStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idStr))
                {
                    int id;
                    if (int.TryParse(idStr, out id))
                    {
                        litPageHeading.Text = "Edit Campaign";
                        btnSave.Text = "Update Campaign";
                        LoadCampaign(id);
                    }
                }
            }
        }

        private void LoadCategories()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteDataTable("SELECT CategoryName FROM Categories WHERE IsActive = 1 ORDER BY DisplayOrder, CategoryName");
                if (dt.Rows.Count > 0)
                {
                    string current = ddlCategory.SelectedValue;
                    ddlCategory.Items.Clear();
                    ddlCategory.Items.Add(new ListItem("Select Category", ""));
                    foreach (DataRow row in dt.Rows)
                    {
                        string name = row["CategoryName"].ToString();
                        ddlCategory.Items.Add(new ListItem(name, name));
                    }
                    if (!string.IsNullOrEmpty(current) && ddlCategory.Items.FindByValue(current) != null)
                    {
                        ddlCategory.SelectedValue = current;
                    }
                }
            }
            catch
            {
            }
        }

        private void LoadCampaign(int id)
        {
            try
            {
                int cid = CurrentCompanyId;
                DataTable dt = DbHelper.ExecuteDataTable(
                    "SELECT Title, Description, Category, Budget, MinFollowers, MinAge, MaxAge FROM Campaigns WHERE CampaignID = @id AND CompanyID = @cid",
                    new SqlParameter("@id", id),
                    new SqlParameter("@cid", cid)
                );

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    txtTitle.Text = r["Title"].ToString();
                    txtDescription.Text = r["Description"].ToString();

                    string cat = r["Category"].ToString();
                    if (ddlCategory.Items.FindByValue(cat) != null)
                    {
                        ddlCategory.SelectedValue = cat;
                    }
                    else if (ddlCategory.Items.FindByText(cat) != null)
                    {
                        ddlCategory.Items.FindByText(cat).Selected = true;
                    }

                    if (r["Budget"] != DBNull.Value)
                    {
                        txtBudget.Text = Convert.ToDecimal(r["Budget"]).ToString("0.##");
                    }

                    if (r["MinFollowers"] != DBNull.Value)
                    {
                        txtMinFollowers.Text = r["MinFollowers"].ToString();
                    }

                    if (r["MinAge"] != DBNull.Value)
                    {
                        txtMinAge.Text = r["MinAge"].ToString();
                    }

                    if (r["MaxAge"] != DBNull.Value)
                    {
                        txtMaxAge.Text = r["MaxAge"].ToString();
                    }
                }
                else
                {
                    ShowErrorMessage("Campaign not found or you do not have permission to edit it.");
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading campaign details: " + Server.HtmlEncode(ex.Message));
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid)
            {
                ShowErrorMessage("Please correct the highlighted validation errors below.");
                return;
            }

            string title = txtTitle.Text.Trim();
            string description = txtDescription.Text.Trim();
            string category = ddlCategory.SelectedValue;

            decimal budget = 0;
            decimal.TryParse(txtBudget.Text.Trim(), out budget);

            int minFollowers = 0;
            if (!string.IsNullOrEmpty(txtMinFollowers.Text.Trim()))
            {
                int.TryParse(txtMinFollowers.Text.Trim(), out minFollowers);
            }

            int minAge = 18;
            if (!string.IsNullOrEmpty(txtMinAge.Text.Trim()))
            {
                int.TryParse(txtMinAge.Text.Trim(), out minAge);
            }

            int maxAge = 55;
            if (!string.IsNullOrEmpty(txtMaxAge.Text.Trim()))
            {
                int.TryParse(txtMaxAge.Text.Trim(), out maxAge);
            }

            if (maxAge > 0 && minAge > 0 && minAge > maxAge)
            {
                ShowErrorMessage("Minimum age cannot be greater than maximum age.");
                return;
            }

            int cid = CurrentCompanyId;
            if (cid == 0)
            {
                ShowErrorMessage("Error identifying your advertiser account. Please log in again.");
                return;
            }

            // Look up company name
            object compNameObj = DbHelper.ExecuteScalar(
                "SELECT CompanyName FROM Companies WHERE CompanyID = @cid",
                new SqlParameter("@cid", cid)
            );
            string advertiserName = compNameObj != null ? compNameObj.ToString().Trim() : "Brand Account";

            try
            {
                string idStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idStr))
                {
                    int id;
                    if (int.TryParse(idStr, out id))
                    {
                        string updateQuery = @"
                            UPDATE Campaigns 
                            SET Title = @title, Description = @desc, Category = @cat, Budget = @bud, 
                                MinFollowers = @mf, MinAge = @minA, MaxAge = @maxA 
                            WHERE CampaignID = @id AND CompanyID = @cid";

                        DbHelper.ExecuteNonQuery(
                            updateQuery,
                            new SqlParameter("@title", title),
                            new SqlParameter("@desc", description),
                            new SqlParameter("@cat", category),
                            new SqlParameter("@bud", budget),
                            new SqlParameter("@mf", minFollowers > 0 ? (object)minFollowers : DBNull.Value),
                            new SqlParameter("@minA", minAge > 0 ? (object)minAge : DBNull.Value),
                            new SqlParameter("@maxA", maxAge > 0 ? (object)maxAge : DBNull.Value),
                            new SqlParameter("@id", id),
                            new SqlParameter("@cid", cid)
                        );

                        Response.Redirect("~/Advertiser/MyCampaigns.aspx");
                        return;
                    }
                }
                else
                {
                    string insertQuery = @"
                        INSERT INTO Campaigns(CompanyID, Title, Advertiser, Description, Category, Budget, MinFollowers, MinAge, MaxAge, Status, CreatedDate)
                        VALUES(@cid, @title, @advertiser, @desc, @cat, @bud, @mf, @minA, @maxA, 'Open', GETDATE());
                        SELECT SCOPE_IDENTITY();";

                    object newIdObj = DbHelper.ExecuteScalar(
                        insertQuery,
                        new SqlParameter("@cid", cid),
                        new SqlParameter("@title", title),
                        new SqlParameter("@advertiser", advertiserName),
                        new SqlParameter("@desc", description),
                        new SqlParameter("@cat", category),
                        new SqlParameter("@bud", budget),
                        new SqlParameter("@mf", minFollowers > 0 ? (object)minFollowers : DBNull.Value),
                        new SqlParameter("@minA", minAge > 0 ? (object)minAge : DBNull.Value),
                        new SqlParameter("@maxA", maxAge > 0 ? (object)maxAge : DBNull.Value)
                    );

                    int newCampaignId = newIdObj != null ? Convert.ToInt32(newIdObj) : 0;

                    if (newCampaignId > 0)
                    {
                        // Add default deliverable
                        DbHelper.ExecuteNonQuery(
                            @"INSERT INTO CampaignDeliverables(CampaignID, Platform, DeliverableType, Quantity, Instructions, DueDays)
                              VALUES(@cid, 'Instagram', 'Reel (60s)', 1, 'Authentic product review and showcase highlighting main features.', 7)",
                            new SqlParameter("@cid", newCampaignId)
                        );

                        // Notify advertiser of successful launch
                        if (Session["UserID"] != null)
                        {
                            int uid = Convert.ToInt32(Session["UserID"]);
                            DbHelper.ExecuteNonQuery(
                                @"INSERT INTO Notifications(UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt)
                                  VALUES(@uid, @msg, 'CampaignLive', @cid, 0, GETDATE())",
                                new SqlParameter("@uid", uid),
                                new SqlParameter("@msg", string.Format("Your campaign \"{0}\" is now live and open for influencer applications.", title)),
                                new SqlParameter("@cid", newCampaignId)
                            );
                        }
                    }

                    Response.Redirect("~/Advertiser/MyCampaigns.aspx");
                    return;
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error saving campaign: " + Server.HtmlEncode(ex.Message));
            }
        }

        private void ShowErrorMessage(string msg)
        {
            lblMessage.Text = msg;
            pnlMessage.Visible = true;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Advertiser/MyCampaigns.aspx");
        }
    }
}
