<%@ Page Title="Notifications" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="Influish_net.Notifications" %>

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

    <asp:Panel ID="pnlNotice" runat="server" Visible="false" style="background:#DCFCE7; color:#15803D; padding:12px; border-radius:8px; margin-bottom:16px; font-size:13px; font-weight:500;">
        ✓ All notifications marked as read.
    </asp:Panel>

    <asp:Repeater ID="rptNotifications" runat="server">
        <ItemTemplate>
            <div class='<%# "notification-item " + (Convert.ToBoolean(Eval("IsRead")) ? "" : "unread") %>'>
                <div class='<%# GetIconClass(Eval("RelatedType")) %>'>
                    <%# GetIconSymbol(Eval("RelatedType")) %>
                </div>
                <div style="flex:1;">
                    <div class="notif-text"><%# Eval("Message") %></div>
                    <div class="notif-time"><%# FormatTime(Eval("CreatedAt")) %></div>
                    <%# GetActionButton(Eval("RelatedType"), Eval("RelatedID")) %>
                </div>
                <%# Convert.ToBoolean(Eval("IsRead")) ? "" : "<span class=\"notif-dot\"></span>" %>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" style="padding:48px 24px; text-align:center; background:#fff; border-radius:12px; border:1px solid #E5E7EB; margin-top:16px;">
        <div style="font-size:40px; margin-bottom:12px;">🔔</div>
        <h3 style="font-size:18px; color:var(--text-heading); font-weight:700;">No notifications yet</h3>
        <p style="color:var(--text-muted); font-size:14px;">You're all caught up! Updates regarding campaign applications and messages will appear here.</p>
    </asp:Panel>

</asp:Content>
