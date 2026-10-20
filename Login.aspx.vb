Imports System.Web.UI

Public Class Login
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        If Page.IsValid Then
            ' TODO: Authenticate user
            Response.Redirect("~/Dashboard.aspx")
        End If
    End Sub
End Class
