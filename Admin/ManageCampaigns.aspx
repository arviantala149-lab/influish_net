<<<<<<< Updated upstream
<<<<<<< Updated upstream
<%@ Page Language="VB" MasterPageFile="~/Admin/AdminMaster.master" %>
=======
<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" %>
>>>>>>> Stashed changes
=======
<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" %>
>>>>>>> Stashed changes
<%--
    ================================================================
    Admin/ManageCampaigns.aspx  —  Manage Campaigns Page
    Language    : C# (inline runat="server")
    Master Page : AdminMaster.master
    Syllabus    : Section 6 — GridView, TemplateField
                  Section 7 — ADO.NET: SqlConnection, SqlDataAdapter,
                              DataTable
    ================================================================
--%>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Manage Campaigns
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">

<<<<<<< Updated upstream
<<<<<<< Updated upstream
        ' ── Page_Load ──────────────────────────────────────────
        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            If Not IsPostBack Then
                LoadCampaigns()
            End If
        End Sub

        ' ── LoadCampaigns ──────────────────────────────────────
        Private Sub LoadCampaigns()
            Dim connStr As String = System.Configuration.ConfigurationManager _
                                    .ConnectionStrings("InfluishDB").ConnectionString

            Using conn As New System.Data.SqlClient.SqlConnection(connStr)
                Try
                    Dim query As String = "SELECT CampaignID, CampaignName, Advertiser, " &
                                          "Category, Budget, Applicants, Status, CreatedDate " &
                                          "FROM Campaigns ORDER BY CreatedDate DESC"

                    Dim da As New System.Data.SqlClient.SqlDataAdapter(query, conn)
                    Dim dt As New System.Data.DataTable()
                    da.Fill(dt)

                    gvCampaigns.DataSource = dt
                    gvCampaigns.DataBind()

                    lblCount.Text = "Showing 1 to " & dt.Rows.Count &
                                    " of " & dt.Rows.Count & " campaigns"
                Catch ex As Exception
                    lblError.Text = "&#9888; Could not load campaigns. Details: " & ex.Message
                    lblError.Visible = True
                End Try
            End Using
        End Sub

        ' ── Helper: CSS class for Status badge ──────────────────────
        Protected Function GetStatusBadge(ByVal status As Object) As String
            Select Case status.ToString().ToLower()
                Case "active"      : Return "badge badge-active"
                Case "pending"     : Return "badge badge-pending"
                Case "deactivated" : Return "badge badge-deactivated"
                Case Else          : Return "badge"
            End Select
        End Function

        ' ── Helper: emoji icon for campaign category ────────────────
        Protected Function GetCampaignIcon(ByVal category As Object) As String
            If category Is Nothing Then Return "&#128203;"
            Dim cat As String = category.ToString().ToLower()
            If cat.Contains("fashion") Then Return "&#128084;"
            If cat.Contains("tech")    Then Return "&#128241;"
            If cat.Contains("food")    Then Return "&#9749;"
            Return "&#128203;"
        End Function

        Protected Function GetCampaignThumbClass(ByVal category As Object) As String
            If category Is Nothing Then Return "campaign-thumb ct-default"
            Dim cat As String = category.ToString().ToLower()
            If cat.Contains("fashion") Then Return "campaign-thumb ct-fashion"
            If cat.Contains("tech")    Then Return "campaign-thumb ct-tech"
            If cat.Contains("food")    Then Return "campaign-thumb ct-food"
            Return "campaign-thumb ct-default"
        End Function

        ' ── Helper: format Budget as Indian Rupee string ─────────────
        Protected Function FormatBudget(ByVal budget As Object) As String
            Dim amount As Decimal = Convert.ToDecimal(budget)
            Return "&#8377;" & String.Format("{0:N0}", amount)
        End Function
