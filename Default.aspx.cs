using System;
using System.Web.UI;
using Influish_net.Helpers;

namespace Influish_net
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStats();
            }
        }

        private void LoadStats()
        {
            try
            {
                object infObj = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Role = 'Influencer'");
                int infCount = infObj != null ? Convert.ToInt32(infObj) : 0;
                litInfCount.Text = (infCount > 0 ? (infCount + 850).ToString("N0") : "850") + "+";

                object advObj = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Role = 'Advertiser'");
                int advCount = advObj != null ? Convert.ToInt32(advObj) : 0;
                litAdvCount.Text = (advCount > 0 ? (advCount + 400).ToString("N0") : "400") + "+";

                object campObj = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Campaigns");
                int campCount = campObj != null ? Convert.ToInt32(campObj) : 0;
                litCampCount.Text = (campCount > 0 ? (campCount + 12000).ToString("N0") : "12K") + "+";

                litEarnings.Text = "₹50M+";
            }
            catch
            {
                litInfCount.Text = "850+";
                litAdvCount.Text = "400+";
                litCampCount.Text = "12K+";
                litEarnings.Text = "₹50M+";
            }
        }
    }
}
