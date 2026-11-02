using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class Notifications : Page
    {
        protected int CurrentUserId
        {
            get
            {
                if (Session["UserID"] != null)
                {
                    return Convert.ToInt32(Session["UserID"]);
                }
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this.Page, "Influencer");

            if (!IsPostBack)
            {
                LoadNotifications();
            }
        }

        private void LoadNotifications()
        {
            int uid = CurrentUserId;
            if (uid <= 0) return;

            try
            {
                DataTable dt = DbHelper.ExecuteDataTable(
                    "SELECT NotificationID, Message, RelatedType, RelatedID, IsRead, CreatedAt " +
                    "FROM Notifications " +
                    "WHERE UserID = @uid " +
                    "ORDER BY CreatedAt DESC",
                    new SqlParameter("@uid", uid)
                );

                if (dt.Rows.Count > 0)
                {
                    rptNotifications.DataSource = dt;
                    rptNotifications.DataBind();
                    rptNotifications.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    rptNotifications.Visible = false;
                    pnlEmpty.Visible = true;
                }
            }
            catch
            {
                rptNotifications.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            int uid = CurrentUserId;
            if (uid > 0)
            {
                try
                {
                    DbHelper.ExecuteNonQuery(
                        "UPDATE Notifications SET IsRead = 1 WHERE UserID = @uid",
                        new SqlParameter("@uid", uid)
                    );
                    pnlNotice.Visible = true;
                }
                catch
                {
                }
            }
            LoadNotifications();
        }

        public string GetIconClass(object typeObj)
        {
            string type = typeObj != null ? typeObj.ToString().ToLower() : "";
            if (type.Contains("accept")) return "notif-icon notif-icon-green";
            if (type.Contains("applicant")) return "notif-icon notif-icon-blue";
            if (type.Contains("billing")) return "notif-icon notif-icon-orange";
            return "notif-icon notif-icon-gray";
        }

        public string GetIconSymbol(object typeObj)
        {
            string type = typeObj != null ? typeObj.ToString().ToLower() : "";
            if (type.Contains("accept")) return "✔";
            if (type.Contains("applicant")) return "👤";
            if (type.Contains("campaign")) return "📢";
            if (type.Contains("billing")) return "💳";
            return "ℹ";
        }

        public string FormatTime(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value) return "Recently";
            DateTime dt;
            if (DateTime.TryParse(dateObj.ToString(), out dt))
            {
                TimeSpan span = DateTime.Now - dt;
                if (span.TotalMinutes < 60)
                {
                    return Math.Max(1, (int)span.TotalMinutes) + " mins ago";
                }
                if (span.TotalHours < 24)
                {
                    return (int)span.TotalHours + " hours ago";
                }
                return dt.ToString("MMM dd, yyyy");
            }
            return dateObj.ToString();
        }

        public string GetActionButton(object typeObj, object relIdObj)
        {
            string type = typeObj != null ? typeObj.ToString().ToLower() : "";
            int id = 0;
            if (relIdObj != null && relIdObj != DBNull.Value)
            {
                int.TryParse(relIdObj.ToString(), out id);
            }

            if (type.Contains("accept") && id > 0)
            {
                return string.Format("<div style=\"margin-top:10px;\"><a href=\"CampaignDetails.aspx?id={0}\" class=\"btn btn-primary btn-sm\">View Campaign</a></div>", id);
            }
            if (type.Contains("applicant") && id > 0)
            {
                return string.Format("<div style=\"margin-top:10px;\"><a href=\"Applications.aspx\" class=\"btn btn-outline btn-sm\">View Applications</a></div>", id);
            }
            return "";
        }
    }
}
