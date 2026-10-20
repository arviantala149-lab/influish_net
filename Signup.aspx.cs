using System;
using System.Web.UI;

namespace Influish_net
{
    public partial class Signup : Page
    {
        public string CurrentRole { get; set; }

        public Signup()
        {
            CurrentRole = "influencer";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string role = Request.QueryString["role"];
            if (!string.IsNullOrEmpty(role) && role.Equals("advertiser", StringComparison.OrdinalIgnoreCase))
            {
                CurrentRole = "advertiser";
            }
            else
            {
                CurrentRole = "influencer";
            }

            if (!IsPostBack)
            {
                if (CurrentRole == "advertiser")
                {
                    pnlAdvertiser.Visible = true;
                    pnlInfluencer.Visible = false;
                }
                else
                {
                    pnlInfluencer.Visible = true;
                    pnlAdvertiser.Visible = false;
                }
            }
        }

        protected void btnInfSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Session["User"] = string.IsNullOrWhiteSpace(txtInfFullName.Text) ? "Creator" : txtInfFullName.Text.Trim();
                Session["Role"] = "Influencer";
                Session["Email"] = txtInfEmail.Text.Trim();
                Response.Redirect("~/ProfileSetup.aspx");
            }
        }

        protected void btnAdvSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Session["User"] = string.IsNullOrWhiteSpace(txtAdvBrandName.Text) ? "Brand Partner" : txtAdvBrandName.Text.Trim();
                Session["Role"] = "Advertiser";
                Session["Email"] = txtAdvEmail.Text.Trim();
                Response.Redirect("~/Advertiser/Dashboard.aspx");
            }
        }
    }
}
