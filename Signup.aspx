<%@ Page Title="Create Account" Language="VB" AutoEventWireup="true" CodeBehind="Signup.aspx.vb" Inherits="Influish_net.Signup" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Create your Influish account and start monetizing your reach." />
    <title>Create Account - Influish</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="~/Content/influish.css" rel="stylesheet" type="text/css" runat="server" />
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%237C3AED'/><path d='M16 4L19.5 12.5L28 16L19.5 19.5L16 28L12.5 19.5L4 16L12.5 12.5Z' fill='white'/></svg>" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" runat="server" />
</head>
<body>
    <form runat="server" id="frmSignup">
        <div class="auth-page">

            <div class="auth-card">
                <!-- Role Badge -->
                <div style="text-align: center; margin-bottom: 20px;">
                    <span class="auth-role-badge" style="display:inline-flex; align-items:center; gap:6px;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/>
                        </svg>
                        Signing up as Influencer
                    </span>
                </div>

                <!-- Title -->
                <h1 class="auth-title" style="text-align: center;">Create Account</h1>
                <p class="auth-subtitle" style="text-align: center;">Join Influish and start monetizing your reach.</p>

                <!-- Validation Summary -->
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="validation-summary"
                    DisplayMode="BulletList" HeaderText="Please fix the following:"
                    style="background:#FEE2E2;color:#B91C1C;padding:12px;border-radius:8px;margin-bottom:16px;font-size:13px;" />

                <!-- Full Name -->
                <div class="form-group">
                    <label for="txtFullName">Full Name</label>
                    <div class="form-control-icon">
                        <span class="icon">👤</span>
                        <asp:TextBox ID="txtFullName" runat="server" placeholder="Riddhi Devaliya" />
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                            ControlToValidate="txtFullName" ErrorMessage="Full Name is required."
                            Display="None" />
                    </div>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <div class="form-control-icon">
                        <span class="icon">✉️</span>
                        <asp:TextBox ID="txtEmail" runat="server" placeholder="riddhi@example.com" TextMode="Email" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                            ControlToValidate="txtEmail" ErrorMessage="Email address is required." Display="None" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server"
                            ControlToValidate="txtEmail" ErrorMessage="Enter a valid email."
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="None" />
                    </div>
                </div>

                <!-- Mobile Number -->
                <div class="form-group">
                    <label for="txtMobile">Mobile Number</label>
                    <div class="form-control-icon">
                        <span class="icon">📱</span>
                        <asp:TextBox ID="txtMobile" runat="server" placeholder="+91 99984 59006" TextMode="Phone" />
                        <asp:RequiredFieldValidator ID="rfvMobile" runat="server"
                            ControlToValidate="txtMobile" ErrorMessage="Mobile number is required." Display="None" />
                    </div>
                </div>

                <!-- Password row -->
                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtPassword">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                            placeholder="••••••••" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                            ControlToValidate="txtPassword" ErrorMessage="Password is required." Display="None" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtConfirm">Confirm</label>
                        <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password"
                            placeholder="••••••••" CssClass="form-control" />
                        <asp:CompareValidator ID="cvPassword" runat="server"
                            ControlToValidate="txtConfirm" ControlToCompare="txtPassword"
                            ErrorMessage="Passwords do not match." Display="None" />
                    </div>
                </div>

                <!-- Terms checkbox -->
                <div class="form-check" style="margin: 20px 0;">
                    <asp:CheckBox ID="chkTerms" runat="server" />
                    <label for="chkTerms">
                        I agree to the <a href="~/TermsOfService.aspx" runat="server">Terms of Service</a>.
                    </label>
                </div>

                <!-- Submit -->
                <asp:Button ID="btnCreate" runat="server" Text="Create Account"
                    CssClass="btn btn-primary btn-lg btn-full"
                    OnClick="btnCreate_Click"
                    style="background: linear-gradient(135deg,#7C3AED 0%,#EC4899 100%); border-radius: 10px; font-size:16px; font-weight:700; padding:14px;" />

                <div class="auth-footer-link">
                    Already have an account? <a href="~/Login.aspx" runat="server">Log in</a>
                </div>
            </div>

        </div>
    </form>
</body>
</html>
