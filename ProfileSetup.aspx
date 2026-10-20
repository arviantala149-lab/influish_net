<%@ Page Title="Set Up Profile" Language="VB" AutoEventWireup="true" CodeBehind="ProfileSetup.aspx.vb" Inherits="Influish_net.ProfileSetup" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Set up your Influish influencer profile." />
    <title>Set Up Profile - Influish</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="~/Content/influish.css" rel="stylesheet" type="text/css" runat="server" />
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%237C3AED'/><path d='M16 4L19.5 12.5L28 16L19.5 19.5L16 28L12.5 19.5L4 16L12.5 12.5Z' fill='white'/></svg>" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" runat="server" />
</head>
<body>
    <form runat="server" id="frmProfileSetup">
        <div class="auth-page" style="padding: 40px 24px;">

            <div class="auth-card" style="max-width:520px;">

                <h1 class="auth-title" style="text-align:center; color:var(--purple-primary); margin-bottom:28px;">Set Up Profile</h1>

                <!-- Avatar -->
                <div class="profile-avatar-wrap" style="margin-bottom:28px;">
                    <img id="profilePreview"
                         src="https://i.pravatar.cc/200?img=47"
                         alt="Profile photo" />
                    <label class="avatar-edit-btn" for="fileAvatar" title="Change photo">📷</label>
                    <input type="file" id="fileAvatar" name="fileAvatar" accept="image/*" style="display:none;"
                           onchange="previewAvatar(this)" runat="server" />
                </div>

                <!-- Full Name -->
                <div class="form-group">
                    <label for="txtFullName">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" placeholder="Devaliya Riddhi" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                        ControlToValidate="txtFullName" ErrorMessage="Full Name is required." Display="Dynamic"
                        style="font-size:12px;color:#B91C1C;margin-top:4px;" />
                </div>

                <!-- Instagram Handle -->
                <div class="form-group">
                    <label for="txtInstagram">Instagram Handle</label>
                    <div class="form-control-icon">
                        <span class="icon" style="font-size:14px;font-weight:600;color:var(--text-muted);">@</span>
                        <asp:TextBox ID="txtInstagram" runat="server" placeholder="riddhi.09" />
                    </div>
                </div>

                <!-- Followers + Age row -->
                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtFollowers">Followers</label>
                        <asp:TextBox ID="txtFollowers" runat="server" placeholder="18,500" CssClass="form-control" TextMode="Number" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtAge">Age</label>
                        <asp:TextBox ID="txtAge" runat="server" placeholder="21" CssClass="form-control" TextMode="Number" />
                    </div>
                </div>

                <!-- Category -->
                <div class="form-group" style="margin-top:18px;">
                    <label for="ddlCategory">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Select a category</asp:ListItem>
                        <asp:ListItem Value="Technology">Technology</asp:ListItem>
                        <asp:ListItem Value="Fashion">Fashion</asp:ListItem>
                        <asp:ListItem Value="Lifestyle">Lifestyle</asp:ListItem>
                        <asp:ListItem Value="Food">Food &amp; Beverage</asp:ListItem>
                        <asp:ListItem Value="Fitness">Fitness &amp; Health</asp:ListItem>
                        <asp:ListItem Value="Travel">Travel</asp:ListItem>
                        <asp:ListItem Value="Beauty">Beauty</asp:ListItem>
                        <asp:ListItem Value="Gaming">Gaming</asp:ListItem>
                        <asp:ListItem Value="Finance">Finance</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Bio -->
                <div class="form-group">
                    <label for="txtBio">Bio</label>
                    <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" Rows="4"
                        placeholder="Tell brands about yourself..." CssClass="form-control" />
                    <div class="form-hint">Brief description for your profile.</div>
                </div>

                <!-- Submit -->
                <asp:Button ID="btnSave" runat="server" Text="Save &amp; Continue →"
                    CssClass="btn btn-primary btn-full btn-lg"
                    OnClick="btnSave_Click"
                    style="background: linear-gradient(135deg,#7C3AED 0%,#EC4899 100%); border-radius:10px; font-size:16px; font-weight:700; padding:14px;" />

            </div>
        </div>
    </form>

    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('profilePreview').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>
