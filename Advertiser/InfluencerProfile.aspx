<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InfluencerProfile.aspx.cs" Inherits="Influish_net.Advertiser.InfluencerProfile" MasterPageFile="~/Site.Master" Title="Applicant Review" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb -->
    <div class="influish-breadcrumb">
        <a href="Dashboard.aspx">Dashboard</a>
        <span>/</span>
        <asp:HyperLink ID="lnkBreadcrumbCampaign" runat="server" NavigateUrl="MyCampaigns.aspx" Text="Campaigns" />
        <span>/</span>
        <span class="text-dark fw-medium">Applicant Review</span>
    </div>

    <!-- Status Notice -->
    <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="mb-3">
        <div class="alert alert-success d-flex align-items-center" role="alert">
            <asp:Label ID="lblNotice" runat="server" />
        </div>
    </asp:Panel>

    <!-- Top Influencer Profile Card (Figma Page 23) -->
    <div class="influish-card mb-4" style="max-width: 900px;">
        <div class="d-flex flex-wrap align-items-start gap-4">
            <!-- Avatar -->
            <div class="user-avatar" style="width: 80px; height: 80px; font-size: 26px; border-radius: 16px; background: linear-gradient(135deg, #8B5CF6, #EC4899); box-shadow: 0 4px 12px rgba(139, 92, 246, 0.25);">
                <asp:Literal ID="litAvatarInitials" runat="server" Text="MN" />
            </div>

            <!-- Details -->
            <div class="flex-grow-1">
                <div class="d-flex align-items-center gap-3 flex-wrap mb-1">
                    <h2 class="card-title" style="font-size: 22px;">
                        <asp:Label ID="lblName" runat="server" Text="Mer Nensi" />
                    </h2>
                    <span class="category-tag" style="background:#EDE9FE; color:#7C3AED; font-weight:600;">
                        <asp:Label ID="lblCategory" runat="server" Text="Technology" />
                    </span>
                </div>

                <div class="text-secondary small mb-3">
                    <asp:Label ID="lblSocial" runat="server" Text="@mernensi" />
                </div>

                <div class="d-flex align-items-center gap-4 mb-4">
                    <div>
                        <div class="stat-item-label">FOLLOWERS</div>
                        <div class="fw-bold fs-5 text-dark">
                            <asp:Label ID="lblFollowers" runat="server" Text="18,500" />
                        </div>
                    </div>
                    <div style="border-left: 1px solid var(--border-color); height: 32px;"></div>
                    <div>
                        <div class="stat-item-label">AGE</div>
                        <div class="fw-bold fs-5 text-dark">
                            <asp:Label ID="lblAge" runat="server" Text="21" />
                        </div>
                    </div>
                </div>

                <div>
                    <div class="stat-item-label mb-1">ABOUT</div>
                    <p class="text-secondary small mb-0" style="line-height: 1.6;">
                        <asp:Label ID="lblBio" runat="server" Text="Tech enthusiast and gadget reviewer. I specialize in breaking down complex smart home products and consumer tech into easy-to-understand content for millennials and Gen Z. Passionate about AI, wearables, and sustainable tech solutions." />
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bottom Two Columns: Details & Actions -->
    <div class="row g-4" style="max-width: 900px;">
        <!-- Left: Application & Contact Details -->
        <div class="col-md-7">
            <!-- Application Details Card -->
            <div class="influish-card mb-3">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="16" y1="13" x2="8" y2="13"></line>
                        <line x1="16" y1="17" x2="8" y2="17"></line>
                        <polyline points="10 9 9 9 8 9"></polyline>
                    </svg>
                    <h4 class="card-title" style="font-size: 15px;">Application Details</h4>
                </div>
                <div class="mb-2">
                    <span class="text-secondary small d-block">Applying for Campaign</span>
                    <strong class="text-dark small">
                        <asp:Label ID="lblCampaignTitle" runat="server" Text="Smart Tech Product Promotion" />
                    </strong>
                </div>
                <div>
                    <span class="text-secondary small d-block">Applied</span>
                    <span class="text-dark small">
                        <asp:Label ID="lblAppliedDate" runat="server" Text="Oct 24, 2024" />
                    </span>
                </div>
            </div>

            <!-- Contact Information Card -->
            <div class="influish-card">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                        <polyline points="22,6 12,13 2,6"></polyline>
                    </svg>
                    <h4 class="card-title" style="font-size: 15px;">Contact Information</h4>
                </div>
                <div>
                    <span class="text-secondary small d-block">Email Address</span>
                    <span class="text-dark small fw-medium">
                        <asp:Label ID="lblEmail" runat="server" Text="contact@mernensi.tech" />
                    </span>
                </div>
            </div>
        </div>

        <!-- Right: Review Action Card (Figma Page 23) -->
        <div class="col-md-5">
            <div class="influish-card">
                <h4 class="card-title mb-3" style="font-size: 15px;">Review Action</h4>
                <p class="text-secondary small mb-3">
                    Choose whether to approve this influencer for the campaign or reject their application.
                </p>

                <div class="d-grid gap-2">
                    <asp:LinkButton ID="btnAccept" runat="server" CssClass="btn-influish-primary justify-content-center" OnClick="btnAccept_Click">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        <span>Accept Application</span>
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnReject" runat="server" CssClass="btn btn-outline-danger d-inline-flex align-items-center justify-content-center gap-2 py-2" style="border-radius:10px; font-weight:600; font-size:14px;" OnClick="btnReject_Click">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                        <span>Reject Application</span>
                    </asp:LinkButton>

                    <asp:Button ID="btnBack" runat="server" Text="Back to Applicants" CssClass="btn-influish-secondary justify-content-center mt-2" OnClick="btnBack_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>