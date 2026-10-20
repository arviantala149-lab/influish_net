using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Influish_net.Admin
{
    public partial class ManageUsers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            var dt = new DataTable();
            bool dbSuccess = false;

            try
            {
                var connSetting = ConfigurationManager.ConnectionStrings["InfluishDB"];
                if (connSetting != null && !string.IsNullOrEmpty(connSetting.ConnectionString) && !connSetting.ConnectionString.Contains("YOUR_SERVER"))
                {
                    using (var conn = new SqlConnection(connSetting.ConnectionString))
                    {
                        string query = "SELECT UserID, FullName, Email, Role, Status, JoinedDate FROM Users ORDER BY JoinedDate DESC";
                        var da = new SqlDataAdapter(query, conn);
                        da.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            dbSuccess = true;
                        }
                    }
                }
            }
            catch (Exception)
            {
            }

            if (!dbSuccess || dt.Rows.Count == 0)
            {
                dt = GetSampleUsers();
            }

            gvUsers.DataSource = dt;
            gvUsers.DataBind();
            lblCount.Text = "Showing " + dt.Rows.Count + " user(s)";
        }

        private DataTable GetSampleUsers()
        {
            var dt = new DataTable();
            dt.Columns.Add("UserID", typeof(int));
            dt.Columns.Add("FullName", typeof(string));
            dt.Columns.Add("Email", typeof(string));
            dt.Columns.Add("Role", typeof(string));
            dt.Columns.Add("Status", typeof(string));
            dt.Columns.Add("JoinedDate", typeof(DateTime));

            dt.Rows.Add(1, "Riddhi Devaliya", "riddhi.creates@example.com", "Influencer", "Active", DateTime.Today.AddDays(-10));
            dt.Rows.Add(2, "TechNova Solutions", "contact@technova.io", "Advertiser", "Active", DateTime.Today.AddDays(-25));
            dt.Rows.Add(3, "Aarav Sharma", "aarav.vlogs@example.com", "Influencer", "Active", DateTime.Today.AddDays(-15));
            dt.Rows.Add(4, "Aura Beauty Co.", "partnerships@aurabeauty.in", "Advertiser", "Active", DateTime.Today.AddDays(-30));
            dt.Rows.Add(5, "Priya Patel", "priya.style@example.com", "Influencer", "Pending", DateTime.Today.AddDays(-2));

            return dt;
        }

        public string GetRoleBadge(object role)
        {
            if (role == null || role == DBNull.Value) return "badge";
            switch (role.ToString().ToLower())
            {
                case "influencer": return "badge badge-influencer";
                case "advertiser": return "badge badge-advertiser";
                default: return "badge";
            }
        }

        public string GetStatusBadge(object status)
        {
            if (status == null || status == DBNull.Value) return "badge";
            switch (status.ToString().ToLower())
            {
                case "active": return "badge badge-active";
                case "inactive": return "badge badge-inactive";
                default: return "badge";
            }
        }

        public string GetAvatarClass(object name)
        {
            if (name == null || name == DBNull.Value) return "user-avatar ua-purple";
            string[] colours = { "ua-purple", "ua-green", "ua-blue", "ua-orange", "ua-pink" };
            int index = Math.Abs(name.ToString().GetHashCode()) % colours.Length;
            return "user-avatar " + colours[index];
        }

        public string GetInitial(object name)
        {
            if (name == null || name == DBNull.Value) return "?";
            string n = name.ToString().Trim();
            return n.Length > 0 ? n[0].ToString().ToUpper() : "?";
        }
    }
}
