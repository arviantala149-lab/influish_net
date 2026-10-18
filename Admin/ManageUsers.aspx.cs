using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

// ============================================================================
// Admin/ManageUsers.aspx.cs  -  C# Code-Behind for Manage Users Page
// Language    : C#
// Syllabus    : Section 6 - GridView
//               Section 7 - ADO.NET: SqlConnection, SqlDataAdapter, DataTable
// ============================================================================
// ADO.NET DISCONNECTED MODEL used here:
//   SqlDataAdapter.Fill(DataTable) fetches all rows into memory,
//   then the connection is automatically closed by the Using statement.
//   The DataTable is then bound to the GridView for display.
// ============================================================================
public partial class Admin_ManageUsers : System.Web.UI.Page
{
    // ── Page_Load ────────────────────────────────────────────────────────────
    protected void Page_Load(object sender, EventArgs e)
    {
        // Load the GridView only on the FIRST load (not on PostBack)
        // IsPostBack is false on the first request, true on button clicks etc.
        if (!IsPostBack)
        {
            LoadUsers();
        }
    }

    // ── LoadUsers: reads Users table and binds to GridView ───────────────────
    private void LoadUsers()
    {
        // STEP 1: Read the connection string from Web.config
        string connStr = ConfigurationManager
                            .ConnectionStrings["InfluishDB"].ConnectionString;

        // STEP 2: SqlConnection opens a channel to SQL Server
        //         Using statement closes the connection automatically
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            try
            {
                // STEP 3: SQL SELECT query
                string query = "SELECT UserID, FullName, Email, Role, Status, JoinedDate " +
                               "FROM Users ORDER BY JoinedDate DESC";

                // STEP 4: SqlDataAdapter fills DataTable
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);   // fetch all rows from Users table

                // STEP 5: Bind DataTable to GridView
                gvUsers.DataSource = dt;
                gvUsers.DataBind();

                lblCount.Text = "Showing " + dt.Rows.Count + " user(s)";
            }
            catch (Exception ex)
            {
                lblError.Text    = "&#9888; Could not load users. " +
                                   "Check the database connection. Details: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }

    // ── Helper: CSS badge class for Role ─────────────────────────────────────
    protected string GetRoleBadge(object role)
    {
        switch (role.ToString().ToLower())
        {
            case "influencer": return "badge badge-influencer";
            case "advertiser": return "badge badge-advertiser";
            default:           return "badge";
        }
    }

    // ── Helper: CSS badge class for Status ───────────────────────────────────
    protected string GetStatusBadge(object status)
    {
        switch (status.ToString().ToLower())
        {
            case "active":   return "badge badge-active";
            case "inactive": return "badge badge-inactive";
            default:         return "badge";
        }
    }

    // ── Helper: coloured avatar CSS class based on name hash ─────────────────
    protected string GetAvatarClass(object name)
    {
        string[] colours = { "ua-purple", "ua-green", "ua-blue", "ua-orange", "ua-pink" };
        int index = Math.Abs(name.ToString().GetHashCode()) % colours.Length;
        return "user-avatar " + colours[index];
    }

    // ── Helper: first letter of name for avatar initials ─────────────────────
    protected string GetInitial(object name)
    {
        string n = name.ToString().Trim();
        return (n.Length > 0) ? n[0].ToString().ToUpper() : "?";
    }
}
