using System;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

[assembly: System.Web.PreApplicationStartMethod(typeof(Influish_net.RouteConfig), "Start")]

namespace Influish_net
{
    public static class RouteConfig
    {
        public static void Start()
        {
            RegisterRoutes(RouteTable.Routes);
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            routes.EnableFriendlyUrls(settings);

            routes.MapPageRoute("CampaignSingular", "campaign", "~/Campaigns.aspx");
            routes.MapPageRoute("CampaignSingularCap", "Campaign", "~/Campaigns.aspx");
        }
    }
}

