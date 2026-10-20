<%@ Page Title="Forgot Password" Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Reset your Influish account password." />
    <title>Forgot Password - Influish</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="~/Content/influish.css" rel="stylesheet" type="text/css" runat="server" />
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%237C3AED'/><path d='M16 4L19.5 12.5L28 16L19.5 19.5L16 28L12.5 19.5L4 16L12.5 12.5Z' fill='white'/></svg>" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" runat="server" />
</head>
<body>
<script runat="server">
    protected void btnSend_Click(object sender, EventArgs e)
    {
        // In a real app, send reset email. For demo, show success.
        Response.Redirect("~/Login.aspx");
    }
</script>
    <form runat="server" id="frmForgot">
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

                <asp:Panel ID="pnlForm" runat="server">
                    <h1 class="auth-title">Forgot your password?</h1>
                    <p class="auth-subtitle">Enter your email address and we'll send you a link to reset your password.</p>

                    <div class="form-group">
                        <label for="txtEmail">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" placeholder="you@example.com"
                            TextMode="Email" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                            ControlToValidate="txtEmail" ErrorMessage="Email is required."
                            Display="Dynamic"
                            style="font-size:12px;color:#B91C1C;margin-top:4px;" />
                    </div>

                    <asp:Button ID="btnSend" runat="server" Text="Send Reset Link"
                        CssClass="btn btn-primary btn-lg btn-full"
                        OnClick="btnSend_Click"
                        style="background: var(--purple-primary); border-radius:10px; font-size:16px; font-weight:700; padding:14px; margin-bottom: 20px;" />
                </asp:Panel>

                <!-- Success message -->
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
                    style="text-align:center; padding: 20px 0;">
                    <div style="width:56px;height:56px;background:#DCFCE7;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:24px;margin:0 auto 14px;">✅</div>
                    <h2 style="font-size:18px;font-weight:700;color:var(--text-heading);margin-bottom:8px;">Check your inbox!</h2>
                    <p style="font-size:14px;color:var(--text-muted);">We've sent a password reset link to your email address.</p>
                </asp:Panel>

                <div class="auth-footer-link">
                    <a href="~/Login.aspx" runat="server" style="color:var(--text-muted);">&#8592; Back to Login</a>
                </div>
            </div>

        </div>
    </form>
</body>
</html>
