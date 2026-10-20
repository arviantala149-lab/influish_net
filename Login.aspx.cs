using System;
using System.Web.UI;

namespace Influish_net
{
    public partial class Login : Page
    {
        public string CurrentRole { get; set; }

        public Login()
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
                    lblRoleBadge.Text = "🏢 Brand &amp; Advertiser Login";
                    litTitle.Text = "Sign In as Advertiser";
                    litSubtitle.Text = "Manage your brand campaigns, creator partnerships, and analytics.";
                    lblEmailLabel.Text = "Work / Business Email";
                    txtEmail.Attributes["placeholder"] = "partnerships@brand.com";
                    btnLogin.Text = "Sign In as Advertiser →";
                    litSwitchRole.Text = "Are you a Creator? <a href='Login.aspx?role=influencer' style='font-weight:600; color:var(--purple-primary);'>Sign in as Influencer</a>";
                    litSignupLink.Text = "Don't have an account? <a href='Signup.aspx?role=advertiser' style='font-weight:600; color:var(--purple-primary);'>Join as Advertiser</a>";
                }
                else
                {
                    lblRoleBadge.Text = "⭐ Influencer &amp; Creator Login";
                    litTitle.Text = "Sign In as Influencer";
                    litSubtitle.Text = "Explore brand deals, collaborate seamlessly, and track your revenue.";
                    lblEmailLabel.Text = "Email Address";
                    txtEmail.Attributes["placeholder"] = "creator@example.com";
                    btnLogin.Text = "Sign In as Influencer →";
                    litSwitchRole.Text = "Are you a Brand / Advertiser? <a href='Login.aspx?role=advertiser' style='font-weight:600; color:var(--purple-primary);'>Sign in as Advertiser</a>";
                    litSignupLink.Text = "Don't have an account? <a href='Signup.aspx?role=influencer' style='font-weight:600; color:var(--purple-primary);'>Join as Influencer</a>";
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string email = txtEmail.Text.Trim();
                if (CurrentRole == "advertiser")
                {
                    Session["User"] = "Brand Partner";
                    Session["Role"] = "Advertiser";
                    Session["Email"] = email;
                    Response.Redirect("~/Advertiser/Dashboard.aspx");
                }
                else
                {
                    Session["User"] = "Creator";
                    Session["Role"] = "Influencer";
                    Session["Email"] = email;
                    Response.Redirect("~/Dashboard.aspx");
                }
            }
        }
    }
}
