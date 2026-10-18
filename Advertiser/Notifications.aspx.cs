using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Influish_net.Advertiser
{
    public partial class Notifications : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadNotifications();
            }
        }

        private string GetConnectionString()
        {
            try
            {
                var conn = ConfigurationManager.ConnectionStrings["InfluishConnection"];
                if (conn != null)
                {
                    return conn.ConnectionString;
                }
            }
            catch
            {
            }
            return string.Empty;
        }

        private void LoadNotifications()
        {
            DataTable dtNotes = new DataTable();
            bool loadedFromDb = false;

            try
            {
                string cs = GetConnectionString();
                if (!string.IsNullOrEmpty(cs) && !cs.Contains("YOUR_SERVER"))
                {
                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        SqlDataAdapter da = new SqlDataAdapter("SELECT NotificationID, Message, CreatedAt, RelatedType, RelatedID FROM Notifications ORDER BY CreatedAt DESC", con);
                        da.Fill(dtNotes);
                        if (dtNotes.Rows.Count > 0)
                        {
                            loadedFromDb = true;
                        }
                    }
                }
            }
            catch (Exception)
            {
            }

            if (!loadedFromDb)
            {
                dtNotes = GetSampleNotifications();
            }

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

        private DataTable GetSampleNotifications()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("NotificationID", typeof(int));
            dt.Columns.Add("Message", typeof(string));
            dt.Columns.Add("CreatedAt", typeof(DateTime));
            dt.Columns.Add("RelatedType", typeof(string));
            dt.Columns.Add("RelatedID", typeof(int));

            dt.Rows.Add(1, "Nike accepted your application for the \"Summer Activewear 2024\" campaign.", DateTime.Now.AddHours(-2), "Acceptance", 1);
            dt.Rows.Add(2, "Alex Fitness applied to your \"Pre-workout Supplement Launch\" campaign.", DateTime.Now.AddHours(-5), "Applicant", 104);
            dt.Rows.Add(3, "Your campaign \"Tech Gadget Review Q3\" is now live and visible to influencers.", DateTime.Now.AddDays(-1).AddHours(2), "CampaignLive", 1);
            dt.Rows.Add(4, "Your account balance is running low (₹1,500 remaining). Please top up to keep campaigns active.", DateTime.Now.AddDays(-1).AddHours(-2), "Billing", 0);
            dt.Rows.Add(5, "Influish platform update: New analytics features are now available in your dashboard.", DateTime.Now.AddDays(-5), "System", 0);

            return dt;
        }

        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            pnlNotice.Visible = true;
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

            if (t == "acceptance")
            {
                return string.Format("<div class='mt-2'><a href='CampaignDetails.aspx?id={0}' class='btn btn-sm btn-primary py-1 px-3' style='background:#7C3AED; border-color:#7C3AED; border-radius:6px; font-size:12px; font-weight:600;'>View Campaign</a></div>", id);
            }
            else if (t == "applicant")
            {
                return string.Format("<div class='mt-2'><a href='InfluencerProfile.aspx?id={0}' class='btn btn-sm btn-outline-secondary py-1 px-3' style='border-radius:6px; font-size:12px; font-weight:600;'>Review Profile</a></div>", id);
            }
            else if (t == "billing")
            {
                return "<div class='mt-2'><a href='#' class='btn btn-sm btn-outline-danger py-1 px-3' style='border-radius:6px; font-size:12px; font-weight:600;'>Add Funds</a></div>";
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
