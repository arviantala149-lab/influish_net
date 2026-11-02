using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net.Advertiser
{
    public partial class Notifications : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Advertiser");

            if (!IsPostBack)
            {
                LoadNotifications();
            }
        }

        private void LoadNotifications()
        {
            int userId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;

            string query = @"
                SELECT NotificationID, Message, CreatedAt, RelatedType, RelatedID, IsRead 
                FROM Notifications 
                WHERE UserID = @uid 
                ORDER BY CreatedAt DESC";

            DataTable dtNotes = DbHelper.ExecuteDataTable(query, new SqlParameter("@uid", userId));

            if (dtNotes.Rows.Count > 0)
            {
                rptNotifications.DataSource = dtNotes;
                rptNotifications.DataBind();
                rptNotifications.Visible = true;
                pnlEmptyNotes.Visible = false;
            }
            else
            {
                rptNotifications.Visible = false;
                pnlEmptyNotes.Visible = true;
            }
        }

        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            int userId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;
            if (userId > 0)
            {
                DbHelper.ExecuteNonQuery(
                    "UPDATE Notifications SET IsRead = 1 WHERE UserID = @uid",
                    new SqlParameter("@uid", userId)
                );
            }
            pnlNotice.Visible = true;
            LoadNotifications();
        }

        public string GetIconBackground(object typeObj)
        {
            if (typeObj == null || Convert.IsDBNull(typeObj)) return "background-color: #EDE9FE; color: #7C3AED;";
            string t = typeObj.ToString().ToLower();
            if (t == "acceptance")
            {
                return "background-color: #EDE9FE; color: #7C3AED;";
            }
            else if (t == "applicant")
            {
                return "background-color: #FCE7F3; color: #DB2777;";
            }
            else if (t == "campaignlive")
            {
                return "background-color: #FEF3C7; color: #D97706;";
            }
            else if (t == "billing")
            {
                return "background-color: #FEE2E2; color: #DC2626;";
            }
            else
            {
                return "background-color: #E0F2FE; color: #0284C7;";
            }
        }

        public string GetIconSvg(object typeObj)
        {
            if (typeObj == null || Convert.IsDBNull(typeObj))
            {
                return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><line x1='12' y1='16' x2='12' y2='12'></line><line x1='12' y1='8' x2='12.01' y2='8'></line></svg>";
            }
            string t = typeObj.ToString().ToLower();
            if (t == "acceptance")
            {
                return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='20 6 9 17 4 12'></polyline></svg>";
            }
            else if (t == "applicant")
            {
                return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'></path><circle cx='9' cy='7' r='4'></circle></svg>";
            }
            else if (t == "campaignlive")
            {
                return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='m3 11 18-5v12L3 14v-3z'></path></svg>";
            }
            else if (t == "billing")
            {
                return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='1' y='4' width='22' height='16' rx='2' ry='2'></rect><line x1='1' y1='10' x2='23' y2='10'></line></svg>";
            }
            else
            {
                return "<svg width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'></circle><line x1='12' y1='16' x2='12' y2='12'></line><line x1='12' y1='8' x2='12.01' y2='8'></line></svg>";
            }
        }

        public string GetActionButton(object typeObj, object idObj)
        {
            if (typeObj == null || Convert.IsDBNull(typeObj)) return "";
            string t = typeObj.ToString().ToLower();
            string id = idObj != null ? idObj.ToString() : "1";

            if (t == "acceptance" || t == "campaignlive")
            {
                return string.Format("<div class='mt-2'><a href='CampaignDetails.aspx?id={0}' class='btn btn-sm btn-primary py-1 px-3' style='background:#7C3AED; border-color:#7C3AED; border-radius:6px; font-size:12px; font-weight:600;'>View Campaign</a></div>", id);
            }
            else if (t == "applicant")
            {
                return string.Format("<div class='mt-2'><a href='InfluencerProfile.aspx?id={0}' class='btn btn-sm btn-outline-secondary py-1 px-3' style='border-radius:6px; font-size:12px; font-weight:600;'>Review Profile</a></div>", id);
            }
            return "";
        }

        public string FormatRelativeTime(object dateObj)
        {
            if (dateObj == null || Convert.IsDBNull(dateObj)) return "Just now";
            DateTime d;
            if (DateTime.TryParse(dateObj.ToString(), out d))
            {
                TimeSpan span = DateTime.Now.Subtract(d);
                if (span.TotalMinutes < 60)
                {
                    return Math.Max(1, (int)span.TotalMinutes) + " minutes ago";
                }
                else if (span.TotalHours < 24)
                {
                    return (int)span.TotalHours + " hours ago";
                }
                else if (span.TotalDays < 2)
                {
                    return "Yesterday at " + d.ToString("HH:mm");
                }
                else
                {
                    return d.ToString("MMM dd, yyyy");
                }
            }
            return dateObj.ToString();
        }
    }
}
