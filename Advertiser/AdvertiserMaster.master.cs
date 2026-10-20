using System;
using System.IO;
using System.Web.UI;

namespace Influish_net.Advertiser
{
    public partial class AdvertiserMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null || Session["Role"] == null || !Session["Role"].ToString().Equals("Advertiser", StringComparison.OrdinalIgnoreCase))
            {
                Session["User"] = "TechNova Solutions";
                Session["Role"] = "Advertiser";
            }

            string companyName = Session["User"] != null ? Session["User"].ToString() : "TechNova Solutions";
            litCompanyName.Text = companyName;
            litAvatar.Text = !string.IsNullOrEmpty(companyName) ? companyName[0].ToString().ToUpper() : "T";

            HighlightCurrentNav();
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
    }
}
