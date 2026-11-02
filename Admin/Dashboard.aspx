<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Influish_net.Admin.Dashboard" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Admin Dashboard
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <h2>Admin Dashboard</h2>
        <p>Monitor users, campaigns and platform activity.</p>
    </div>

    <!-- Stats Cards (4 cards matching Figma design) -->
    <div class="stats-grid">

        <!-- Card 1: Total Users -->
        <div class="stat-card">
            <div class="stat-card-top">
                <span class="stat-label">Total Users</span>
                <div class="stat-icon purple">&#128100;</div>
            </div>
            <div class="stat-value">
                <asp:Label ID="lblTotalUsers" runat="server" Text="0" />
            </div>
            <div class="stat-change">
                <span class="up">&#8679; Live</span> from database
            </div>
        </div>

        <!-- Card 2: Total Influencers -->
        <div class="stat-card">
            <div class="stat-card-top">
                <span class="stat-label">Total Influencers</span>
                <div class="stat-icon pink">&#11088;</div>
            </div>
            <div class="stat-value">
                <asp:Label ID="lblTotalInfluencers" runat="server" Text="0" />
            </div>
            <div class="stat-change">
                <span class="up">&#8679; Verified</span> creators
            </div>
        </div>

        <!-- Card 3: Total Advertisers -->
        <div class="stat-card">
            <div class="stat-card-top">
                <span class="stat-label">Total Advertisers</span>
                <div class="stat-icon blue">&#128203;</div>
            </div>
            <div class="stat-value">
                <asp:Label ID="lblTotalAdvertisers" runat="server" Text="0" />
            </div>
            <div class="stat-change">
                <span class="up">&#8679; Active</span> brand accounts
            </div>
        </div>

        <!-- Card 4: Active Campaigns -->
        <div class="stat-card">
            <div class="stat-card-top">
                <span class="stat-label">Active Campaigns</span>
                <div class="stat-icon orange">&#9889;</div>
            </div>
            <div class="stat-value">
                <asp:Label ID="lblActiveCampaigns" runat="server" Text="0" />
            </div>
            <div class="stat-change">
                <span class="up">&#8679; Open</span> marketplace briefs
            </div>
        </div>

    </div>

    <!-- Bottom Row: Recent Activities + Pending Actions -->
    <div class="dashboard-bottom">

        <!-- Recent Activities Card -->
        <div class="card">
            <div class="card-header">
                <h3>Recent Activities</h3>
                <a href="ManageUsers.aspx" class="card-link">View All</a>
            </div>
            <div class="card-body">
                <asp:Repeater ID="rptActivities" runat="server">
                    <ItemTemplate>
                        <div class="activity-item">
                            <div class='<%# Eval("AvatarClass") %>'><%# Eval("Avatar") %></div>
                            <div>
                                <div class="activity-text">
                                    <%# Eval("Text") %>
                                </div>
                                <span class="activity-time"><%# Eval("TimeText") %></span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoActivities" runat="server" Visible="false">
                    <p class="text-muted" style="padding: 15px 0;">No recent activities logged.</p>
                </asp:Panel>
            </div>
        </div>

        <!-- Pending Actions Card -->
        <div class="card">
            <div class="card-header">
                <h3>Pending Actions</h3>
                <span class="pending-badge-count">
                    <asp:Label ID="lblPendingBadgeCount" runat="server" Text="0 Pending" />
                </span>
            </div>
            <div class="card-body">

                <div class="pending-item">
                    <div class="pending-left">
                        <div class="pending-icon orange">&#128100;</div>
                        <div>
                            <div class="pending-title">User Account Reviews</div>
                            <div class="pending-desc">
                                <asp:Label ID="lblPendingUsersCount" runat="server" Text="0 users pending approval." />
                            </div>
                        </div>
                    </div>
                    <a href="ManageUsers.aspx" class="btn-view">View</a>
                </div>

                <div class="pending-item">
                    <div class="pending-left">
                        <div class="pending-icon purple">&#128203;</div>
                        <div>
                            <div class="pending-title">Campaign Moderation</div>
                            <div class="pending-desc">
                                <asp:Label ID="lblPendingCampaignsCount" runat="server" Text="0 campaigns pending review." />
                            </div>
                        </div>
                    </div>
                    <a href="ManageCampaigns.aspx" class="btn-view">View</a>
                </div>

                <div class="pending-item">
                    <div class="pending-left">
                        <div class="pending-icon red">&#128229;</div>
                        <div>
                            <div class="pending-title">Support Reports</div>
                            <div class="pending-desc">
                                <asp:Label ID="lblPendingReportsCount" runat="server" Text="0 unresolved support reports." />
                            </div>
                        </div>
                    </div>
                    <a href="ReportsSupport.aspx" class="btn-view">View</a>
                </div>

            </div>
        </div>

    </div>

</asp:Content>
