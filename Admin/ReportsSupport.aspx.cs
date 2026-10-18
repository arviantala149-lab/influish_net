using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

// ============================================================================
// Admin/ReportsSupport.aspx.cs  -  C# Code-Behind for Reports & Support
// Language    : C#
// Syllabus    : Section 6 - GridView, Label
//               Section 7 - ADO.NET Connected + Disconnected models
// ============================================================================
// TWO ADO.NET MODELS DEMONSTRATED:
// 1. CONNECTED  - SqlConnection.Open() + SqlCommand.ExecuteScalar() for counts
// 2. DISCONNECTED - SqlDataAdapter.Fill(DataTable) for the GridView rows
// ============================================================================
public partial class Admin_ReportsSupport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadReportStats();   // fill the 4 summary cards
            LoadReports();       // fill the GridView
        }
    }

    // ────────────────────────────────────────────────────────────────────────
    // CONNECTED ADO.NET MODEL - SqlConnection + SqlCommand + ExecuteScalar
    // ────────────────────────────────────────────────────────────────────────
    private void LoadReportStats()
    {
        string connStr = ConfigurationManager
                            .ConnectionStrings["InfluishDB"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            try
            {
                conn.Open();   // explicitly open connection (Connected model)

                // Total Reports count
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Reports", conn);
                lblTotal.Text = cmd.ExecuteScalar().ToString();

                // Pending count
                cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='Pending'";
                lblPending.Text = cmd.ExecuteScalar().ToString();

                // In Review count
                cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='In Review'";
                lblInReview.Text = cmd.ExecuteScalar().ToString();

                // Resolved count
                cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='Resolved'";
                lblResolved.Text = cmd.ExecuteScalar().ToString();

                conn.Close();  // explicitly close connection
            }
            catch (Exception ex)
            {
                // If DB not available, show dashes so page still looks clean
                lblTotal.Text    = "-";
                lblPending.Text  = "-";
                lblInReview.Text = "-";
                lblResolved.Text = "-";
                lblError.Text    = "&#9888; Could not load stats. " + ex.Message;
                lblError.Visible = true;
            }
        }
    }

    // ────────────────────────────────────────────────────────────────────────
    // DISCONNECTED ADO.NET MODEL - SqlDataAdapter + DataTable
    // ────────────────────────────────────────────────────────────────────────
    private void LoadReports()
    {
        string connStr = ConfigurationManager
                            .ConnectionStrings["InfluishDB"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            try
            {
                string query = "SELECT ReportID, ReportType, Subject, " +
                               "ReportedBy, ReportDate, Priority, Status " +
                               "FROM Reports ORDER BY ReportDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvReports.DataSource = dt;
                gvReports.DataBind();

                lblCount.Text = "Showing 1 to " + dt.Rows.Count +
                                " of " + dt.Rows.Count + " entries";
            }
            catch (Exception ex)
            {
                if (!lblError.Visible)
                {
                    lblError.Text    = "&#9888; Could not load reports. " + ex.Message;
                    lblError.Visible = true;
                }
            }
        }
    }

    // ── Helper: badge class for ReportType ───────────────────────────────────
    protected string GetTypeBadge(object type)
    {
        switch (type.ToString().ToLower())
        {
            case "report":  return "badge badge-report";
            case "support": return "badge badge-support";
            default:        return "badge";
        }
    }

    // ── Helper: badge class for Priority ─────────────────────────────────────
    protected string GetPriorityBadge(object priority)
    {
        switch (priority.ToString().ToLower())
        {
            case "high":   return "badge badge-high";
            case "medium": return "badge badge-medium";
            case "low":    return "badge badge-low";
            default:       return "badge";
        }
    }

    // ── Helper: badge class for Status ───────────────────────────────────────
    protected string GetStatusBadge(object status)
    {
        switch (status.ToString().ToLower())
        {
            case "pending":   return "badge badge-pending";
            case "in review": return "badge badge-in-review";
            case "resolved":  return "badge badge-resolved";
            default:          return "badge";
        }
    }
}
