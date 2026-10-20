<%@ Page Title="Login" Language="VB" AutoEventWireup="true" CodeBehind="Login.aspx.vb" Inherits="Influish_net.Login" %>

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
                <div class="brand-icon" style="width:28px;height:28px;background:var(--purple-primary);border-radius:6px;display:flex;align-items:center;justify-content:center;color:#fff;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/>
                    </svg>
                </div>
                Influish
            </div>

            <div class="auth-card">

                <h1 class="auth-title" style="text-align: center;">Welcome back</h1>
                <p class="auth-subtitle" style="text-align: center;">Log in to your Influish account to continue.</p>

                <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="validation-summary"
                    DisplayMode="BulletList" HeaderText="Please fix the following:"
                    style="background:#FEE2E2;color:#B91C1C;padding:12px;border-radius:8px;margin-bottom:16px;font-size:13px;" />

                <!-- Email -->
                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <div class="form-control-icon">
                        <span class="icon">✉️</span>
                        <asp:TextBox ID="txtEmail" runat="server" placeholder="you@example.com" TextMode="Email" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                            ControlToValidate="txtEmail" ErrorMessage="Email is required." Display="None" />
                    </div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                        <label for="txtPassword" style="margin-bottom:0;">Password</label>
                        <a href="~/ForgotPassword.aspx" runat="server"
                           style="font-size:13px; color:var(--purple-primary); font-weight:500;">Forgot password?</a>
                    </div>
                    <div class="form-control-icon">
                        <span class="icon">🔒</span>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                            placeholder="••••••••" />
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                            ControlToValidate="txtPassword" ErrorMessage="Password is required." Display="None" />
                    </div>
                </div>

                <!-- Login button -->
                <asp:Button ID="btnLogin" runat="server" Text="Log In"
                    CssClass="btn btn-primary btn-lg btn-full"
                    OnClick="btnLogin_Click"
                    style="background: linear-gradient(135deg,#7C3AED 0%,#EC4899 100%); border-radius: 10px; font-size:16px; font-weight:700; padding:14px;" />

                <div class="auth-footer-link">
                    Don't have an account? <a href="~/Signup.aspx" runat="server">Sign up</a>
                </div>
            </div>

        </div>
    </form>
</body>
</html>
