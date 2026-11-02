<%@ Page Title="Manage Campaigns" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="ManageCampaigns.aspx.cs" Inherits="Influish_net.Admin.ManageCampaigns" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Manage Campaigns
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <h2>Manage Campaigns</h2>
        <p>Review and manage campaigns created by advertisers. Monitor active promotions and approve pending requests.</p>
    </div>

    <!-- Feedback Labels -->
    <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" style="display:block; margin-bottom:12px;" />
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" style="display:block; margin-bottom:12px; padding:10px 14px; background:#ECFDF5; border:1px solid #10B981; border-radius:6px; color:#065F46; font-size:14px;">
        <asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>

    <!-- Toolbar -->
    <div class="toolbar">
        <!-- Filter tabs (All / Active / Pending / Deactivated) -->
        <div class="filter-tabs">
            <asp:LinkButton ID="btnTabAll" runat="server" CssClass="filter-tab active" Text="All" CommandArgument="" OnClick="FilterTab_Click" />
            <asp:LinkButton ID="btnTabActive" runat="server" CssClass="filter-tab" Text="Active" CommandArgument="Active" OnClick="FilterTab_Click" />
            <asp:LinkButton ID="btnTabPending" runat="server" CssClass="filter-tab" Text="Pending" CommandArgument="Pending" OnClick="FilterTab_Click" />
            <asp:LinkButton ID="btnTabDeactivated" runat="server" CssClass="filter-tab" Text="Deactivated" CommandArgument="Deactivated" OnClick="FilterTab_Click" />
        </div>
        <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search campaigns..." AutoPostBack="true" OnTextChanged="Filter_Changed" />
        </div>
        <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="filter-select" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
            <asp:ListItem Text="All Categories" Value="" />
        </asp:DropDownList>
    </div>

    <!-- Data Card with GridView -->
    <div class="data-card">

        <asp:GridView ID="gvCampaigns" runat="server"
            AutoGenerateColumns="false"
            CssClass="data-table"
            GridLines="None"
            UseAccessibleHeader="true"
            HeaderStyle-CssClass="gv-header"
            RowStyle-CssClass="gv-row">

            <Columns>

                <!-- Column 1: Campaign — icon + name + category -->
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

                <!-- Column 2: Advertiser -->
                <asp:BoundField DataField="Advertiser" HeaderText="Advertiser" />

                <!-- Column 3: Budget (formatted as ₹) -->
                <asp:TemplateField HeaderText="Budget">
                    <ItemTemplate>
                        <%# FormatBudget(Eval("Budget")) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <!-- Column 4: Applicants -->
                <asp:BoundField DataField="Applicants" HeaderText="Applicants" />

                <!-- Column 5: Status badge -->
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusBadge(Eval("Status")) %>'>
                            <%# (Eval("Status") ?? "").ToString().ToUpper() %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <!-- Column 6: Created Date -->
                <asp:BoundField DataField="CreatedDate"
                    HeaderText="Created Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <!-- Column 7: Actions -->
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnToggleCampaign" runat="server"
                            CommandName="ToggleCampaign"
                            CommandArgument='<%# Eval("CampaignID") %>'
                            Text='<%# (Eval("Status") ?? "").ToString() == "Active" || (Eval("Status") ?? "").ToString() == "Open" ? "Deactivate" : "Approve" %>'
                            CssClass='<%# (Eval("Status") ?? "").ToString() == "Active" || (Eval("Status") ?? "").ToString() == "Open" ? "btn-action btn-danger-action" : "btn-action btn-primary-action" %>'
                            OnCommand="btnToggleCampaign_Command" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">
                    <span class="empty-icon">&#128203;</span>
                    <p>No campaigns found matching your criteria.</p>
                </div>
            </EmptyDataTemplate>

        </asp:GridView>

        <div class="pagination-row">
            <asp:Label ID="lblCount" runat="server"
                CssClass="pagination-info" Text="Loading..." />
        </div>

    </div>

</asp:Content>
