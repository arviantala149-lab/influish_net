<%@ Page Title="Campaigns" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Browse all available campaigns on the Influish marketplace." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1>Campaigns</h1>
        <p>Discover and apply to brand campaigns that match your audience.</p>
    </div>

    <!-- Filters bar -->
    <div style="display:flex; gap:10px; margin-bottom:24px; flex-wrap:wrap; align-items:center;">
        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" style="max-width:180px; border-radius:var(--radius-full);">
            <asp:ListItem Value="">All Categories</asp:ListItem>
            <asp:ListItem Value="Tech">Tech</asp:ListItem>
            <asp:ListItem Value="Fashion">Fashion</asp:ListItem>
            <asp:ListItem Value="Food">Food</asp:ListItem>
            <asp:ListItem Value="Fitness">Fitness</asp:ListItem>
            <asp:ListItem Value="Beauty">Beauty</asp:ListItem>
        </asp:DropDownList>
        <asp:DropDownList ID="ddlBudget" runat="server" CssClass="form-control" style="max-width:180px; border-radius:var(--radius-full);">
            <asp:ListItem Value="">All Budgets</asp:ListItem>
            <asp:ListItem Value="5000">Under ₹5,000</asp:ListItem>
            <asp:ListItem Value="15000">₹5,000 – ₹15,000</asp:ListItem>
            <asp:ListItem Value="50000">₹15,000 – ₹50,000</asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" CssClass="btn btn-purple-solid btn-sm" />
    </div>

    <!-- Campaigns Grid -->
    <div class="campaigns-grid">

        <a href="~/CampaignDetails.aspx?id=1" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&q=80&fit=crop" alt="Smart Tech" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Tech</span>
                <h3 class="campaign-title">Smart Tech Product Promotion</h3>
                <p class="campaign-desc">Seeking tech-savvy creators to review our flagship smartwatch line.</p>
                <div class="campaign-meta">
                    <div class="campaign-budget"><div class="meta-label">Budget</div><div class="meta-value">&#8377;10,000</div></div>
                    <div class="campaign-followers"><div class="meta-label">Min Followers</div><div class="meta-value">👥 10k+</div></div>
                </div>
            </div>
        </a>

        <a href="~/CampaignDetails.aspx?id=2" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=600&q=80&fit=crop" alt="Fashion" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Fashion</span>
                <h3 class="campaign-title">Diwali Festive Wear Launch</h3>
                <p class="campaign-desc">Promote our exclusive Diwali collection through authentic lifestyle content.</p>
                <div class="campaign-meta">
                    <div class="campaign-budget"><div class="meta-label">Budget</div><div class="meta-value">&#8377;15,000</div></div>
                    <div class="campaign-followers"><div class="meta-label">Min Followers</div><div class="meta-value">👥 25k+</div></div>
                </div>
            </div>
        </a>

        <a href="~/CampaignDetails.aspx?id=3" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=600&q=80&fit=crop" alt="Fitness" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Fitness</span>
                <h3 class="campaign-title">Summer Skincare Routine Series</h3>
                <p class="campaign-desc">Partner with GlowCare to showcase a daily skincare routine using our products.</p>
                <div class="campaign-meta">
                    <div class="campaign-budget"><div class="meta-label">Budget</div><div class="meta-value">&#8377;22,500</div></div>
                    <div class="campaign-followers"><div class="meta-label">Min Followers</div><div class="meta-value">👥 15k+</div></div>
                </div>
            </div>
        </a>

        <a href="~/CampaignDetails.aspx?id=4" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80&fit=crop" alt="Food" />
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Food</span>
                <h3 class="campaign-title">Weekend Foodie Reels</h3>
                <p class="campaign-desc">Create fun and engaging Reels showcasing your weekend dining experience.</p>
                <div class="campaign-meta">
                    <div class="campaign-budget"><div class="meta-label">Budget</div><div class="meta-value">&#8377;12,000</div></div>
                    <div class="campaign-followers"><div class="meta-label">Min Followers</div><div class="meta-value">👥 5k+</div></div>
                </div>
            </div>
        </a>

        <a href="~/CampaignDetails.aspx?id=5" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80&fit=crop" alt="Audio" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Tech</span>
                <h3 class="campaign-title">NexGen Audio Launch</h3>
                <p class="campaign-desc">Review our new premium wireless earbuds for audiophiles and tech enthusiasts.</p>
                <div class="campaign-meta">
                    <div class="campaign-budget"><div class="meta-label">Budget</div><div class="meta-value">&#8377;8,000</div></div>
                    <div class="campaign-followers"><div class="meta-label">Min Followers</div><div class="meta-value">👥 10k+</div></div>
                </div>
            </div>
        </a>

        <a href="~/CampaignDetails.aspx?id=6" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1601397922721-4326b5a5b741?w=600&q=80&fit=crop" alt="Beauty" />
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Beauty</span>
                <h3 class="campaign-title">Glow-Up Challenge</h3>
                <p class="campaign-desc">Share your before &amp; after transformation using our new premium beauty range.</p>
                <div class="campaign-meta">
                    <div class="campaign-budget"><div class="meta-label">Budget</div><div class="meta-value">&#8377;18,000</div></div>
                    <div class="campaign-followers"><div class="meta-label">Min Followers</div><div class="meta-value">👥 20k+</div></div>
                </div>
            </div>
        </a>

    </div>

</asp:Content>
