using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;

namespace Influish_net.Helpers
{
    public static class AuthHelper
    {
        private const string COOKIE_NAME = "InfluishAuth";

        public static string HashPassword(string password)
        {
            if (string.IsNullOrEmpty(password)) return string.Empty;
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return sb.ToString();
            }
        }

        public static bool VerifyPassword(string inputPassword, string storedHash, out bool needsUpgrade)
        {
            needsUpgrade = false;
            if (string.IsNullOrEmpty(inputPassword) || string.IsNullOrEmpty(storedHash))
            {
                return false;
            }

            string hashedInput = HashPassword(inputPassword);
            if (string.Equals(hashedInput, storedHash, StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }

            // Check if stored as plaintext (legacy seed data: e.g. Creator@123, Brand@123, Abc@1234)
            if (string.Equals(inputPassword, storedHash, StringComparison.Ordinal))
            {
                needsUpgrade = true;
                return true;
            }

            return false;
        }

        public static void UpgradePasswordHash(int userId, string plainPassword)
        {
            try
            {
                string newHash = HashPassword(plainPassword);
                DbHelper.ExecuteNonQuery(
                    "UPDATE Users SET PasswordHash = @hash WHERE UserID = @uid",
                    new SqlParameter("@hash", newHash),
                    new SqlParameter("@uid", userId)
                );
            }
            catch
            {
                // Non-fatal if upgrade fails
            }
        }

        public static void LoginUser(HttpContext context, int userId, string email, string fullName, string role, bool rememberMe)
        {
            var session = context.Session;
            session["UserID"] = userId;
            session["Email"] = email;
            session["FullName"] = fullName;
            session["User"] = fullName; // backward compatibility
            session["Role"] = role;

            int influencerId = 0;
            int companyId = 0;

            if (role.Equals("Influencer", StringComparison.OrdinalIgnoreCase))
            {
                object infIdObj = DbHelper.ExecuteScalar(
                    "SELECT InfluencerID FROM Influencers WHERE UserID = @uid",
                    new SqlParameter("@uid", userId)
                );
                if (infIdObj != null && infIdObj != DBNull.Value)
                {
                    influencerId = Convert.ToInt32(infIdObj);
                }
                else
                {
                    // If no Influencer profile exists yet, create one
                    object newInfId = DbHelper.ExecuteScalar(
                        "INSERT INTO Influencers (UserID, Name, Category, FollowerCount, Bio, City) OUTPUT INSERTED.InfluencerID VALUES (@uid, @name, 'Lifestyle, Tech', 0, '', 'Ahmedabad')",
                        new SqlParameter("@uid", userId),
                        new SqlParameter("@name", fullName)
                    );
                    if (newInfId != null && newInfId != DBNull.Value)
                    {
                        influencerId = Convert.ToInt32(newInfId);
                    }
                }
                session["InfluencerID"] = influencerId;
            }
            else if (role.Equals("Advertiser", StringComparison.OrdinalIgnoreCase))
            {
                object compIdObj = DbHelper.ExecuteScalar(
                    "SELECT CompanyID FROM Companies WHERE UserID = @uid",
                    new SqlParameter("@uid", userId)
                );
                if (compIdObj != null && compIdObj != DBNull.Value)
                {
                    companyId = Convert.ToInt32(compIdObj);
                }
                else
                {
                    // If no Company profile exists yet, create one
                    object newCompId = DbHelper.ExecuteScalar(
                        "INSERT INTO Companies (UserID, CompanyName, ContactPerson, Email) OUTPUT INSERTED.CompanyID VALUES (@uid, @cname, @cp, @email)",
                        new SqlParameter("@uid", userId),
                        new SqlParameter("@cname", fullName),
                        new SqlParameter("@cp", fullName),
                        new SqlParameter("@email", email)
                    );
                    if (newCompId != null && newCompId != DBNull.Value)
                    {
                        companyId = Convert.ToInt32(newCompId);
                    }
                }
                session["CompanyID"] = companyId;
            }
            else if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                session["AdminLoggedIn"] = true;
                session["AdminName"] = fullName;
                session["AdminRole"] = "System Admin";
            }

            if (rememberMe)
            {
                HttpCookie authCookie = new HttpCookie(COOKIE_NAME);
                authCookie.Values["UserID"] = userId.ToString();
                authCookie.Values["Email"] = email;
                authCookie.Values["Role"] = role;
                authCookie.Values["FullName"] = HttpUtility.UrlEncode(fullName);
                authCookie.Expires = DateTime.Now.AddDays(14);
                authCookie.HttpOnly = true;
                context.Response.Cookies.Add(authCookie);
            }
        }

