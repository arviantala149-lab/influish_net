<%@ Page Title="My Applications" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Applications.aspx.cs" Inherits="Influish_net.Applications" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Track the status of your campaign applications across brands." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <h1>My Applications</h1>
        <p>Track the status of your campaign applications across brands.</p>
    </div>

    <!-- Tabs -->
    <div class="tab-nav" id="appTabs">
        <asp:LinkButton ID="tabAll" runat="server" CssClass="tab-btn active" OnClick="FilterTab_Click" CommandArgument="all">All</asp:LinkButton>
        <asp:LinkButton ID="tabPending" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="pending">Pending</asp:LinkButton>
        <asp:LinkButton ID="tabAccepted" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="accepted">Accepted</asp:LinkButton>
        <asp:LinkButton ID="tabRejected" runat="server" CssClass="tab-btn" OnClick="FilterTab_Click" CommandArgument="rejected">Rejected</asp:LinkButton>
    </div>

    <!-- Table Card -->
    <div class="card card-shadow">
        <table class="influish-table" id="applicationsTable">
            <thead>
                <tr>
                    <th>Campaign &amp; Brand</th>
                    <th>Proposed / Budget</th>
                    <th>Applied Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptApplications" runat="server">
                    <ItemTemplate>
                        <tr data-status='<%# Eval("Status").ToString().ToLower() %>'>
                            <td>
                                <div class="table-brand-cell">
                                    <div style="width:40px;height:40px;border-radius:8px;background:linear-gradient(135deg,#7C3AED,#EC4899);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;flex-shrink:0;">
                                        <%# GetInitials(Eval("Advertiser")) %>
                                    </div>
                                    <div>
                                        <div class="brand-name"><%# Eval("CampaignTitle") %></div>
                                        <div class="brand-company"><%# Eval("Advertiser") %></div>
                                    </div>
                                </div>
                            </td>
                            <td style="font-size:15px; font-weight:700; color:var(--text-heading);">
                                <%# FormatBudget(Eval("ProposedRate"), Eval("Budget")) %>
                            </td>
                            <td><%# FormatDate(Eval("AppliedAt")) %></td>
                            <td>
                                <span class='<%# GetStatusBadgeClass(Eval("Status")) %>'><%# Eval("Status") %></span>
                            </td>
                            <td>
                                <a href='<%# "CampaignDetails.aspx?id=" + Eval("CampaignID") %>' class="btn btn-outline btn-sm">View</a>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>

        <asp:Panel ID="pnlNoApps" runat="server" Visible="false" style="padding:40px 20px; text-align:center;">
            <div style="font-size:36px; margin-bottom:10px;">📋</div>
            <h3 style="font-size:16px; font-weight:700; color:var(--text-heading);">No applications found</h3>
            <p style="font-size:13px; color:var(--text-muted); margin-bottom:16px;">Explore brand campaigns on the marketplace to start collaborating.</p>
            <a href="Campaigns.aspx" class="btn btn-primary btn-sm">Browse Campaigns</a>
        </asp:Panel>

        <!-- Pagination summary -->
        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:20px; padding-top:16px; border-top:1px solid var(--border-light);">
            <span style="font-size:13px; color:var(--text-muted);">
                <asp:Literal ID="litShowingCount" runat="server" Text="Showing 0 entries" />
            </span>
        </div>
    </div>

</asp:Content>
