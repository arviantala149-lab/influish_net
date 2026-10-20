<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="Influish_net.Admin.ManageUsers" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Manage Users
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
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
