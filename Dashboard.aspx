<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Influish_net.Dashboard" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Influish Influencer Dashboard — overview of your activity, stats and recommended campaigns." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <h1>Welcome back, <asp:Literal ID="litCreatorName" runat="server" Text="Creator" /></h1>
        <p>Here's an overview of your influencer activity and brand collaborations.</p>
    </div>

    <!-- Stat Cards -->
    <div class="stat-cards-grid">
        <div class="stat-card">
            <div class="stat-info">
                <div class="stat-label">Applications Sent</div>
                <div class="stat-value"><asp:Literal ID="litSentCount" runat="server" Text="0" /></div>
            </div>
            <div class="stat-icon stat-icon-blue">▶</div>
        </div>
        <div class="stat-card">
            <div class="stat-info">
                <div class="stat-label">Accepted</div>
                <div class="stat-value"><asp:Literal ID="litAcceptedCount" runat="server" Text="0" /></div>
            </div>
            <div class="stat-icon stat-icon-green">✔</div>
        </div>
        <div class="stat-card">
            <div class="stat-info">
                <div class="stat-label">Pending</div>
                <div class="stat-value"><asp:Literal ID="litPendingCount" runat="server" Text="0" /></div>
            </div>
            <div class="stat-icon stat-icon-orange">⏳</div>
        </div>
    </div>

    <!-- Recommended Campaigns Header -->
    <div class="section-header" style="margin-top:32px;">
        <h2>Recommended Campaigns</h2>
        <div style="display:flex; gap:10px; align-items:center;">
            <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlCategoryFilter_SelectedIndexChanged" style="max-width:180px; border-radius:99px; height:38px;">
                <asp:ListItem Value="All" Text="All Categories" />
            </asp:DropDownList>
            <a href="Campaigns.aspx" class="btn btn-outline btn-sm">Explore All ➔</a>
        </div>
    </div>

    <!-- Campaigns Grid -->
    <div class="campaigns-grid">
        <asp:Repeater ID="rptCampaigns" runat="server">
            <ItemTemplate>
                <a href='<%# "CampaignDetails.aspx?id=" + Eval("CampaignID") %>' class="campaign-card">
                    <div class="campaign-img-wrap">
                        <img src='<%# GetCampaignImage(Eval("Category"), Eval("CampaignID")) %>' alt='<%# Eval("Title") %>' />
                        <span class="eligible-badge"><%# GetEligibilityBadge(Eval("MinFollowers")) %></span>
                    </div>
                    <div class="campaign-body">
                        <span class="campaign-category"><%# Eval("Category") %></span>
                        <h3 class="campaign-title"><%# Eval("Title") %></h3>
                        <p class="campaign-desc"><%# Eval("Description") %></p>
                        <div class="campaign-meta">
                            <div class="campaign-budget">
                                <div class="meta-label">Budget</div>
                                <div class="meta-value"><%# FormatBudget(Eval("Budget")) %></div>
                            </div>
                            <div class="campaign-followers">
                                <div class="meta-label">Follower Req.</div>
                                <div class="meta-value">👥 <%# FormatFollowers(Eval("MinFollowers")) %></div>
                            </div>
                        </div>
                    </div>
                </a>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlNoCampaigns" runat="server" Visible="false" style="padding:40px; text-align:center; background:#fff; border-radius:12px; margin-top:20px; border:1px solid #E5E7EB;">
        <div style="font-size:36px; margin-bottom:12px;">📢</div>
        <h3 style="font-size:18px; color:var(--text-heading); font-weight:700;">No campaigns found in this category</h3>
        <p style="color:var(--text-muted); font-size:14px;">Try selecting "All Categories" to view active opportunities.</p>
    </asp:Panel>

</asp:Content>
