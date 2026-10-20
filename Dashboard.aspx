<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Influish Influencer Dashboard — overview of your activity, stats and recommended campaigns." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <h1>Welcome back, Riddhi 👋</h1>
        <p>Here's an overview of your influencer activity.</p>
    </div>

    <!-- Stat Cards -->
    <div class="stat-cards-grid">
        <div class="stat-card">
            <div class="stat-info">
                <div class="stat-label">Applications Sent</div>
                <div class="stat-value">8</div>
            </div>
            <div class="stat-icon stat-icon-blue">▶</div>
        </div>
        <div class="stat-card">
            <div class="stat-info">
                <div class="stat-label">Accepted</div>
                <div class="stat-value">3</div>
            </div>
            <div class="stat-icon stat-icon-green">✔</div>
        </div>
        <div class="stat-card">
            <div class="stat-info">
                <div class="stat-label">Pending</div>
                <div class="stat-value">4</div>
            </div>
            <div class="stat-icon stat-icon-orange">⏳</div>
        </div>
    </div>

    <!-- Recommended Campaigns Header -->
    <div class="section-header">
        <h2>Recommended Campaigns</h2>
        <div style="display:flex; gap:10px;">
            <button class="btn btn-outline btn-sm" id="btnFilters">⚙ Filters</button>
            <button class="btn btn-outline btn-sm" id="btnSort">Sort by: Match ▾</button>
        </div>
    </div>

    <!-- Campaigns Grid -->
    <div class="campaigns-grid">

        <!-- Campaign 1 -->
        <a href="~/CampaignDetails.aspx?id=1" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1588702547923-7093a6c3ba33?w=600&q=80&fit=crop" alt="TechNova Solutions" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Tech</span>
                <h3 class="campaign-title">TechNova Solutions</h3>
                <p class="campaign-desc">Seeking tech influencers to review our latest productivity suite. Must have...</p>
                <div class="campaign-meta">
                    <div class="campaign-budget">
                        <div class="meta-label">Budget</div>
                        <div class="meta-value">&#8377;10,000</div>
                    </div>
                    <div class="campaign-followers">
                        <div class="meta-label">Follower Req.</div>
                        <div class="meta-value">👥 10k+</div>
                    </div>
                </div>
            </div>
        </a>

        <!-- Campaign 2 -->
        <a href="~/CampaignDetails.aspx?id=2" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1551816230-ef5deaed4a26?w=600&q=80&fit=crop" alt="NexGen Audio" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Tech</span>
                <h3 class="campaign-title">NexGen Audio</h3>
                <p class="campaign-desc">Looking for audiophiles and tech reviewers for our new wireless earbuds</p>
                <div class="campaign-meta">
                    <div class="campaign-budget">
                        <div class="meta-label">Budget</div>
                        <div class="meta-value">&#8377;15,000</div>
                    </div>
                    <div class="campaign-followers">
                        <div class="meta-label">Follower Req.</div>
                        <div class="meta-value">👥 25k+</div>
                    </div>
                </div>
            </div>
        </a>

        <!-- Campaign 3 -->
        <a href="~/CampaignDetails.aspx?id=3" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=600&q=80&fit=crop" alt="CloudSync Pro" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Software</span>
                <h3 class="campaign-title">CloudSync Pro</h3>
                <p class="campaign-desc">B2B campaign aimed at developers and IT professionals. Share your workflow...</p>
                <div class="campaign-meta">
                    <div class="campaign-budget">
                        <div class="meta-label">Budget</div>
                        <div class="meta-value">&#8377;20,000</div>
                    </div>
                    <div class="campaign-followers">
                        <div class="meta-label">Follower Req.</div>
                        <div class="meta-value">👥 15k+</div>
                    </div>
                </div>
            </div>
        </a>

        <!-- Campaign 4 -->
        <a href="~/CampaignDetails.aspx?id=4" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600&q=80&fit=crop" alt="CodeCraft AI" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Tech</span>
                <h3 class="campaign-title">CodeCraft AI</h3>
                <p class="campaign-desc">Promote our new AI coding assistant tool to your audience of software...</p>
                <div class="campaign-meta">
                    <div class="campaign-budget">
                        <div class="meta-label">Budget</div>
                        <div class="meta-value">&#8377;12,500</div>
                    </div>
                    <div class="campaign-followers">
                        <div class="meta-label">Follower Req.</div>
                        <div class="meta-value">👥 10k+</div>
                    </div>
                </div>
            </div>
        </a>

        <!-- Campaign 5 -->
        <a href="~/CampaignDetails.aspx?id=5" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80&fit=crop" alt="FitTrack Pro" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Gadgets</span>
                <h3 class="campaign-title">FitTrack Pro</h3>
                <p class="campaign-desc">Fitness and tech crossover campaign for our new premium smartwatch line.</p>
                <div class="campaign-meta">
                    <div class="campaign-budget">
                        <div class="meta-label">Budget</div>
                        <div class="meta-value">&#8377;8,000</div>
                    </div>
                    <div class="campaign-followers">
                        <div class="meta-label">Follower Req.</div>
                        <div class="meta-value">👥 5k+</div>
                    </div>
                </div>
            </div>
        </a>

        <!-- Campaign 6 -->
        <a href="~/CampaignDetails.aspx?id=6" runat="server" class="campaign-card">
            <div class="campaign-img-wrap">
                <img src="https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=600&q=80&fit=crop" alt="SecureNet Hub" />
                <span class="eligible-badge">✔ Eligible</span>
            </div>
            <div class="campaign-body">
                <span class="campaign-category">Cybersecurity</span>
                <h3 class="campaign-title">SecureNet Hub</h3>
                <p class="campaign-desc">Educational campaign focusing on online security best practices using our...</p>
                <div class="campaign-meta">
                    <div class="campaign-budget">
                        <div class="meta-label">Budget</div>
                        <div class="meta-value">&#8377;18,000</div>
                    </div>
                    <div class="campaign-followers">
                        <div class="meta-label">Follower Req.</div>
                        <div class="meta-value">👥 50k+</div>
                    </div>
                </div>
            </div>
        </a>

    </div><!-- /campaigns-grid -->

</asp:Content>
