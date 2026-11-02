using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net.Admin
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Admin");

            if (!IsPostBack)
            {
                LoadStats();
                LoadRecentActivities();
                LoadPendingActions();
            }
        }

        private void LoadStats()
        {
            try
            {
                // Total Users
                object totalUsers = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Users");
                lblTotalUsers.Text = totalUsers != null ? string.Format("{0:N0}", Convert.ToInt32(totalUsers)) : "0";

                // Total Influencers
                object totalInf = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Role = 'Influencer'");
                lblTotalInfluencers.Text = totalInf != null ? string.Format("{0:N0}", Convert.ToInt32(totalInf)) : "0";

                // Total Advertisers
                object totalAdv = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Role = 'Advertiser'");
                lblTotalAdvertisers.Text = totalAdv != null ? string.Format("{0:N0}", Convert.ToInt32(totalAdv)) : "0";

                // Active Campaigns
                object activeCamp = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Campaigns WHERE Status = 'Active' OR Status = 'Open'");
                lblActiveCampaigns.Text = activeCamp != null ? string.Format("{0:N0}", Convert.ToInt32(activeCamp)) : "0";
            }
            catch
            {
                lblTotalUsers.Text = "0";
                lblTotalInfluencers.Text = "0";
                lblTotalAdvertisers.Text = "0";
                lblActiveCampaigns.Text = "0";
            }
        }

        private void LoadRecentActivities()
        {
            DataTable dtActivities = new DataTable();
            dtActivities.Columns.Add("Avatar", typeof(string));
            dtActivities.Columns.Add("AvatarClass", typeof(string));
            dtActivities.Columns.Add("Text", typeof(string));
            dtActivities.Columns.Add("TimeText", typeof(string));

            try
            {
                // 1. Try to load from AdminLogs
                DataTable dtLogs = DbHelper.ExecuteDataTable(@"
                    SELECT TOP 5 l.Action, l.Details, l.Timestamp, ISNULL(u.FullName, 'Admin') AS AdminName
                    FROM AdminLogs l
                    LEFT JOIN Users u ON l.AdminUserID = u.UserID
                    ORDER BY l.Timestamp DESC");

                if (dtLogs.Rows.Count > 0)
                {
                    string[] colours = { "activity-avatar", "activity-avatar blue", "activity-avatar orange", "activity-avatar green" };
                    int i = 0;
                    foreach (DataRow r in dtLogs.Rows)
                    {
                        string action = r["Action"].ToString();
                        string details = r["Details"] != DBNull.Value ? r["Details"].ToString() : action;
                        DateTime ts = Convert.ToDateTime(r["Timestamp"]);

                        dtActivities.Rows.Add(
                            action.Length > 0 ? action[0].ToString().ToUpper() : "A",
                            colours[i % colours.Length],
                            details,
                            FormatTimeSpan(ts)
                        );
                        i++;
                    }
                }
                else
                {
                    // Fallback to recent users and campaigns
                    DataTable dtRecentUsers = DbHelper.ExecuteDataTable(@"
                        SELECT TOP 3 FullName, Role, JoinedDate FROM Users ORDER BY JoinedDate DESC, UserID DESC");

                    foreach (DataRow u in dtRecentUsers.Rows)
                    {
                        string name = u["FullName"].ToString();
                        string role = u["Role"].ToString();
                        dtActivities.Rows.Add(
                            name.Length > 0 ? name[0].ToString().ToUpper() : "U",
                            role == "Influencer" ? "activity-avatar" : "activity-avatar blue",
                            string.Format("{0} registered as a new {1}.", name, role.ToLower()),
                            "Recently"
                        );
                    }

                    DataTable dtRecentCampaigns = DbHelper.ExecuteDataTable(@"
                        SELECT TOP 2 Title, Advertiser, CreatedDate FROM Campaigns ORDER BY CampaignID DESC");

                    foreach (DataRow c in dtRecentCampaigns.Rows)
                    {
                        string title = c["Title"].ToString();
                        string brand = c["Advertiser"].ToString();
                        dtActivities.Rows.Add(
                            brand.Length > 0 ? brand[0].ToString().ToUpper() : "C",
                            "activity-avatar orange",
                            string.Format("{0} created campaign \"{1}\".", brand, title),
                            "Recently"
                        );
                    }
                }
            }
            catch
            {
            }

            if (dtActivities.Rows.Count > 0)
            {
                rptActivities.DataSource = dtActivities;
                rptActivities.DataBind();
                rptActivities.Visible = true;
                pnlNoActivities.Visible = false;
            }
            else
            {
                rptActivities.Visible = false;
                pnlNoActivities.Visible = true;
            }
        }

        private void LoadPendingActions()
        {
            try
            {
                object pendUsers = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Status = 'Pending'");
                int usersCount = pendUsers != null ? Convert.ToInt32(pendUsers) : 0;
                lblPendingUsersCount.Text = string.Format("{0} new user{1} pending approval.", usersCount, usersCount == 1 ? "" : "s");

                object pendCamps = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Campaigns WHERE Status = 'Pending'");
                int campsCount = pendCamps != null ? Convert.ToInt32(pendCamps) : 0;
                lblPendingCampaignsCount.Text = string.Format("{0} campaign{1} flagged or pending review.", campsCount, campsCount == 1 ? "" : "s");

                object pendReports = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Reports WHERE Status = 'Pending' OR Status = 'In Review'");
                int reportsCount = pendReports != null ? Convert.ToInt32(pendReports) : 0;
                lblPendingReportsCount.Text = string.Format("{0} unresolved support ticket{1}.", reportsCount, reportsCount == 1 ? "" : "s");

                int totalPending = usersCount + campsCount + reportsCount;
                lblPendingBadgeCount.Text = string.Format("{0} Pending", totalPending);
            }
            catch
            {
                lblPendingUsersCount.Text = "0 users pending approval.";
                lblPendingCampaignsCount.Text = "0 campaigns pending review.";
                lblPendingReportsCount.Text = "0 unresolved support reports.";
                lblPendingBadgeCount.Text = "0 Pending";
            }
        }

        private string FormatTimeSpan(DateTime dt)
        {
            TimeSpan diff = DateTime.Now.Subtract(dt);
            if (diff.TotalMinutes < 60) return Math.Max(1, (int)diff.TotalMinutes) + " minutes ago";
            if (diff.TotalHours < 24) return (int)diff.TotalHours + " hours ago";
            if (diff.TotalDays < 2) return "Yesterday";
            return dt.ToString("MMM dd, yyyy");
        }
    }
}
