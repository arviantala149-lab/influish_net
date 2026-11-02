using System;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            string name = txtName != null ? txtName.Text.Trim() : "Visitor";
            string email = txtEmail != null ? txtEmail.Text.Trim() : "visitor@example.com";
            string message = txtMessage != null ? txtMessage.Text.Trim() : "";

            try
            {
                DbHelper.ExecuteNonQuery(
                    "INSERT INTO Reports (ReportType, Subject, Message, ReportedBy, ReportDate, Priority, Status) " +
                    "VALUES ('Support', @sub, @msg, @by, GETDATE(), 'Low', 'Pending')",
                    new SqlParameter("@sub", "Website Inquiry from " + name),
                    new SqlParameter("@msg", message),
                    new SqlParameter("@by", email)
                );
            }
            catch
            {
            }

            if (pnlSuccess != null)
            {
                pnlSuccess.Visible = true;
            }
            if (txtName != null) txtName.Text = "";
            if (txtEmail != null) txtEmail.Text = "";
            if (txtMessage != null) txtMessage.Text = "";
        }
    }
}
