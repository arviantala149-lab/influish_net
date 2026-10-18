Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Advertiser
    Partial Public Class Dashboard
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                LoadCompanyName()
                LoadStatistics()
                LoadCampaigns()
            End If
        End Sub

        Private Function GetConnectionString() As String
            Try
                Dim conn = ConfigurationManager.ConnectionStrings("InfluishConnection")
                If conn IsNot Nothing Then
                    Return conn.ConnectionString
                End If
            Catch
            End Try
            Return String.Empty
        End Function

        Private Sub LoadCompanyName()
            Try
                Dim cs As String = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim cmd As New SqlCommand("SELECT TOP 1 CompanyName FROM Companies", con)
                        con.Open()
                        Dim result = cmd.ExecuteScalar()
                        If result IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(result.ToString()) Then
                            lblCompanyName.Text = result.ToString().Trim()
                            Return
                        End If
                    End Using
                End If
            Catch ex As Exception
            End Try
            lblCompanyName.Text = "TechNova Solutions"
        End Sub

        Private Sub LoadStatistics()
            Dim hasDbData As Boolean = False
            Try
                Dim cs As String = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        con.Open()
                        Dim cmdActive As New SqlCommand("SELECT COUNT(*) FROM Campaigns WHERE Status='Active' OR Status='Open'", con)
                        lblActiveCampaigns.Text = cmdActive.ExecuteScalar().ToString()

                        Dim cmdApplicants As New SqlCommand("SELECT COUNT(*) FROM Applications", con)
                        lblTotalApplicants.Text = cmdApplicants.ExecuteScalar().ToString()

                        Dim cmdAccepted As New SqlCommand("SELECT COUNT(*) FROM Applications WHERE Status='Accepted'", con)
                        lblAccepted.Text = cmdAccepted.ExecuteScalar().ToString()

                        Dim cmdPending As New SqlCommand("SELECT COUNT(*) FROM Applications WHERE Status='Pending'", con)
                        lblPending.Text = cmdPending.ExecuteScalar().ToString()
                        hasDbData = True
                    End Using
                End If
            Catch ex As Exception
            End Try

            If Not hasDbData Then
                ' Default Figma reference values for presentation
                lblActiveCampaigns.Text = "3"
                lblTotalApplicants.Text = "48"
                lblAccepted.Text = "12"
                lblPending.Text = "8"
            End If
        End Sub

        Private Sub LoadCampaigns()
            Dim bound As Boolean = False
            Try
                Dim cs As String = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim query As String = "SELECT c.CampaignID, c.Title, c.Category, c.Budget, c.Status, ISNULL(a.AppCount, 0) AS ApplicantCount " &
                                              "FROM Campaigns c " &
                                              "LEFT JOIN (SELECT CampaignID, COUNT(*) AS AppCount FROM Applications GROUP BY CampaignID) a " &
                                              "ON c.CampaignID = a.CampaignID " &
                                              "ORDER BY c.CampaignID DESC"
                        Dim da As New SqlDataAdapter(query, con)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        If dt.Rows.Count > 0 Then
                            gvCampaigns.DataSource = dt
                            gvCampaigns.DataBind()
                            bound = True
                        End If
                    End Using
                End If
            Catch ex As Exception
            End Try

            If Not bound Then
                ' Populate Figma sample campaigns if database is not yet seeded
                Dim dtSample As New DataTable()
                dtSample.Columns.Add("CampaignID", GetType(Integer))
                dtSample.Columns.Add("Title", GetType(String))
                dtSample.Columns.Add("Category", GetType(String))
                dtSample.Columns.Add("Budget", GetType(Decimal))
                dtSample.Columns.Add("Status", GetType(String))
                dtSample.Columns.Add("ApplicantCount", GetType(Integer))

                dtSample.Rows.Add(1, "Smart Tech Promotion", "Tech & Gadgets", 10000D, "Open", 14)
                dtSample.Rows.Add(2, "Wireless Earbuds Review", "Tech", 15000D, "Open", 8)
                dtSample.Rows.Add(3, "FitTrack Pro", "Fitness & Health", 5000D, "Closed", 26)

                gvCampaigns.DataSource = dtSample
                gvCampaigns.DataBind()
            End If
        End Sub

        Public Function GetStatusBadgeClass(statusObj As Object) As String
            If statusObj Is Nothing OrElse IsDBNull(statusObj) Then
                Return "closed"
            End If
            Dim status As String = statusObj.ToString().ToLower()
            If status = "active" OrElse status = "open" Then
                Return "open"
            ElseIf status = "pending" Then
                Return "pending"
            ElseIf status = "accepted" Then
                Return "accepted"
            ElseIf status = "rejected" Then
                Return "rejected"
            Else
                Return "closed"
            End If
        End Function

        Public Function FormatBudget(budgetObj As Object) As String
            If budgetObj Is Nothing OrElse IsDBNull(budgetObj) Then
                Return "₹0"
            End If
            Dim val As Decimal = 0
            If Decimal.TryParse(budgetObj.ToString(), val) Then
                Return "₹" & val.ToString("N0")
            End If
            Return budgetObj.ToString()
        End Function

        Protected Sub btnCreate_Click(sender As Object, e As EventArgs)
            Response.Redirect("~/Advertiser/CreateCampaign.aspx")
        End Sub

        Protected Sub btnProfile_Click(sender As Object, e As EventArgs)
            Response.Redirect("~/Advertiser/CompanyProfile.aspx")
        End Sub

        Protected Sub lnkDelete_Click(sender As Object, e As EventArgs)
            Dim lb As LinkButton = CType(sender, LinkButton)
            Dim id As Integer = 0
            If Integer.TryParse(lb.CommandArgument, id) Then
                Try
                    Dim cs As String = GetConnectionString()
                    If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                        Using con As New SqlConnection(cs)
                            Dim cmd As New SqlCommand("DELETE FROM Campaigns WHERE CampaignID=@id", con)
                            cmd.Parameters.AddWithValue("@id", id)
                            con.Open()
                            cmd.ExecuteNonQuery()
                        End Using
                    End If
                Catch ex As Exception
                End Try
                LoadStatistics()
                LoadCampaigns()
            End If
        End Sub
    End Class
End Namespace
