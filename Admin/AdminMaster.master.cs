using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

// ============================================================================
// Admin/AdminMaster.master.cs  -  C# Code-Behind for Admin Master Page
// Language    : C#
// Purpose     : Handles Page_Load (sidebar active link, top-bar labels)
//               and Logout button click.
// Syllabus    : Section 6 - Master Pages, Session State
// NOTE        : Session login check is REMOVED.
//               Admin Dashboard opens directly without login.
// ============================================================================
public partial class Admin_AdminMaster : System.Web.UI.MasterPage
{
    // ── Page_Load runs every time ANY Admin page is loaded ──────────────────
    protected void Page_Load(object sender, EventArgs e)
    {
        // Set a default Admin name and role in the top bar
        // (No session login required - set static defaults)
        lblAdminName.Text = "Arvi Antala";
        lblAdminRole.Text = "System Admin";
        lblAvatar.Text    = "A";

        // ── Highlight the active sidebar link ───────────────────────────────
        // Get the filename of the current page (e.g. "Dashboard.aspx")
        string currentPage = System.IO.Path.GetFileName(
                                 Request.Url.AbsolutePath).ToLower();

        switch (currentPage)
        {
            case "dashboard.aspx":
                lnkDashboard.CssClass = "nav-item active";
                break;
            case "manageusers.aspx":
                lnkUsers.CssClass = "nav-item active";
                break;
            case "managecampaigns.aspx":
                lnkCampaigns.CssClass = "nav-item active";
                break;
            case "reportssupport.aspx":
                lnkReports.CssClass = "nav-item active";
                break;
        }
    }

    // ── btnLogout_Click: redirects back to the main site home page ──────────
    protected void btnLogout_Click(object sender, EventArgs e)
    {
        // No session to clear (login is bypassed).
        // Just navigate back to the site home page.
        Response.Redirect("~/Default.aspx");
    }
}
