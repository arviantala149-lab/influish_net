<%@ Page Title="Notifications" Language="VB" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.vb" Inherits="Influish_net.Notifications" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Stay updated on your Influish marketplace activity." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:28px;">
        <div>
            <h1 style="font-size:26px;font-weight:800;color:var(--text-heading);margin-bottom:4px;">Notifications</h1>
            <p style="font-size:14px;color:var(--text-muted);">Stay updated on your marketplace activity.</p>
        </div>
        <asp:LinkButton ID="btnMarkAllRead" runat="server" CssClass="btn btn-ghost" OnClick="btnMarkAllRead_Click"
            style="color:var(--purple-primary); font-weight:600; font-size:14px;">Mark all as read</asp:LinkButton>
    </div>

    <!-- Notification 1 — Unread + Action -->
    <div class="notification-item unread">
        <div class="notif-icon notif-icon-green">✔</div>
        <div style="flex:1;">
            <div class="notif-text">Nike accepted your application for the "Summer Activewear 2024" campaign.</div>
            <div class="notif-time">2 hours ago</div>
            <div style="margin-top:10px;">
                <a href="~/CampaignDetails.aspx?id=1" runat="server" class="btn btn-primary btn-sm">View Campaign</a>
            </div>
        </div>
        <span class="notif-dot"></span>
    </div>

    <!-- Notification 2 — Unread + Avatar -->
    <div class="notification-item unread">
        <img src="https://i.pravatar.cc/80?img=15" alt="Alex Fitness" class="notif-img" />
        <div style="flex:1;">
            <div class="notif-text">Alex Fitness applied to your "Pre-workout Supplement Launch" campaign.</div>
            <div class="notif-time">5 hours ago</div>
            <div style="margin-top:10px;">
                <a href="~/Profile.aspx" runat="server" class="btn btn-outline btn-sm">Review Profile</a>
            </div>
        </div>
        <span class="notif-dot"></span>
    </div>

    <!-- Notification 3 — Read -->
    <div class="notification-item">
        <div class="notif-icon" style="background:var(--purple-light);color:var(--purple-primary);">📢</div>
        <div style="flex:1;">
            <div class="notif-text">Your campaign "Tech Gadget Review Q3" is now live and visible to influencers.</div>
            <div class="notif-time">Yesterday at 14:30</div>
        </div>
    </div>

    <!-- Notification 4 — Read + Action -->
    <div class="notification-item">
        <div class="notif-icon" style="background:#FEE2E2;color:#EF4444;">💳</div>
        <div style="flex:1;">
            <div class="notif-text">Your account balance is running low (&#8377;1,500 remaining). Please top up to keep campaigns active.</div>
            <div class="notif-time">Yesterday at 09:15</div>
            <div style="margin-top:10px;">
                <a href="#" class="btn btn-outline btn-sm">Add Funds</a>
            </div>
        </div>
    </div>

    <!-- Notification 5 — Read -->
    <div class="notification-item">
        <div class="notif-icon notif-icon-gray">ℹ</div>
        <div style="flex:1;">
            <div class="notif-text">Influish platform update: New analytics features are now available in your dashboard.</div>
            <div class="notif-time">Oct 24, 2023</div>
        </div>
    </div>

</asp:Content>
