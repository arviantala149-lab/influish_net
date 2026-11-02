<%@ Page Title="Profile Settings" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Influish_net.Profile" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Manage your Influish influencer profile and account details." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1>Profile Settings</h1>
        <p>Manage your influencer profile and account details.</p>
    </div>

    <div class="settings-grid">

        <!-- Left: Profile Card -->
        <div class="settings-profile-card">
            <div class="profile-avatar-wrap">
                <img src="https://i.pravatar.cc/200?img=47" alt="Profile photo" id="imgAvatar" />
                <label class="avatar-edit-btn" for="fileAvatar" title="Change photo">📷</label>
                <input type="file" id="fileAvatar" name="fileAvatar" accept="image/*" style="display:none;" runat="server" />
            </div>
            <div class="profile-name"><asp:Literal ID="litCardName" runat="server" Text="Creator" /></div>
            <div class="profile-handle"><asp:Literal ID="litCardHandle" runat="server" Text="@handle" /></div>
            <div class="settings-profile-tags">
                <asp:Literal ID="litCardCategories" runat="server" />
            </div>
            <a href="Dashboard.aspx" class="btn btn-primary btn-full" style="text-decoration:none; display:block; text-align:center;">Back to Dashboard</a>
        </div>

        <!-- Right: Form Area -->
        <div>

            <!-- Basic Information -->
            <div class="card" style="margin-bottom:20px;">
                <h2 class="settings-section-title">Basic Information</h2>

                <asp:Panel ID="pnlBasicStatus" runat="server" Visible="false"
                    style="background:#DCFCE7;color:#15803D;padding:12px;border-radius:8px;margin-bottom:16px;font-size:13px;font-weight:500;border:1px solid #86EFAC;">
                    <asp:Label ID="lblBasicStatus" runat="server" />
                </asp:Panel>

                <div class="form-group">
                    <label for="txtFullName">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName" ErrorMessage="Full Name is required." Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" ValidationGroup="BasicVal" />
                </div>

                <div class="form-group">
                    <label for="txtBio">Bio</label>
                    <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" Rows="4"
                        placeholder="Tell brands about yourself..." CssClass="form-control" />
                </div>

                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtCity">City / Location</label>
                        <asp:TextBox ID="txtCity" runat="server" placeholder="Ahmedabad" CssClass="form-control" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtCategory">Primary Niche / Category</label>
                        <asp:TextBox ID="txtCategory" runat="server" placeholder="Technology, Lifestyle" CssClass="form-control" />
                    </div>
                </div>

                <div class="form-row" style="margin-top:18px;">
                    <div class="form-group mb-0">
                        <label for="txtFollowers">Total Followers</label>
                        <asp:TextBox ID="txtFollowers" runat="server" CssClass="form-control" TextMode="Number" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtSocialHandle">Primary Social Handle</label>
                        <asp:TextBox ID="txtSocialHandle" runat="server" placeholder="@riddhi.creates" CssClass="form-control" />
                    </div>
                </div>

                <div style="display:flex; justify-content:flex-end; gap:12px; margin-top:20px;">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                        CssClass="btn btn-outline" CausesValidation="false" OnClick="btnCancel_Click" />
                    <asp:Button ID="btnSaveBasic" runat="server" Text="Save Changes"
                        CssClass="btn btn-purple-solid" OnClick="btnSaveBasic_Click" ValidationGroup="BasicVal" />
                </div>
            </div>

            <!-- Account Settings & Security -->
            <div class="card">
                <h2 class="settings-section-title">Account Security</h2>

                <asp:Panel ID="pnlSecurityStatus" runat="server" Visible="false"
                    style="background:#DCFCE7;color:#15803D;padding:12px;border-radius:8px;margin-bottom:16px;font-size:13px;font-weight:500;border:1px solid #86EFAC;">
                    <asp:Label ID="lblSecurityStatus" runat="server" />
                </asp:Panel>

                <asp:Panel ID="pnlSecurityError" runat="server" Visible="false"
                    style="background:#FEE2E2;color:#B91C1C;padding:12px;border-radius:8px;margin-bottom:16px;font-size:13px;font-weight:500;border:1px solid #FCA5A5;">
                    <asp:Label ID="lblSecurityError" runat="server" />
                </asp:Panel>

                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" ReadOnly="true" style="background:#F3F4F6;" />
                </div>

                <div class="form-group">
                    <label for="txtCurrentPassword">Current Password</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvCurPass" runat="server" ControlToValidate="txtCurrentPassword" ErrorMessage="Current password is required." Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" ValidationGroup="SecVal" />
                </div>

                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtNewPassword">New Password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvNewPass" runat="server" ControlToValidate="txtNewPassword" ErrorMessage="New password is required." Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" ValidationGroup="SecVal" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtConfirmPassword">Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="form-control" />
                        <asp:CompareValidator ID="cvPass" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword" ErrorMessage="Passwords do not match." Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" ValidationGroup="SecVal" />
                    </div>
                </div>

                <div style="margin-top:20px;">
                    <asp:Button ID="btnUpdateSecurity" runat="server" Text="Update Password"
                        CssClass="btn btn-outline" OnClick="btnUpdateSecurity_Click" ValidationGroup="SecVal" />
                </div>
            </div>
        </div>

    </div>

</asp:Content>
