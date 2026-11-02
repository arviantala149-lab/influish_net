using System;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class ContactSupport : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Influencer");
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            lblError.Text = "";

            if (!Page.IsValid)
            {
                return;
            }

            string subject = ddlSubject.SelectedValue;
            string message = txtMessage.Text.Trim();
            string email = Session["Email"] != null ? Session["Email"].ToString() : "user@example.com";

            try
            {
                object newReportId = DbHelper.ExecuteScalar(
                    "INSERT INTO Reports (ReportType, Subject, Message, ReportedBy, ReportDate, Priority, Status) " +
                    "OUTPUT INSERTED.ReportID VALUES ('Support', @sub, @msg, @by, GETDATE(), 'Medium', 'Pending')",
                    new SqlParameter("@sub", subject),
                    new SqlParameter("@msg", message),
                    new SqlParameter("@by", email)
                );

                int ticketId = newReportId != null ? Convert.ToInt32(newReportId) : 100;
                litTicketId.Text = ticketId.ToString();

                // Create user confirmation notification
                int uid = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;
                if (uid > 0)
                {
                    DbHelper.ExecuteNonQuery(
                        "INSERT INTO Notifications (UserID, Message, RelatedType, RelatedID, IsRead, CreatedAt) " +
                        "VALUES (@uid, @msg, 'System', @relId, 0, GETDATE())",
                        new SqlParameter("@uid", uid),
                        new SqlParameter("@msg", "Your support request #" + ticketId + " has been submitted to administration."),
                        new SqlParameter("@relId", ticketId)
                    );
                }

                pnlSuccess.Visible = true;
                btnSubmit.Enabled = false;
                txtMessage.Text = "";
                ddlSubject.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                lblError.Text = "Error submitting ticket: " + Server.HtmlEncode(ex.Message);
                pnlError.Visible = true;
            }
        }
    }
}