        public static void Logout(HttpContext context)
        {
            if (context.Session != null)
            {
                context.Session.Clear();
                context.Session.Abandon();
            }

            if (context.Request.Cookies[COOKIE_NAME] != null)
            {
                HttpCookie c = new HttpCookie(COOKIE_NAME);
                c.Expires = DateTime.Now.AddDays(-1);
                context.Response.Cookies.Add(c);
            }
        }

        public static bool CheckAndRestoreSession(HttpContext context)
        {
            if (context.Session != null && context.Session["UserID"] != null && context.Session["Role"] != null)
            {
                return true;
            }

            HttpCookie authCookie = context.Request.Cookies[COOKIE_NAME];
            if (authCookie != null && !string.IsNullOrEmpty(authCookie.Values["UserID"]))
            {
                int uid;
                if (int.TryParse(authCookie.Values["UserID"], out uid))
                {
                    string email = authCookie.Values["Email"];
                    string role = authCookie.Values["Role"];
                    string fullName = HttpUtility.UrlDecode(authCookie.Values["FullName"]);

                    // Verify against database that user is active
                    DataTable dt = DbHelper.ExecuteDataTable(
                        "SELECT UserID, FullName, Email, Role, Status FROM Users WHERE UserID = @uid",
                        new SqlParameter("@uid", uid)
                    );

                    if (dt.Rows.Count > 0 && dt.Rows[0]["Status"].ToString().Equals("Active", StringComparison.OrdinalIgnoreCase))
                    {
                        LoginUser(context, uid, dt.Rows[0]["Email"].ToString(), dt.Rows[0]["FullName"].ToString(), dt.Rows[0]["Role"].ToString(), false);
                        return true;
                    }
                }
            }

            return false;
        }

        public static void RequireRole(Page page, string expectedRole)
        {
            HttpContext context = HttpContext.Current;
            bool isAuthenticated = CheckAndRestoreSession(context);

            if (!isAuthenticated)
            {
                string returnUrl = page.Request.RawUrl;
                page.Response.Redirect("~/Login.aspx?returnUrl=" + page.Server.UrlEncode(returnUrl), true);
                return;
            }

            string actualRole = context.Session["Role"] != null ? context.Session["Role"].ToString() : "";
            if (!actualRole.Equals(expectedRole, StringComparison.OrdinalIgnoreCase))
            {
                // Not authorized for this role, redirect to their proper dashboard
                page.Response.Redirect(GetRoleDashboardUrl(actualRole), true);
            }
        }

        public static void RequireAnyAuth(Page page)
        {
            HttpContext context = HttpContext.Current;
            bool isAuthenticated = CheckAndRestoreSession(context);

            if (!isAuthenticated)
            {
                string returnUrl = page.Request.RawUrl;
                page.Response.Redirect("~/Login.aspx?returnUrl=" + page.Server.UrlEncode(returnUrl), true);
            }
        }

        public static string GetRoleDashboardUrl(string role)
        {
            if (string.IsNullOrEmpty(role)) return "~/Login.aspx";

            switch (role.ToLower())
            {
                case "influencer":
                    return "~/Dashboard.aspx";
                case "advertiser":
                    return "~/Advertiser/Dashboard.aspx";
                case "admin":
                    return "~/Admin/Dashboard.aspx";
                default:
                    return "~/Default.aspx";
            }
        }
    }
}
