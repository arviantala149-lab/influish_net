<<<<<<< Updated upstream
<<<<<<< Updated upstream
<%@ Page Language="VB" MasterPageFile="~/Admin/AdminMaster.master" %>
=======
<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" %>
>>>>>>> Stashed changes
=======
<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" %>
>>>>>>> Stashed changes
<%--
    ================================================================
    Admin/Dashboard.aspx  —  Admin Dashboard
    Language    : C# (inline runat="server")
    Master Page : AdminMaster.master (provides sidebar + topbar)
    Syllabus    : Section 6 — ASP.NET Page, Master Pages, Controls
    ================================================================

    WHAT THIS PAGE DOES:
    Shows summary statistics and recent platform activity.
    The stats cards are static (hardcoded) as shown in the Figma.
    Session protection is handled by AdminMaster.master Page_Load.
    ================================================================
--%>

<%-- ── Page Title shown in the topbar ──────────────────────────── --%>
<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Admin Dashboard
</asp:Content>

<%-- ── Main page body ────────────────────────────────────────────── --%>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        ' ── Page_Load ─────────────────────────────────────────────
        ' Session check is already done in AdminMaster.master.
        ' Dashboard shows static data from the Figma design.
        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            ' No additional server code needed for the static Dashboard.
        End Sub
=======
=======
>>>>>>> Stashed changes
        // ── Page_Load ─────────────────────────────────────────────
        // Session check is already done in AdminMaster.master.
        // Dashboard shows static data from the Figma design.
        protected void Page_Load(object sender, EventArgs e)
        {
            // No additional server code needed for the static Dashboard.
        }
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    </script>

    <%-- ── Page Header ──────────────────────────────────────────── --%>
    <div class="page-header">
        <h2>Admin Dashboard</h2>
        <p>Monitor users, campaigns and platform activity.</p>
    </div>

    <%-- ══════════════════════════════════════════════════════════
         STATS CARDS (4 cards matching Figma design)
         These figures are static as shown in the Figma reference.
         ══════════════════════════════════════════════════════════ --%>
    <div class="stats-grid">

        <%-- Card 1: Total Users --%>
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

        <%-- Card 2: Total Influencers --%>
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

        <%-- Card 3: Total Advertisers --%>
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

        <%-- Card 4: Active Campaigns --%>
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
    <%-- end stats-grid --%>


    <%-- ══════════════════════════════════════════════════════════
         BOTTOM ROW — Recent Activities  +  Pending Actions
         (2 side-by-side cards as in Figma design)
         ══════════════════════════════════════════════════════════ --%>
    <div class="dashboard-bottom">

        <%-- ── Recent Activities Card ───────────────────────────── --%>
        <div class="card">
            <div class="card-header">
                <h3>Recent Activities</h3>
                <a href="ManageUsers.aspx" class="card-link">View All</a>
            </div>
            <div class="card-body">

                <div class="activity-item">
                    <div class="activity-avatar">S</div>
                    <div>
                        <div class="activity-text">
                            Sarah Jenkins registered as a new influencer.
                        </div>
                        <span class="activity-time">10 minutes ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar blue">N</div>
                    <div>
                        <div class="activity-text">
                            Nike created a new campaign: &quot;Summer Activewear 2024&quot;.
                        </div>
                        <span class="activity-time">45 minutes ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar orange">T</div>
                    <div>
                        <div class="activity-text">
                            TechReviewer24 registered as a new influencer.
                        </div>
                        <span class="activity-time">2 hours ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar green">C</div>
                    <div>
                        <div class="activity-text">
                            Campaign &quot;Eco Friendly Launch&quot; marked as completed.
                        </div>
                        <span class="activity-time">3 hours ago</span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-avatar">L</div>
                    <div>
                        <div class="activity-text">
                            Local Coffee Shop created a new campaign: &quot;Morning Brew Promo&quot;.
                        </div>
                        <span class="activity-time">5 hours ago</span>
                    </div>
                </div>

            </div>
        </div>
        <%-- end Recent Activities card --%>


        <%-- ── Pending Actions Card ──────────────────────────────── --%>
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
        <%-- end Pending Actions card --%>

    </div>
    <%-- end dashboard-bottom --%>

</asp:Content>
