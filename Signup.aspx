<%@ Page Title="Create Account" Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="Influish_net.Signup" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Create your Influish account to start collaborating." />
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

            <!-- ==============================
                 INFLUENCER SIGN UP FORM
                 ============================== -->
            <asp:Panel ID="pnlInfluencer" runat="server" CssClass="auth-card" style="max-width: 520px;">
                <div style="text-align: center; margin-bottom: 12px;">
                    <span class="auth-role-badge">⭐ Influencer Registration</span>
                </div>

                <h1 class="auth-title" style="text-align: center;">Join as Influencer</h1>
                <p class="auth-subtitle" style="text-align: center;">Monetize your creativity and connect with India's leading brands.</p>

                <asp:ValidationSummary ID="valSummaryInfluencer" runat="server" ValidationGroup="InfluencerVal"
                    CssClass="validation-summary" DisplayMode="BulletList" HeaderText="Please fix the following:"
                    style="background:#FEE2E2;color:#B91C1C;padding:12px;border-radius:8px;margin-bottom:16px;font-size:13px;" />

                <div class="form-group">
                    <label for="txtInfFullName">Full Name</label>
                    <div class="form-control-icon">
                        <span class="icon">👤</span>
                        <asp:TextBox ID="txtInfFullName" runat="server" placeholder="Riddhi Devaliya" />
                    </div>
                    <asp:RequiredFieldValidator ID="rfvInfFullName" runat="server"
                        ControlToValidate="txtInfFullName" ErrorMessage="Full Name is required."
                        ValidationGroup="InfluencerVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                </div>

                <div class="form-group">
                    <label for="txtInfEmail">Email Address</label>
                    <div class="form-control-icon">
                        <span class="icon">✉️</span>
                        <asp:TextBox ID="txtInfEmail" runat="server" placeholder="creator@example.com" TextMode="Email" />
                    </div>
                    <asp:RequiredFieldValidator ID="rfvInfEmail" runat="server"
                        ControlToValidate="txtInfEmail" ErrorMessage="Email address is required."
                        ValidationGroup="InfluencerVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    <asp:RegularExpressionValidator ID="revInfEmail" runat="server"
                        ControlToValidate="txtInfEmail" ErrorMessage="Enter a valid email address."
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        ValidationGroup="InfluencerVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                </div>

                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtInfPhone">Mobile Number</label>
                        <div class="form-control-icon">
                            <span class="icon">📱</span>
                            <asp:TextBox ID="txtInfPhone" runat="server" placeholder="+91 99984 59006" TextMode="Phone" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvInfPhone" runat="server"
                            ControlToValidate="txtInfPhone" ErrorMessage="Mobile number is required."
                            ValidationGroup="InfluencerVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtInfHandle">Primary Social Handle</label>
                        <div class="form-control-icon">
                            <span class="icon">@</span>
                            <asp:TextBox ID="txtInfHandle" runat="server" placeholder="@yourhandle" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvInfHandle" runat="server"
                            ControlToValidate="txtInfHandle" ErrorMessage="Social handle is required."
                            ValidationGroup="InfluencerVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="ddlInfNiche">Primary Niche / Category</label>
                    <asp:DropDownList ID="ddlInfNiche" runat="server" CssClass="form-control" style="width:100%; height:44px; padding:8px 12px; border:1px solid #E5E7EB; border-radius:8px;">
                        <asp:ListItem Text="Fashion &amp; Lifestyle" Value="Fashion &amp; Lifestyle" Selected="True" />
                        <asp:ListItem Text="Tech &amp; Gadgets" Value="Tech &amp; Gadgets" />
                        <asp:ListItem Text="Fitness, Health &amp; Wellness" Value="Fitness, Health &amp; Wellness" />
                        <asp:ListItem Text="Travel &amp; Hospitality" Value="Travel &amp; Hospitality" />
                        <asp:ListItem Text="Food, Dining &amp; Cooking" Value="Food, Dining &amp; Cooking" />
                        <asp:ListItem Text="Beauty, Skincare &amp; Makeup" Value="Beauty, Skincare &amp; Makeup" />
                        <asp:ListItem Text="Gaming &amp; Esports" Value="Gaming &amp; Esports" />
                        <asp:ListItem Text="Entertainment &amp; Comedy" Value="Entertainment &amp; Comedy" />
                        <asp:ListItem Text="Finance &amp; Business" Value="Finance &amp; Business" />
                    </asp:DropDownList>
                </div>

                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtInfPassword">Password</label>
                        <asp:TextBox ID="txtInfPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvInfPassword" runat="server"
                            ControlToValidate="txtInfPassword" ErrorMessage="Password is required."
                            ValidationGroup="InfluencerVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtInfConfirm">Confirm Password</label>
                        <asp:TextBox ID="txtInfConfirm" runat="server" TextMode="Password" placeholder="••••••••" CssClass="form-control" />
                        <asp:CompareValidator ID="cvInfPassword" runat="server"
                            ControlToValidate="txtInfConfirm" ControlToCompare="txtInfPassword"
                            ErrorMessage="Passwords do not match."
                            ValidationGroup="InfluencerVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                </div>

                <div class="form-check" style="margin: 18px 0 14px 0;">
                    <asp:CheckBox ID="chkInfTerms" runat="server" Checked="true" />
                    <label for="chkInfTerms">
                        I agree to the <a href="~/TermsOfService.aspx" runat="server">Terms of Service</a> and Creator Guidelines.
                    </label>
                </div>

                <asp:Button ID="btnInfSubmit" runat="server" Text="Create Influencer Account →"
                    CssClass="btn btn-primary btn-lg btn-full"
                    OnClick="btnInfSubmit_Click" ValidationGroup="InfluencerVal"
                    style="background: linear-gradient(135deg,#7C3AED 0%,#EC4899 100%); border-radius: 10px; font-size:16px; font-weight:700; padding:14px;" />

                <div class="auth-footer-link" style="margin-top: 18px; text-align: center; font-size: 14px; line-height: 1.8;">
                    <div>Are you a Brand or Agency? <a href="Signup.aspx?role=advertiser" style="font-weight:600; color:var(--purple-primary);">Join as Advertiser</a></div>
                    <div>Already have an account? <a href="Login.aspx?role=influencer" style="font-weight:600; color:var(--purple-primary);">Log in</a></div>
                </div>
            </asp:Panel>

            <!-- ==============================
                 ADVERTISER SIGN UP FORM
                 ============================== -->
            <asp:Panel ID="pnlAdvertiser" runat="server" CssClass="auth-card" style="max-width: 520px;" Visible="false">
                <div style="text-align: center; margin-bottom: 12px;">
                    <span class="auth-role-badge" style="background: #EDE9FE; color: #6D28D9;">🏢 Brand &amp; Advertiser Registration</span>
                </div>

                <h1 class="auth-title" style="text-align: center;">Join as Advertiser</h1>
                <p class="auth-subtitle" style="text-align: center;">Discover top creators and launch high-impact brand campaigns.</p>

                <asp:ValidationSummary ID="valSummaryAdvertiser" runat="server" ValidationGroup="AdvertiserVal"
                    CssClass="validation-summary" DisplayMode="BulletList" HeaderText="Please fix the following:"
                    style="background:#FEE2E2;color:#B91C1C;padding:12px;border-radius:8px;margin-bottom:16px;font-size:13px;" />

                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtAdvBrandName">Company / Brand Name</label>
                        <div class="form-control-icon">
                            <span class="icon">🏢</span>
                            <asp:TextBox ID="txtAdvBrandName" runat="server" placeholder="TechNova Labs" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvAdvBrandName" runat="server"
                            ControlToValidate="txtAdvBrandName" ErrorMessage="Brand Name is required."
                            ValidationGroup="AdvertiserVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtAdvContactPerson">Contact Person</label>
                        <div class="form-control-icon">
                            <span class="icon">👤</span>
                            <asp:TextBox ID="txtAdvContactPerson" runat="server" placeholder="Sarah Jenkins" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvAdvContactPerson" runat="server"
                            ControlToValidate="txtAdvContactPerson" ErrorMessage="Contact Person is required."
                            ValidationGroup="AdvertiserVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="txtAdvEmail">Work / Business Email</label>
                    <div class="form-control-icon">
                        <span class="icon">✉️</span>
                        <asp:TextBox ID="txtAdvEmail" runat="server" placeholder="partnerships@technova.io" TextMode="Email" />
                    </div>
                    <asp:RequiredFieldValidator ID="rfvAdvEmail" runat="server"
                        ControlToValidate="txtAdvEmail" ErrorMessage="Business Email is required."
                        ValidationGroup="AdvertiserVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    <asp:RegularExpressionValidator ID="revAdvEmail" runat="server"
                        ControlToValidate="txtAdvEmail" ErrorMessage="Enter a valid email address."
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        ValidationGroup="AdvertiserVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                </div>

                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtAdvPhone">Work Phone / WhatsApp</label>
                        <div class="form-control-icon">
                            <span class="icon">📱</span>
                            <asp:TextBox ID="txtAdvPhone" runat="server" placeholder="+91 98200 12345" TextMode="Phone" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvAdvPhone" runat="server"
                            ControlToValidate="txtAdvPhone" ErrorMessage="Phone number is required."
                            ValidationGroup="AdvertiserVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtAdvWebsite">Brand Website (Optional)</label>
                        <div class="form-control-icon">
                            <span class="icon">🌐</span>
                            <asp:TextBox ID="txtAdvWebsite" runat="server" placeholder="https://technova.io" />
                        </div>
                    </div>
                </div>

                <div class="form-group" style="margin-top: 14px;">
                    <label for="ddlAdvIndustry">Industry / Vertical</label>
                    <asp:DropDownList ID="ddlAdvIndustry" runat="server" CssClass="form-control" style="width:100%; height:44px; padding:8px 12px; border:1px solid #E5E7EB; border-radius:8px;">
                        <asp:ListItem Text="D2C &amp; E-Commerce" Value="D2C &amp; E-Commerce" Selected="True" />
                        <asp:ListItem Text="Fashion &amp; Apparel" Value="Fashion &amp; Apparel" />
                        <asp:ListItem Text="Technology &amp; Software (SaaS)" Value="Technology &amp; Software (SaaS)" />
                        <asp:ListItem Text="Beauty, Cosmetics &amp; Skincare" Value="Beauty, Cosmetics &amp; Skincare" />
                        <asp:ListItem Text="Health, Wellness &amp; Nutrition" Value="Health, Wellness &amp; Nutrition" />
                        <asp:ListItem Text="Food &amp; Beverage" Value="Food &amp; Beverage" />
                        <asp:ListItem Text="Fintech &amp; Banking" Value="Fintech &amp; Banking" />
                        <asp:ListItem Text="Marketing &amp; PR Agency" Value="Marketing &amp; PR Agency" />
                        <asp:ListItem Text="Other" Value="Other" />
                    </asp:DropDownList>
                </div>

                <div class="form-row">
                    <div class="form-group mb-0">
                        <label for="txtAdvPassword">Password</label>
                        <asp:TextBox ID="txtAdvPassword" runat="server" TextMode="Password" placeholder="••••••••" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvAdvPassword" runat="server"
                            ControlToValidate="txtAdvPassword" ErrorMessage="Password is required."
                            ValidationGroup="AdvertiserVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                    <div class="form-group mb-0">
                        <label for="txtAdvConfirm">Confirm Password</label>
                        <asp:TextBox ID="txtAdvConfirm" runat="server" TextMode="Password" placeholder="••••••••" CssClass="form-control" />
                        <asp:CompareValidator ID="cvAdvPassword" runat="server"
                            ControlToValidate="txtAdvConfirm" ControlToCompare="txtAdvPassword"
                            ErrorMessage="Passwords do not match."
                            ValidationGroup="AdvertiserVal" Display="Dynamic" ForeColor="#DC2626" Font-Size="12px" />
                    </div>
                </div>

                <div class="form-check" style="margin: 18px 0 14px 0;">
                    <asp:CheckBox ID="chkAdvTerms" runat="server" Checked="true" />
                    <label for="chkAdvTerms">
                        I agree to the <a href="~/TermsOfService.aspx" runat="server">Terms of Service</a> and Advertiser Agreement.
                    </label>
                </div>

                <asp:Button ID="btnAdvSubmit" runat="server" Text="Create Advertiser Account →"
                    CssClass="btn btn-primary btn-lg btn-full"
                    OnClick="btnAdvSubmit_Click" ValidationGroup="AdvertiserVal"
                    style="background: linear-gradient(135deg,#7C3AED 0%,#2563EB 100%); border-radius: 10px; font-size:16px; font-weight:700; padding:14px;" />

                <div class="auth-footer-link" style="margin-top: 18px; text-align: center; font-size: 14px; line-height: 1.8;">
                    <div>Are you a Creator? <a href="Signup.aspx?role=influencer" style="font-weight:600; color:var(--purple-primary);">Join as Influencer</a></div>
                    <div>Already have an account? <a href="Login.aspx?role=advertiser" style="font-weight:600; color:var(--purple-primary);">Log in</a></div>
                </div>
            </asp:Panel>

        </div>
    </form>
</body>
</html>
