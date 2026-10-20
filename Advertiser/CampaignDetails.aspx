<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CampaignDetails.aspx.cs" Inherits="Influish_net.Advertiser.CampaignDetails" MasterPageFile="~/Advertiser/AdvertiserMaster.master" Title="Campaign Applicants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb -->
    <div class="influish-breadcrumb">
        <a href="Dashboard.aspx">Dashboard</a>
        <span>/</span>
        <a href="MyCampaigns.aspx">Campaigns</a>
        <span>/</span>
        <span class="text-dark fw-medium"><asp:Literal ID="litBreadcrumbTitle" runat="server" Text="Smart Tech Product Promotion" /></span>
    </div>

    <!-- Page Header & Action -->
    <div class="page-header-row align-items-center">
        <div>
            <h1 class="page-title">Applicants List</h1>
            <p class="page-subtitle">
                Review and manage influencers who applied for 
                <strong class="text-dark"><asp:Label ID="lblTitle" runat="server" Text="Smart Tech Product Promotion" /></strong>
            </p>
        </div>
        <div class="d-flex align-items-center gap-2">
            <asp:Button ID="btnEdit" runat="server" Text="Edit Campaign" CssClass="btn-influish-secondary" OnClick="btnEdit_Click" />
            <asp:Button ID="btnBack" runat="server" Text="Back to Campaigns" CssClass="btn-influish-secondary" OnClick="btnBack_Click" />
        </div>
    </div>

    <!-- Campaign Quick Info Banner -->
    <div class="influish-card p-3 mb-4" style="background:#FDFBFF; border-color:#EDE9FE;">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-3">
                <span class="category-tag" style="background:#EDE9FE; color:#7C3AED; font-weight:600;">
                    <asp:Label ID="lblCategory" runat="server" Text="Tech & Gadgets" />
                </span>
                <span class="text-secondary small">
                    Budget: <strong class="text-dark"><asp:Label ID="lblBudget" runat="server" Text="₹10,000" /></strong>
                </span>
            </div>
            <p class="text-secondary small mb-0" style="max-width: 600px;">
                <asp:Label ID="lblDescription" runat="server" Text="Campaign goals and deliverables for selected influencers." />
            </p>
        </div>
    </div>

    <!-- 4 Stat Summary Cards (Figma Page 21) -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-card p-3">
                <span class="stat-item-label">TOTAL APPLIED</span>
                <div class="stat-value" style="font-size:26px;">
                    <asp:Label ID="lblTotalApplied" runat="server" Text="14" />
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card p-3">
                <span class="stat-item-label">PENDING</span>
                <div class="stat-value text-warning" style="font-size:26px; color:#D97706 !important;">
                    <asp:Label ID="lblCountPending" runat="server" Text="8" />
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card p-3">
                <span class="stat-item-label">ACCEPTED</span>
                <div class="stat-value text-success" style="font-size:26px; color:#059669 !important;">
                    <asp:Label ID="lblCountAccepted" runat="server" Text="4" />
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card p-3">
                <span class="stat-item-label">REJECTED</span>
                <div class="stat-value text-danger" style="font-size:26px; color:#DC2626 !important;">
                    <asp:Label ID="lblCountRejected" runat="server" Text="2" />
                </div>
            </div>
        </div>
    </div>

    <!-- Applicants Table Card -->
    <div class="influish-card p-0">
        <!-- Table Filter Bar -->
        <div class="d-flex align-items-center justify-content-between p-3 border-bottom flex-wrap gap-2">
            <div class="d-flex align-items-center gap-2">
                <span class="fw-bold" style="font-size:15px;">Influencer Applications</span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" 
                    CssClass="influish-select py-1 px-3" style="font-size:13px; width:auto;">
                    <asp:ListItem Value="All" Text="All Status" />
                    <asp:ListItem Value="Pending" Text="Pending" />
                    <asp:ListItem Value="Accepted" Text="Accepted" />
                    <asp:ListItem Value="Rejected" Text="Rejected" />
                </asp:DropDownList>

                <asp:DropDownList ID="ddlSortFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSortFilter_SelectedIndexChanged" 
                    CssClass="influish-select py-1 px-3" style="font-size:13px; width:auto;">
                    <asp:ListItem Value="FollowersDesc" Text="Sort by Followers (High - Low)" />
                    <asp:ListItem Value="FollowersAsc" Text="Sort by Followers (Low - High)" />
                    <asp:ListItem Value="DateDesc" Text="Sort by Date (Newest)" />
                </asp:DropDownList>
            </div>
        </div>

        <!-- GridView of Applicants -->
        <div class="table-responsive">
            <asp:GridView ID="gvApplicants" runat="server" AutoGenerateColumns="False" 
                CssClass="influish-table mb-0" GridLines="None" EmptyDataText="No applicants found for this filter.">
                <Columns>
                    <asp:TemplateField HeaderText="INFLUENCER">
                        <ItemTemplate>
                            <div class="d-flex align-items-center gap-3">
                                <div class="user-avatar" style="width:38px; height:38px; font-size:13px; background:linear-gradient(135deg, #A855F7, #EC4899);">
                                    <%# GetInitials(Eval("InfluencerName")) %>
                                </div>
                                <div>
                                    <span class="fw-bold text-dark d-block"><%# Eval("InfluencerName") %></span>
                                    <span class="text-muted small">@<%# Eval("InfluencerName").ToString().ToLower().Replace(" ", "") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="CATEGORY">
                        <ItemTemplate>
                            <span class="category-tag"><%# Eval("Category") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="FOLLOWERS">
                        <ItemTemplate>
                            <span class="fw-semibold text-dark"><%# FormatFollowerCount(Eval("FollowerCount")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="APPLIED DATE">
                        <ItemTemplate>
                            <span class="text-secondary small"><%# FormatAppliedDate(Eval("AppliedAt")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="STATUS">
                        <ItemTemplate>
                            <span class='status-badge <%# Eval("Status").ToString().ToLower() %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="ACTIONS">
                        <ItemTemplate>
                            <div class="d-flex align-items-center gap-2">
                                <asp:HyperLink ID="lnkProfile" runat="server" Text="View" 
                                    NavigateUrl='<%# String.Format("InfluencerProfile.aspx?id={0}&appId={1}&cid={2}", Eval("InfluencerID"), Eval("ApplicationID"), Request.QueryString["id"]) %>' 
                                    CssClass="btn btn-sm btn-outline-primary" style="border-radius:6px; font-size:12px; font-weight:600;" />

                                <asp:LinkButton ID="lnkAccept" runat="server" CommandName="Accept" CommandArgument='<%# Eval("ApplicationID") %>' 
                                    Text="Accept" OnClick="lnkAccept_Click" 
                                    Visible='<%# IsPending(Eval("Status")) %>'
                                    CssClass="btn btn-sm btn-success text-white" style="border-radius:6px; font-size:12px; font-weight:600;" />

                                <asp:LinkButton ID="lnkReject" runat="server" CommandName="Reject" CommandArgument='<%# Eval("ApplicationID") %>' 
                                    Text="Reject" OnClick="lnkReject_Click" 
                                    Visible='<%# IsPending(Eval("Status")) %>'
                                    CssClass="btn btn-sm btn-outline-danger" style="border-radius:6px; font-size:12px; font-weight:600;" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="p-3 border-top d-flex align-items-center justify-content-between text-secondary small">
            <div>
                Showing <asp:Literal ID="litShowingApplicants" runat="server" Text="1 to 4 of 4 applicants" />
            </div>
        </div>
    </div>
</asp:Content>