using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Influish_net.Advertiser
{
    public partial class CreateCampaign : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
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
            try
            {
                string cs = GetConnectionString();
                if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        SqlCommand cmd = new SqlCommand("SELECT Title, Description, Category, Budget, MinFollowers, MinAge, MaxAge FROM Campaigns WHERE CampaignID=@id", con);
                        cmd.Parameters.AddWithValue("@id", id);
                        con.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
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
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error loading campaign details: " + Server.HtmlEncode(ex.Message));
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Syllabus requirement: Always validate on the server side
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

            int minAge = 0;
            if (!string.IsNullOrEmpty(txtMinAge.Text.Trim()))
            {
                int.TryParse(txtMinAge.Text.Trim(), out minAge);
            }

            int maxAge = 0;
            if (!string.IsNullOrEmpty(txtMaxAge.Text.Trim()))
            {
                int.TryParse(txtMaxAge.Text.Trim(), out maxAge);
            }

            // Additional server check
            if (maxAge > 0 && minAge > 0 && minAge > maxAge)
            {
                ShowErrorMessage("Minimum age cannot be greater than maximum age.");
                return;
            }

            try
            {
                string cs = GetConnectionString();
                if (string.IsNullOrEmpty(cs) || cs.Contains("YOUR_SERVER"))
                {
                    // When database connection is pending configuration, redirect gracefully
                    Response.Redirect("~/Advertiser/MyCampaigns.aspx");
                    return;
                }

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string idStr = Request.QueryString["id"];
                    if (!string.IsNullOrEmpty(idStr))
                    {
                        int id;
                        if (int.TryParse(idStr, out id))
                        {
                            SqlCommand cmdUpdate = new SqlCommand("UPDATE Campaigns SET Title=@title, Description=@desc, Category=@cat, Budget=@bud, MinFollowers=@mf, MinAge=@minA, MaxAge=@maxA WHERE CampaignID=@id", con);
                            cmdUpdate.Parameters.AddWithValue("@title", title);
                            cmdUpdate.Parameters.AddWithValue("@desc", description);
                            cmdUpdate.Parameters.AddWithValue("@cat", category);
                            cmdUpdate.Parameters.AddWithValue("@bud", budget);
                            cmdUpdate.Parameters.AddWithValue("@mf", minFollowers > 0 ? (object)minFollowers : DBNull.Value);
                            cmdUpdate.Parameters.AddWithValue("@minA", minAge > 0 ? (object)minAge : DBNull.Value);
                            cmdUpdate.Parameters.AddWithValue("@maxA", maxAge > 0 ? (object)maxAge : DBNull.Value);
                            cmdUpdate.Parameters.AddWithValue("@id", id);
                            con.Open();
                            cmdUpdate.ExecuteNonQuery();
                            Response.Redirect("~/Advertiser/MyCampaigns.aspx");
                            return;
                        }
                    }
                    else
                    {
                        SqlCommand cmd = new SqlCommand("INSERT INTO Campaigns(Title, Description, Category, Budget, MinFollowers, MinAge, MaxAge, Status) VALUES(@title,@desc,@cat,@bud,@mf,@minA,@maxA,@status)", con);
                        cmd.Parameters.AddWithValue("@title", title);
                        cmd.Parameters.AddWithValue("@desc", description);
                        cmd.Parameters.AddWithValue("@cat", category);
                        cmd.Parameters.AddWithValue("@bud", budget);
                        cmd.Parameters.AddWithValue("@mf", minFollowers > 0 ? (object)minFollowers : DBNull.Value);
                        cmd.Parameters.AddWithValue("@minA", minAge > 0 ? (object)minAge : DBNull.Value);
                        cmd.Parameters.AddWithValue("@maxA", maxAge > 0 ? (object)maxAge : DBNull.Value);
                        cmd.Parameters.AddWithValue("@status", "Open");
                        con.Open();
                        cmd.ExecuteNonQuery();
                        Response.Redirect("~/Advertiser/MyCampaigns.aspx");
                        return;
                    }
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
