Imports System.Web.UI

Public Class ContactSupport
    Inherits Page
    Protected pnlSuccess As Global.System.Web.UI.WebControls.Panel

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    End Sub
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        If Page.IsValid Then
            pnlSuccess.Visible = True
        End If
    End Sub
End Class
