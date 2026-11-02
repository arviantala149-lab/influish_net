<%@ Page Title="Reports &amp; Support" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="ReportsSupport.aspx.cs" Inherits="Influish_net.Admin.ReportsSupport" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Reports &amp; Support
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <h2>Reports &amp; Support</h2>
        <p>Review user complaints, dispute inquiries and support messages.</p>
    </div>

    <!-- Error & Success Messages -->
    <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" style="display:block; margin-bottom:12px;" />
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" style="display:block; margin-bottom:12px; padding:10px 14px; background:#ECFDF5; border:1px solid #10B981; border-radius:6px; color:#065F46; font-size:14px;">
        <asp:Label ID="lblSuccess" runat="server" />
    </asp:Panel>

    <!-- STAT CARDS — 4 summary counts (Demonstrating Connected ADO.NET model per syllabus) -->
    <div class="reports-stats">

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-blue">&#128229;</div>
            <div>
                <div class="report-stat-label">Total Reports</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblTotal" runat="server" Text="0" />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-orange">&#9203;</div>
            <div>
                <div class="report-stat-label">Pending</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblPending" runat="server" Text="0" />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-purple">&#128269;</div>
            <div>
                <div class="report-stat-label">In Review</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblInReview" runat="server" Text="0" />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-green">&#10003;</div>
            <div>
                <div class="report-stat-label">Resolved</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblResolved" runat="server" Text="0" />
                </div>
            </div>
        </div>

    </div>

    <!-- TAB STRIP — All / Reports / Support Messages -->
    <div class="reports-tabs">
        <asp:LinkButton ID="btnTabAll" runat="server" CssClass="report-tab active" Text="All" CommandArgument="" OnClick="FilterTab_Click" />
        <asp:LinkButton ID="btnTabReports" runat="server" CssClass="report-tab" Text="Reports" CommandArgument="Report" OnClick="FilterTab_Click" />
        <asp:LinkButton ID="btnTabSupport" runat="server" CssClass="report-tab" Text="Support Messages" CommandArgument="Support" OnClick="FilterTab_Click" />
    </div>

    <!-- Toolbar: Search -->
    <div class="toolbar" style="margin-bottom:16px;">
        <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search subject or user..." AutoPostBack="true" OnTextChanged="Filter_Changed" />
        </div>
    </div>

    <!-- Data Card with GridView (Demonstrating Disconnected ADO.NET model per syllabus) -->
    <div class="data-card">

        <asp:GridView ID="gvReports" runat="server"
            AutoGenerateColumns="false"
            CssClass="data-table"
            GridLines="None"
            UseAccessibleHeader="true"
            HeaderStyle-CssClass="gv-header"
            RowStyle-CssClass="gv-row">

            <Columns>

                <!-- Column 1: Type badge (Report / Support) -->
                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate>
                        <span class='<%# GetTypeBadge(Eval("ReportType")) %>'>
                            <%# Eval("ReportType") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <!-- Column 2: Subject & Message snippet -->
                <asp:TemplateField HeaderText="Subject">
                    <ItemTemplate>
                        <div style="font-weight:600; color:#1F2937;"><%# Eval("Subject") %></div>
                        <div style="font-size:12px; color:#6B7280; max-width:320px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                            <%# Eval("Message") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <!-- Column 3: Reported By -->
                <asp:BoundField DataField="ReportedBy" HeaderText="Reported By" />

                <!-- Column 4: Date -->
                <asp:BoundField DataField="ReportDate"
                    HeaderText="Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <!-- Column 5: Priority badge -->
                <asp:TemplateField HeaderText="Priority">
                    <ItemTemplate>
                        <span class='<%# GetPriorityBadge(Eval("Priority")) %>'>
                            <%# Eval("Priority") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <!-- Column 6: Status badge -->
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusBadge(Eval("Status")) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <!-- Column 7: Action button -->
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <div style="display:flex; gap:6px;">
                            <asp:LinkButton ID="btnReview" runat="server"
                                CommandName="Review"
                                CommandArgument='<%# Eval("ReportID") %>'
                                Text="In Review"
                                CssClass="btn-action"
                                style="background:#F3F4F6; color:#374151;"
                                Visible='<%# (Eval("Status") ?? "").ToString() == "Pending" %>'
                                OnCommand="btnReview_Command" />

                            <asp:LinkButton ID="btnResolve" runat="server"
                                CommandName="Resolve"
                                CommandArgument='<%# Eval("ReportID") %>'
                                Text='<%# (Eval("Status") ?? "").ToString() == "Resolved" ? "Re-open" : "Resolve" %>'
                                CssClass='<%# (Eval("Status") ?? "").ToString() == "Resolved" ? "btn-action btn-danger-action" : "btn-action btn-primary-action" %>'
                                OnCommand="btnResolve_Command" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">
                    <span class="empty-icon">&#128229;</span>
                    <p>No reports found matching your criteria.</p>
                </div>
            </EmptyDataTemplate>

        </asp:GridView>

        <div class="pagination-row">
            <asp:Label ID="lblCount" runat="server"
                CssClass="pagination-info" Text="Loading..." />
        </div>

    </div>

</asp:Content>
