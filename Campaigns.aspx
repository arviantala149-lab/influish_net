<%@ Page Title="Campaigns" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Campaigns.aspx.cs" Inherits="Influish_net.Campaigns" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Browse all available campaigns on the Influish marketplace." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1>Campaigns</h1>
        <p>Discover and apply to brand campaigns that match your audience.</p>
    </div>

    <!-- Filters bar -->
    <div style="display:flex; gap:12px; margin-bottom:24px; flex-wrap:wrap; align-items:center;">
        <asp:TextBox ID="txtSearch" runat="server" placeholder="Search campaigns or brands..." CssClass="form-control" style="max-width:240px; border-radius:var(--radius-full);" />
        
        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" style="max-width:180px; border-radius:var(--radius-full);">
            <asp:ListItem Value="" Text="All Categories" />
        </asp:DropDownList>

        <asp:DropDownList ID="ddlBudget" runat="server" CssClass="form-control" style="max-width:180px; border-radius:var(--radius-full);">
            <asp:ListItem Value="" Text="All Budgets" />
            <asp:ListItem Value="5000" Text="Under ₹5,000" />
            <asp:ListItem Value="15000" Text="Under ₹15,000" />
            <asp:ListItem Value="50000" Text="Under ₹50,000" />
            <asp:ListItem Value="50001" Text="₹50,000+" />
        </asp:DropDownList>

        <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" CssClass="btn btn-purple-solid btn-sm" OnClick="btnFilter_Click" />
        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline btn-sm" OnClick="btnReset_Click" />
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
                                <div class="meta-label">Min Followers</div>
                                <div class="meta-value">👥 <%# FormatFollowers(Eval("MinFollowers")) %></div>
                            </div>
                        </div>
                    </div>
                </a>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlNoResults" runat="server" Visible="false" style="padding:48px 24px; text-align:center; background:#fff; border-radius:12px; border:1px solid #E5E7EB; margin-top:16px;">
        <div style="font-size:40px; margin-bottom:12px;">🔍</div>
        <h3 style="font-size:18px; color:var(--text-heading); font-weight:700;">No matching campaigns found</h3>
        <p style="color:var(--text-muted); font-size:14px;">Try clearing filters or search with different keywords.</p>
    </asp:Panel>

</asp:Content>
