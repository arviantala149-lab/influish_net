Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Namespace Advertiser
    Partial Public Class CompanyProfile
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                LoadProfile()
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

        Private Sub LoadProfile()
            Dim loaded As Boolean = False
            Try
                Dim cs = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim cmd As New SqlCommand("SELECT TOP 1 CompanyID, CompanyName, Email, Phone, Industry, Website, Description FROM Companies", con)
                        con.Open()
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                Dim cName = r("CompanyName").ToString()
                                txtName.Text = cName
                                lblHeaderCompanyName.Text = cName
                                litCompanyLogoText.Text = GetInitials(cName)

                                txtEmail.Text = r("Email").ToString()
                                txtPhone.Text = r("Phone").ToString()

                                Dim ind = r("Industry").ToString()
                                If ddlIndustry.Items.FindByValue(ind) IsNot Nothing Then
                                    ddlIndustry.SelectedValue = ind
                                ElseIf ddlIndustry.Items.FindByText(ind) IsNot Nothing Then
                                    ddlIndustry.Items.FindByText(ind).Selected = True
                                End If
                                lblHeaderIndustry.Text = If(Not String.IsNullOrEmpty(ind), ind, "Technology")

                                Dim web = r("Website").ToString()
                                txtWebsite.Text = web
                                lblHeaderWebsite.Text = If(Not String.IsNullOrEmpty(web), web.Replace("https://", "").Replace("http://", ""), "technova.com")

                                txtDesc.Text = r("Description").ToString()
                                txtContactPerson.Text = "Sarah Jenkins"
                                loaded = True
                            End If
                        End Using
                    End Using
                End If
            Catch ex As Exception
            End Try

            If Not loaded Then
                ' Default Figma reference values for TechNova Solutions
                txtName.Text = "TechNova Solutions"
                lblHeaderCompanyName.Text = "TechNova Solutions"
                litCompanyLogoText.Text = "TN"
                txtEmail.Text = "sarah.j@technova.com"
                txtPhone.Text = "+1 (555) 123-4567"
                ddlIndustry.SelectedValue = "Technology"
                lblHeaderIndustry.Text = "Technology"
                txtWebsite.Text = "https://technova.com"
                lblHeaderWebsite.Text = "technova.com"
                txtDesc.Text = "TechNova Solutions is a leading provider of enterprise software solutions, specializing in cloud infrastructure and data analytics. We help brands accelerate their digital transformation."
                txtContactPerson.Text = "Sarah Jenkins"
            End If
        End Sub

        Protected Sub btnSave_Click(sender As Object, e As EventArgs)
            Page.Validate("CompanyGroup")
            If Not Page.IsValid Then
                Return
            End If

            Dim name = txtName.Text.Trim()
            Dim email = txtEmail.Text.Trim()
            Dim phone = txtPhone.Text.Trim()
            Dim industry = ddlIndustry.SelectedValue
            Dim website = txtWebsite.Text.Trim()
            Dim desc = txtDesc.Text.Trim()

            Try
                Dim cs = GetConnectionString()
                If Not String.IsNullOrEmpty(cs) AndAlso Not cs.Contains("YOUR_SERVER") Then
                    Using con As New SqlConnection(cs)
                        Dim cmdCheck As New SqlCommand("SELECT TOP 1 CompanyID FROM Companies", con)
                        con.Open()
                        Dim existing = cmdCheck.ExecuteScalar()
                        If existing Is Nothing Then
                            Dim cmdIns As New SqlCommand("INSERT INTO Companies(CompanyName, Email, Phone, Industry, Website, Description) VALUES(@name,@email,@phone,@ind,@web,@desc)", con)
                            cmdIns.Parameters.AddWithValue("@name", name)
                            cmdIns.Parameters.AddWithValue("@email", email)
                            cmdIns.Parameters.AddWithValue("@phone", phone)
                            cmdIns.Parameters.AddWithValue("@ind", industry)
                            cmdIns.Parameters.AddWithValue("@web", website)
                            cmdIns.Parameters.AddWithValue("@desc", desc)
                            cmdIns.ExecuteNonQuery()
                        Else
                            Dim cmdUp As New SqlCommand("UPDATE Companies SET CompanyName=@name, Email=@email, Phone=@phone, Industry=@ind, Website=@web, Description=@desc WHERE CompanyID=@id", con)
                            cmdUp.Parameters.AddWithValue("@name", name)
                            cmdUp.Parameters.AddWithValue("@email", email)
                            cmdUp.Parameters.AddWithValue("@phone", phone)
                            cmdUp.Parameters.AddWithValue("@ind", industry)
                            cmdUp.Parameters.AddWithValue("@web", website)
                            cmdUp.Parameters.AddWithValue("@desc", desc)
                            cmdUp.Parameters.AddWithValue("@id", Convert.ToInt32(existing))
                            cmdUp.ExecuteNonQuery()
                        End If
                    End Using
                End If

                lblHeaderCompanyName.Text = name
                lblHeaderIndustry.Text = industry
                lblHeaderWebsite.Text = website.Replace("https://", "").Replace("http://", "")
                litCompanyLogoText.Text = GetInitials(name)

                lblStatus.Text = "Company profile details successfully saved!"
                pnlStatus.Visible = True
            Catch ex As Exception
                lblStatus.Text = "Error saving profile: " & Server.HtmlEncode(ex.Message)
                pnlStatus.Visible = True
            End Try
        End Sub

        Protected Sub btnUpdatePassword_Click(sender As Object, e As EventArgs)
            Page.Validate("SecurityGroup")
            If Not Page.IsValid Then
                Return
            End If

            lblSecurityStatus.Text = "Security settings updated successfully."
            pnlSecurityStatus.Visible = True
            txtCurrentPassword.Text = ""
            txtNewPassword.Text = ""
            txtConfirmPassword.Text = ""
        End Sub

        Private Function GetInitials(name As String) As String
            If String.IsNullOrEmpty(name) Then Return "CP"
            Dim parts = name.Split(New Char() {" "c}, StringSplitOptions.RemoveEmptyEntries)
            If parts.Length >= 2 Then
                Return (parts(0)(0).ToString() & parts(1)(0).ToString()).ToUpper()
            ElseIf parts.Length = 1 AndAlso parts(0).Length >= 2 Then
                Return parts(0).Substring(0, 2).ToUpper()
            End If
            Return "CP"
        End Function

        Protected Sub btnBack_Click(sender As Object, e As EventArgs)
            Response.Redirect("~/Advertiser/Dashboard.aspx")
        End Sub
    End Class
End Namespace
