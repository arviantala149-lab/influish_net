Imports System.Web.UI

Public Class ForgotPassword
    Inherits Page

    Protected pnlForm As Global.System.Web.UI.WebControls.Panel
    Protected pnlSuccess As Global.System.Web.UI.WebControls.Panel

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnSend_Click(sender As Object, e As EventArgs)
        If Page.IsValid Then
            ' TODO: Send password reset email
            pnlForm.Visible = False
            pnlSuccess.Visible = True
        End If
    End Sub
End Class
