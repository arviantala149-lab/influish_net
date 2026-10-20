<%@ Page Title="For Influencers" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForInfluencers.aspx.vb" Inherits="Influish_net.ForInfluencers" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Join India's fastest-growing creator marketplace. Connect with premium brands, negotiate seamlessly, and get paid securely — all in one place." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ==============================
         HERO SECTION
         ============================== -->
    <section style="background: #F8F7FF;">
        <div class="hero-section">
            <!-- Left -->
            <div class="hero-left">
                <div class="hero-badge">
                    <span class="dot" style="background: var(--purple-primary);"></span>
                    Turn Your Influence Into Income
                </div>
                <h1 class="hero-title" style="font-size: 42px;">
                    Elevate Your Creator<br />
                    Career with<br />
                    Premium Brands
                </h1>
                <p class="hero-desc">
                    Join India's fastest-growing creator marketplace. Connect with top-tier advertisers, negotiate seamlessly, and get paid securely — all in one place.
                </p>
                <div class="hero-actions">
                    <a href="~/Signup.aspx" runat="server" class="btn btn-primary btn-lg">Get Started Free</a>
                </div>
            </div>

            <!-- Right: Influencer image -->
            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1617469767053-d3b523a0b982?w=800&q=80&fit=crop&crop=faces"
                     alt="Creator recording content" />
            </div>
        </div>
    </section>

    <!-- ==============================
         WHY CREATORS CHOOSE INFLUISH
         ============================== -->
    <section style="background: #fff; padding: 80px 0;">
        <div style="max-width: 1200px; margin: 0 auto; padding: 0 32px;">
            <h2 class="section-title">Why Creators Choose Influish</h2>
            <p class="section-sub">We provide the tools, network, and security you need to focus on what you do best: creating amazing content.</p>

            <div class="feature-cards-grid">
                <!-- Card 1 -->
                <div class="feature-card">
                    <div class="feature-icon">📢</div>
                    <h3 class="feature-title">Premium Brand Deals</h3>
                    <p class="feature-desc">Access a curated marketplace of top-tier brands looking for authentic voices in your specific niche.</p>
                </div>

                <!-- Card 2 -->
                <div class="feature-card">
                    <div class="feature-icon">💳</div>
                    <h3 class="feature-title">Guaranteed Payments</h3>
                    <p class="feature-desc">Say goodbye to chasing invoices. Funds are held in escrow and released automatically upon milestone completion.</p>
                </div>

                <!-- Card 3 -->
                <div class="feature-card">
                    <div class="feature-icon">📊</div>
                    <h3 class="feature-title">Audience Insights</h3>
                    <p class="feature-desc">Showcase your true value with verified analytics that help brands understand your impact and engagement rates.</p>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
