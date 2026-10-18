<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="CreateCampaign.aspx.vb" Inherits="Influish_net.Advertiser.CreateCampaign" MasterPageFile="~/Site.Master" Title="Create Campaign" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb -->
    <div class="influish-breadcrumb">
        <a href="Dashboard.aspx">Dashboard</a>
        <span>/</span>
        <a href="MyCampaigns.aspx">Campaigns</a>
        <span>/</span>
        <span class="text-dark fw-medium">Create Campaign</span>
    </div>

    <!-- Page Header -->
    <div class="page-header-row">
        <div>
            <h1 class="page-title">
                <asp:Literal ID="litPageHeading" runat="server" Text="Create Campaign" />
            </h1>
            <p class="page-subtitle">Define your goals, budget, and requirements to attract the best influencers.</p>
        </div>
    </div>

    <!-- Status Message Alert -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-4">
        <div class="alert alert-danger d-flex align-items-center" role="alert">
            <svg width="20" height="20" fill="currentColor" class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2" viewBox="0 0 16 16">
                <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
            </svg>
            <div>
                <asp:Label ID="lblMessage" runat="server" />
            </div>
        </div>
    </asp:Panel>

    <!-- Main Form Card -->
    <div class="influish-card" style="max-width: 860px;">
        <!-- Section 1: Basic Information -->
        <div class="mb-4">
            <h3 class="card-title mb-3" style="font-size:16px;">Basic Information</h3>

            <!-- Campaign Title -->
            <div class="influish-form-group">
                <label class="influish-label">Campaign Title <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="influish-input" placeholder="e.g., Summer Fashion Launch 2024" MaxLength="200" />
                <asp:RequiredFieldValidator ID="vTitle" runat="server" ControlToValidate="txtTitle" 
                    ErrorMessage="Campaign Title is required." Text="Campaign Title is required." EnableClientScript="false" 
                    CssClass="influish-val-error" Display="Dynamic" />
            </div>

            <!-- Description -->
            <div class="influish-form-group">
                <label class="influish-label">Description <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="influish-textarea" 
                    placeholder="Describe your campaign goals, deliverables, and what you are looking for in an influencer..." />
                <asp:RequiredFieldValidator ID="vDescription" runat="server" ControlToValidate="txtDescription" 
                    ErrorMessage="Campaign Description is required." Text="Campaign Description is required." EnableClientScript="false" 
                    CssClass="influish-val-error" Display="Dynamic" />
            </div>

            <!-- Category -->
            <div class="influish-form-group">
                <label class="influish-label">Category <span class="text-danger">*</span></label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="influish-select">
                    <asp:ListItem Value="" Text="Select a category" />
                    <asp:ListItem Value="Technology" Text="Technology" />
                    <asp:ListItem Value="Fashion & Lifestyle" Text="Fashion & Lifestyle" />
                    <asp:ListItem Value="Beauty & Wellness" Text="Beauty & Wellness" />
                    <asp:ListItem Value="Gadgets" Text="Gadgets" />
                    <asp:ListItem Value="Software" Text="Software" />
                    <asp:ListItem Value="Food & Beverage" Text="Food & Beverage" />
                    <asp:ListItem Value="Fitness & Health" Text="Fitness & Health" />
                    <asp:ListItem Value="Travel & Tourism" Text="Travel & Tourism" />
                    <asp:ListItem Value="Education" Text="Education" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="vCategory" runat="server" ControlToValidate="ddlCategory" 
                    InitialValue="" ErrorMessage="Please select a campaign category." Text="Please select a campaign category." EnableClientScript="false" 
                    CssClass="influish-val-error" Display="Dynamic" />
            </div>
        </div>

        <hr style="border-color: var(--border-subtle); margin: 28px 0;" />

        <!-- Section 2: Requirements & Budget -->
        <div class="mb-4">
            <h3 class="card-title mb-3" style="font-size:16px;">Requirements & Budget</h3>

            <div class="row g-3">
                <!-- Budget per Influencer -->
                <div class="col-md-6">
                    <div class="influish-form-group">
                        <label class="influish-label">Budget per Influencer (₹) <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtBudget" runat="server" CssClass="influish-input" placeholder="e.g., 50000" />
                        <asp:RequiredFieldValidator ID="vBudget" runat="server" ControlToValidate="txtBudget" 
                            ErrorMessage="Budget amount is required." Text="Budget amount is required." EnableClientScript="false" 
                            CssClass="influish-val-error" Display="Dynamic" />
                        <asp:RangeValidator ID="rBudget" runat="server" ControlToValidate="txtBudget" 
                            Type="Double" MinimumValue="1" MaximumValue="10000000" 
                            ErrorMessage="Please enter a valid budget greater than 0." Text="Please enter a valid budget greater than 0." EnableClientScript="false" 
                            CssClass="influish-val-error" Display="Dynamic" />
                    </div>
                </div>

                <!-- Minimum Follower Requirement -->
                <div class="col-md-6">
                    <div class="influish-form-group">
                        <label class="influish-label">Minimum Follower Requirement</label>
                        <asp:TextBox ID="txtMinFollowers" runat="server" CssClass="influish-input" placeholder="e.g., 10000" />
                        <asp:RangeValidator ID="rFollowers" runat="server" ControlToValidate="txtMinFollowers" 
                            Type="Integer" MinimumValue="0" MaximumValue="10000000" 
                            ErrorMessage="Enter a valid minimum follower count (0 to 10,000,000)." Text="Enter a valid minimum follower count (0 to 10,000,000)." EnableClientScript="false" 
                            CssClass="influish-val-error" Display="Dynamic" />
                    </div>
                </div>
            </div>

            <!-- Target Audience Age Range -->
            <div class="influish-form-group">
                <label class="influish-label">Target Audience Age Range</label>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text bg-white" style="border-color:#D1D5DB; font-size:13px; color:var(--text-secondary);">Min Age</span>
                            <asp:TextBox ID="txtMinAge" runat="server" CssClass="influish-input" placeholder="18" />
                        </div>
                        <asp:RangeValidator ID="rMinAge" runat="server" ControlToValidate="txtMinAge" 
                            Type="Integer" MinimumValue="13" MaximumValue="100" 
                            ErrorMessage="Min age must be between 13 and 100." Text="Min age must be between 13 and 100." EnableClientScript="false" 
                            CssClass="influish-val-error" Display="Dynamic" />
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text bg-white" style="border-color:#D1D5DB; font-size:13px; color:var(--text-secondary);">Max Age</span>
                            <asp:TextBox ID="txtMaxAge" runat="server" CssClass="influish-input" placeholder="35" />
                        </div>
                        <asp:RangeValidator ID="rMaxAge" runat="server" ControlToValidate="txtMaxAge" 
                            Type="Integer" MinimumValue="13" MaximumValue="100" 
                            ErrorMessage="Max age must be between 13 and 100." Text="Max age must be between 13 and 100." EnableClientScript="false" 
                            CssClass="influish-val-error" Display="Dynamic" />
                        <asp:CompareValidator ID="cAgeRange" runat="server" ControlToValidate="txtMaxAge" 
                            ControlToCompare="txtMinAge" Operator="GreaterThanEqual" Type="Integer" 
                            ErrorMessage="Max age must be greater than or equal to Min age." Text="Max age must be greater than or equal to Min age." EnableClientScript="false" 
                            CssClass="influish-val-error" Display="Dynamic" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Buttons Row -->
        <div class="d-flex align-items-center justify-content-end gap-3 mt-4 pt-3 border-top">
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-influish-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
            <asp:Button ID="btnSave" runat="server" Text="Publish Campaign" CssClass="btn-influish-primary" OnClick="btnSave_Click" />
        </div>
    </div>
</asp:Content>