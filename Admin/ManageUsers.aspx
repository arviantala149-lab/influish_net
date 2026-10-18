<<<<<<< Updated upstream
<%@ Page Language="VB" MasterPageFile="~/Admin/AdminMaster.master" %>
=======
<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" %>
>>>>>>> Stashed changes
<%--
    ================================================================
    Admin/ManageUsers.aspx  —  Manage Users Page
    Language    : C# (inline runat="server")
    Master Page : AdminMaster.master
    Syllabus    : Section 6 — GridView, Controls
                  Section 7 — ADO.NET: SqlConnection, SqlDataAdapter,
                              DataTable (Connected + Disconnected model)
    ================================================================

    ADO.NET EXPLAINED (for viva):
    SqlConnection  — opens a channel to the SQL Server database
    SqlDataAdapter — runs the SQL SELECT query and fetches results
    DataTable      — stores the fetched rows in memory (like a table)
    GridView.DataBind() — displays the DataTable rows on the web page
    ================================================================
--%>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Manage Users
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">

<<<<<<< Updated upstream
        ' ── Page_Load ──────────────────────────────────────────────
        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            ' Load the GridView only on the FIRST load (not on PostBack)
            If Not IsPostBack Then
                LoadUsers()
            End If
        End Sub

        ' ── LoadUsers — reads Users table and binds to GridView ────
        Private Sub LoadUsers()
            ' STEP 1: Read the connection string stored in Web.config
            Dim connStr As String = System.Configuration.ConfigurationManager _
                                    .ConnectionStrings("InfluishDB").ConnectionString

            ' STEP 2: Create SqlConnection — Using closes it automatically
            Using conn As New System.Data.SqlClient.SqlConnection(connStr)
                Try
                    ' STEP 3: SQL SELECT query
                    Dim query As String = "SELECT UserID, FullName, Email, Role, " &
                                          "Status, JoinedDate FROM Users " &
                                          "ORDER BY JoinedDate DESC"

                    ' STEP 4: SqlDataAdapter fills DataTable with query results
                    Dim da As New System.Data.SqlClient.SqlDataAdapter(query, conn)
                    Dim dt As New System.Data.DataTable()
                    da.Fill(dt)   ' fetch all rows from Users table

                    ' STEP 5: Bind DataTable to GridView for display
                    gvUsers.DataSource = dt
                    gvUsers.DataBind()

                    lblCount.Text = "Showing " & dt.Rows.Count & " user(s)"
                Catch ex As Exception
                    ' If connection fails, show a friendly error message
                    lblError.Text = "&#9888; Could not load users. " &
                                    "Please check the database connection. " &
                                    "Details: " & ex.Message
                    lblError.Visible = True
                End Try
            End Using
        End Sub

        ' ── Helper: CSS badge class for Role ───────────────────────
        Protected Function GetRoleBadge(ByVal role As Object) As String
            Select Case role.ToString().ToLower()
                Case "influencer" : Return "badge badge-influencer"
                Case "advertiser" : Return "badge badge-advertiser"
                Case Else         : Return "badge"
            End Select
        End Function

        ' ── Helper: CSS badge class for Status ─────────────────────
        Protected Function GetStatusBadge(ByVal status As Object) As String
            Select Case status.ToString().ToLower()
                Case "active"   : Return "badge badge-active"
                Case "inactive" : Return "badge badge-inactive"
                Case Else       : Return "badge"
            End Select
        End Function

        ' ── Helper: colour class for user avatar ───────────────────
        Protected Function GetAvatarClass(ByVal name As Object) As String
            Dim colours() As String = {"ua-purple", "ua-green", "ua-blue",
                                       "ua-orange", "ua-pink"}
            Dim index As Integer = Math.Abs(name.ToString().GetHashCode()) Mod colours.Length
            Return "user-avatar " & colours(index)
        End Function

        ' ── Helper: first letter of name for avatar initials ───────
        Protected Function GetInitial(ByVal name As Object) As String
            Dim n As String = name.ToString().Trim()
            Return If(n.Length > 0, n(0).ToString().ToUpper(), "?")
        End Function

    </script>