=======
=======
>>>>>>> Stashed changes
        // ── Page_Load ──────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCampaigns();
            }
        }

        // ── LoadCampaigns — reads Campaigns table, binds GridView ─
        private void LoadCampaigns()
        {
            // STEP 1: Get connection string from Web.config
            string connStr = System.Configuration.ConfigurationManager
                             .ConnectionStrings["InfluishDB"].ConnectionString;

            // STEP 2: Create connection and use it
            using (System.Data.SqlClient.SqlConnection conn =
                   new System.Data.SqlClient.SqlConnection(connStr))
            {
                try
                {
                    // STEP 3: SQL query to select all campaigns
                    string query = "SELECT CampaignID, CampaignName, Advertiser, " +
                                   "Category, Budget, Applicants, Status, CreatedDate " +
                                   "FROM Campaigns ORDER BY CreatedDate DESC";

                    // STEP 4: SqlDataAdapter fills a DataTable with query results
                    System.Data.SqlClient.SqlDataAdapter da =
                        new System.Data.SqlClient.SqlDataAdapter(query, conn);

                    System.Data.DataTable dt = new System.Data.DataTable();
                    da.Fill(dt);

                    // STEP 5: Bind DataTable to GridView
                    gvCampaigns.DataSource = dt;
                    gvCampaigns.DataBind();

                    lblCount.Text = "Showing 1 to " + dt.Rows.Count +
                                    " of " + dt.Rows.Count + " campaigns";
                }
                catch (Exception ex)
                {
                    lblError.Text    = "&#9888; Could not load campaigns. " +
                                       "Details: " + ex.Message;
                    lblError.Visible = true;
                }
            }
        }

        // ── Helper: CSS class for Status badge ─────────────────────
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

        // ── Helper: emoji icon and CSS class for campaign category ─
        protected string GetCampaignIcon(object category)
        {
            if (category == null) return "&#128203;";
            switch (category.ToString().ToLower())
            {
                case string s when s.Contains("fashion"): return "&#128084;";
                case string s when s.Contains("tech"):    return "&#128241;";
                case string s when s.Contains("food"):    return "&#9749;";
                default: return "&#128203;";
            }
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

        // ── Helper: format Budget as Indian Rupee string ───────────
        protected string FormatBudget(object budget)
        {
            decimal amount = Convert.ToDecimal(budget);
            return "&#8377;" + String.Format("{0:N0}", amount);
        }
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

    </script>

    <%-- ── Page Header ─────────────────────────────────────────── --%>
    <div class="page-header">
        <h2>Manage Campaigns</h2>
        <p>Review and manage campaigns created by advertisers. Monitor active promotions and approve pending requests.</p>
    </div>

    <%-- ── Error Label ─────────────────────────────────────────── --%>
    <asp:Label ID="lblError" runat="server"
        CssClass="msg-error" Visible="false" />

    <%-- ── Toolbar ─────────────────────────────────────────────── --%>
    <div class="toolbar">
        <%-- Filter tabs (All / Active / Pending / Deactivated) --%>
        <div class="filter-tabs">
            <button type="button" class="filter-tab active">All</button>
            <button type="button" class="filter-tab">Active</button>
            <button type="button" class="filter-tab">Pending</button>
            <button type="button" class="filter-tab">Deactivated</button>
        </div>
        <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <input type="text" id="txtSearch" class="search-input"
                   placeholder="Search campaigns..." />
        </div>
        <select class="filter-select">
            <option>All Categories</option>
            <option>Fashion &amp; Apparel</option>
            <option>Technology</option>
            <option>Food &amp; Beverage</option>
        </select>
    </div>

    <%-- ── Data Card with GridView ────────────────────────────── --%>
    <div class="data-card">

        <asp:GridView ID="gvCampaigns" runat="server"
            AutoGenerateColumns="false"
            CssClass="data-table"
            GridLines="None"
            UseAccessibleHeader="true"
            HeaderStyle-CssClass="gv-header"
            RowStyle-CssClass="gv-row">

            <Columns>

                <%-- Column 1: Campaign — icon + name + category --%>
                <asp:TemplateField HeaderText="Campaign">
                    <ItemTemplate>
                        <div class="campaign-cell">
                            <div class='<%# GetCampaignThumbClass(Eval("Category")) %>'>
                                <%# GetCampaignIcon(Eval("Category")) %>
                            </div>
                            <div>
                                <div class="campaign-name"><%# Eval("CampaignName") %></div>
                                <div class="campaign-cat"><%# Eval("Category") %></div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 2: Advertiser --%>
                <asp:BoundField DataField="Advertiser" HeaderText="Advertiser" />

                <%-- Column 3: Budget (formatted as ₹) --%>
                <asp:TemplateField HeaderText="Budget">
                    <ItemTemplate>
                        <%# FormatBudget(Eval("Budget")) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 4: Applicants --%>
                <asp:BoundField DataField="Applicants" HeaderText="Applicants" />

                <%-- Column 5: Status badge --%>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusBadge(Eval("Status")) %>'>
                            <%# Eval("Status").ToString().ToUpper() %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 6: Created Date --%>
                <asp:BoundField DataField="CreatedDate"
                    HeaderText="Created Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <%-- Column 7: Actions --%>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <a href="#" class="btn-action btn-primary-action">View</a>
                        <a href="#" class="btn-action btn-danger-action">Deactivate</a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">
                    <span class="empty-icon">&#128203;</span>
                    <p>No campaigns found. Add campaigns to the database first.</p>
                </div>
            </EmptyDataTemplate>

        </asp:GridView>

        <div class="pagination-row">
            <asp:Label ID="lblCount" runat="server"
                CssClass="pagination-info" Text="Loading..." />
        </div>

    </div>

</asp:Content>
