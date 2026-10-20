<%@ Page Title="Connect with Top Influencers in India" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="Influish_net._Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Influish bridges the gap between creative talent and visionary advertisers — India's #1 Creator Marketplace." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ==============================
         HERO SECTION
         ============================== -->
    <section style="background: #F8F7FF;">
        <div class="hero-section">
            <!-- Left: Text -->
            <div class="hero-left">
                <div class="hero-badge">
                    <span class="dot"></span>
                    India's #1 Creator Marketplace
                </div>
                <h1 class="hero-title">
                    Connect with<br />
                    <span class="gradient-text">Top Influencers</span><br />
                    in India
                </h1>
                <p class="hero-desc">
                    Discover authentic voices to elevate your brand. Influish bridges the gap between creative talent and visionary advertisers, making campaign collaboration effortless and impactful.
                </p>
                <div class="hero-actions">
                    <a href="~/Signup.aspx" runat="server" class="btn btn-primary btn-lg" style="display:inline-flex; align-items:center; gap:8px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        Join as Influencer
                    </a>
                    <a href="~/Signup.aspx" runat="server" class="btn btn-outline btn-lg" style="display:inline-flex; align-items:center; gap:8px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
                            <path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"></path>
                        </svg>
                        Join as Advertiser
                    </a>
                </div>
            </div>

            <!-- Right: Hero Image -->
            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1581403341630-a6e0b9d2d257?w=800&q=80&fit=crop&crop=faces"
                     alt="Indian influencer with shopping bag" />
            </div>
        </div>
    </section>

    <!-- ==============================
         STATS STRIP
         ============================== -->
    <section class="stats-strip">
        <div class="stats-inner">
            <div class="stat-item">
                <div class="stat-num purple">850+</div>
                <div class="stat-desc">Verified Influencers</div>
            </div>
            <div class="stat-item">
                <div class="stat-num magenta">400+</div>
                <div class="stat-desc">Active Advertisers</div>
            </div>
            <div class="stat-item">
                <div class="stat-num teal">12K+</div>
                <div class="stat-desc">Campaigns Delivered</div>
            </div>
            <div class="stat-item">
                <div class="stat-num" style="color:#1A1A2E;">&#8377;50M+</div>
                <div class="stat-desc">Creator Earnings</div>
            </div>
        </div>
    </section>

    <!-- ==============================
         HOW INFLUISH WORKS
         ============================== -->
    <section style="background:#fff; padding: 80px 0;">
        <div class="how-section">
            <h2 class="section-title">How Influish Works</h2>
            <p class="section-sub">Streamlined collaboration from discovery to payment. We handle the complexity so you can focus on creating impact.</p>

            <div class="steps-grid">
                <!-- Step 1 -->
                <div class="step-item">
                    <div class="step-icon-wrap" style="background: var(--purple-light);">
                        <span style="font-size:26px;">🔍</span>
                        <div class="step-num">1</div>
                    </div>
                    <h3 class="step-title">Discover &amp; Connect</h3>
                    <p class="step-desc">Brands search our curated marketplace to find influencers that align perfectly with their target audience and niche.</p>
                </div>

                <!-- Step 2 -->
                <div class="step-item">
                    <div class="step-icon-wrap" style="background: #FDF2F8;">
                        <span style="font-size:26px;">🤝</span>
                        <div class="step-num" style="background: #EC4899;">2</div>
                    </div>
                    <h3 class="step-title">Collaborate &amp; Create</h3>
                    <p class="step-desc">Negotiate terms seamlessly on platform. Creators produce authentic content based on clear campaign briefs.</p>
                </div>

                <!-- Step 3 -->
                <div class="step-item">
                    <div class="step-icon-wrap" style="background: #E0F2FE;">
                        <span style="font-size:26px;">💰</span>
                        <div class="step-num teal-num">3</div>
                    </div>
                    <h3 class="step-title">Publish &amp; Earn</h3>
                    <p class="step-desc">Content goes live, performance is tracked, and secure payments are released automatically upon completion.</p>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
