using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

// ============================================================================
// Admin/ManageCampaigns.aspx.cs  -  C# Code-Behind for Manage Campaigns
// Language    : C#
// Syllabus    : Section 6 - GridView, TemplateField
//               Section 7 - ADO.NET: SqlDataAdapter, DataTable
// ============================================================================
public partial class Admin_ManageCampaigns : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCampaigns();
        }
    }

    private void LoadCampaigns()
    {
        string connStr = ConfigurationManager
                            .ConnectionStrings["InfluishDB"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            try
            {
                string query = "SELECT CampaignID, CampaignName, Advertiser, " +
                               "Category, Budget, Applicants, Status, CreatedDate " +
                               "FROM Campaigns ORDER BY CreatedDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvCampaigns.DataSource = dt;
                gvCampaigns.DataBind();

                lblCount.Text = "Showing 1 to " + dt.Rows.Count +
                                " of " + dt.Rows.Count + " campaigns";
            }
            catch (Exception ex)
            {
                lblError.Text    = "&#9888; Could not load campaigns. Details: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }

    // ── Helper: CSS class for Status badge ───────────────────────────────────
    protected string GetStatusBadge(object status)
    {
        switch (status.ToString().ToLower())
        {
            case "active":      return "badge badge-active";
            case "pending":     return "badge badge-pending";
            case "deactivated": return "badge badge-deactivated";
            default:            return "badge";
        }
    }

    // ── Helper: emoji icon for campaign category ──────────────────────────────
    protected string GetCampaignIcon(object category)
    {
        if (category == null) return "&#128203;";
        string cat = category.ToString().ToLower();
        if (cat.Contains("fashion")) return "&#128084;";
        if (cat.Contains("tech"))    return "&#128241;";
        if (cat.Contains("food"))    return "&#9749;";
        return "&#128203;";
    }

    protected string GetCampaignThumbClass(object category)
    {
        if (category == null) return "campaign-thumb ct-default";
        string cat = category.ToString().ToLower();
        if (cat.Contains("fashion")) return "campaign-thumb ct-fashion";
        if (cat.Contains("tech"))    return "campaign-thumb ct-tech";
        if (cat.Contains("food"))    return "campaign-thumb ct-food";
        return "campaign-thumb ct-default";
    }

    // ── Helper: format Budget as Indian Rupee string ──────────────────────────
    protected string FormatBudget(object budget)
    {
        decimal amount = Convert.ToDecimal(budget);
        return "&#8377;" + String.Format("{0:N0}", amount);
    }
}
