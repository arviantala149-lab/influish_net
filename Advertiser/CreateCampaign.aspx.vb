Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Advertiser
    Partial Public Class CreateCampaign
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                Dim idStr As String = Request.QueryString("id")
                If Not String.IsNullOrEmpty(idStr) Then
                    Dim id As Integer
                    If Integer.TryParse(idStr, id) Then
                        litPageHeading.Text = "Edit Campaign"
                        btnSave.Text = "Update Campaign"
                        LoadCampaign(id)
                    End If
                End If
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

        Private Sub LoadCampaign(id As Integer)
            Try
                Dim cs As String = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim cmd As New SqlCommand("SELECT Title, Description, Category, Budget, MinFollowers, MinAge, MaxAge FROM Campaigns WHERE CampaignID=@id", con)
                        cmd.Parameters.AddWithValue("@id", id)
                        con.Open()
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                txtTitle.Text = r("Title").ToString()
                                txtDescription.Text = r("Description").ToString()
                                
                                Dim cat As String = r("Category").ToString()
                                If ddlCategory.Items.FindByValue(cat) IsNot Nothing Then
                                    ddlCategory.SelectedValue = cat
                                ElseIf ddlCategory.Items.FindByText(cat) IsNot Nothing Then
                                    ddlCategory.Items.FindByText(cat).Selected = True
                                End If

                                If r("Budget") IsNot DBNull.Value Then
                                    txtBudget.Text = Convert.ToDecimal(r("Budget")).ToString("0.##")
                                End If

                                If r("MinFollowers") IsNot DBNull.Value Then
                                    txtMinFollowers.Text = r("MinFollowers").ToString()
                                End If

                                If r("MinAge") IsNot DBNull.Value Then
                                    txtMinAge.Text = r("MinAge").ToString()
                                End If

                                If r("MaxAge") IsNot DBNull.Value Then
                                    txtMaxAge.Text = r("MaxAge").ToString()
                                End If
                            End If
                        End Using
                    End Using
                End If
            Catch ex As Exception
                ShowErrorMessage("Error loading campaign details: " & Server.HtmlEncode(ex.Message))
            End Try
        End Sub

        Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
            ' Syllabus requirement: Always validate on the server side
            Page.Validate()
            If Not Page.IsValid Then
                ShowErrorMessage("Please correct the highlighted validation errors below.")
                Return
            End If

            Dim title As String = txtTitle.Text.Trim()
            Dim description As String = txtDescription.Text.Trim()
            Dim category As String = ddlCategory.SelectedValue

            Dim budget As Decimal = 0
            Decimal.TryParse(txtBudget.Text.Trim(), budget)

            Dim minFollowers As Integer = 0
            If Not String.IsNullOrEmpty(txtMinFollowers.Text.Trim()) Then
                Integer.TryParse(txtMinFollowers.Text.Trim(), minFollowers)
            End If

            Dim minAge As Integer = 0
            If Not String.IsNullOrEmpty(txtMinAge.Text.Trim()) Then
                Integer.TryParse(txtMinAge.Text.Trim(), minAge)
            End If

            Dim maxAge As Integer = 0
            If Not String.IsNullOrEmpty(txtMaxAge.Text.Trim()) Then
                Integer.TryParse(txtMaxAge.Text.Trim(), maxAge)
            End If

            ' Additional server check
            If maxAge > 0 AndAlso minAge > 0 AndAlso minAge > maxAge Then
                ShowErrorMessage("Minimum age cannot be greater than maximum age.")
                Return
            End If

            Try
                Dim cs As String = GetConnectionString()
                If String.IsNullOrEmpty(cs) OrElse cs.Contains("YOUR_SERVER") Then
                    ' When database connection is pending configuration, inform gracefully and redirect
                    Response.Redirect("~/Advertiser/MyCampaigns.aspx")
                    Return
                End If

                Using con As New SqlConnection(cs)
                    Dim idStr As String = Request.QueryString("id")
                    If Not String.IsNullOrEmpty(idStr) Then
                        Dim id As Integer
                        If Integer.TryParse(idStr, id) Then
                            Dim cmdUpdate As New SqlCommand("UPDATE Campaigns SET Title=@title, Description=@desc, Category=@cat, Budget=@bud, MinFollowers=@mf, MinAge=@minA, MaxAge=@maxA WHERE CampaignID=@id", con)
                            cmdUpdate.Parameters.AddWithValue("@title", title)
                            cmdUpdate.Parameters.AddWithValue("@desc", description)
                            cmdUpdate.Parameters.AddWithValue("@cat", category)
                            cmdUpdate.Parameters.AddWithValue("@bud", budget)
                            cmdUpdate.Parameters.AddWithValue("@mf", If(minFollowers > 0, CType(minFollowers, Object), DBNull.Value))
                            cmdUpdate.Parameters.AddWithValue("@minA", If(minAge > 0, CType(minAge, Object), DBNull.Value))
                            cmdUpdate.Parameters.AddWithValue("@maxA", If(maxAge > 0, CType(maxAge, Object), DBNull.Value))
                            cmdUpdate.Parameters.AddWithValue("@id", id)
                            con.Open()
                            cmdUpdate.ExecuteNonQuery()
                            Response.Redirect("~/Advertiser/MyCampaigns.aspx")
                            Return
                        End If
                    Else
                        Dim cmd As New SqlCommand("INSERT INTO Campaigns(Title, Description, Category, Budget, MinFollowers, MinAge, MaxAge, Status) VALUES(@title,@desc,@cat,@bud,@mf,@minA,@maxA,@status)", con)
                        cmd.Parameters.AddWithValue("@title", title)
                        cmd.Parameters.AddWithValue("@desc", description)
                        cmd.Parameters.AddWithValue("@cat", category)
                        cmd.Parameters.AddWithValue("@bud", budget)
                        cmd.Parameters.AddWithValue("@mf", If(minFollowers > 0, CType(minFollowers, Object), DBNull.Value))
                        cmd.Parameters.AddWithValue("@minA", If(minAge > 0, CType(minAge, Object), DBNull.Value))
                        cmd.Parameters.AddWithValue("@maxA", If(maxAge > 0, CType(maxAge, Object), DBNull.Value))
                        cmd.Parameters.AddWithValue("@status", "Open")
                        con.Open()
                        cmd.ExecuteNonQuery()
                        Response.Redirect("~/Advertiser/MyCampaigns.aspx")
                        Return
                    End If
                End Using
            Catch ex As Exception
                ShowErrorMessage("Error saving campaign: " & Server.HtmlEncode(ex.Message))
            End Try
        End Sub

        Private Sub ShowErrorMessage(msg As String)
            lblMessage.Text = msg
            pnlMessage.Visible = True
        End Sub

        Protected Sub btnCancel_Click(sender As Object, e As EventArgs)
            Response.Redirect("~/Advertiser/MyCampaigns.aspx")
        End Sub
    End Class
End Namespace
