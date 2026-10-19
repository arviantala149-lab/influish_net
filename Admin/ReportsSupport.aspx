<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master"
         CodeFile="ReportsSupport.aspx.cs" Inherits="Admin_ReportsSupport" %>
<%--
    ================================================================
    Admin/ReportsSupport.aspx  -  Reports & Support Page
    Language    : C# (code-behind: ReportsSupport.aspx.cs)
    Master Page : AdminMaster.master
    Syllabus    : Section 6 - GridView, Label, Controls
                  Section 7 - ADO.NET: SqlCommand+SqlDataReader (Connected)
                              and SqlDataAdapter+DataTable (Disconnected)
    ================================================================
    NOTE ON ADO.NET MODELS USED HERE:
    1. CONNECTED model   - SqlCommand + ExecuteScalar for the 4 stat counts
    2. DISCONNECTED model - SqlDataAdapter + DataTable for the GridView rows
    ================================================================
--%>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">
    Reports &amp; Support
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%-- Page Header --%>
    <div class="page-header">
        <h2>Reports &amp; Support</h2>
        <p>Review user complaints and support messages.</p>
    </div>

    <%-- Error Label --%>
    <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />

    <%-- STAT CARDS: 4 summary counts (Connected ADO.NET) --%>
    <div class="reports-stats">

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-blue">&#128229;</div>
            <div>
                <div class="report-stat-label">Total Reports</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblTotal" runat="server" Text="..." />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-orange">&#9203;</div>
            <div>
                <div class="report-stat-label">Pending</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblPending" runat="server" Text="..." />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-purple">&#128269;</div>
            <div>
                <div class="report-stat-label">In Review</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblInReview" runat="server" Text="..." />
                </div>
            </div>
        </div>

        <div class="report-stat-card">
            <div class="report-stat-icon rsi-green">&#10003;</div>
            <div>
                <div class="report-stat-label">Resolved</div>
                <div class="report-stat-value">
                    <asp:Label ID="lblResolved" runat="server" Text="..." />
                </div>
            </div>
        </div>

    </div>

    <%-- TAB STRIP --%>
    <div class="reports-tabs">
        <button type="button" class="report-tab active">All</button>
        <button type="button" class="report-tab">Reports</button>
        <button type="button" class="report-tab">Support Messages</button>
    </div>

    <%-- Toolbar: Search --%>
    <div class="toolbar" style="margin-bottom:16px;">
        <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <input type="text" id="txtSearch" class="search-input"
                   placeholder="Search subject or user..." />
        </div>
        <button type="button" class="btn-action btn-primary-action">
            &#9744; Filter
        </button>
    </div>

    <%-- Data Card with GridView --%>
    <div class="data-card">

        <asp:GridView ID="gvReports" runat="server"
            AutoGenerateColumns="false"
            CssClass="data-table"
            GridLines="None"
            UseAccessibleHeader="true"
            HeaderStyle-CssClass="gv-header"
            RowStyle-CssClass="gv-row">

            <Columns>

                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate>
                        <span class='<%# GetTypeBadge(Eval("ReportType")) %>'>
                            <%# Eval("ReportType") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Subject" HeaderText="Subject" />
                <asp:BoundField DataField="ReportedBy" HeaderText="Reported By" />

                <asp:BoundField DataField="ReportDate"
                    HeaderText="Date"
                    DataFormatString="{0:dd MMM yyyy}" />

                <asp:TemplateField HeaderText="Priority">
                    <ItemTemplate>
                        <span class='<%# GetPriorityBadge(Eval("Priority")) %>'>
                            <%# Eval("Priority") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='<%# GetStatusBadge(Eval("Status")) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <a href="#" class="btn-action btn-primary-action">View Details</a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

            <EmptyDataTemplate>
                <div class="empty-state">
                    <span class="empty-icon">&#128229;</span>
                    <p>No reports found. Add records to the Reports table first.</p>
                </div>
            </EmptyDataTemplate>

        </asp:GridView>

        <div class="pagination-row">
            <asp:Label ID="lblCount" runat="server"
                CssClass="pagination-info" Text="Loading..." />
        </div>

    </div>

</asp:Content>
