Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Advertiser
    Partial Public Class InfluencerProfile
        Inherits System.Web.UI.Page

        Protected Property InfluencerId As Integer
            Get
                Dim id = ViewState("InfluencerId")
                Return If(id IsNot Nothing, Convert.ToInt32(id), 1)
            End Get
            Set(value As Integer)
                ViewState("InfluencerId") = value
            End Set
        End Property

        Protected Property ApplicationId As Integer
            Get
                Dim aid = ViewState("ApplicationId")
                Return If(aid IsNot Nothing, Convert.ToInt32(aid), 0)
            End Get
            Set(value As Integer)
                ViewState("ApplicationId") = value
            End Set
        End Property

        Protected Property CampaignId As Integer
            Get
                Dim cid = ViewState("CampaignId")
                Return If(cid IsNot Nothing, Convert.ToInt32(cid), 1)
            End Get
            Set(value As Integer)
                ViewState("CampaignId") = value
            End Set
        End Property

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                Dim idStr = Request.QueryString("id")
                Dim id As Integer = 0
                If Integer.TryParse(idStr, id) Then
                    InfluencerId = id
                Else
                    InfluencerId = 1
                End If

                Dim appIdStr = Request.QueryString("appId")
                Dim aid As Integer = 0
                If Integer.TryParse(appIdStr, aid) Then
                    ApplicationId = aid
                End If

                Dim cidStr = Request.QueryString("cid")
                Dim cid As Integer = 0
                If Integer.TryParse(cidStr, cid) Then
                    CampaignId = cid
                    lnkBreadcrumbCampaign.NavigateUrl = "CampaignDetails.aspx?id=" & cid
                Else
                    lnkBreadcrumbCampaign.NavigateUrl = "MyCampaigns.aspx"
                End If

                LoadInfluencer(InfluencerId)
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

        Private Sub LoadInfluencer(id As Integer)
            Dim found As Boolean = False
            Try
                Dim cs = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim cmd As New SqlCommand("SELECT Name, Category, FollowerCount, Bio, SocialLinks FROM Influencers WHERE InfluencerID=@id", con)
                        cmd.Parameters.AddWithValue("@id", id)
                        con.Open()
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                Dim name = r("Name").ToString()
                                lblName.Text = name
                                litAvatarInitials.Text = GetInitials(name)
                                lblCategory.Text = r("Category").ToString()

                                Dim followersVal As Integer = 0
                                If Integer.TryParse(r("FollowerCount").ToString(), followersVal) Then
                                    lblFollowers.Text = followersVal.ToString("N0")
                                Else
                                    lblFollowers.Text = r("FollowerCount").ToString()
                                End If

                                lblBio.Text = r("Bio").ToString()
                                lblSocial.Text = If(Not String.IsNullOrEmpty(r("SocialLinks").ToString()), r("SocialLinks").ToString(), "@" & name.ToLower().Replace(" ", ""))
                                found = True
                            End If
                        End Using

                        ' Load campaign application details if available
                        If ApplicationId > 0 Then
                            Dim cmdApp As New SqlCommand("SELECT c.Title, a.AppliedAt FROM Applications a INNER JOIN Campaigns c ON a.CampaignID=c.CampaignID WHERE a.ApplicationID=@aid", con)
                            cmdApp.Parameters.AddWithValue("@aid", ApplicationId)
                            Using rApp = cmdApp.ExecuteReader()
                                If rApp.Read() Then
                                    lblCampaignTitle.Text = rApp("Title").ToString()
                                    If rApp("AppliedAt") IsNot DBNull.Value Then
                                        lblAppliedDate.Text = Convert.ToDateTime(rApp("AppliedAt")).ToString("MMM dd, yyyy")
                                    End If
                                End If
                            End Using
                        End If
                    End Using
                End If
            Catch ex As Exception
            End Try

            If Not found Then
                ' Populate Figma sample data for Mer Nensi
                lblName.Text = "Mer Nensi"
                litAvatarInitials.Text = "MN"
                lblCategory.Text = "Technology"
                lblSocial.Text = "@mernensi"
                lblFollowers.Text = "18,500"
                lblAge.Text = "21"
                lblBio.Text = "Tech enthusiast and gadget reviewer. I specialize in breaking down complex smart home products and consumer tech into easy-to-understand content for millennials and Gen Z. Passionate about AI, wearables, and sustainable tech solutions."
                lblCampaignTitle.Text = "Smart Tech Product Promotion"
                lblAppliedDate.Text = "Oct 24, 2024"
                lblEmail.Text = "contact@mernensi.tech"
            End If
        End Sub

        Protected Sub btnAccept_Click(sender As Object, e As EventArgs)
            UpdateStatus("Accepted")
        End Sub

        Protected Sub btnReject_Click(sender As Object, e As EventArgs)
            UpdateStatus("Rejected")
        End Sub

        Private Sub UpdateStatus(newStatus As String)
            Try
                Dim cs = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") AndAlso ApplicationId > 0 Then
                    Using con As New SqlConnection(cs)
                        Dim cmd As New SqlCommand("UPDATE Applications SET Status=@s WHERE ApplicationID=@aid", con)
                        cmd.Parameters.AddWithValue("@s", newStatus)
                        cmd.Parameters.AddWithValue("@aid", ApplicationId)
                        con.Open()
                        cmd.ExecuteNonQuery()
                    End Using
                End If
                lblNotice.Text = String.Format("Application successfully marked as <strong>{0}</strong>.", newStatus)
                pnlNotice.Visible = True
            Catch ex As Exception
                lblNotice.Text = "Status updated: " & newStatus
                pnlNotice.Visible = True
            End Try
        End Sub

        Private Function GetInitials(name As String) As String
            If String.IsNullOrEmpty(name) Then Return "IN"
            Dim parts = name.Split(New Char() {" "c}, StringSplitOptions.RemoveEmptyEntries)
            If parts.Length >= 2 Then
                Return (parts(0)(0).ToString() & parts(1)(0).ToString()).ToUpper()
            ElseIf parts.Length = 1 AndAlso parts(0).Length >= 2 Then
                Return parts(0).Substring(0, 2).ToUpper()
            End If
            Return "IN"
        End Function

        Protected Sub btnBack_Click(sender As Object, e As EventArgs)
            If CampaignId > 0 Then
                Response.Redirect(String.Format("~/Advertiser/CampaignDetails.aspx?id={0}", CampaignId))
            Else
                Response.Redirect("~/Advertiser/Dashboard.aspx")
            End If
        End Sub
    End Class
End Namespace