=======
        // ── Page_Load ──────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            // Load the GridView only on the FIRST load (not on PostBack)
            // IsPostBack is false when the page loads for the first time
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        // ── LoadUsers — reads Users table and binds to GridView ────
        private void LoadUsers()
        {
            // STEP 1: Read the connection string stored in Web.config
            string connStr = System.Configuration.ConfigurationManager
                             .ConnectionStrings["InfluishDB"].ConnectionString;

            // STEP 2: Create a SqlConnection object with that string
            // "using" automatically closes the connection when done
            using (System.Data.SqlClient.SqlConnection conn =
                   new System.Data.SqlClient.SqlConnection(connStr))
            {
                try
                {
                    // STEP 3: Write the SQL SELECT query
                    string query = "SELECT UserID, FullName, Email, Role, " +
                                   "Status, JoinedDate FROM Users " +
                                   "ORDER BY JoinedDate DESC";

                    // STEP 4: SqlDataAdapter runs the query and fills a DataTable
                    // It opens and closes the connection automatically
                    System.Data.SqlClient.SqlDataAdapter da =
                        new System.Data.SqlClient.SqlDataAdapter(query, conn);

                    System.Data.DataTable dt = new System.Data.DataTable();
                    da.Fill(dt);   // fetch all rows from Users table

                    // STEP 5: Bind DataTable to GridView for display
                    gvUsers.DataSource = dt;
                    gvUsers.DataBind();

                    // Show count in label
                    lblCount.Text = "Showing " + dt.Rows.Count + " user(s)";
                }
                catch (Exception ex)
                {
                    // If connection fails, show a friendly error message
                    lblError.Text    = "&#9888; Could not load users. " +
                                       "Please check the database connection. " +
                                       "Details: " + ex.Message;
                    lblError.Visible = true;
                }
            }
        }

        // ── Helper: returns the CSS badge class for each Role value ─
        protected string GetRoleBadge(object role)
        {
            switch (role.ToString().ToLower())
            {
                case "influencer": return "badge badge-influencer";
                case "advertiser": return "badge badge-advertiser";
                default:           return "badge";
            }
        }

        // ── Helper: returns the CSS badge class for each Status value
        protected string GetStatusBadge(object status)
        {
            switch (status.ToString().ToLower())
            {
                case "active":   return "badge badge-active";
                case "inactive": return "badge badge-inactive";
                default:         return "badge";
            }
        }

        // ── Helper: pick a colour class for the user avatar ────────
        protected string GetAvatarClass(object name)
        {
            string[] colours = { "ua-purple", "ua-green", "ua-blue",
                                 "ua-orange", "ua-pink" };
            int index = Math.Abs(name.ToString().GetHashCode()) % colours.Length;
            return "user-avatar " + colours[index];
        }

        // ── Helper: get first letter of name for avatar initials ───
        protected string GetInitial(object name)
        {
            string n = name.ToString().Trim();
            return n.Length > 0 ? n[0].ToString().ToUpper() : "?";
        }

    </script>

>>>>>>> Stashed changes
    <%-- ── Page Header ─────────────────────────────────────────── --%>
    <div class="page-header">
        <h2>Manage Users</h2>
        <p>View and manage all registered influencers and advertisers.</p>
    </div>

    <%-- ── Error Label (hidden until an error occurs) ─────────── --%>
    <asp:Label ID="lblError" runat="server"
        CssClass="msg-error" Visible="false" />

    <%-- ── Toolbar: Search + Filter dropdowns ─────────────────── --%>
    <div class="toolbar">
        <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <input type="text" id="txtSearch" class="search-input"
                   placeholder="Search users by name or email..." />
        </div>
        <select class="filter-select">
            <option>All Roles</option>
            <option>Influencer</option>
            <option>Advertiser</option>
        </select>
        <select class="filter-select">
            <option>All Status</option>
            <option>Active</option>
            <option>Inactive</option>
        </select>
    </div>

    <%-- ── Data Card wrapping the GridView ────────────────────── --%>
    <div class="data-card">

        <%--
            GridView — ASP.NET control that displays data as an HTML table.
            AutoGenerateColumns="false" means we define columns manually.
            CssClass applies our custom CSS table styles.
        --%>
        <asp:GridView ID="gvUsers" runat="server"
            AutoGenerateColumns="false"
            CssClass="data-table"
            GridLines="None"
            UseAccessibleHeader="true"
            HeaderStyle-CssClass="gv-header"
            RowStyle-CssClass="gv-row">

            <%-- Column definitions --%>
            <Columns>

                <%-- Column 1: Profile — coloured avatar + full name --%>
                <asp:TemplateField HeaderText="Profile">
                    <ItemTemplate>
                        <div class="user-profile">
                            <div class='<%# GetAvatarClass(Eval("FullName")) %>'>
                                <%# GetInitial(Eval("FullName")) %>
                            </div>
                            <span class="user-name"><%# Eval("FullName") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 2: Email — plain text --%>
                <asp:BoundField DataField="Email" HeaderText="Email" />

                <%-- Column 3: Role — coloured badge (Influencer / Advertiser) --%>
                <asp:TemplateField HeaderText="Role">
                    <ItemTemplate>
                        <span class='<%# GetRoleBadge(Eval("Role")) %>'>
                            <%# Eval("Role") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 4: Status — coloured badge (Active / Inactive) --%>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusBadge(Eval("Status")) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 5: Joined Date — formatted as dd MMM yyyy --%>
                <asp:BoundField DataField="JoinedDate"
                    HeaderText="Joined Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <%-- Column 6: Actions — View button --%>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <a href="#" class="btn-action btn-primary-action">View</a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

            <%-- Shown when the Users table is empty --%>
            <EmptyDataTemplate>
                <div class="empty-state">
                    <span class="empty-icon">&#128100;</span>
                    <p>No users found. Add users to the database first.</p>
                </div>
            </EmptyDataTemplate>

        </asp:GridView>
        <%-- end GridView --%>

        <%-- Count row below the table --%>
        <div class="pagination-row">
            <asp:Label ID="lblCount" runat="server"
                CssClass="pagination-info" Text="Loading..." />
        </div>

    </div>
    <%-- end data-card --%>

</asp:Content>
