<%@ Page Title="Contact Support" Language="VB" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="ContactSupport.aspx.vb" Inherits="Influish_net.ContactSupport" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Contact Influish support — we're here to help." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h1>Contact Support</h1>
        <p>We're here to help. Send us a message and we'll get back to you soon.</p>
    </div>

    <div class="card card-shadow" style="max-width: 760px;">

        <asp:ValidationSummary ID="ValidationSummary1" runat="server" DisplayMode="BulletList"
            style="background:#FEE2E2;color:#B91C1C;padding:12px;border-radius:8px;margin-bottom:20px;font-size:13px;" />

        <!-- Subject -->
        <div class="form-group">
            <label for="ddlSubject">Subject</label>
            <asp:DropDownList ID="ddlSubject" runat="server" CssClass="form-control">
                <asp:ListItem Value="">Select a subject</asp:ListItem>
                <asp:ListItem Value="Campaign Issue">Campaign Issue</asp:ListItem>
                <asp:ListItem Value="Payment Problem">Payment Problem</asp:ListItem>
                <asp:ListItem Value="Account Access">Account Access</asp:ListItem>
                <asp:ListItem Value="Technical Bug">Technical Bug</asp:ListItem>
                <asp:ListItem Value="Other">Other</asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvSubject" runat="server"
                ControlToValidate="ddlSubject" InitialValue=""
                ErrorMessage="Please select a subject." Display="None" />
        </div>

        <!-- Message -->
        <div class="form-group">
            <label for="txtMessage">Message</label>
            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6"
                placeholder="Describe your issue or question in detail..." CssClass="form-control" />
            <asp:RequiredFieldValidator ID="rfvMessage" runat="server"
                ControlToValidate="txtMessage" ErrorMessage="Please enter a message." Display="None" />
        </div>

        <!-- Attachments -->
        <div class="form-group">
            <label>Attachments <span style="color:var(--text-muted); font-weight:400;">(Optional)</span></label>
            <div class="upload-zone" id="dropZone" onclick="document.getElementById('fileAttachment').click();">
                <div class="upload-icon">☁️</div>
                <div>
                    <span class="upload-link">Upload a file</span>
                    <span style="font-size:14px;color:var(--text-muted);"> or drag and drop</span>
                </div>
                <div class="upload-hint">PNG, JPG, PDF up to 10MB</div>
                <asp:FileUpload ID="fileAttachment" runat="server" style="display:none;" />
            </div>
        </div>

        <!-- Submit -->
        <div style="display:flex; justify-content:flex-end; margin-top:8px;">
            <asp:Button ID="btnSubmit" runat="server" Text="Submit Request ›"
                CssClass="btn btn-primary btn-lg"
                OnClick="btnSubmit_Click"
                style="background: var(--purple-primary); border-radius:10px; font-size:15px; font-weight:700;" />
        </div>

        <!-- Success message -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
            style="margin-top:20px; background:#DCFCE7; border-radius:8px; padding:16px; display:flex; align-items:center; gap:12px; color:#15803D; font-size:14px; font-weight:500;">
            <span style="font-size:20px;">✅</span>
            Your support request has been submitted! We'll get back to you within 24 hours.
        </asp:Panel>

    </div>

    <script>
        // Drag and drop visual
        var dz = document.getElementById('dropZone');
        if (dz) {
            dz.addEventListener('dragover', function (e) { e.preventDefault(); dz.style.borderColor = 'var(--purple-primary)'; dz.style.background = 'var(--purple-light)'; });
            dz.addEventListener('dragleave', function () { dz.style.borderColor = ''; dz.style.background = ''; });
            dz.addEventListener('drop', function (e) { e.preventDefault(); dz.style.borderColor = ''; dz.style.background = ''; });
        }
    </script>

</asp:Content>
