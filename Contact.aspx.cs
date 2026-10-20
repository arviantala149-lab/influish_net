using System;
using System.Web.UI;

namespace Influish_net
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
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
