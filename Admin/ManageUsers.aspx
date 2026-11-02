<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="Influish_net.Admin.ManageUsers" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Manage Users
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header -->
    <div class="page-header">
        <h2>Manage Users</h2>
        <p>View and manage all registered influencers and advertisers.</p>
    </div>

    <!-- Feedback Labels -->
    <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" style="display:block; margin-bottom:12px;" />
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" style="display:block; margin-bottom:12px; padding:10px 14px; background:#ECFDF5; border:1px solid #10B981; border-radius:6px; color:#065F46; font-size:14px;">
        <asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>

    <!-- Toolbar: Search + Filter dropdowns -->
    <div class="toolbar">
        <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search users by name or email..." AutoPostBack="true" OnTextChanged="Filter_Changed" />
        </div>
        <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
            <asp:ListItem Text="All Roles" Value="" />
            <asp:ListItem Text="Influencer" Value="Influencer" />
            <asp:ListItem Text="Advertiser" Value="Advertiser" />
            <asp:ListItem Text="Admin" Value="Admin" />
        </asp:DropDownList>
        <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
            <asp:ListItem Text="All Status" Value="" />
            <asp:ListItem Text="Active" Value="Active" />
            <asp:ListItem Text="Inactive" Value="Inactive" />
            <asp:ListItem Text="Pending" Value="Pending" />
            <asp:ListItem Text="Suspended" Value="Suspended" />
        </asp:DropDownList>
    </div>

    <!-- Data Card wrapping the GridView -->
    <div class="data-card">

        <asp:GridView ID="gvUsers" runat="server"
            AutoGenerateColumns="false"
            CssClass="data-table"
            GridLines="None"
            UseAccessibleHeader="true"
            HeaderStyle-CssClass="gv-header"
            RowStyle-CssClass="gv-row">

            <Columns>
                <!-- Column 1: Profile — coloured avatar + full name -->
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

                <!-- Column 2: Email -->
                <asp:BoundField DataField="Email" HeaderText="Email" />

                <!-- Column 3: Role badge -->
                <asp:TemplateField HeaderText="Role">
                    <ItemTemplate>
                        <span class='<%# GetRoleBadge(Eval("Role")) %>'>
                            <%# Eval("Role") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <!-- Column 4: Status badge -->
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusBadge(Eval("Status")) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <!-- Column 5: Joined Date -->
                <asp:BoundField DataField="JoinedDate"
                    HeaderText="Joined Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <!-- Column 6: Actions -->
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnToggleStatus" runat="server"
                            CommandName="ToggleStatus"
                            CommandArgument='<%# Eval("UserID") %>'
                            Text='<%# (Eval("Status") ?? "").ToString().ToLower() == "active" ? "Deactivate" : "Activate" %>'
                            CssClass='<%# (Eval("Status") ?? "").ToString().ToLower() == "active" ? "btn-action btn-danger-action" : "btn-action btn-primary-action" %>'
                            OnCommand="btnToggleStatus_Command" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">
                    <span class="empty-icon">&#128100;</span>
                    <p>No users found matching your criteria.</p>
                </div>
            </EmptyDataTemplate>

        </asp:GridView>

        <!-- Count row below the table -->
        <div class="pagination-row">
            <asp:Label ID="lblCount" runat="server"
                CssClass="pagination-info" Text="Loading..." />
        </div>

    </div>

</asp:Content>
