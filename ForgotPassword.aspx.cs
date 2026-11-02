using System;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            lblError.Text = "";

            if (!Page.IsValid)
            {
                return;
            }

            string email = txtEmail.Text.Trim();

            try
            {
                object userId = DbHelper.ExecuteScalar(
                    "SELECT UserID FROM Users WHERE Email = @email",
                    new SqlParameter("@email", email)
                );

                if (userId != null && userId != DBNull.Value)
                {
                    // Create in-app system notification for the user
                    DbHelper.ExecuteNonQuery(
                        "INSERT INTO Notifications (UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt) " +
                        "VALUES (@uid, 'A password reset request was initiated for your Influish account.', 'System', 0, 0, GETDATE())",
                        new SqlParameter("@uid", Convert.ToInt32(userId))
                    );

                    pnlForm.Visible = false;
                    pnlSuccess.Visible = true;
                }
                else
                {
                    lblError.Text = "No registered account found with this email address.";
                    pnlError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error verifying account: " + Server.HtmlEncode(ex.Message);
                pnlError.Visible = true;
            }
        }
    }
}
