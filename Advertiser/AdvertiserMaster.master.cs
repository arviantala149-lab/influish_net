using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net.Advertiser
{
    public partial class AdvertiserMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Advertiser");

            if (!IsPostBack)
            {
                LoadCompanyInfo();
                LoadNotificationCount();
                HighlightCurrentNav();
            }
        }

        private void LoadCompanyInfo()
        {
            string companyName = Session["User"] != null ? Session["User"].ToString() : "Brand Account";

            // If CompanyID is not set in session, resolve it from DB
            if (Session["CompanyID"] == null && Session["UserID"] != null)
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                object cid = DbHelper.ExecuteScalar(
                    "SELECT CompanyID FROM Companies WHERE UserID = @UserID",
                    new SqlParameter("@UserID", userId)
                );
                if (cid != null && cid != DBNull.Value)
                {
                    Session["CompanyID"] = Convert.ToInt32(cid);
                }
            }

            if (Session["CompanyID"] != null)
            {
                int compId = Convert.ToInt32(Session["CompanyID"]);
                object name = DbHelper.ExecuteScalar(
                    "SELECT CompanyName FROM Companies WHERE CompanyID = @cid",
                    new SqlParameter("@cid", compId)
                );
                if (name != null && !string.IsNullOrWhiteSpace(name.ToString()))
                {
                    companyName = name.ToString().Trim();
                    Session["User"] = companyName;
                }
            }

            litCompanyName.Text = Server.HtmlEncode(companyName);
            litAvatar.Text = !string.IsNullOrEmpty(companyName) ? companyName[0].ToString().ToUpper() : "B";
        }

        private void LoadNotificationCount()
        {
            if (Session["UserID"] != null)
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                object unreadObj = DbHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM Notifications WHERE UserID = @uid AND IsRead = 0",
                    new SqlParameter("@uid", userId)
                );
                int unread = unreadObj != null ? Convert.ToInt32(unreadObj) : 0;
                if (unread > 0)
                {
                    litNotificationBadge.Text = string.Format("<span class=\"notification-badge\">{0}</span>", unread > 9 ? "9+" : unread.ToString());
                }
                else
                {
                    litNotificationBadge.Text = string.Empty;
                }
            }
        }

        private void HighlightCurrentNav()
        {
            string page = Path.GetFileName(Request.Url.AbsolutePath).ToLower();
            lnkDashboard.Attributes["class"] = "influish-nav-item" + (page == "dashboard.aspx" ? " active" : "");
            lnkCampaigns.Attributes["class"] = "influish-nav-item" + (page == "mycampaigns.aspx" || page == "campaigndetails.aspx" ? " active" : "");
            lnkCreate.Attributes["class"] = "influish-nav-item" + (page == "createcampaign.aspx" ? " active" : "");
            lnkNotifications.Attributes["class"] = "influish-nav-item" + (page == "notifications.aspx" ? " active" : "");
            lnkProfile.Attributes["class"] = "influish-nav-item" + (page == "companyprofile.aspx" ? " active" : "");
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            AuthHelper.Logout(Response);
        }
    }
}
