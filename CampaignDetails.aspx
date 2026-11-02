<%@ Page Title="Campaign Details" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="CampaignDetails.aspx.cs" Inherits="Influish_net.CampaignDetails" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="View campaign details and apply for brand collaborations on Influish." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="Campaigns.aspx">Campaigns</a>
        <span class="breadcrumb-sep">›</span>
        <span><asp:Literal ID="litBreadcrumbAdv" runat="server" Text="Brand" /></span>
    </nav>

    <h1 style="font-size:26px;font-weight:800;color:var(--text-heading);margin-bottom:24px;">
        <asp:Literal ID="litPageTitle" runat="server" Text="Campaign Details" />
    </h1>

    <div class="campaign-detail-layout">

        <!-- LEFT: Campaign Content -->
        <div>
            <!-- Hero Image -->
            <asp:Image ID="imgHero" runat="server" CssClass="campaign-hero-img" ImageUrl="https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=900&q=80&fit=crop" AlternateText="Campaign banner" />

            <div class="card">
                <!-- Title + Category -->
                <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">
                    <div>
                        <h2 class="campaign-details-title"><asp:Literal ID="litDetailsTitle" runat="server" /></h2>
                        <p class="campaign-by">By <asp:Literal ID="litCampaignBy" runat="server" /></p>
                    </div>
                    <span class="badge badge-purple"><asp:Literal ID="litCategoryBadge" runat="server" /></span>
                </div>

                <p class="campaign-details-desc">
                    <asp:Literal ID="litDescription" runat="server" />
                </p>

                <h3 class="campaign-section-title">Key Responsibilities &amp; Deliverables</h3>
                <ul class="campaign-responsibilities">
                    <asp:Repeater ID="rptDeliverables" runat="server">
                        <ItemTemplate>
                            <li><strong><%# Eval("Platform") %>:</strong> <%# Eval("Quantity") %>x <%# Eval("DeliverableType") %> — <%# Eval("Instructions") %></li>
                        </ItemTemplate>
                    </asp:Repeater>
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
                            <div class="req-value"><asp:Literal ID="litMinFollowers" runat="server" /></div>
                        </div>
                    </div>
                    <div class="requirement-item">
                        <span class="req-icon">🎂</span>
                        <div>
                            <div class="req-label">Age Range</div>
                            <div class="req-value"><asp:Literal ID="litAgeRange" runat="server" /></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT: Apply Sidebar -->
        <div class="apply-card">
            <div class="card">
                <div class="apply-budget">Budget</div>
                <div class="apply-budget-val"><asp:Literal ID="litBudget" runat="server" Text="₹0" /></div>

                <!-- Eligibility status -->
                <asp:Panel ID="pnlEligible" runat="server" CssClass="eligible-notice">
                    <span style="font-size:18px;">✅</span>
                    <div>
                        <strong>You're eligible!</strong><br />
                        <span style="font-size:13px;">Your profile meets the follower requirements for this campaign.</span>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlNotEligible" runat="server" Visible="false" CssClass="eligible-notice" style="background:#FEF3C7; color:#92400E; border:1px solid #FCD34D;">
                    <span style="font-size:18px;">ℹ️</span>
                    <div>
                        <strong>Audience Notice</strong><br />
                        <span style="font-size:13px;">Campaign requests higher follower reach, but you may still submit your proposal.</span>
                    </div>
                </asp:Panel>

                <!-- Already Applied Panel -->
                <asp:Panel ID="pnlAlreadyApplied" runat="server" Visible="false" style="background:#ECFDF5; border:1px solid #A7F3D0; border-radius:10px; padding:16px; margin:16px 0; text-align:center;">
                    <div style="font-size:24px; margin-bottom:6px;">📋</div>
                    <h4 style="font-size:15px; font-weight:700; color:#065F46; margin:0 0 4px 0;">Application Submitted</h4>
                    <p style="font-size:13px; color:#047857; margin:0 0 10px 0;">
                        Status: <strong style="text-transform:uppercase;"><asp:Literal ID="litAppliedStatus" runat="server" /></strong><br />
                        <asp:Literal ID="litAppliedDate" runat="server" />
                    </p>
                    <a href="Applications.aspx" class="btn btn-outline btn-sm btn-full" style="background:#fff;">View in My Applications</a>
                </asp:Panel>

                <!-- Application Form -->
                <asp:Panel ID="pnlApplyForm" runat="server" style="margin-top:16px;">
                    <div class="form-group">
                        <label for="txtProposedRate" style="font-size:13px; font-weight:600; color:var(--text-heading);">Proposed Rate (₹)</label>
                        <asp:TextBox ID="txtProposedRate" runat="server" CssClass="form-control" TextMode="Number" placeholder="10000" />
                        <asp:RequiredFieldValidator ID="rfvRate" runat="server" ControlToValidate="txtProposedRate" ErrorMessage="Proposed rate is required." ForeColor="#DC2626" Font-Size="12px" Display="Dynamic" ValidationGroup="ApplyVal" />
                    </div>

                    <div class="form-group">
                        <label for="txtCoverLetter" style="font-size:13px; font-weight:600; color:var(--text-heading);">Pitch / Cover Note</label>
                        <asp:TextBox ID="txtCoverLetter" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Explain why you are the best fit for this campaign..." />
                        <asp:RequiredFieldValidator ID="rfvCover" runat="server" ControlToValidate="txtCoverLetter" ErrorMessage="Pitch message is required." ForeColor="#DC2626" Font-Size="12px" Display="Dynamic" ValidationGroup="ApplyVal" />
                    </div>

                    <asp:Button ID="btnApply" runat="server" Text="Apply Now →"
                        CssClass="btn btn-primary btn-full btn-lg"
                        OnClick="btnApply_Click" ValidationGroup="ApplyVal"
                        style="background: linear-gradient(135deg,#7C3AED 0%,#EC4899 100%); border-radius:10px; font-size:16px; font-weight:700;" />
                </asp:Panel>

                <!-- Success Alert -->
                <asp:Panel ID="pnlApplySuccess" runat="server" Visible="false" style="background:#DCFCE7; border:1px solid #86EFAC; border-radius:10px; padding:16px; margin-top:16px; text-align:center;">
                    <div style="font-size:24px;">🎉</div>
                    <strong style="color:#15803D; font-size:15px;">Applied Successfully!</strong>
                    <p style="color:#166534; font-size:13px; margin:6px 0 0 0;">The advertiser has been notified and will review your pitch.</p>
                </asp:Panel>

                <asp:Panel ID="pnlApplyError" runat="server" Visible="false" style="background:#FEE2E2; border:1px solid #FCA5A5; color:#B91C1C; padding:12px; border-radius:8px; margin-top:12px; font-size:13px;">
                    <asp:Label ID="lblApplyError" runat="server" />
                </asp:Panel>
            </div>

            <!-- About Advertiser -->
            <div class="card" style="margin-top:16px;">
                <h3 style="font-size:15px;font-weight:700;color:var(--text-heading);margin-bottom:14px;">About the Advertiser</h3>
                <div class="advertiser-brand">
                    <div style="width:44px;height:44px;border-radius:8px;background:var(--purple-primary);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:16px;">
                        <asp:Literal ID="litAdvInitials" runat="server" Text="TN" />
                    </div>
                    <div>
                        <div class="adv-name"><asp:Literal ID="litAdvName" runat="server" Text="TechNova Solutions" /></div>
                        <div class="adv-cat"><asp:Literal ID="litAdvIndustry" runat="server" Text="Technology" /></div>
                    </div>
                </div>
                <p class="advertiser-desc">
                    <asp:Literal ID="litAdvDesc" runat="server" />
                </p>
            </div>
        </div>

    </div>

</asp:Content>
