using System;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class DashboardMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Server-side role protection: Must be logged in as Influencer
            AuthHelper.RequireRole(this.Page, "Influencer");

            if (!IsPostBack)
            {
                LoadHeaderInfo();
                HighlightNav();
            }
        }

        private void LoadHeaderInfo()
        {
            string fullName = Session["FullName"] != null ? Session["FullName"].ToString() : "Creator";
            if (!string.IsNullOrEmpty(fullName))
            {
                string[] parts = fullName.Trim().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                if (parts.Length >= 2)
                {
                    litAvatarInitials.Text = (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
                }
                else if (parts.Length == 1 && parts[0].Length > 0)
                {
                    litAvatarInitials.Text = parts[0][0].ToString().ToUpper();
                }
            }

            int userId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;
            if (userId > 0)
            {
                try
                {
                    object unreadObj = DbHelper.ExecuteScalar(
                        "SELECT COUNT(*) FROM Notifications WHERE UserID = @uid AND IsRead = 0",
                        new SqlParameter("@uid", userId)
                    );

                    int unreadCount = unreadObj != null && unreadObj != DBNull.Value ? Convert.ToInt32(unreadObj) : 0;
                    if (unreadCount > 0)
                    {
                        lblNotifBadge.Visible = true;
                        lblTopNotifDot.Visible = true;
                    }
                    else
                    {
                        lblNotifBadge.Visible = false;
                        lblTopNotifDot.Visible = false;
                    }
                }
                catch
                {
                }
            }
        }

        private void HighlightNav()
        {
            string currentPage = Path.GetFileName(Request.Url.AbsolutePath).ToLower();
            sidebarDashboard.Attributes["class"] = "sidebar-link" + (currentPage == "dashboard.aspx" ? " active" : "");
            sidebarCampaigns.Attributes["class"] = "sidebar-link" + (currentPage == "campaigns.aspx" || currentPage == "campaigndetails.aspx" ? " active" : "");
            sidebarApplications.Attributes["class"] = "sidebar-link" + (currentPage == "applications.aspx" ? " active" : "");
            sidebarNotifications.Attributes["class"] = "sidebar-link" + (currentPage == "notifications.aspx" ? " active" : "");
            sidebarProfile.Attributes["class"] = "sidebar-link" + (currentPage == "profile.aspx" || currentPage == "profilesetup.aspx" || currentPage == "settings.aspx" ? " active" : "");
            sidebarSupport.Attributes["class"] = "sidebar-link" + (currentPage == "contactsupport.aspx" ? " active" : "");
        }

        protected void txtTopSearch_TextChanged(object sender, EventArgs e)
        {
            string q = txtTopSearch.Text.Trim();
            if (!string.IsNullOrEmpty(q))
            {
                Response.Redirect("~/Campaigns.aspx?q=" + Server.UrlEncode(q));
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            AuthHelper.Logout(Context);
            Response.Redirect("~/Login.aspx");
        }
    }
}
