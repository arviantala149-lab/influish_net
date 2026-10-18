<%@ Page Language="VB" %>
<%--
    ================================================================
    Admin/Login.aspx  —  Admin Login Page
    Language   : C#  (inline code — no separate .cs file needed)
    Controls   : TextBox, Button, Label, RequiredFieldValidator, Panel
    Concept    : ASP.NET Web Forms controls + Server-side validation
                 + Session state (Section 6 & 8 of syllabus)
    ================================================================
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Influish Admin Login" />
    <title>Admin Login — Influish</title>

    <%-- Admin CSS (one folder up because this page is inside Admin/) --%>
    <link href="../Content/admin.css" rel="stylesheet" />
</head>
<body class="login-body">

    <%-- ============================================================
         C# Server-Side Code (runs on the Web Server, not the browser)
         ============================================================
         This <script runat="server"> block is C# code.
         It executes AFTER the user clicks the Login button.
         The browser never sees this code — only the HTML result.
    --%>
    <script runat="server">

        ' ── Demo Credentials (for college practical only) ──────────
        ' NOTE: In a real application, passwords must be hashed
        '       and stored securely in the database. Never store
        '       plain-text passwords in production code.
        Private Const ADMIN_EMAIL As String = "arviantala18@gmail.com"
        Private Const ADMIN_PASSWORD As String = "Abc@1234"

        ' ── Page_Load : Runs every time this page loads ────────────
        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            ' If Admin is already logged in (session exists), go to Dashboard
            If Session("AdminLoggedIn") IsNot Nothing Then
                Response.Redirect("~/Admin/Dashboard.aspx")
            End If
        End Sub

        ' ── btnLogin_Click : Runs when Login button is clicked ─────
        Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs)
            ' Read what the user typed in the textboxes
            Dim email As String = txtEmail.Text.Trim()
            Dim password As String = txtPassword.Text.Trim()

            ' Compare with correct credentials
            If email = ADMIN_EMAIL AndAlso password = ADMIN_PASSWORD Then
                ' ── Correct credentials ────────────────────────────
                ' Store Admin info in Session (server memory)
                ' Session keeps the Admin logged in across all pages
                Session("AdminLoggedIn") = True
                Session("AdminName") = "Arvi Antala"
                Session("AdminRole") = "System Admin"

                ' Redirect to the Admin Dashboard
                Response.Redirect("~/Admin/Dashboard.aspx")
            Else
                ' ── Wrong credentials ──────────────────────────────
                ' Show the error panel with a message
                pnlError.Visible = True
                lblError.Text = "&#9888; Invalid email or password. Please try again."

                ' Clear the password field so user can retype
                txtPassword.Text = String.Empty
            End If
        End Sub

    </script>

    <%-- ── HTML Form starts here ─────────────────────────────────────
         runat="server" means ASP.NET handles this form (PostBack)
    ─────────────────────────────────────────────────────────────── --%>
    <form id="frmLogin" runat="server">
        <div class="login-card">

            <%-- ── Logo ──────────────────────────────────────────── --%>
            <div class="login-logo">
                <div class="login-logo-icon">i</div>
                <div>
                    <div class="login-logo-text">Influish</div>
                    <div class="login-logo-sub">INFLUENCER ADMIN</div>
                </div>
            </div>

            <%-- ── Headings ───────────────────────────────────────── --%>
            <h1 class="login-heading">Welcome Back</h1>
            <p class="login-subheading">Sign in to your admin account</p>

            <%-- ── Error Message Panel (hidden by default) ─────────── --%>
            <%-- asp:Panel is a container. Visible=false hides it until
                 the server sets pnlError.Visible = true on wrong login --%>
            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <asp:Label ID="lblError" runat="server" CssClass="login-error" />
            </asp:Panel>

            <%-- ── Email Field ─────────────────────────────────────── --%>
            <div class="form-group">
                <label for="txtEmail">Email Address</label>

                <%-- TextBox: TextMode="Email" adds browser email validation --%>
                <asp:TextBox ID="txtEmail" runat="server"
                    TextMode="Email"
                    placeholder="Enter admin email"
                    CssClass="txt-input" />

                <%-- RequiredFieldValidator: prevents empty email on submit --%>
                <asp:RequiredFieldValidator
                    ID="rfvEmail"
                    runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="&#9888; Email address is required."
                    CssClass="validation-error"
                    Display="Dynamic" />
            </div>

            <%-- ── Password Field ──────────────────────────────────── --%>
            <div class="form-group">
                <label for="txtPassword">Password</label>

                <%-- TextMode="Password" hides the typed characters --%>
                <asp:TextBox ID="txtPassword" runat="server"
                    TextMode="Password"
                    placeholder="Enter your password"
                    CssClass="txt-input" />

                <asp:RequiredFieldValidator
                    ID="rfvPassword"
                    runat="server"
                    ControlToValidate="txtPassword"
                    ErrorMessage="&#9888; Password is required."
                    CssClass="validation-error"
                    Display="Dynamic" />
            </div>

            <%-- ── Login Button ─────────────────────────────────────── --%>
            <%-- OnClick="btnLogin_Click" calls the C# method above --%>
            <asp:Button ID="btnLogin" runat="server"
                Text="Sign In"
                CssClass="btn-login"
                OnClick="btnLogin_Click" />

        </div>
    </form>

</body>
</html>
