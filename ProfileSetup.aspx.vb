Imports System.Web.UI

Public Class ProfileSetup
    Inherits Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    End Sub
    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        ' TODO: Save profile setup
        Response.Redirect("~/Dashboard.aspx")
    End Sub
End Class
