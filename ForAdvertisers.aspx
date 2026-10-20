<%@ Page Title="For Advertisers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Find the perfect influencer for your brand campaign on Influish — India's #1 Creator Marketplace." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero -->
    <section style="background: #F8F7FF;">
        <div class="hero-section">
            <div class="hero-left">
                <div class="hero-badge">
                    <span class="dot" style="background:#EC4899;"></span>
                    Built for Brands &amp; Marketers
                </div>
                <h1 class="hero-title" style="font-size:42px;">
                    Find Your Brand's<br />
                    <span class="gradient-text">Perfect Voice</span>
                </h1>
                <p class="hero-desc">
                    Access India's largest curated network of verified creators. Launch, manage, and track campaigns with complete transparency from discovery to payment.
                </p>
                <div class="hero-actions">
                    <a href="~/Signup.aspx?role=advertiser" runat="server" class="btn btn-primary btn-lg">Start a Campaign</a>
                </div>
            </div>
            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1553877522-43269d4ea984?w=800&q=80&fit=crop"
                     alt="Marketing team at work" />
            </div>
        </div>
    </section>

    <!-- Why Advertisers Choose Influish -->
    <section style="background: #fff; padding: 80px 0;">
        <div style="max-width: 1200px; margin: 0 auto; padding: 0 32px;">
            <h2 class="section-title">Why Advertisers Choose Influish</h2>
            <p class="section-sub">From discovery to payment, we make influencer marketing simple, transparent, and results-driven.</p>

            <div class="feature-cards-grid">
                <div class="feature-card">
                    <div class="feature-icon">🔍</div>
                    <h3 class="feature-title">Smart Discovery Engine</h3>
                    <p class="feature-desc">AI-powered matching finds creators who align with your brand values, audience demographics, and campaign goals.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">📊</div>
                    <h3 class="feature-title">Real-Time Analytics</h3>
                    <p class="feature-desc">Track campaign performance, reach, engagement, and ROI in real-time with our comprehensive analytics dashboard.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔒</div>
                    <h3 class="feature-title">Escrow Payments</h3>
                    <p class="feature-desc">Funds are held securely and only released when content is delivered and approved, protecting both parties.</p>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
