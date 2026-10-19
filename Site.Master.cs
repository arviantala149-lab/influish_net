using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Influish_net
{
    public partial class SiteMaster : MasterPage
    {
        public string CompanyDisplayName { get; set; } = "TechNova Solutions";
        public string CompanyInitials { get; set; } = "TS";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCompanyInfo();
            }
        }

        private void LoadCompanyInfo()
        {
            try
            {
                var connSetting = ConfigurationManager.ConnectionStrings["InfluishConnection"];
                if (connSetting != null && !string.IsNullOrEmpty(connSetting.ConnectionString) && !connSetting.ConnectionString.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection con = new SqlConnection(connSetting.ConnectionString))
                    {
                        SqlCommand cmd = new SqlCommand("SELECT TOP 1 CompanyName FROM Companies", con);
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null && !string.IsNullOrWhiteSpace(result.ToString()))
                        {
                            CompanyDisplayName = result.ToString().Trim();
                        }
                    }
                }
            }
            catch (Exception)
            {
                // Keep default TechNova Solutions gracefully if database is unconfigured
            }

            // Generate initials
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
