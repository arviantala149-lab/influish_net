<%@ Page Language="C#" %>
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

    <script runat="server">

        private const string ADMIN_EMAIL = "arviantala18@gmail.com";
        private const string ADMIN_PASSWORD = "Abc@1234";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminLoggedIn"] != null)
                Response.Redirect("~/Admin/Dashboard.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (email == ADMIN_EMAIL && password == ADMIN_PASSWORD)
            {
                Session["AdminLoggedIn"] = true;
                Session["AdminName"] = "Arvi Antala";
                Session["AdminRole"] = "System Admin";
                Response.Redirect("~/Admin/Dashboard.aspx");
            }
            else
            {
                pnlError.Visible = true;
                lblError.Text = "&#9888; Invalid email or password. Please try again.";
                txtPassword.Text = string.Empty;
            }
        }

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
