Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Advertiser
    Partial Public Class CampaignDetails
        Inherits System.Web.UI.Page

        Protected Property CurrentCampaignId As Integer
            Get
                Dim cid = ViewState("CampaignId")
                Return If(cid IsNot Nothing, Convert.ToInt32(cid), 1)
            End Get
            Set(value As Integer)
                ViewState("CampaignId") = value
            End Set
        End Property

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                Dim idStr As String = Request.QueryString("id")
                Dim id As Integer = 0
                If Integer.TryParse(idStr, id) Then
                    CurrentCampaignId = id
                Else
                    CurrentCampaignId = 1
                End If

                LoadCampaign(CurrentCampaignId)
                LoadApplicants(CurrentCampaignId)
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
            Dim loaded As Boolean = False
            Try
                Dim cs As String = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim cmd As New SqlCommand("SELECT Title, Description, Category, Budget FROM Campaigns WHERE CampaignID=@id", con)
                        cmd.Parameters.AddWithValue("@id", id)
                        con.Open()
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                Dim title As String = r("Title").ToString()
                                lblTitle.Text = title
                                litBreadcrumbTitle.Text = title
                                lblDescription.Text = r("Description").ToString()
                                lblCategory.Text = r("Category").ToString()

                                Dim budgetVal As Decimal = 0
                                If Decimal.TryParse(r("Budget").ToString(), budgetVal) Then
                                    lblBudget.Text = "₹" & budgetVal.ToString("N0")
                                Else
                                    lblBudget.Text = r("Budget").ToString()
                                End If
                                loaded = True
                            End If
                        End Using
                    End Using
                End If
            Catch ex As Exception
            End Try

            If Not loaded Then
                ' Default Figma reference representation
                lblTitle.Text = "Smart Tech Product Promotion"
                litBreadcrumbTitle.Text = "Smart Tech Product Promotion"
                lblCategory.Text = "Tech & Gadgets"
                lblBudget.Text = "₹10,000"
                lblDescription.Text = "We are launching our new flagship smart device and looking for tech-savvy creators to help us spread the word. This campaign involves creating unboxing and review content focusing on the innovative features and seamless integration into daily life."
            End If
        End Sub

        Private Sub LoadApplicants(campaignId As Integer)
            Dim dtApplicants As New DataTable()
            Dim hasDbData As Boolean = False

            Try
                Dim cs As String = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim query As String = "SELECT a.ApplicationID, i.InfluencerID, i.Name AS InfluencerName, i.FollowerCount, i.Category, a.Status, a.AppliedAt " &
                                              "FROM Applications a " &
                                              "INNER JOIN Influencers i ON a.InfluencerID = i.InfluencerID " &
                                              "WHERE a.CampaignID = @cid"
                        Dim da As New SqlDataAdapter(query, con)
                        da.SelectCommand.Parameters.AddWithValue("@cid", campaignId)
                        da.Fill(dtApplicants)
                        hasDbData = True
                    End Using
                End If
            Catch ex As Exception
            End Try

            If Not hasDbData OrElse dtApplicants.Rows.Count = 0 Then
                dtApplicants = GetSampleApplicants()
            End If

            ' Compute summary metrics
            Dim total As Integer = dtApplicants.Rows.Count
            Dim pendingCount As Integer = 0
            Dim acceptedCount As Integer = 0
            Dim rejectedCount As Integer = 0

            For Each row As DataRow In dtApplicants.Rows
                Dim st As String = row("Status").ToString().ToLower()
                If st = "pending" Then
                    pendingCount += 1
                ElseIf st = "accepted" Then
                    acceptedCount += 1
                ElseIf st = "rejected" Then
                    rejectedCount += 1
                End If
            Next

            lblTotalApplied.Text = total.ToString()
            lblCountPending.Text = pendingCount.ToString()
            lblCountAccepted.Text = acceptedCount.ToString()
            lblCountRejected.Text = rejectedCount.ToString()

            ' Apply Status and Sort filters
            Dim dv As New DataView(dtApplicants)
            Dim filterStatus As String = ddlStatusFilter.SelectedValue
            If filterStatus <> "All" Then
                dv.RowFilter = "Status = '" & filterStatus & "'"
            End If

            Dim sortOrder As String = ddlSortFilter.SelectedValue
            If sortOrder = "FollowersAsc" Then
                dv.Sort = "FollowerCount ASC"
            ElseIf sortOrder = "DateDesc" Then
                dv.Sort = "AppliedAt DESC"
            Else
                dv.Sort = "FollowerCount DESC"
            End If

            Dim filteredTable = dv.ToTable()
            gvApplicants.DataSource = filteredTable
            gvApplicants.DataBind()

            litShowingApplicants.Text = String.Format("Showing 1 to {0} of {1} applicants", filteredTable.Rows.Count, total)
        End Sub

        Private Function GetSampleApplicants() As DataTable
            Dim dt As New DataTable()
            dt.Columns.Add("ApplicationID", GetType(Integer))
            dt.Columns.Add("InfluencerID", GetType(Integer))
            dt.Columns.Add("InfluencerName", GetType(String))
            dt.Columns.Add("Category", GetType(String))
            dt.Columns.Add("FollowerCount", GetType(Integer))
            dt.Columns.Add("Status", GetType(String))
            dt.Columns.Add("AppliedAt", GetType(DateTime))

            dt.Rows.Add(1, 101, "Mer Nensi", "Tech", 18500, "Pending", DateTime.Now.AddDays(-2))
            dt.Rows.Add(2, 102, "Devaliya Riddhi", "Lifestyle, Tech", 25200, "Accepted", DateTime.Now.AddDays(-3))
            dt.Rows.Add(3, 103, "Sarah Jenkins", "Tech", 12800, "Rejected", DateTime.Now.AddDays(-4))
            dt.Rows.Add(4, 104, "Alex Johnson", "Tech", 45100, "Pending", DateTime.Now.AddDays(-5))

            Return dt
        End Function

        Protected Sub ddlStatusFilter_SelectedIndexChanged(sender As Object, e As EventArgs)
            LoadApplicants(CurrentCampaignId)
        End Sub

        Protected Sub ddlSortFilter_SelectedIndexChanged(sender As Object, e As EventArgs)
            LoadApplicants(CurrentCampaignId)
        End Sub

        Protected Sub lnkAccept_Click(sender As Object, e As EventArgs)
            Dim lb As LinkButton = CType(sender, LinkButton)
            Dim appId As Integer
            If Integer.TryParse(lb.CommandArgument, appId) Then
                UpdateApplicationStatus(appId, "Accepted")
            End If
        End Sub

        Protected Sub lnkReject_Click(sender As Object, e As EventArgs)
            Dim lb As LinkButton = CType(sender, LinkButton)
            Dim appId As Integer
            If Integer.TryParse(lb.CommandArgument, appId) Then
                UpdateApplicationStatus(appId, "Rejected")
            End If
        End Sub

        Private Sub UpdateApplicationStatus(appId As Integer, status As String)
            Try
                Dim cs As String = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim cmd As New SqlCommand("UPDATE Applications SET Status=@s WHERE ApplicationID=@id", con)
                        cmd.Parameters.AddWithValue("@s", status)
                        cmd.Parameters.AddWithValue("@id", appId)
                        con.Open()
                        cmd.ExecuteNonQuery()
                    End Using
                End If
            Catch ex As Exception
            End Try
            LoadApplicants(CurrentCampaignId)
        End Sub

        Public Function GetInitials(nameObj As Object) As String
            If nameObj Is Nothing OrElse IsDBNull(nameObj) Then Return "IN"
            Dim parts = nameObj.ToString().Split(New Char() {" "c}, StringSplitOptions.RemoveEmptyEntries)
            If parts.Length >= 2 Then
                Return (parts(0)(0).ToString() & parts(1)(0).ToString()).ToUpper()
            ElseIf parts.Length = 1 AndAlso parts(0).Length >= 2 Then
                Return parts(0).Substring(0, 2).ToUpper()
            End If
            Return "IN"
        End Function

        Public Function FormatFollowerCount(countObj As Object) As String
            If countObj Is Nothing OrElse IsDBNull(countObj) Then Return "0"
            Dim count As Integer = 0
            If Integer.TryParse(countObj.ToString(), count) Then
                If count >= 1000000 Then
                    Return (count / 1000000.0).ToString("0.#") & "M"
                ElseIf count >= 1000 Then
                    Return (count / 1000.0).ToString("0.#") & "k"
                Else
                    Return count.ToString()
                End If
            End If
            Return countObj.ToString()
        End Function

        Public Function FormatAppliedDate(dateObj As Object) As String
            If dateObj Is Nothing OrElse IsDBNull(dateObj) Then Return "Recently"
            Dim d As DateTime
            If DateTime.TryParse(dateObj.ToString(), d) Then
                Return d.ToString("MMM dd, yyyy")
            End If
            Return dateObj.ToString()
        End Function

        Protected Sub btnEdit_Click(sender As Object, e As EventArgs)
            Response.Redirect(String.Format("~/Advertiser/CreateCampaign.aspx?id={0}", CurrentCampaignId))
        End Sub

        Protected Sub btnBack_Click(sender As Object, e As EventArgs)
            Response.Redirect("~/Advertiser/MyCampaigns.aspx")
        End Sub
    End Class
End Namespace
