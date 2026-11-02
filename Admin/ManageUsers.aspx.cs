using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Influish_net.Helpers;

namespace Influish_net.Admin
{
    public partial class ManageUsers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            LoadUsers();
        }

        private void LoadUsers()
        {
            try
            {
                string query = "SELECT UserID, FullName, Email, Role, Status, JoinedDate FROM Users WHERE 1=1 ";
                var parameters = new System.Collections.Generic.List<SqlParameter>();

                string search = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (FullName LIKE @search OR Email LIKE @search) ";
                    parameters.Add(new SqlParameter("@search", "%" + search + "%"));
                }

                string role = ddlRoleFilter.SelectedValue;
                if (!string.IsNullOrEmpty(role))
                {
                    query += " AND Role = @role ";
                    parameters.Add(new SqlParameter("@role", role));
                }

                string status = ddlStatusFilter.SelectedValue;
                if (!string.IsNullOrEmpty(status))
                {
                    query += " AND Status = @status ";
                    parameters.Add(new SqlParameter("@status", status));
                }

                query += " ORDER BY JoinedDate DESC, UserID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query, parameters.ToArray());
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
                lblCount.Text = "Showing " + dt.Rows.Count + " user(s)";
                lblError.Visible = false;
            }
            catch (Exception ex)
            {
                lblError.Text = "Error loading users: " + Server.HtmlEncode(ex.Message);
                lblError.Visible = true;
            }
        }

        protected void btnToggleStatus_Command(object sender, CommandEventArgs e)
        {
            int userId = 0;
            if (int.TryParse(e.CommandArgument.ToString(), out userId))
            {
                try
                {
                    object currentStatusObj = DbHelper.ExecuteScalar(
                        "SELECT Status FROM Users WHERE UserID = @id",
                        new SqlParameter("@id", userId)
                    );

                    if (currentStatusObj != null)
                    {
                        string currentStatus = currentStatusObj.ToString();
                        string newStatus = currentStatus.Equals("Active", StringComparison.OrdinalIgnoreCase) ? "Inactive" : "Active";

                        DbHelper.ExecuteNonQuery(
                            "UPDATE Users SET Status = @status WHERE UserID = @id",
                            new SqlParameter("@status", newStatus),
                            new SqlParameter("@id", userId)
                        );

                        // Audit log to AdminLogs
                        int adminId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;
                        DbHelper.ExecuteNonQuery(
                            @"INSERT INTO AdminLogs(AdminUserID, Action, TargetEntity, TargetID, Details, Timestamp)
                              VALUES(@adminId, 'User Status Updated', 'Users', @targetId, @details, GETDATE())",
                            new SqlParameter("@adminId", adminId > 0 ? (object)adminId : DBNull.Value),
                            new SqlParameter("@targetId", userId),
                            new SqlParameter("@details", string.Format("User ID {0} status changed from {1} to {2}", userId, currentStatus, newStatus))
                        );

                        lblSuccess.Text = string.Format("User ID {0} status successfully updated to <strong>{1}</strong>.", userId, newStatus);
                        pnlSuccess.Visible = true;
                    }

                    LoadUsers();
                }
                catch (Exception ex)
                {
                    lblError.Text = "Error updating user: " + Server.HtmlEncode(ex.Message);
                    lblError.Visible = true;
                }
            }
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
                case "suspended": return "badge badge-deactivated";
                default: return "badge badge-pending";
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
