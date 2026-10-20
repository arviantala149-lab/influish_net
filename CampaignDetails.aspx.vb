Imports System.Web.UI

Public Class CampaignDetails
    Inherits Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    End Sub
    Protected Sub btnApply_Click(sender As Object, e As EventArgs)
        ' TODO: Submit campaign application
        Response.Redirect("~/Applications.aspx")
    End Sub
End Class
