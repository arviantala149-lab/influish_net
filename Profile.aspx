<%@ Page Title="Profile Settings" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Manage your Influish influencer profile and account details." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script runat="server">
        protected void btnSaveBasic_Click(object sender, EventArgs e)
        {
            btnSaveBasic.Text = "Saved ✓";
        }

        protected void btnUpdateSecurity_Click(object sender, EventArgs e)
        {
            btnUpdateSecurity.Text = "Updated ✓";
        }
    </script>

    <div class="page-header">
        <h1>Profile Settings</h1>
        <p>Manage your influencer profile and account details.</p>
    </div>

    <div class="settings-grid">

        <!-- Left: Profile Card -->
        <div class="settings-profile-card">
            <div class="profile-avatar-wrap">
                <img src="https://i.pravatar.cc/200?img=47" alt="Riddhi Devaliya" />
                <label class="avatar-edit-btn" for="fileAvatar" title="Change photo">📷</label>
                <input type="file" id="fileAvatar" name="fileAvatar" accept="image/*" style="display:none;" runat="server" />
            </div>
            <div class="profile-name">Riddhi Devaliya</div>
            <div class="profile-handle">@riddhi.creates</div>
            <div class="settings-profile-tags">
                <span class="tag-pill">Lifestyle</span>
                <span class="tag-pill">Tech</span>
            </div>
            <asp:Button ID="btnViewPublic" runat="server" Text="View Public Profile"
                CssClass="btn btn-primary btn-full" />
        </div>

        <!-- Right: Form Area -->
        <div>

            <!-- Basic Information -->
            <div class="card" style="margin-bottom:20px;">
                <h2 class="settings-section-title">Basic Information</h2>

                <div class="form-group">
                    <label for="txtBio">Bio</label>
                    <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" Rows="4"
                        placeholder="Tell brands about yourself..." CssClass="form-control" />
                </div>

                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtAge">Age</label>
                        <asp:TextBox ID="txtAge" runat="server" Text="25" CssClass="form-control" TextMode="Number" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtLocation">Location</label>
                        <asp:TextBox ID="txtLocation" runat="server" Text="New York, NY" CssClass="form-control" />
                    </div>
                </div>

                <div class="form-row" style="margin-top:18px;">
                    <div class="form-group mb-0">
                        <label for="txtFollowers">Total Followers</label>
                        <asp:TextBox ID="txtFollowers" runat="server" Text="150K" CssClass="form-control" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtStartingPrice">Starting Price (&#8377;)</label>
                        <asp:TextBox ID="txtStartingPrice" runat="server" Text="5000" CssClass="form-control" TextMode="Number" />
                    </div>
                </div>

                <div style="display:flex; justify-content:flex-end; gap:12px; margin-top:20px;">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                        CssClass="btn btn-outline" CausesValidation="false" />
                    <asp:Button ID="btnSaveBasic" runat="server" Text="Save Changes"
                        CssClass="btn btn-purple-solid" OnClick="btnSaveBasic_Click" />
                </div>
            </div>

            <!-- Account Settings -->
            <div class="card">
                <h2 class="settings-section-title">Account Settings</h2>

                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" Text="riddhi.creates@example.com"
                        TextMode="Email" CssClass="form-control" />
                </div>

                <div class="form-group">
                    <label for="txtNewPassword">New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"
                        placeholder="••••••••" CssClass="form-control" />
                </div>

                <asp:Button ID="btnUpdateSecurity" runat="server" Text="Update Security Info"
                    CssClass="btn btn-outline" OnClick="btnUpdateSecurity_Click" />
            </div>
        </div>

    </div>

</asp:Content>
