<%@ Page Title="My Applications" Language="VB" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Applications.aspx.vb" Inherits="Influish_net.Applications" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Track the status of your campaign applications across brands." />
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <h1>My Applications</h1>
        <p>Track the status of your campaign applications across brands.</p>
    </div>

    <!-- Tabs -->
    <div class="tab-nav" id="appTabs">
        <button class="tab-btn active" id="tabAll" onclick="filterTable('all')">All</button>
        <button class="tab-btn" id="tabPending" onclick="filterTable('pending')">Pending</button>
        <button class="tab-btn" id="tabAccepted" onclick="filterTable('accepted')">Accepted</button>
        <button class="tab-btn" id="tabRejected" onclick="filterTable('rejected')">Rejected</button>
    </div>

    <!-- Table Card -->
    <div class="card card-shadow">
        <table class="influish-table" id="applicationsTable">
            <thead>
                <tr>
                    <th>Campaign &amp; Brand</th>
                    <th>Budget</th>
                    <th>Applied Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr data-status="accepted">
                    <td>
                        <div class="table-brand-cell">
                            <img src="https://ui-avatars.com/api/?name=SH&background=8B5CF6&color=fff&size=40" alt="StyleHub India" />
                            <div>
                                <div class="brand-name">Diwali Festive Wear Launch</div>
                                <div class="brand-company">StyleHub India</div>
                            </div>
                        </div>
                    </td>
                    <td style="font-size:15px; font-weight:700; color:var(--text-heading);">&#8377; 15,000</td>
                    <td>Oct 12, 2024</td>
                    <td><span class="badge badge-accepted">Accepted</span></td>
                </tr>
                <tr data-status="pending">
                    <td>
                        <div class="table-brand-cell">
                            <img src="https://ui-avatars.com/api/?name=GC&background=10B981&color=fff&size=40" alt="GlowCare" />
                            <div>
                                <div class="brand-name">Summer Skincare Routine Series</div>
                                <div class="brand-company">GlowCare</div>
                            </div>
                        </div>
                    </td>
                    <td style="font-size:15px; font-weight:700; color:var(--text-heading);">&#8377; 22,500</td>
                    <td>Oct 15, 2024</td>
                    <td><span class="badge badge-pending">Pending</span></td>
                </tr>
                <tr data-status="rejected">
                    <td>
                        <div class="table-brand-cell">
                            <img src="https://ui-avatars.com/api/?name=TV&background=0EA5E9&color=fff&size=40" alt="TechVibe" />
                            <div>
                                <div class="brand-name">Smartwatch Review — Series 9</div>
                                <div class="brand-company">TechVibe</div>
                            </div>
                        </div>
                    </td>
                    <td style="font-size:15px; font-weight:700; color:var(--text-heading);">&#8377; 8,000</td>
                    <td>Oct 08, 2024</td>
                    <td><span class="badge badge-rejected">Rejected</span></td>
                </tr>
                <tr data-status="pending">
                    <td>
                        <div class="table-brand-cell">
                            <img src="https://ui-avatars.com/api/?name=UB&background=F59E0B&color=fff&size=40" alt="UrbanBites" />
                            <div>
                                <div class="brand-name">Weekend Foodie Reels</div>
                                <div class="brand-company">UrbanBites</div>
                            </div>
                        </div>
                    </td>
                    <td style="font-size:15px; font-weight:700; color:var(--text-heading);">&#8377; 12,000</td>
                    <td>Oct 18, 2024</td>
                    <td><span class="badge badge-pending">Pending</span></td>
                </tr>
            </tbody>
        </table>

        <!-- Pagination -->
        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:20px; padding-top:16px; border-top:1px solid var(--border-light);">
            <span style="font-size:13px; color:var(--text-muted);">Showing 1 to 4 of 12 entries</span>
            <div class="pagination">
                <span class="page-nav">Prev</span>
                <button class="page-btn active">1</button>
                <button class="page-btn">2</button>
                <button class="page-btn">3</button>
                <span class="page-nav">Next</span>
            </div>
        </div>
    </div>

    <script>
        function filterTable(status) {
            var rows = document.querySelectorAll('#applicationsTable tbody tr');
            rows.forEach(function (r) {
                r.style.display = (status === 'all' || r.dataset.status === status) ? '' : 'none';
            });
            document.querySelectorAll('.tab-btn').forEach(function (b) { b.classList.remove('active'); });
            event.target.classList.add('active');
        }
    </script>

</asp:Content>
