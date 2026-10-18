<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Influish_net.Advertiser.Dashboard" MasterPageFile="~/Site.Master" Title="Advertiser Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Welcome Header & Action -->
    <div class="page-header-row">
        <div>
            <h1 class="page-title">
                Welcome back, <asp:Label ID="lblCompanyName" runat="server" Text="TechNova Solutions" />
            </h1>
            <p class="page-subtitle">Here's an overview of your campaign performance.</p>
        </div>
        <div class="d-flex align-items-center gap-2">
            <asp:Button ID="btnProfile" runat="server" CssClass="btn-influish-secondary" Text="Company Profile" OnClick="btnProfile_Click" />
            <asp:LinkButton ID="btnCreate" runat="server" CssClass="btn-influish-primary" OnClick="btnCreate_Click">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Create Campaign</span>
            </asp:LinkButton>
        </div>
    </div>

    <!-- 3 Stat Metric Cards -->
    <div class="row g-4 mb-4">
        <!-- Active Campaigns -->
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-card-icon purple">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="m3 11 18-5v12L3 14v-3z"></path>
                        <path d="M11.6 16.8a3 3 0 1 1-5.8-1.6"></path>
                    </svg>
                </div>
                <div>
                    <div class="stat-value">
                        <asp:Label ID="lblActiveCampaigns" runat="server" Text="3" />
                    </div>
                    <p class="stat-label">Active Campaigns</p>
                </div>
            </div>
        </div>

        <!-- Total Applicants -->
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-card-icon pink">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                </div>
                <div>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalApplicants" runat="server" Text="48" />
                    </div>
                    <p class="stat-label">Total Applicants</p>
                </div>
            </div>
        </div>

        <!-- Accepted Influencers -->
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-card-icon teal">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        <path d="m9 12 2 2 4-4"></path>
                    </svg>
                </div>
                <div>
                    <div class="stat-value">
                        <asp:Label ID="lblAccepted" runat="server" Text="12" />
                    </div>
                    <p class="stat-label">
                        Accepted Influencers 
                        <span class="text-muted" style="font-size:12px;">(<asp:Label ID="lblPending" runat="server" Text="0" /> pending)</span>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- My Recent Campaigns Section -->
    <div class="influish-card">
        <div class="influish-card-header">
            <h2 class="card-title">My Recent Campaigns</h2>
            <asp:HyperLink ID="lnkViewAll" runat="server" NavigateUrl="~/Advertiser/MyCampaigns.aspx" CssClass="text-primary fw-semibold" style="font-size:14px;">
                View All &rarr;
            </asp:HyperLink>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvCampaigns" runat="server" AutoGenerateColumns="False" CssClass="influish-table" GridLines="None" EmptyDataText="No recent campaigns found.">
                <Columns>
                    <asp:TemplateField HeaderText="CAMPAIGN NAME">
                        <ItemTemplate>
                            <div class="d-flex align-items-center gap-3">
                                <div class="campaign-thumbnail" style="width:42px; height:42px; border-radius:8px; font-size:16px;">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                                        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                                    </svg>
                                </div>
                                <div>
                                    <asp:HyperLink ID="lnkCampaignTitle" runat="server" CssClass="fw-bold text-dark d-block" Text='<%# Eval("Title") %>' NavigateUrl='<%# Eval("CampaignID", "CampaignDetails.aspx?id={0}") %>' />
                                    <span class="text-muted small"><%# Eval("Category") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="STATUS">
                        <ItemTemplate>
                            <span class='status-badge <%# GetStatusBadgeClass(Eval("Status")) %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="APPLICANTS">
                        <ItemTemplate>
                            <span class="fw-semibold text-secondary">
                                <%# FormatApplicantCount(Eval("ApplicantCount")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="BUDGET">
                        <ItemTemplate>
                            <span class="fw-bold text-dark">
                                <%# FormatBudget(Eval("Budget")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="ACTIONS">
                        <ItemTemplate>
                            <div class="d-flex align-items-center gap-2">
                                <asp:HyperLink ID="lnkView" runat="server" Text="View" NavigateUrl='<%# Eval("CampaignID", "CampaignDetails.aspx?id={0}") %>' CssClass="btn btn-sm btn-outline-primary" style="border-radius:6px; font-size:12px; font-weight:600;" />
                                <asp:HyperLink ID="lnkEdit" runat="server" Text="Edit" NavigateUrl='<%# Eval("CampaignID", "CreateCampaign.aspx?id={0}") %>' CssClass="btn btn-sm btn-outline-secondary" style="border-radius:6px; font-size:12px; font-weight:600;" />
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("CampaignID") %>' Text="Delete" OnClick="lnkDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this campaign?');" CssClass="btn btn-sm btn-outline-danger" style="border-radius:6px; font-size:12px; font-weight:600;" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>