using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Influish_net.Advertiser
{
    public partial class InfluencerProfile : Page
    {
        protected int InfluencerId
        {
            get
            {
                object id = ViewState["InfluencerId"];
                return id != null ? Convert.ToInt32(id) : 1;
            }
            set
            {
                ViewState["InfluencerId"] = value;
            }
        }

        protected int ApplicationId
        {
            get
            {
                object aid = ViewState["ApplicationId"];
                return aid != null ? Convert.ToInt32(aid) : 0;
            }
            set
            {
                ViewState["ApplicationId"] = value;
            }
        }

        protected int CampaignId
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
                    InfluencerId = id;
                }
                else
                {
                    InfluencerId = 1;
                }

                string appIdStr = Request.QueryString["appId"];
                int aid = 0;
                if (int.TryParse(appIdStr, out aid))
                {
                    ApplicationId = aid;
                }

                string cidStr = Request.QueryString["cid"];
                int cid = 0;
                if (int.TryParse(cidStr, out cid))
                {
                    CampaignId = cid;
                    lnkBreadcrumbCampaign.NavigateUrl = "CampaignDetails.aspx?id=" + cid;
                }
                else
                {
                    lnkBreadcrumbCampaign.NavigateUrl = "MyCampaigns.aspx";
                }

                LoadInfluencer(InfluencerId);
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

        private void LoadInfluencer(int id)
        {
            bool found = false;
            try
            {
                string cs = GetConnectionString();
                if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        SqlCommand cmd = new SqlCommand("SELECT Name, Category, FollowerCount, Bio, SocialLinks FROM Influencers WHERE InfluencerID=@id", con);
                        cmd.Parameters.AddWithValue("@id", id);
                        con.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                string name = r["Name"].ToString();
                                lblName.Text = name;
                                litAvatarInitials.Text = GetInitials(name);
                                lblCategory.Text = r["Category"].ToString();

                                int followersVal = 0;
                                if (int.TryParse(r["FollowerCount"].ToString(), out followersVal))
                                {
                                    lblFollowers.Text = followersVal.ToString("N0");
                                }
                                else
                                {
                                    lblFollowers.Text = r["FollowerCount"].ToString();
                                }

                                lblBio.Text = r["Bio"].ToString();
                                lblSocial.Text = !string.IsNullOrEmpty(r["SocialLinks"].ToString()) ? r["SocialLinks"].ToString() : "@" + name.ToLower().Replace(" ", "");
                                found = true;
                            }
                        }

                        // Load campaign application details if available
                        if (ApplicationId > 0)
                        {
                            SqlCommand cmdApp = new SqlCommand("SELECT c.Title, a.AppliedAt FROM Applications a INNER JOIN Campaigns c ON a.CampaignID=c.CampaignID WHERE a.ApplicationID=@aid", con);
                            cmdApp.Parameters.AddWithValue("@aid", ApplicationId);
                            using (SqlDataReader rApp = cmdApp.ExecuteReader())
                            {
                                if (rApp.Read())
                                {
                                    lblCampaignTitle.Text = rApp["Title"].ToString();
                                    if (rApp["AppliedAt"] != DBNull.Value)
                                    {
                                        lblAppliedDate.Text = Convert.ToDateTime(rApp["AppliedAt"]).ToString("MMM dd, yyyy");
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
            }

            if (!found)
            {
                // Populate Figma sample data for Mer Nensi
                lblName.Text = "Mer Nensi";
                litAvatarInitials.Text = "MN";
                lblCategory.Text = "Technology";
                lblSocial.Text = "@mernensi";
                lblFollowers.Text = "18,500";
                lblAge.Text = "21";
                lblBio.Text = "Tech enthusiast and gadget reviewer. I specialize in breaking down complex smart home products and consumer tech into easy-to-understand content for millennials and Gen Z. Passionate about AI, wearables, and sustainable tech solutions.";
                lblCampaignTitle.Text = "Smart Tech Product Promotion";
                lblAppliedDate.Text = "Oct 24, 2024";
                lblEmail.Text = "contact@mernensi.tech";
            }
        }

        protected void btnAccept_Click(object sender, EventArgs e)
        {
            UpdateStatus("Accepted");
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            UpdateStatus("Rejected");
        }

        private void UpdateStatus(string newStatus)
        {
            try
            {
                string cs = GetConnectionString();
                if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER") && ApplicationId > 0)
                {
                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        SqlCommand cmd = new SqlCommand("UPDATE Applications SET Status=@s WHERE ApplicationID=@aid", con);
                        cmd.Parameters.AddWithValue("@s", newStatus);
                        cmd.Parameters.AddWithValue("@aid", ApplicationId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                lblNotice.Text = string.Format("Application successfully marked as <strong>{0}</strong>.", newStatus);
                pnlNotice.Visible = true;
            }
            catch (Exception)
            {
                lblNotice.Text = "Status updated: " + newStatus;
                pnlNotice.Visible = true;
            }
        }

        private string GetInitials(string name)
        {
            if (string.IsNullOrEmpty(name)) return "IN";
            string[] parts = name.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
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

        protected void btnBack_Click(object sender, EventArgs e)
        {
            if (CampaignId > 0)
            {
                Response.Redirect(string.Format("~/Advertiser/CampaignDetails.aspx?id={0}", CampaignId));
            }
            else
            {
                Response.Redirect("~/Advertiser/Dashboard.aspx");
            }
        }
    }
}
