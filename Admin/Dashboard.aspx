<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master"
         CodeFile="Dashboard.aspx.cs" Inherits="Admin_Dashboard" %>
<%--
    ================================================================
    Admin/Dashboard.aspx  -  Admin Dashboard
    Language    : C# (code-behind: Dashboard.aspx.cs)
    Master Page : AdminMaster.master (provides sidebar + topbar)
    Syllabus    : Section 6 - ASP.NET Page, Master Pages, Controls
    ================================================================
    WHAT THIS PAGE DOES:
    Shows summary statistics and recent platform activity.
    The stats cards are static (hardcoded) as shown in the Figma.
    ================================================================
--%>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Admin Dashboard
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%-- Page Header --%>
    <div class="page-header">
        <h2>Admin Dashboard</h2>
        <p>Monitor users, campaigns and platform activity.</p>
    </div>

    <%-- STATS CARDS (4 cards) --%>
    <div class="stats-grid">

        <div class="stat-card">
            <div class="stat-card-top">
                <span class="stat-label">Total Users</span>
                <div class="stat-icon purple">&#128100;</div>
            </div>
            <div class="stat-value">1,250</div>
            <div class="stat-change">
                <span class="up">&#8679; +12%</span> vs last month
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-card-top">
                <span class="stat-label">Total Influencers</span>
                <div class="stat-icon pink">&#11088;</div>
            </div>
            <div class="stat-value">820</div>
            <div class="stat-change">
                <span class="up">&#8679; +8%</span> vs last month
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-card-top">
                <span class="stat-label">Total Advertisers</span>
                <div class="stat-icon blue">&#128203;</div>
            </div>
            <div class="stat-value">430</div>
            <div class="stat-change">
                <span class="up">&#8679; +15%</span> vs last month
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-card-top">
                <span class="stat-label">Active Campaigns</span>
                <div class="stat-icon orange">&#9889;</div>
            </div>
            <div class="stat-value">96</div>
            <div class="stat-change">
                <span class="down">&#8681; -2%</span> vs last month
            </div>
        </div>

    </div>

    <%-- BOTTOM ROW: Recent Activities + Pending Actions --%>
    <div class="dashboard-bottom">

        <div class="card">
            <div class="card-header">
                <h3>Recent Activities</h3>
                <a href="ManageUsers.aspx" class="card-link">View All</a>
            </div>
            <div class="card-body">

                <div class="activity-item">
                    <div class="activity-avatar">S</div>
                    <div>
                        <div class="activity-text">Sarah Jenkins registered as a new influencer.</div>
                        <span class="activity-time">10 minutes ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar blue">N</div>
                    <div>
                        <div class="activity-text">Nike created a new campaign: &quot;Summer Activewear 2024&quot;.</div>
                        <span class="activity-time">45 minutes ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar orange">T</div>
                    <div>
                        <div class="activity-text">TechReviewer24 registered as a new influencer.</div>
                        <span class="activity-time">2 hours ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar green">C</div>
                    <div>
                        <div class="activity-text">Campaign &quot;Eco Friendly Launch&quot; marked as completed.</div>
                        <span class="activity-time">3 hours ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar">L</div>
                    <div>
                        <div class="activity-text">Local Coffee Shop created a new campaign: &quot;Morning Brew Promo&quot;.</div>
                        <span class="activity-time">5 hours ago</span>
                    </div>
                </div>

            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3>Pending Actions</h3>
                <span class="pending-badge-count">12 Pending</span>
            </div>
            <div class="card-body">

                <div class="pending-item">
                    <div class="pending-left">
                        <div class="pending-icon orange">&#128100;</div>
                        <div>
                            <div class="pending-title">User Account Reviews</div>
                            <div class="pending-desc">5 new influencers pending approval.</div>
                        </div>
                    </div>
                    <a href="ManageUsers.aspx" class="btn-view">View</a>
                </div>

                <div class="pending-item">
                    <div class="pending-left">
                        <div class="pending-icon purple">&#128203;</div>
                        <div>
                            <div class="pending-title">Campaign Moderation</div>
                            <div class="pending-desc">3 campaigns flagged for review.</div>
                        </div>
                    </div>
                    <a href="ManageCampaigns.aspx" class="btn-view">View</a>
                </div>

                <div class="pending-item">
                    <div class="pending-left">
                        <div class="pending-icon red">&#128229;</div>
                        <div>
                            <div class="pending-title">Support Reports</div>
                            <div class="pending-desc">4 unresolved critical issues.</div>
                        </div>
                    </div>
                    <a href="ReportsSupport.aspx" class="btn-view">View</a>
                </div>

            </div>
        </div>

    </div>

</asp:Content>
