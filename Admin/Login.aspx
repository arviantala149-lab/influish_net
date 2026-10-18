<%@ Page Language="C#" %>
<%--
    ================================================================
    Admin/Login.aspx  -  Admin Login Page (BYPASSED)
    NOTE: Login is not required at this stage.
          This page immediately redirects to the Admin Dashboard.
    ================================================================
--%>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // Admin Login is bypassed - redirect straight to Dashboard
        Response.Redirect("~/Admin/Dashboard.aspx");
    }
</script>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Redirecting...</title>
</head>
<body>
    <p>Redirecting to Admin Dashboard...</p>
</body>
</html>
