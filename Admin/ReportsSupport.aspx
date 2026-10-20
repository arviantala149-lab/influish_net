<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" %>
<%--
    =
    Admin/ReportsSupport.aspx  —  Reports & Support Page
    Language    : C# (inline runat="server")
    Master Page : AdminMaster.master
    Syllabus    : Section 6 — GridView, Label, Controls
                  Section 7 — ADO.NET: SqlConnection, SqlCommand,
                              SqlDataReader (Connected model),
                              SqlDataAdapter, DataTable
    =

    NOTE ON ADO.NET MODELS USED HERE:
    This page uses TWO ADO.NET models to demonstrate the syllabus:
    1. CONNECTED model   — SqlCommand + SqlDataReader for the 4 stat counts
    2. DISCONNECTED model — SqlDataAdapter + DataTable for the GridView rows
    Both concepts are in Section 7 of the syllabus.
    =
--%>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Reports &amp; Support
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReportStats();
                LoadReports();
            }
        }

        private void LoadReportStats()
        {
            string connStr = System.Configuration.ConfigurationManager
                                .ConnectionStrings["InfluishDB"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                try
                {
                    conn.Open();
                    var cmd = new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM Reports", conn);
                    lblTotal.Text = cmd.ExecuteScalar().ToString();
                    cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='Pending'";
                    lblPending.Text = cmd.ExecuteScalar().ToString();
                    cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='In Review'";
                    lblInReview.Text = cmd.ExecuteScalar().ToString();
                    cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='Resolved'";
                    lblResolved.Text = cmd.ExecuteScalar().ToString();
                }
                catch (Exception ex)
                {
                    lblTotal.Text = lblPending.Text = lblInReview.Text = lblResolved.Text = "-";
                    lblError.Text = "&#9888; Could not load stats. " + ex.Message;
                    lblError.Visible = true;
                }
            }
        }

        private void LoadReports()
        {
            string connStr = System.Configuration.ConfigurationManager
                                .ConnectionStrings["InfluishDB"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                try
                {
                    string query = "SELECT ReportID, ReportType, Subject, ReportedBy, ReportDate, Priority, Status FROM Reports ORDER BY ReportDate DESC";
                    var da = new System.Data.SqlClient.SqlDataAdapter(query, conn);
                    var dt = new System.Data.DataTable();
                    da.Fill(dt);
                    gvReports.DataSource = dt;
                    gvReports.DataBind();
                    lblCount.Text = "Showing 1 to " + dt.Rows.Count + " of " + dt.Rows.Count + " entries";
                }
                catch (Exception ex)
                {
                    if (!lblError.Visible)
                    {
                        lblError.Text = "&#9888; Could not load reports. " + ex.Message;
                        lblError.Visible = true;
                    }
                }
            }
        }

        protected string GetTypeBadge(object type)
        {
            switch (type.ToString().ToLower())
            {
                case "report": return "badge badge-report";
                case "support": return "badge badge-support";
                default: return "badge";
            }
        }

        protected string GetPriorityBadge(object priority)
        {
            switch (priority.ToString().ToLower())
            {
                case "high": return "badge badge-high";
                case "medium": return "badge badge-medium";
                case "low": return "badge badge-low";
                default: return "badge";
            }
        }

        protected string GetStatusBadge(object status)
        {
            switch (status.ToString().ToLower())
            {
                case "pending": return "badge badge-pending";
                case "in review": return "badge badge-in-review";
                case "resolved": return "badge badge-resolved";
                default: return "badge";
            }
        }

    </script>

    <%-- ── Page Header ─────────────────────────────────────────── --%>
    <div class="page-header">
        <h2>Reports &amp; Support</h2>
        <p>Review user complaints and support messages.</p>
    </div>

    <%-- ── Error Label ─────────────────────────────────────────── --%>
    <asp:Label ID="lblError" runat="server"
        CssClass="msg-error" Visible="false" />

    <%-- ══════════════════════════════════════════════════════════
         STAT CARDS — 4 summary counts (from Connected ADO.NET)
         Uses SqlCommand + ExecuteScalar() to count rows
         ══════════════════════════════════════════════════════════ --%>
    <div class="reports-stats">

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-blue">&#128229;</div>
            <div>
                <div class="report-stat-label">Total Reports</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblTotal" runat="server" Text="..." />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-orange">&#9203;</div>
            <div>
                <div class="report-stat-label">Pending</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblPending" runat="server" Text="..." />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-purple">&#128269;</div>
            <div>
                <div class="report-stat-label">In Review</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblInReview" runat="server" Text="..." />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-green">&#10003;</div>
            <div>
                <div class="report-stat-label">Resolved</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblResolved" runat="server" Text="..." />
                </div>
            </div>
        </div>

    </div>
    <%-- end reports-stats --%>


    <%-- ══════════════════════════════════════════════════════════
         TAB STRIP — All / Reports / Support Messages
         ══════════════════════════════════════════════════════════ --%>
    <div class="reports-tabs">
        <button type="button" class="report-tab active">All</button>
        <button type="button" class="report-tab">Reports</button>
        <button type="button" class="report-tab">Support Messages</button>
    </div>

    <%-- ── Toolbar: Search ────────────────────────────────────── --%>
    <div class="toolbar" style="margin-bottom:16px;">
        <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <input type="text" id="txtSearch" class="search-input"
                   placeholder="Search subject or user..." />
        </div>
        <button type="button" class="btn-action btn-primary-action">
            &#9744; Filter
        </button>
    </div>

    <%-- ── Data Card with GridView ────────────────────────────── --%>
    <div class="data-card">

        <asp:GridView ID="gvReports" runat="server"
            AutoGenerateColumns="false"
            CssClass="data-table"
            GridLines="None"
            UseAccessibleHeader="true"
            HeaderStyle-CssClass="gv-header"
            RowStyle-CssClass="gv-row">

            <Columns>

                <%-- Column 1: Type badge (Report / Support) --%>
                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate>
                        <span class='<%# GetTypeBadge(Eval("ReportType")) %>'>
                            <%# Eval("ReportType") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 2: Subject --%>
                <asp:BoundField DataField="Subject" HeaderText="Subject" />

                <%-- Column 3: Reported By --%>
                <asp:BoundField DataField="ReportedBy" HeaderText="Reported By" />

                <%-- Column 4: Date --%>
                <asp:BoundField DataField="ReportDate"
                    HeaderText="Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <%-- Column 5: Priority badge --%>
                <asp:TemplateField HeaderText="Priority">
                    <ItemTemplate>
                        <span class='<%# GetPriorityBadge(Eval("Priority")) %>'>
                            + <%# Eval("Priority") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 6: Status badge --%>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusBadge(Eval("Status")) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 7: Action button --%>
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <a href="#" class="btn-action btn-primary-action">View Details</a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">
                    <span class="empty-icon">&#128229;</span>
                    <p>No reports found. Add records to the Reports table first.</p>
                </div>
            </EmptyDataTemplate>

        </asp:GridView>

        <div class="pagination-row">
            <asp:Label ID="lblCount" runat="server"
                CssClass="pagination-info" Text="Loading..." />
        </div>

    </div>
    <%-- end data-card --%>

</asp:Content>
