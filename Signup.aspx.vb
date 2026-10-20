Imports System.Web.UI

Public Class Signup
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnCreate_Click(sender As Object, e As EventArgs)
        If Page.IsValid Then
            ' TODO: Save user to database
            Response.Redirect("~/ProfileSetup.aspx")
        End If
    End Sub
End Class
