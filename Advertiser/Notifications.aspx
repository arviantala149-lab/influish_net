<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs"
    Inherits="Influish_net.Advertiser.Notifications" MasterPageFile="~/Advertiser/AdvertiserMaster.master"
    Title="Notifications" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <!-- Breadcrumb -->
        <div class="influish-breadcrumb">
            <a href="Dashboard.aspx">Dashboard</a>
            <span>/</span>
            <span class="text-dark fw-medium">Notifications</span>
        </div>

        <!-- Page Header & Action (Figma Page 14) -->
        <div class="page-header-row align-items-center">
            <div>
                <h1 class="page-title">Notifications</h1>
                <p class="page-subtitle">Stay updated on your marketplace activity.</p>
            </div>
            <div>
                <asp:LinkButton ID="btnMarkAllRead" runat="server" CssClass="text-secondary small fw-medium"
                    OnClick="btnMarkAllRead_Click">
                    Mark all as read
                </asp:LinkButton>
            </div>
        </div>

        <!-- Notice alert if marked read -->
        <asp:Panel ID="pnlNotice" runat="server" Visible="false" CssClass="mb-3">
            <div class="alert alert-success py-2 small" role="alert">
                All notifications have been marked as read.
            </div>
        </asp:Panel>

        <!-- Notifications List (Figma Page 14) -->
        <div style="max-width: 900px;">
            <asp:Repeater ID="rptNotifications" runat="server">
                <ItemTemplate>
                    <div class="notification-card">
                        <div class="notification-left">
                            <div class="notification-icon-wrap" style='<%# GetIconBackground(Eval("RelatedType")) %>'>
                                <asp:Literal ID="litIconSvg" runat="server" Text='<%# GetIconSvg(Eval("RelatedType")) %>' />
                            </div>
                            <div>
                                <div class="fw-medium text-dark" style="font-size: 14px; line-height: 1.4;">
                                    <%# Eval("Message") %>
                                </div>
                                <div class="text-muted small mt-1">
                                    <%# FormatRelativeTime(Eval("CreatedAt")) %>
                                </div>
                                <asp:Literal ID="litActionButton" runat="server" Text='<%# GetActionButton(Eval("RelatedType"), Eval("RelatedID")) %>' />
                            </div>
                        </div>

                        <div>
                            <span
                                style="display:inline-block; width:8px; height:8px; border-radius:50%; background-color:#8B5CF6;"></span>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlEmptyNotes" runat="server" Visible="false">
                <div class="influish-card text-center p-5">
                    <div style="font-size: 36px; color: var(--text-muted); margin-bottom: 8px;">🔔</div>
                    <h5 class="fw-bold">No notifications yet</h5>
                    <p class="text-secondary small">You will receive updates here as influencers apply and interact with
                        your campaigns.</p>
                </div>
            </asp:Panel>
        </div>
    </asp:Content>