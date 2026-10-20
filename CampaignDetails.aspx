<%@ Page Title="Campaign Details" Language="VB" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="CampaignDetails.aspx.vb" Inherits="Influish_net.CampaignDetails" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="View campaign details and apply for brand collaborations on Influish." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="~/Campaigns.aspx" runat="server">Campaigns</a>
        <span class="breadcrumb-sep">›</span>
        <span>TechNova Solutions</span>
    </nav>

    <h1 style="font-size:26px;font-weight:800;color:var(--text-heading);margin-bottom:24px;">Smart Tech Product Promotion</h1>

    <div class="campaign-detail-layout">

        <!-- LEFT: Campaign Content -->
        <div>
            <!-- Hero Image -->
            <img src="https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=900&q=80&fit=crop"
                 alt="Smart Watch campaign"
                 class="campaign-hero-img" />

            <div class="card">
                <!-- Title + Category -->
                <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">
                    <div>
                        <h2 class="campaign-details-title">Smart Tech Product Promotion</h2>
                        <p class="campaign-by">By TechNova Solutions</p>
                    </div>
                    <span class="badge badge-purple">Tech</span>
                </div>

                <p class="campaign-details-desc">
                    We are launching our new flagship smart device and looking for tech-savvy creators to help us spread the word. This campaign involves creating unboxing and review content focusing on the innovative features and seamless integration into daily life.
                </p>

                <h3 class="campaign-section-title">Key Responsibilities</h3>
                <ul class="campaign-responsibilities">
                    <li>Create one 60-second dedicated review video (Reel/TikTok/Short).</li>
                    <li>Post 2 Instagram/Facebook stories with a swipe-up link to our product page.</li>
                    <li>Highlight key features: battery life, connectivity, and design.</li>
                </ul>
            </div>

            <!-- Campaign Requirements -->
            <div class="card" style="margin-top:16px;">
                <h3 class="campaign-section-title" style="margin-top:0;">Campaign Requirements</h3>
                <div class="requirement-grid">
                    <div class="requirement-item">
                        <span class="req-icon">👥</span>
                        <div>
                            <div class="req-label">Follower Count</div>
                            <div class="req-value">Min 10,000</div>
                        </div>
                    </div>
                    <div class="requirement-item">
                        <span class="req-icon">🎂</span>
                        <div>
                            <div class="req-label">Age Range</div>
                            <div class="req-value">18 – 30 years</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT: Apply Sidebar -->
        <div class="apply-card">
            <div class="card">
                <div class="apply-budget">Budget</div>
                <div class="apply-budget-val">&#8377;10,000</div>

                <div class="eligible-notice">
                    <span style="font-size:18px;">✅</span>
                    <div>
                        <strong>You're eligible!</strong><br />
                        <span style="font-size:13px;">Your profile meets all the requirements for this campaign.</span>
                    </div>
                </div>

                <asp:Button ID="btnApply" runat="server" Text="Apply Now"
                    CssClass="btn btn-primary btn-full btn-lg"
                    OnClick="btnApply_Click"
                    style="background: linear-gradient(135deg,#7C3AED 0%,#EC4899 100%); border-radius:10px; font-size:16px; font-weight:700;" />
            </div>

            <!-- About Advertiser -->
            <div class="card" style="margin-top:16px;">
                <h3 style="font-size:15px;font-weight:700;color:var(--text-heading);margin-bottom:14px;">About the Advertiser</h3>
                <div class="advertiser-brand">
                    <img src="https://ui-avatars.com/api/?name=TN&background=7C3AED&color=fff&size=44" alt="TechNova" style="border-radius:8px;" />
                    <div>
                        <div class="adv-name">TechNova Solutions</div>
                        <div class="adv-cat">Technology &amp; Electronics</div>
                    </div>
                </div>
                <p class="advertiser-desc">
                    TechNova Solutions is a leading innovator in smart consumer electronics, dedicated to creating devices that seamlessly integrate into and enhance everyday life through cutting-edge design and engineering.
                </p>
            </div>
        </div>

    </div>

</asp:Content>
