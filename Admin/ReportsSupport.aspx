<<<<<<< Updated upstream
<%@ Page Language="VB" MasterPageFile="~/Admin/AdminMaster.master" %>
<%--
    ================================================================
    Admin/ReportsSupport.aspx  —  Reports & Support Page
    Language    : VB (inline runat="server")
=======
<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" %>
<%--
    ================================================================
    Admin/ReportsSupport.aspx  —  Reports & Support Page
    Language    : C# (inline runat="server")
>>>>>>> Stashed changes
    Master Page : AdminMaster.master
    Syllabus    : Section 6 — GridView, Label, Controls
                  Section 7 — ADO.NET: SqlConnection, SqlCommand,
                              SqlDataReader (Connected model),
                              SqlDataAdapter, DataTable
    ================================================================

    NOTE ON ADO.NET MODELS USED HERE:
    This page uses TWO ADO.NET models to demonstrate the syllabus:
    1. CONNECTED model   — SqlCommand + SqlDataReader for the 4 stat counts
    2. DISCONNECTED model — SqlDataAdapter + DataTable for the GridView rows
    Both concepts are in Section 7 of the syllabus.
    ================================================================
--%>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Reports &amp; Support
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">

<<<<<<< Updated upstream
        ' ── Page_Load ──────────────────────────────────────────
        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            If Not IsPostBack Then
                LoadReportStats()   ' fill the 4 summary cards
                LoadReports()       ' fill the GridView
            End If
        End Sub

        ' ────────────────────────────────────────────────────────────
        ' CONNECTED ADO.NET MODEL — SqlConnection + SqlCommand
        ' Demonstrates: SqlConnection.Open(), SqlCommand, ExecuteScalar()
        ' ────────────────────────────────────────────────────────────
        Private Sub LoadReportStats()
            Dim connStr As String = System.Configuration.ConfigurationManager _
                                    .ConnectionStrings("InfluishDB").ConnectionString

            Using conn As New System.Data.SqlClient.SqlConnection(connStr)
                Try
                    conn.Open()   ' explicitly open connection (Connected model)

                    ' Total Reports count
                    Dim cmd As New System.Data.SqlClient.SqlCommand(
                        "SELECT COUNT(*) FROM Reports", conn)
                    lblTotal.Text = cmd.ExecuteScalar().ToString()

                    ' Pending count
                    cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='Pending'"
                    lblPending.Text = cmd.ExecuteScalar().ToString()

                    ' In Review count
                    cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='In Review'"
                    lblInReview.Text = cmd.ExecuteScalar().ToString()

                    ' Resolved count
                    cmd.CommandText = "SELECT COUNT(*) FROM Reports WHERE Status='Resolved'"
                    lblResolved.Text = cmd.ExecuteScalar().ToString()

                    conn.Close()  ' explicitly close connection
                Catch ex As Exception
                    ' If DB not available, show dashes so page still looks clean
                    lblTotal.Text    = "-"
                    lblPending.Text  = "-"
                    lblInReview.Text = "-"
                    lblResolved.Text = "-"
                    lblError.Text    = "&#9888; Could not load stats. " & ex.Message
                    lblError.Visible = True
                End Try
            End Using
        End Sub

        ' ────────────────────────────────────────────────────────────
        ' DISCONNECTED ADO.NET MODEL — SqlDataAdapter + DataTable
        ' ────────────────────────────────────────────────────────────
        Private Sub LoadReports()
            Dim connStr As String = System.Configuration.ConfigurationManager _
                                    .ConnectionStrings("InfluishDB").ConnectionString

            Using conn As New System.Data.SqlClient.SqlConnection(connStr)
                Try
                    Dim query As String = "SELECT ReportID, ReportType, Subject, " &
                                          "ReportedBy, ReportDate, Priority, Status " &
                                          "FROM Reports ORDER BY ReportDate DESC"

                    Dim da As New System.Data.SqlClient.SqlDataAdapter(query, conn)
                    Dim dt As New System.Data.DataTable()
                    da.Fill(dt)

                    gvReports.DataSource = dt
                    gvReports.DataBind()

                    lblCount.Text = "Showing 1 to " & dt.Rows.Count &
                                    " of " & dt.Rows.Count & " entries"
                Catch ex As Exception
                    If Not lblError.Visible Then
                        lblError.Text    = "&#9888; Could not load reports. " & ex.Message
                        lblError.Visible = True
                    End If
                End Try
            End Using
        End Sub

        ' ── Helper: badge class for ReportType ────────────────────
        Protected Function GetTypeBadge(ByVal type As Object) As String
            Select Case type.ToString().ToLower()
                Case "report"  : Return "badge badge-report"
                Case "support" : Return "badge badge-support"
                Case Else      : Return "badge"
            End Select
        End Function

        ' ── Helper: badge class for Priority ──────────────────────
        Protected Function GetPriorityBadge(ByVal priority As Object) As String
            Select Case priority.ToString().ToLower()
                Case "high"   : Return "badge badge-high"
                Case "medium" : Return "badge badge-medium"
                Case "low"    : Return "badge badge-low"
                Case Else     : Return "badge"
            End Select
        End Function

        ' ── Helper: badge class for Status ────────────────────────
        Protected Function GetStatusBadge(ByVal status As Object) As String
            Select Case status.ToString().ToLower()
                Case "pending"   : Return "badge badge-pending"
                Case "in review" : Return "badge badge-in-review"
                Case "resolved"  : Return "badge badge-resolved"
                Case Else        : Return "badge"
            End Select
        End Function

    </script>rn "badge badge-high";
