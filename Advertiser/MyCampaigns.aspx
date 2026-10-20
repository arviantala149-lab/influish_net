<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyCampaigns.aspx.cs" Inherits="Influish_net.Advertiser.MyCampaigns" MasterPageFile="~/Advertiser/AdvertiserMaster.master" Title="My Campaigns" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb -->
    <div class="influish-breadcrumb">
        <a href="Dashboard.aspx">Dashboard</a>
        <span>/</span>
        <span class="text-dark fw-medium">My Campaigns</span>
    </div>

    <!-- Page Header & Create Action -->
    <div class="page-header-row">
        <div>
            <h1 class="page-title">My Campaigns</h1>
            <p class="page-subtitle">Manage and track your active influencer promotions.</p>
        </div>
        <div>
            <asp:LinkButton ID="btnCreate" runat="server" CssClass="btn-influish-primary" OnClick="btnCreate_Click">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Create New Campaign</span>
            </asp:LinkButton>
        </div>
    </div>

    <!-- Filter Tabs (Figma Page 20) -->
    <div class="influish-tabs">
        <asp:LinkButton ID="btnTabAll" runat="server" CssClass="influish-tab-btn active" OnClick="FilterTab_Click" CommandArgument="all">
            All Campaigns
        </asp:LinkButton>
        <asp:LinkButton ID="btnTabOpen" runat="server" CssClass="influish-tab-btn" OnClick="FilterTab_Click" CommandArgument="open">
            Open (<asp:Literal ID="litOpenCount" runat="server" Text="2" />)
        </asp:LinkButton>
        <asp:LinkButton ID="btnTabClosed" runat="server" CssClass="influish-tab-btn" OnClick="FilterTab_Click" CommandArgument="closed">
            Closed/Ended (<asp:Literal ID="litClosedCount" runat="server" Text="1" />)
        </asp:LinkButton>
    </div>

    <!-- Campaign Cards List (Figma Page 20) -->
    <asp:Repeater ID="rptCampaigns" runat="server">
        <ItemTemplate>
            <div class="campaign-card">
                <div class="campaign-card-left">
                    <div class="campaign-thumbnail">
                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                        </svg>
                    </div>
                    <div class="campaign-details-col">
                        <div class="d-flex align-items-center gap-2 flex-wrap mb-1">
                            <span class='status-badge <%# GetStatusBadgeClass(Eval("Status")) %>'>
                                <%# Eval("Status") %>
                            </span>
                            <span class="category-tag">
                                <%# Eval("Category") %>
                            </span>
                            <span class="text-muted small">
                                &#8226; <%# GetPostedText(Eval("CampaignID")) %>
                            </span>
                        </div>

                        <asp:HyperLink ID="lnkTitle" runat="server" CssClass="campaign-title-link" 
                            Text='<%# Eval("Title") %>' NavigateUrl='<%# Eval("CampaignID", "CampaignDetails.aspx?id={0}") %>' />

                        <p class="text-secondary small mb-0" style="max-width: 600px; line-height: 1.4;">
                            <%# TruncateDescription(Eval("Description")) %>
                        </p>

                        <div class="campaign-stats-row">
                            <div class="stat-item">
                                <span class="stat-item-label">Budget</span>
                                <span class="stat-item-val"><%# FormatBudget(Eval("Budget")) %></span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-item-label">Min. Followers</span>
                                <span class="stat-item-val"><%# FormatFollowers(Eval("MinFollowers")) %></span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-item-label">Applicants</span>
                                <span class="stat-item-val">
                                    <span style="display:inline-block; width:7px; height:7px; border-radius:50%; background-color:#10B981; margin-right:4px;"></span>
                                    <%# Eval("ApplicantCount") %>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Card Actions -->
                <div class="d-flex flex-column align-items-end gap-2" style="min-width: 140px;">
                    <asp:HyperLink ID="lnkViewApplicants" runat="server" Text="View Applicants" 
                        NavigateUrl='<%# Eval("CampaignID", "CampaignDetails.aspx?id={0}") %>' 
                        CssClass="btn-influish-secondary" style="padding: 8px 16px; font-size: 13px;" />

                    <div class="d-flex align-items-center gap-3 mt-1">
                        <asp:HyperLink ID="lnkEdit" runat="server" NavigateUrl='<%# Eval("CampaignID", "CreateCampaign.aspx?id={0}") %>' 
                            CssClass="text-secondary small fw-medium" title="Edit Campaign">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-1">
                                <path d="M12 20h9"></path>
                                <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                            </svg>
                            Edit
                        </asp:HyperLink>

                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("CampaignID") %>' 
                            OnClick="lnkDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this campaign?');" 
                            CssClass="text-danger small fw-medium" title="Delete Campaign">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-1">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            </svg>
                            Delete
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <!-- Empty State Fallback -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="influish-card text-center p-5">
            <div style="font-size: 40px; color: var(--text-muted); margin-bottom: 12px;">📢</div>
            <h4 class="fw-bold">No campaigns found</h4>
            <p class="text-secondary small">You haven't created any campaigns matching this filter yet.</p>
            <asp:LinkButton ID="btnEmptyCreate" runat="server" CssClass="btn-influish-primary mt-2" OnClick="btnCreate_Click">
                Create First Campaign
            </asp:LinkButton>
        </div>
    </asp:Panel>

    <!-- Footer Stats -->
    <div class="d-flex align-items-center justify-content-between mt-4 text-secondary small">
        <div>
            Showing <asp:Literal ID="litShowingCount" runat="server" Text="1 to 3 of 3 campaigns" />
        </div>
    </div>
</asp:Content>