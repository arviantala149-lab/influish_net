<%@ Page Title="About Us" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.vb" Inherits="Influish_net.About" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Learn about Influish's mission to democratize influence and empower the creator economy in India." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ==============================
         ABOUT HERO
         ============================== -->
    <section style="background: #F8F7FF; padding: 80px 32px 60px;">
        <div style="max-width: 720px; margin: 0 auto; text-align: center;">
            <h1 style="font-size: 42px; font-weight: 900; color: var(--text-heading); line-height: 1.2; margin-bottom: 20px;">
                Empowering the<br />
                <span style="color: var(--purple-primary);">Creator Economy</span>
            </h1>
            <p style="font-size: 16px; color: var(--text-muted); line-height: 1.7; max-width: 600px; margin: 0 auto;">
                We believe in the power of authentic voices. Influish was built to bridge the gap between visionary brands and creative talent, making collaboration effortless, transparent, and impactful.
            </p>
        </div>
    </section>

    <!-- ==============================
         TEAM PHOTO
         ============================== -->
    <section style="background: #F8F7FF; padding: 0 32px 60px;">
        <div style="max-width: 1100px; margin: 0 auto; border: 1px solid var(--border-color); border-radius: var(--radius-lg); overflow: hidden; background: #fff;">
            <img src="https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=1200&q=80&fit=crop"
                 alt="Influish team collaborating"
                 style="width: 100%; height: 420px; object-fit: cover;" />
        </div>
    </section>

    <!-- ==============================
         MISSION & VISION
         ============================== -->
    <section class="bg-section">
        <div class="bg-section-inner">
            <div class="mv-grid">
                <!-- Mission -->
                <div class="mv-card light">
                    <div class="mv-icon" style="color: var(--purple-primary);">🚩</div>
                    <h2 class="mv-title">Our Mission</h2>
                    <p class="mv-desc">
                        To democratize influence by providing a level playing field where creators of all sizes can discover meaningful partnerships, and brands can find the perfect authentic voice to amplify their message.
                    </p>
                </div>
                <!-- Vision -->
                <div class="mv-card dark">
                    <div class="mv-icon">👁️</div>
                    <h2 class="mv-title">Our Vision</h2>
                    <p class="mv-desc">
                        A world where creative expression is sustainably valued, and every brand story is told through genuine, trusted connections that resonate with audiences globally.
                    </p>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
