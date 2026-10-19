<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master"
         CodeFile="ManageUsers.aspx.cs" Inherits="Admin_ManageUsers" %>
<%--
    ================================================================
    Admin/ManageUsers.aspx  -  Manage Users Page
    Language    : C# (code-behind: ManageUsers.aspx.cs)
    Master Page : AdminMaster.master
    Syllabus    : Section 6 - GridView, Controls
                  Section 7 - ADO.NET: SqlConnection, SqlDataAdapter,
                              DataTable (Connected + Disconnected model)
    ================================================================
    ADO.NET EXPLAINED (for viva):
    SqlConnection  -- opens a channel to the SQL Server database
    SqlDataAdapter -- runs the SQL SELECT query and fetches results
    DataTable      -- stores the fetched rows in memory (like a table)
    GridView.DataBind() -- displays the DataTable rows on the web page
    ================================================================
--%>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Manage Users
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%-- Page Header --%>
    <div class="page-header">
        <h2>Manage Users</h2>
        <p>View and manage all registered influencers and advertisers.</p>
    </div>

    <%-- Error Label (hidden until an error occurs) --%>
    <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />

    <%-- Toolbar: Search + Filter dropdowns --%>
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

    <%-- Data Card wrapping the GridView --%>
    <div class="data-card">

        <%--
            GridView: ASP.NET control that displays data as an HTML table.
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

            <Columns>

                <%-- Column 1: Profile - coloured avatar + full name --%>
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

                <%-- Column 2: Email --%>
                <asp:BoundField DataField="Email" HeaderText="Email" />

                <%-- Column 3: Role badge --%>
                <asp:TemplateField HeaderText="Role">
                    <ItemTemplate>
                        <span class='<%# GetRoleBadge(Eval("Role")) %>'>
                            <%# Eval("Role") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 4: Status badge --%>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusBadge(Eval("Status")) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <%-- Column 5: Joined Date --%>
                <asp:BoundField DataField="JoinedDate"
                    HeaderText="Joined Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <%-- Column 6: Actions --%>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <a href="#" class="btn-action btn-primary-action">View</a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">
                    <span class="empty-icon">&#128100;</span>
                    <p>No users found. Add users to the database first.</p>
                </div>
            </EmptyDataTemplate>

        </asp:GridView>

        <div class="pagination-row">
            <asp:Label ID="lblCount" runat="server"
                CssClass="pagination-info" Text="Loading..." />
        </div>

    </div>

</asp:Content>
