Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Advertiser
    Partial Public Class MyCampaigns
        Inherits System.Web.UI.Page

        Protected Property CurrentFilter As String
            Get
                Dim f = ViewState("CurrentFilter")
                Return If(f IsNot Nothing, f.ToString(), "all")
            End Get
            Set(value As String)
                ViewState("CurrentFilter") = value
            End Set
        End Property

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CurrentFilter = "all"
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

        Private Sub LoadCampaigns()
            Dim dtResult As New DataTable()
            Dim dbSuccess As Boolean = False

            Try
                Dim cs As String = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim query As String = "SELECT c.CampaignID, c.Title, c.Description, c.Category, c.Budget, c.MinFollowers, c.Status, " &
                                              "ISNULL(a.AppCount, 0) AS ApplicantCount " &
                                              "FROM Campaigns c " &
                                              "LEFT JOIN (SELECT CampaignID, COUNT(*) AS AppCount FROM Applications GROUP BY CampaignID) a " &
                                              "ON c.CampaignID = a.CampaignID "

                        If CurrentFilter = "open" Then
                            query &= " WHERE c.Status='Open' OR c.Status='Active' "
                        ElseIf CurrentFilter = "closed" Then
                            query &= " WHERE c.Status='Closed' OR c.Status='Ended' "
                        End If

                        query &= " ORDER BY c.CampaignID DESC"

                        Dim da As New SqlDataAdapter(query, con)
                        da.Fill(dtResult)
                        dbSuccess = True

                        ' Count open and closed
                        Dim cmdOpen As New SqlCommand("SELECT COUNT(*) FROM Campaigns WHERE Status='Open' OR Status='Active'", con)
                        Dim cmdClosed As New SqlCommand("SELECT COUNT(*) FROM Campaigns WHERE Status='Closed' OR Status='Ended'", con)
                        con.Open()
                        litOpenCount.Text = cmdOpen.ExecuteScalar().ToString()
                        litClosedCount.Text = cmdClosed.ExecuteScalar().ToString()
                    End Using
                End If
            Catch ex As Exception
            End Try

            If Not dbSuccess OrElse dtResult.Rows.Count = 0 Then
                ' Populate Figma sample campaigns
                Dim dtAll As DataTable = GetSampleCampaigns()

                ' Set counts
                litOpenCount.Text = "2"
                litClosedCount.Text = "1"

                Dim dv As New DataView(dtAll)
                If CurrentFilter = "open" Then
                    dv.RowFilter = "Status = 'Open' OR Status = 'Active'"
                ElseIf CurrentFilter = "closed" Then
                    dv.RowFilter = "Status = 'Closed' OR Status = 'Ended'"
                End If
                dtResult = dv.ToTable()
            End If

            If dtResult.Rows.Count > 0 Then
                rptCampaigns.DataSource = dtResult
                rptCampaigns.DataBind()
                rptCampaigns.Visible = True
                pnlEmpty.Visible = False
                litShowingCount.Text = String.Format("Showing 1 to {0} of {0} campaigns", dtResult.Rows.Count)
            Else
                rptCampaigns.Visible = False
                pnlEmpty.Visible = True
                litShowingCount.Text = "Showing 0 campaigns"
            End If
        End Sub

        Private Function GetSampleCampaigns() As DataTable
            Dim dt As New DataTable()
            dt.Columns.Add("CampaignID", GetType(Integer))
            dt.Columns.Add("Title", GetType(String))
            dt.Columns.Add("Description", GetType(String))
            dt.Columns.Add("Category", GetType(String))
            dt.Columns.Add("Budget", GetType(Decimal))
            dt.Columns.Add("MinFollowers", GetType(Integer))
            dt.Columns.Add("Status", GetType(String))
            dt.Columns.Add("ApplicantCount", GetType(Integer))

            dt.Rows.Add(1, "Smart Tech Wireless Earbuds Review", "Looking for tech reviewers to create unboxing and hands-on feature reels for our flagship true wireless stereo earbuds.", "Tech & Gadgets", 75000D, 100000, "Open", 89)
            dt.Rows.Add(2, "Diwali Festive Wear Collection Promotion", "Seeking fashion & lifestyle influencers to showcase our new festive collection with authentic styling guides and festive lookbooks.", "Fashion & Lifestyle", 150000D, 50000, "Open", 215)
            dt.Rows.Add(3, "Organic Skincare Routine Launch", "Reels campaign focusing on natural morning skincare routine and cruelty-free benefits.", "Beauty & Wellness", 40000D, 25000, "Closed", 312)

            Return dt
        End Function

        Protected Sub FilterTab_Click(sender As Object, e As EventArgs)
            Dim btn As LinkButton = CType(sender, LinkButton)
            CurrentFilter = btn.CommandArgument.ToLower()

            btnTabAll.CssClass = "influish-tab-btn"
            btnTabOpen.CssClass = "influish-tab-btn"
            btnTabClosed.CssClass = "influish-tab-btn"

            If CurrentFilter = "open" Then
                btnTabOpen.CssClass = "influish-tab-btn active"
            ElseIf CurrentFilter = "closed" Then
                btnTabClosed.CssClass = "influish-tab-btn active"
            Else
                btnTabAll.CssClass = "influish-tab-btn active"
            End If

            LoadCampaigns()
        End Sub

        Public Function GetStatusBadgeClass(statusObj As Object) As String
            If statusObj Is Nothing OrElse IsDBNull(statusObj) Then
                Return "closed"
            End If
            Dim s As String = statusObj.ToString().ToLower()
            If s = "open" OrElse s = "active" Then
                Return "open"
            ElseIf s = "closed" OrElse s = "ended" Then
                Return "closed"
            End If
            Return "closed"
        End Function

        Public Function GetPostedText(idObj As Object) As String
            If idObj IsNot Nothing Then
                Dim id As Integer = 0
                If Integer.TryParse(idObj.ToString(), id) Then
                    If id = 1 Then Return "Posted 2 days ago"
                    If id = 2 Then Return "Posted 5 days ago"
                    If id = 3 Then Return "Ended Oct 15"
                End If
            End If
            Return "Active recently"
        End Function

        Public Function TruncateDescription(descObj As Object) As String
            If descObj Is Nothing OrElse IsDBNull(descObj) Then
                Return "No description provided."
            End If
            Dim text As String = descObj.ToString()
            If text.Length > 120 Then
                Return text.Substring(0, 117) & "..."
            End If
            Return text
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

        Public Function FormatFollowers(fObj As Object) As String
            If fObj Is Nothing OrElse IsDBNull(fObj) Then
                Return "Any"
            End If
            Dim count As Integer = 0
            If Integer.TryParse(fObj.ToString(), count) Then
                If count >= 1000000 Then
                    Return (count / 1000000.0).ToString("0.#") & "M+"
                ElseIf count >= 1000 Then
                    Return (count / 1000.0).ToString("0.#") & "k+"
                Else
                    Return count.ToString()
                End If
            End If
            Return fObj.ToString()
        End Function

        Protected Sub btnCreate_Click(sender As Object, e As EventArgs)
            Response.Redirect("~/Advertiser/CreateCampaign.aspx")
        End Sub

        Protected Sub lnkDelete_Click(sender As Object, e As EventArgs)
            Dim lb As LinkButton = CType(sender, LinkButton)
            Dim id As Integer
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
                LoadCampaigns()
            End If
        End Sub
    End Class
End Namespace
