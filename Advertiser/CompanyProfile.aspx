<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanyProfile.aspx.cs" Inherits="Influish_net.Advertiser.CompanyProfile" MasterPageFile="~/Site.Master" Title="Company Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb -->
    <div class="influish-breadcrumb">
        <a href="Dashboard.aspx">Dashboard</a>
        <span>/</span>
        <span class="text-dark fw-medium">Company Profile</span>
    </div>

    <!-- Status Message Alert -->
    <asp:Panel ID="pnlStatus" runat="server" Visible="false" CssClass="mb-3">
        <div class="alert alert-success d-flex align-items-center" role="alert">
            <svg width="20" height="20" fill="currentColor" class="bi bi-check-circle-fill flex-shrink-0 me-2" viewBox="0 0 16 16">
                <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
            </svg>
            <div>
                <asp:Label ID="lblStatus" runat="server" />
            </div>
        </div>
    </asp:Panel>

    <!-- Top Company Overview Card (Figma Page 22) -->
    <div class="influish-card mb-4" style="max-width: 860px;">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
            <div class="d-flex align-items-center gap-3">
                <div class="user-avatar" style="width: 54px; height: 54px; font-size: 20px; border-radius: 12px; background: linear-gradient(135deg, #7C3AED, #EC4899);">
                    <asp:Literal ID="litCompanyLogoText" runat="server" Text="TN" />
                </div>
                <div>
                    <h2 class="card-title" style="font-size: 20px; margin-bottom: 4px;">
                        <asp:Label ID="lblHeaderCompanyName" runat="server" Text="TechNova Solutions" />
                    </h2>
                    <div class="d-flex align-items-center gap-2">
                        <span class="category-tag" style="background:#EDE9FE; color:#7C3AED; font-weight:600;">
                            <asp:Label ID="lblHeaderIndustry" runat="server" Text="Technology" />
                        </span>
                        <span class="text-secondary small">
                            &#127760; <asp:Label ID="lblHeaderWebsite" runat="server" Text="technova.com" />
                        </span>
                    </div>
                </div>
            </div>
            <a href="#profileForm" class="btn-influish-secondary" style="font-size:13px; padding:8px 16px;">
                Edit Profile
            </a>
        </div>
    </div>

    <!-- Main Company Profile Form Card (Figma Page 22) -->
    <div id="profileForm" class="influish-card mb-4" style="max-width: 860px;">
        <div class="influish-card-header">
            <div>
                <h3 class="card-title" style="font-size: 17px;">Company Profile</h3>
                <p class="text-secondary small mb-0">Update your company details and contact information.</p>
            </div>
        </div>

        <!-- Row 1: Company Name & Industry -->
        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <div class="influish-form-group mb-0">
                    <label class="influish-label">Company Name <span class="text-danger">*</span></label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="influish-input" placeholder="TechNova Solutions" />
                    <asp:RequiredFieldValidator ID="vName" runat="server" ControlToValidate="txtName" 
                        ErrorMessage="Company name is required." Text="Company name is required." EnableClientScript="false" 
                        CssClass="influish-val-error" Display="Dynamic" ValidationGroup="CompanyGroup" />
                </div>
            </div>
            <div class="col-md-6">
                <div class="influish-form-group mb-0">
                    <label class="influish-label">Industry</label>
                    <asp:DropDownList ID="ddlIndustry" runat="server" CssClass="influish-select">
                        <asp:ListItem Value="Technology" Text="Technology" />
                        <asp:ListItem Value="Fashion & Lifestyle" Text="Fashion & Lifestyle" />
                        <asp:ListItem Value="Beauty & Wellness" Text="Beauty & Wellness" />
                        <asp:ListItem Value="Food & Beverage" Text="Food & Beverage" />
                        <asp:ListItem Value="Fitness & Health" Text="Fitness & Health" />
                        <asp:ListItem Value="Education & Media" Text="Education & Media" />
                        <asp:ListItem Value="Other" Text="Other" />
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <!-- Row 2: Website -->
        <div class="influish-form-group">
            <label class="influish-label">Website</label>
            <asp:TextBox ID="txtWebsite" runat="server" CssClass="influish-input" placeholder="https://technova.com" />
            <asp:RegularExpressionValidator ID="vWebsite" runat="server" ControlToValidate="txtWebsite" 
                ValidationExpression="^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$" 
                ErrorMessage="Enter a valid website URL (e.g. https://technova.com)." Text="Enter a valid website URL (e.g. https://technova.com)." EnableClientScript="false" 
                CssClass="influish-val-error" Display="Dynamic" ValidationGroup="CompanyGroup" />
        </div>

        <!-- Row 3: Description -->
        <div class="influish-form-group">
            <label class="influish-label">Description</label>
            <asp:TextBox ID="txtDesc" runat="server" TextMode="MultiLine" Rows="4" CssClass="influish-textarea" 
                placeholder="TechNova Solutions is a leading provider of enterprise software solutions, specializing in cloud infrastructure and data analytics. We help brands accelerate their digital transformation." />
        </div>

        <hr style="border-color: var(--border-subtle); margin: 24px 0;" />

        <!-- Primary Contact Header -->
        <div class="mb-3">
            <span class="stat-item-label mb-2 d-block">PRIMARY CONTACT</span>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <div class="influish-form-group mb-0">
                        <label class="influish-label">Contact Person</label>
                        <asp:TextBox ID="txtContactPerson" runat="server" CssClass="influish-input" placeholder="Sarah Jenkins" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="influish-form-group mb-0">
                        <label class="influish-label">Email Address <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="influish-input" placeholder="sarah.j@technova.com" />
                        <asp:RequiredFieldValidator ID="vEmail" runat="server" ControlToValidate="txtEmail" 
                            ErrorMessage="Email address is required." Text="Email address is required." EnableClientScript="false" 
                            CssClass="influish-val-error" Display="Dynamic" ValidationGroup="CompanyGroup" />
                        <asp:RegularExpressionValidator ID="vEmailFormat" runat="server" ControlToValidate="txtEmail" 
                            ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" 
                            ErrorMessage="Please enter a valid email address." Text="Please enter a valid email address." EnableClientScript="false" 
                            CssClass="influish-val-error" Display="Dynamic" ValidationGroup="CompanyGroup" />
                    </div>
                </div>
            </div>

            <div class="influish-form-group">
                <label class="influish-label">Mobile Number</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="influish-input" placeholder="+1 (555) 123-4567" />
                <asp:RegularExpressionValidator ID="vPhone" runat="server" ControlToValidate="txtPhone" 
                    ValidationExpression="^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$" 
                    ErrorMessage="Please enter a valid phone number." Text="Please enter a valid phone number." EnableClientScript="false" 
                    CssClass="influish-val-error" Display="Dynamic" ValidationGroup="CompanyGroup" />
            </div>
        </div>

        <!-- Form Buttons -->
        <div class="d-flex align-items-center justify-content-end gap-3 pt-3 border-top">
            <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn-influish-secondary" OnClick="btnBack_Click" CausesValidation="false" />
            <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn-influish-primary" OnClick="btnSave_Click" ValidationGroup="CompanyGroup" />
        </div>
    </div>

    <!-- Account Security Card (Figma Page 22) -->
    <div class="influish-card" style="max-width: 860px;">
        <div class="influish-card-header">
            <div>
                <h3 class="card-title" style="font-size: 17px;">Account Security</h3>
                <p class="text-secondary small mb-0">Manage your password and security preferences.</p>
            </div>
        </div>

        <asp:Panel ID="pnlSecurityStatus" runat="server" Visible="false" CssClass="mb-3">
            <div class="alert alert-info py-2 small">
                <asp:Label ID="lblSecurityStatus" runat="server" />
            </div>
        </asp:Panel>

        <div class="influish-form-group">
            <label class="influish-label">Current Password</label>
            <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="influish-input" placeholder="••••••••" />
        </div>

        <div class="influish-form-group">
            <label class="influish-label">New Password</label>
            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="influish-input" placeholder="••••••••" />
        </div>

        <div class="influish-form-group">
            <label class="influish-label">Confirm New Password</label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="influish-input" placeholder="••••••••" />
            <asp:CompareValidator ID="cPassword" runat="server" ControlToValidate="txtConfirmPassword" 
                ControlToCompare="txtNewPassword" Operator="Equal" 
                ErrorMessage="New password and confirm password do not match." Text="New password and confirm password do not match." EnableClientScript="false" 
                CssClass="influish-val-error" Display="Dynamic" ValidationGroup="SecurityGroup" />
        </div>

        <div class="d-flex justify-content-start pt-2">
            <asp:Button ID="btnUpdatePassword" runat="server" Text="Update Password" CssClass="btn-influish-secondary" OnClick="btnUpdatePassword_Click" ValidationGroup="SecurityGroup" />
        </div>
    </div>
</asp:Content>