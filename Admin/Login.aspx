<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // One common login page across entire platform per system specification
        Response.Redirect("~/Login.aspx?role=admin", true);
    }
</script>
