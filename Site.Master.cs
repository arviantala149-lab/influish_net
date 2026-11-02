using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class SiteMaster : MasterPage
    {
        private string _companyDisplayName = "TechNova Solutions";
        private string _companyInitials = "TS";

        public string CompanyDisplayName
        {
            get { return _companyDisplayName; }
            set { _companyDisplayName = value; }
        }

        public string CompanyInitials
        {
            get { return _companyInitials; }
            set { _companyInitials = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCompanyInfo();
                CheckUserLoginState();
            }
        }

        private void CheckUserLoginState()
        {
            bool isLoggedIn = AuthHelper.CheckAndRestoreSession(Context);
            if (isLoggedIn && Session["Role"] != null)
            {
                phAnonymous.Visible = false;
                phLoggedIn.Visible = true;
                string role = Session["Role"].ToString();
                lnkUserDashboard.NavigateUrl = AuthHelper.GetRoleDashboardUrl(role);
                lnkUserDashboard.Text = role + " Dashboard";
            }
            else
            {
                phAnonymous.Visible = true;
                phLoggedIn.Visible = false;
            }
        }

        protected void lnkNavLogout_Click(object sender, EventArgs e)
        {
            AuthHelper.Logout(Context);
            Response.Redirect("~/Login.aspx");
        }

        private void LoadCompanyInfo()
        {
            try
            {
                object cName = DbHelper.ExecuteScalar("SELECT TOP 1 CompanyName FROM Companies");
                if (cName != null && !string.IsNullOrWhiteSpace(cName.ToString()))
                {
                    CompanyDisplayName = cName.ToString().Trim();
                }
            }
            catch
            {
                CompanyDisplayName = "TechNova Solutions";
            }

            try
            {
                if (!string.IsNullOrEmpty(CompanyDisplayName))
                {
                    string[] parts = CompanyDisplayName.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    if (parts.Length >= 2)
                    {
                        CompanyInitials = (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
                    }
                    else if (parts.Length == 1 && parts[0].Length >= 2)
                    {
                        CompanyInitials = parts[0].Substring(0, 2).ToUpper();
                    }
                    else
                    {
                        CompanyInitials = "TN";
                    }
                }
            }
            catch
            {
                CompanyInitials = "TN";
            }
        }

        public string GetActiveClass(string pageKeyword)
        {
            try
            {
                string rawPath = Request.AppRelativeCurrentExecutionFilePath.ToLower();
                if (rawPath.Contains(pageKeyword.ToLower()))
                {
                    return "active";
                }
            }
            catch
            {
            }
            return "";
        }
    }
}
