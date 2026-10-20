<%@ Page Title="Manage Campaigns" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="ManageCampaigns.aspx.cs" Inherits="Influish_net.Admin.ManageCampaigns" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Manage Campaigns
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

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
                            <%# (Eval("Status") ?? "").ToString().ToUpper() %>
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