=======
        // ── Page_Load ──────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReportStats();   // fill the 4 summary cards
                LoadReports();       // fill the GridView
            }
        }

        // ─────────────────────────────────────────────────────────────
        // CONNECTED ADO.NET MODEL — uses SqlCommand + SqlDataReader
        // Demonstrates: SqlConnection, SqlCommand, SqlDataReader
        // ─────────────────────────────────────────────────────────────
        private void LoadReportStats()
        {
            string connStr = System.Configuration.ConfigurationManager
                             .ConnectionStrings["InfluishDB"].ConnectionString;

            using (System.Data.SqlClient.SqlConnection conn =
                   new System.Data.SqlClient.SqlConnection(connStr))
            {
                try
                {
                    conn.Open();   // explicitly open connection (Connected model)

                    // Total Reports count
                    System.Data.SqlClient.SqlCommand cmd =
                        new System.Data.SqlClient.SqlCommand(
                            "SELECT COUNT(*) FROM Reports", conn);
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

        // ─────────────────────────────────────────────────────────────
        // DISCONNECTED ADO.NET MODEL — uses SqlDataAdapter + DataTable
        // ─────────────────────────────────────────────────────────────
        private void LoadReports()
        {
            string connStr = System.Configuration.ConfigurationManager
                             .ConnectionStrings["InfluishDB"].ConnectionString;

            using (System.Data.SqlClient.SqlConnection conn =
                   new System.Data.SqlClient.SqlConnection(connStr))
            {
                try
                {
                    string query = "SELECT ReportID, ReportType, Subject, " +
                                   "ReportedBy, ReportDate, Priority, Status " +
                                   "FROM Reports ORDER BY ReportDate DESC";

                    System.Data.SqlClient.SqlDataAdapter da =
                        new System.Data.SqlClient.SqlDataAdapter(query, conn);

                    System.Data.DataTable dt = new System.Data.DataTable();
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

        // ── Helper: badge class for ReportType ─────────────────────
        protected string GetTypeBadge(object type)
        {
            switch (type.ToString().ToLower())
            {
                case "report":  return "badge badge-report";
                case "support": return "badge badge-support";
                default:        return "badge";
            }
        }

        // ── Helper: badge class for Priority ───────────────────────
        protected string GetPriorityBadge(object priority)
        {
            switch (priority.ToString().ToLower())
            {
                case "high":   return "badge badge-high";
>>>>>>> Stashed changes
                case "medium": return "badge badge-medium";
                case "low":    return "badge badge-low";
                default:       return "badge";
            }
        }

        // ── Helper: badge class for Status ─────────────────────────
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
