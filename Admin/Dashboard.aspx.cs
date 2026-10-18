using System;
using System.Web.UI;

// ============================================================================
// Admin/Dashboard.aspx.cs  -  C# Code-Behind for Admin Dashboard
// Language    : C#
// Master Page : AdminMaster.master
// Syllabus    : Section 6 - ASP.NET Page Lifecycle, Master Pages
// ============================================================================
// WHAT IS Page_Load?
// Page_Load is an event method that ASP.NET calls automatically every time
// the page is requested (or posted back). Here the Dashboard only shows
// static figures, so no database code is needed.
// ============================================================================
public partial class Admin_Dashboard : System.Web.UI.Page
{
    // ── Page_Load ────────────────────────────────────────────────────────────
    protected void Page_Load(object sender, EventArgs e)
    {
        // Dashboard shows static data from the Figma design.
        // No additional server code needed for this page.
    }
}
