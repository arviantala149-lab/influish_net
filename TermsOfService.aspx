<%@ Page Title="Terms of Service" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TermsOfService.aspx.vb" Inherits="Influish_net.TermsOfService" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Read the Influish Terms of Service — user agreement, privacy policy highlights, and account responsibilities." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="terms-page">

        <h1 class="terms-title">Terms of Service</h1>

        <!-- User Agreement -->
        <div class="terms-section">
            <h2 class="terms-section-title">
                <span class="terms-icon">✍</span>
                User Agreement
            </h2>
            <div class="terms-box">
                <p>Welcome to Influish. By accessing or using our platform, you agree to be bound by these Terms of Service. This agreement outlines the rules and regulations for the use of Influish's Website and Services.</p>
                <p style="margin-top:10px;">If you do not agree to all the terms and conditions stated on this page, you must not use our services.</p>
            </div>
        </div>

        <!-- Privacy Policy Highlights -->
        <div class="terms-section">
            <h2 class="terms-section-title">
                <span class="terms-icon">🔒</span>
                Privacy Policy Highlights
            </h2>
            <div class="terms-box">
                <ul>
                    <li>We collect information to provide better services to our users.</li>
                    <li>We will not sell or share your personal information to third parties without your explicit consent.</li>
                    <li>Your data is encrypted and stored securely on our servers.</li>
                    <li>You have the right to request access to or deletion of your personal data at any time.</li>
                </ul>
            </div>
        </div>

        <!-- Limitations of Liability -->
        <div class="terms-section">
            <h2 class="terms-section-title">
                <span class="terms-icon">⚠</span>
                Limitations of Liability
            </h2>
            <div class="terms-box">
                <p>Influish shall not be held liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from:</p>
                <ul style="margin-top:10px;">
                    <li>Your access to or use of or inability to access or use the Service.</li>
                    <li>Any conduct or content of any third party on the Service.</li>
                    <li>Any content obtained from the Service.</li>
                    <li>Unauthorized access, use or alteration of your transmissions or content.</li>
                </ul>
            </div>
        </div>

        <!-- Account Responsibilities -->
        <div class="terms-section">
            <h2 class="terms-section-title">
                <span class="terms-icon">📋</span>
                Account Responsibilities
            </h2>
            <div class="terms-box">
                <p>When you create an account with us, you must provide information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.</p>
                <p style="margin-top:10px;">You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password, whether your password is with our Service or a third-party service.</p>
            </div>
        </div>

        <!-- Return to Home Button -->
        <div style="text-align:center; margin-top:40px;">
            <a href="~/Default.aspx" runat="server" class="btn btn-purple-solid btn-lg" style="border-radius:var(--radius-full);">
                Return to Home
            </a>
        </div>

    </div>

</asp:Content>
