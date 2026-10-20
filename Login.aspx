<%@ Page Title="Login" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Influish_net.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Log in to your Influish account." />
    <title>Login - Influish</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="~/Content/influish.css" rel="stylesheet" type="text/css" runat="server" />
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%237C3AED'/><path d='M16 4L19.5 12.5L28 16L19.5 19.5L16 28L12.5 19.5L4 16L12.5 12.5Z' fill='white'/></svg>" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" runat="server" />
</head>
<body>
    <form runat="server" id="frmLogin">
        <div class="auth-page">

            <div class="auth-logo">
                <a href="Default.aspx" style="text-decoration:none; color:inherit; display:flex; align-items:center; gap:8px;">
                    <div class="brand-icon" style="width:28px;height:28px;background:var(--purple-primary);border-radius:6px;display:flex;align-items:center;justify-content:center;color:#fff;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/>
                        </svg>
                    </div>
                    Influish
                </a>
            </div>

            <div class="auth-card" style="max-width: 480px;">

                <!-- Role Badge -->
                <div style="text-align: center; margin-bottom: 12px;">
                    <span class="auth-role-badge">
                        <asp:Literal ID="lblRoleBadge" runat="server" Text="⭐ Influencer &amp; Creator Login" />
                    </span>
                </div>

                <h1 class="auth-title" style="text-align: center;"><asp:Literal ID="litTitle" runat="server" Text="Welcome back" /></h1>
                <p class="auth-subtitle" style="text-align: center;"><asp:Literal ID="litSubtitle" runat="server" Text="Log in to your Influish account to continue." /></p>

                <asp:ValidationSummary ID="valSummaryLogin" runat="server"
                    CssClass="validation-summary" DisplayMode="BulletList" HeaderText="Please fix the following:"
                    style="background:#FEE2E2;color:#B91C1C;padding:12px;border-radius:8px;margin-bottom:16px;font-size:13px;" />

                <!-- Email -->
                <div class="form-group">
                    <label for="txtEmail"><asp:Literal ID="lblEmailLabel" runat="server" Text="Email Address" /></label>
                    <div class="form-control-icon">
                        <span class="icon">✉️</span>
                        <asp:TextBox ID="txtEmail" runat="server" placeholder="creator@example.com" TextMode="Email" />
                    </div>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail" ErrorMessage="Email address is required." Display="Dynamic"
                        ForeColor="#DC2626" Font-Size="12px" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail" ErrorMessage="Enter a valid email address."
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic"
                        ForeColor="#DC2626" Font-Size="12px" />
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <div class="form-control-icon">
                        <span class="icon">🔒</span>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="••••••••" />
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword" ErrorMessage="Password is required." Display="Dynamic"
                        ForeColor="#DC2626" Font-Size="12px" />
                </div>

                <!-- Remember / Forgot -->
                <div class="form-row" style="align-items:center; margin-bottom:20px;">
                    <div class="form-check" style="margin:0;">
                        <asp:CheckBox ID="chkRemember" runat="server" Checked="true" />
                        <label for="chkRemember">Remember me</label>
                    </div>
                    <div style="text-align:right;">
                        <a href="ForgotPassword.aspx" style="font-size:13px; color:var(--purple-primary); font-weight:500;">Forgot password?</a>
                    </div>
                </div>

                <!-- Submit Button -->
                <asp:Button ID="btnLogin" runat="server" Text="Sign In →"
                    CssClass="btn btn-primary btn-lg btn-full"
                    OnClick="btnLogin_Click"
                    style="background: linear-gradient(135deg,#7C3AED 0%,#EC4899 100%); border-radius: 10px; font-size:16px; font-weight:700; padding:14px;" />

                <!-- Bottom Links -->
                <div class="auth-footer-link" style="margin-top: 20px; text-align: center; font-size: 14px; line-height: 1.8;">
                    <div><asp:Literal ID="litSwitchRole" runat="server" /></div>
                    <div><asp:Literal ID="litSignupLink" runat="server" /></div>
                </div>

            </div>

        </div>
    </form>
</body>
</html>
