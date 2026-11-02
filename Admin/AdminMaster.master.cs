using System;
using System.IO;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net.Admin
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Admin");

            string adminName = Session["User"] != null ? Session["User"].ToString() : "Admin";
            string adminRole = "System Admin";

            lblAdminName.Text = Server.HtmlEncode(adminName);
            lblAdminRole.Text = adminRole;
            lblAvatar.Text = adminName.Length > 0 ? adminName[0].ToString().ToUpper() : "A";

            string currentPage = Path.GetFileName(Request.Url.AbsolutePath).ToLower();
            switch (currentPage)
            {
                case "dashboard.aspx": lnkDashboard.CssClass = "nav-item active"; break;
                case "manageusers.aspx": lnkUsers.CssClass = "nav-item active"; break;
                case "managecampaigns.aspx": lnkCampaigns.CssClass = "nav-item active"; break;
                case "reportssupport.aspx": lnkReports.CssClass = "nav-item active"; break;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            AuthHelper.Logout(Response);
        }
    }
}
