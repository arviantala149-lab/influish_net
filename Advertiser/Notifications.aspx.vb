Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Advertiser
    Partial Public Class Notifications
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                LoadNotifications()
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

        Private Sub LoadNotifications()
            Dim dtNotes As New DataTable()
            Dim loadedFromDb As Boolean = False

            Try
                Dim cs = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim da As New SqlDataAdapter("SELECT NotificationID, Message, CreatedAt, RelatedType, RelatedID FROM Notifications ORDER BY CreatedAt DESC", con)
                        da.Fill(dtNotes)
                        If dtNotes.Rows.Count > 0 Then
                            loadedFromDb = True
                        End If
                    End Using
                End If
            Catch ex As Exception
            End Try

            If Not loadedFromDb Then
                dtNotes = GetSampleNotifications()
            End If

            If dtNotes.Rows.Count > 0 Then
                rptNotifications.DataSource = dtNotes
                rptNotifications.DataBind()
                rptNotifications.Visible = True
                pnlEmptyNotes.Visible = False
            Else
                rptNotifications.Visible = False
                pnlEmptyNotes.Visible = True
            End If
        End Sub

        Private Function GetSampleNotifications() As DataTable
            Dim dt As New DataTable()
            dt.Columns.Add("NotificationID", GetType(Integer))
            dt.Columns.Add("Message", GetType(String))
            dt.Columns.Add("CreatedAt", GetType(DateTime))
            dt.Columns.Add("RelatedType", GetType(String))
            dt.Columns.Add("RelatedID", GetType(Integer))

            dt.Rows.Add(1, "Nike accepted your application for the ""Summer Activewear 2024"" campaign.", DateTime.Now.AddHours(-2), "Acceptance", 1)
            dt.Rows.Add(2, "Alex Fitness applied to your ""Pre-workout Supplement Launch"" campaign.", DateTime.Now.AddHours(-5), "Applicant", 104)
            dt.Rows.Add(3, "Your campaign ""Tech Gadget Review Q3"" is now live and visible to influencers.", DateTime.Now.AddDays(-1).AddHours(2), "CampaignLive", 1)
            dt.Rows.Add(4, "Your account balance is running low (₹1,500 remaining). Please top up to keep campaigns active.", DateTime.Now.AddDays(-1).AddHours(-2), "Billing", 0)
            dt.Rows.Add(5, "Influish platform update: New analytics features are now available in your dashboard.", DateTime.Now.AddDays(-5), "System", 0)

            Return dt
        End Function

        Protected Sub btnMarkAllRead_Click(sender As Object, e As EventArgs)
            pnlNotice.Visible = True
        End Sub

        Public Function GetIconBackground(typeObj As Object) As String
            If typeObj Is Nothing OrElse IsDBNull(typeObj) Then Return "background-color: #EDE9FE; color: #7C3AED;"
            Dim t As String = typeObj.ToString().ToLower()
            If t = "acceptance" Then
                Return "background-color: #EDE9FE; color: #7C3AED;"
            ElseIf t = "applicant" Then
                Return "background-color: #FCE7F3; color: #DB2777;"
            ElseIf t = "campaignlive" Then
                Return "background-color: #FEF3C7; color: #D97706;"
            ElseIf t = "billing" Then
                Return "background-color: #FEE2E2; color: #DC2626;"
            Else
                Return "background-color: #E0F2FE; color: #0284C7;"
            End If
        End Function

        Public Function GetIconSvg(typeObj As Object) As String
            If typeObj Is Nothing OrElse IsDBNull(typeObj) Then
                Return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><line x1='12' y1='16' x2='12' y2='12'></line><line x1='12' y1='8' x2='12.01' y2='8'></line></svg>"
            End If
            Dim t As String = typeObj.ToString().ToLower()
            If t = "acceptance" Then
                Return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='20 6 9 17 4 12'></polyline></svg>"
            ElseIf t = "applicant" Then
                Return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'></path><circle cx='9' cy='7' r='4'></circle></svg>"
            ElseIf t = "campaignlive" Then
                Return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='m3 11 18-5v12L3 14v-3z'></path></svg>"
            ElseIf t = "billing" Then
                Return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='1' y='4' width='22' height='16' rx='2' ry='2'></rect><line x1='1' y1='10' x2='23' y2='10'></line></svg>"
            Else
                Return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><line x1='12' y1='16' x2='12' y2='12'></line><line x1='12' y1='8' x2='12.01' y2='8'></line></svg>"
            End If
        End Function

        Public Function GetActionButton(typeObj As Object, idObj As Object) As String
            If typeObj Is Nothing OrElse IsDBNull(typeObj) Then Return ""
            Dim t As String = typeObj.ToString().ToLower()
            Dim id As String = If(idObj IsNot Nothing, idObj.ToString(), "1")

            If t = "acceptance" Then
                Return String.Format("<div class='mt-2'><a href='CampaignDetails.aspx?id={0}' class='btn btn-sm btn-primary py-1 px-3' style='background:#7C3AED; border-color:#7C3AED; border-radius:6px; font-size:12px; font-weight:600;'>View Campaign</a></div>", id)
            ElseIf t = "applicant" Then
                Return String.Format("<div class='mt-2'><a href='InfluencerProfile.aspx?id={0}' class='btn btn-sm btn-outline-secondary py-1 px-3' style='border-radius:6px; font-size:12px; font-weight:600;'>Review Profile</a></div>", id)
            ElseIf t = "billing" Then
                Return "<div class='mt-2'><a href='#' class='btn btn-sm btn-outline-danger py-1 px-3' style='border-radius:6px; font-size:12px; font-weight:600;'>Add Funds</a></div>"
            End If
            Return ""
        End Function

        Public Function FormatRelativeTime(dateObj As Object) As String
            If dateObj Is Nothing OrElse IsDBNull(dateObj) Then Return "Just now"
            Dim d As DateTime
            If DateTime.TryParse(dateObj.ToString(), d) Then
                Dim span As TimeSpan = DateTime.Now.Subtract(d)
                If span.TotalMinutes < 60 Then
                    Return Math.Max(1, CInt(span.TotalMinutes)) & " minutes ago"
                ElseIf span.TotalHours < 24 Then
                    Return CInt(span.TotalHours) & " hours ago"
                ElseIf span.TotalDays < 2 Then
                    Return "Yesterday at " & d.ToString("HH:mm")
                Else
                    Return d.ToString("MMM dd, yyyy")
                End If
            End If
            Return dateObj.ToString()
        End Function
    End Class
End Namespace
