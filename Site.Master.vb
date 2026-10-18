Imports System.Data.SqlClient
Imports System.Configuration

Public Class SiteMaster
    Inherits MasterPage

    Public Property CompanyDisplayName As String = "TechNova Solutions"
    Public Property CompanyInitials As String = "TS"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadCompanyInfo()
        End If
    End Sub

    Private Sub LoadCompanyInfo()
        Try
            Dim connSetting = ConfigurationManager.ConnectionStrings("InfluishConnection")
            If connSetting IsNot Nothing AndAlso Not String.IsNullOrEmpty(connSetting.ConnectionString) AndAlso Not connSetting.ConnectionString.Contains("YOUR_SERVER") Then
                Using con As New SqlConnection(connSetting.ConnectionString)
                    Dim cmd As New SqlCommand("SELECT TOP 1 CompanyName FROM Companies", con)
                    con.Open()
                    Dim result = cmd.ExecuteScalar()
                    If result IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(result.ToString()) Then
                        CompanyDisplayName = result.ToString().Trim()
                    End If
                End Using
            End If
        Catch ex As Exception
            ' Keep default TechNova Solutions gracefully if database is unconfigured
        End Try

        ' Generate initials
        Try
            If Not String.IsNullOrEmpty(CompanyDisplayName) Then
                Dim parts = CompanyDisplayName.Split(New Char() {" "c}, StringSplitOptions.RemoveEmptyEntries)
                If parts.Length >= 2 Then
                    CompanyInitials = (parts(0)(0).ToString() & parts(1)(0).ToString()).ToUpper()
                ElseIf parts.Length = 1 AndAlso parts(0).Length >= 2 Then
                    CompanyInitials = parts(0).Substring(0, 2).ToUpper()
                Else
                    CompanyInitials = "TN"
                End If
            End If
        Catch
            CompanyInitials = "TN"
        End Try
    End Sub

    Public Function GetActiveClass(pageKeyword As String) As String
        Try
            Dim rawPath As String = Request.AppRelativeCurrentExecutionFilePath.ToLower()
            If rawPath.Contains(pageKeyword.ToLower()) Then
                Return "active"
            End If
        Catch
        End Try
        Return ""
    End Function
End Class