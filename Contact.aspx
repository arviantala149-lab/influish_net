<%@ Page Title="Contact Us" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.vb" Inherits="Influish_net.Contact" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Get in touch with the Influish team." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div style="max-width:680px; margin:0 auto; padding:60px 32px;">

        <h1 style="font-size:32px;font-weight:900;color:var(--text-heading);margin-bottom:8px;">Contact Us</h1>
        <p style="font-size:15px;color:var(--text-muted);margin-bottom:36px;">Have questions? We'd love to hear from you. Send us a message and we'll respond as soon as possible.</p>

        <div class="card card-shadow">
            <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                style="background:#FEE2E2;color:#B91C1C;padding:12px;border-radius:8px;margin-bottom:20px;font-size:13px;" />

            <div class="form-group">
                <label for="txtName">Your Name</label>
                <asp:TextBox ID="txtName" runat="server" placeholder="Full Name" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                    ErrorMessage="Name is required." Display="None" />
            </div>

            <div class="form-group">
                <label for="txtEmail">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" placeholder="you@example.com" TextMode="Email" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." Display="None" />
            </div>

            <div class="form-group">
                <label for="txtMessage">Message</label>
                <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5"
                    placeholder="Write your message here..." CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage"
                    ErrorMessage="Message is required." Display="None" />
            </div>

            <asp:Button ID="btnSend" runat="server" Text="Send Message"
                CssClass="btn btn-primary btn-full btn-lg"
                OnClick="btnSend_Click"
                style="background:linear-gradient(135deg,#7C3AED 0%,#EC4899 100%); border-radius:10px; font-size:16px; font-weight:700; padding:14px;" />

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
                style="margin-top:16px; background:#DCFCE7; border-radius:8px; padding:14px; text-align:center; color:#15803D; font-weight:600;">
                ✅ Your message has been sent! We'll get back to you shortly.
            </asp:Panel>
        </div>

    </div>

</asp:Content>
