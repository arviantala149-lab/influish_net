<<<<<<< Updated upstream
<%@ Page Title="Welcome to Influish" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Influish_net._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Hero Banner (Figma Page 2 & Page 4) -->
    <div class="influish-card p-5 mb-4" style="background: linear-gradient(135deg, #FAF5FF 0%, #FFFFFF 100%); border-color: #EDE9FE;">
        <div class="row align-items-center g-4">
            <div class="col-lg-7">
                <span class="category-tag mb-3" style="background:#EDE9FE; color:#7C3AED; font-weight:600;">
                    &#9679; India's #1 Creator Marketplace
                </span>
                <h1 class="page-title mt-2 mb-3" style="font-size: 34px; line-height: 1.2;">
                    Connect with Top Influencers & Launch Impactful Campaigns
                </h1>
                <p class="text-secondary mb-4" style="font-size: 16px; line-height: 1.6;">
                    Stop guessing. Start growing. Influish bridges the gap between creative talent and visionary advertisers, making collaboration effortless, transparent, and ROI-driven.
                </p>
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <a href="<%= ResolveUrl("~/Advertiser/Dashboard.aspx") %>" class="btn-influish-primary" style="padding: 12px 28px; font-size: 15px;">
                        <span>Launch Advertiser Dashboard</span>
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </a>
                    <a href="<%= ResolveUrl("~/Advertiser/MyCampaigns.aspx") %>" class="btn-influish-secondary" style="padding: 12px 24px; font-size: 15px;">
                        Explore Campaigns
                    </a>
                </div>
            </div>

            <div class="col-lg-5 text-center">
                <div style="background: linear-gradient(135deg, #EDE9FE, #FCE7F3); border-radius: 20px; padding: 40px; box-shadow: 0 10px 30px rgba(124, 58, 237, 0.1);">
                    <div style="font-size: 48px; margin-bottom: 12px;">🚀</div>
                    <h3 class="fw-bold text-dark mb-2">Advertiser Module</h3>
                    <p class="text-secondary small mb-3">Everything you need to create campaigns, review applicant influencers, and track performance.</p>
                    <div class="d-flex justify-content-center gap-3 text-start mt-3">
                        <div class="p-2 px-3 bg-white rounded-3 shadow-sm">
                            <div class="fw-bold text-dark">850+</div>
                            <div class="text-muted" style="font-size:11px;">Verified Creators</div>
                        </div>
                        <div class="p-2 px-3 bg-white rounded-3 shadow-sm">
                            <div class="fw-bold text-dark">400+</div>
                            <div class="text-muted" style="font-size:11px;">Active Brands</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Navigation to Module Pages -->
    <h3 class="card-title mb-3" style="font-size: 18px;">Advertiser Module Screens</h3>
    <div class="row g-3">
        <div class="col-md-4">
            <div class="influish-card p-3 h-100">
                <h5 class="fw-bold mb-1"><a href="<%= ResolveUrl("~/Advertiser/Dashboard.aspx") %>">1. Dashboard</a></h5>
                <p class="text-secondary small mb-0">Overview of active campaigns, total applicants, accepted influencers, and recent promotions.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="influish-card p-3 h-100">
                <h5 class="fw-bold mb-1"><a href="<%= ResolveUrl("~/Advertiser/CreateCampaign.aspx") %>">2. Create Campaign</a></h5>
                <p class="text-secondary small mb-0">Campaign details form with server-side validation for category, budget, followers, and age range.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="influish-card p-3 h-100">
                <h5 class="fw-bold mb-1"><a href="<%= ResolveUrl("~/Advertiser/MyCampaigns.aspx") %>">3. My Campaigns</a></h5>
                <p class="text-secondary small mb-0">Browse and filter campaigns by Open/Closed status, view applicant counts, and edit details.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="influish-card p-3 h-100">
                <h5 class="fw-bold mb-1"><a href="<%= ResolveUrl("~/Advertiser/CampaignDetails.aspx") %>">4. Applicants List</a></h5>
                <p class="text-secondary small mb-0">Review influencers who applied, filter by status, sort by followers, and accept or reject candidates.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="influish-card p-3 h-100">
                <h5 class="fw-bold mb-1"><a href="<%= ResolveUrl("~/Advertiser/InfluencerProfile.aspx") %>">5. Applicant Review</a></h5>
                <p class="text-secondary small mb-0">Detailed influencer profile, statistics, bio, application details, and acceptance actions.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="influish-card p-3 h-100">
                <h5 class="fw-bold mb-1"><a href="<%= ResolveUrl("~/Advertiser/CompanyProfile.aspx") %>">6. Company Profile</a></h5>
                <p class="text-secondary small mb-0">Company contact information, industry, website, and account security password change.</p>
            </div>
        </div>
    </div>
</asp:Content>
=======
<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="Influish_net._Default" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Influish — Influencer Marketing Platform Admin Panel" />
    <title>Influish — Influencer Marketing Platform</title>

    <%-- Link to the Admin CSS file for Splash Screen styles --%>
    <link href="Content/admin.css" rel="stylesheet" />
</head>
<body class="splash-body">

    <%-- ── Logo and Brand ────────────────────────────────────── --%>
    <div class="splash-logo-wrap">
        <div class="splash-logo-icon">i</div>
        <div class="splash-brand-text">
            <h1>Influish</h1>
            <p>Influencer Admin</p>
        </div>
    </div>

    <%-- ── Tagline ─────────────────────────────────────────────── --%>
    <p class="splash-subtitle">Connecting Brands &amp; Influencers</p>

    <%-- ── Animated Loading Dots ──────────────────────────────── --%>
    <div class="splash-loader">
        <span class="splash-dot"></span>
        <span class="splash-dot"></span>
        <span class="splash-dot"></span>
    </div>

    <%-- ── Redirect Text ──────────────────────────────────────── --%>
    <p class="splash-redirect">Redirecting to Admin Panel...</p>

    <%-- ── JavaScript: Auto-redirect after 3 seconds ─────────── --%>
    <script type="text/javascript">
        // Wait 3000 milliseconds (3 seconds), then open Admin Login page
        setTimeout(function () {
            window.location.href = 'Admin/Login.aspx';
        }, 3000);
    </script>

</body>
</html>
>>>>>>> Stashed changes
