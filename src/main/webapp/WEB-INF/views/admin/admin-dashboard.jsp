<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.AdminDashboardData, java.util.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("admin_id") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
    
    String adminName = (String) session.getAttribute("admin_name");
    if (adminName == null) adminName = "Admin";
    
    AdminDashboardData data = (AdminDashboardData) request.getAttribute("dashboardData");
    if (data == null) {
        data = new AdminDashboardData();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
</head>
<body>

<div class="admin-container">
    <!-- Sidebar -->
    <div class="admin-sidebar">
        <div class="admin-sidebar-header">
            <h2><i class="fas fa-hospital-user"></i> <span>MediLife</span></h2>
            <p><span>Admin Panel</span></p>
        </div>
        <ul class="admin-nav">
            <li class="active"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> <span>Users</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/doctors"><i class="fas fa-user-md"></i> <span>Doctors</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="fas fa-calendar-check"></i> <span>Appointments</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/logs"><i class="fas fa-history"></i> <span>System Logs</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/announcement"><i class="fas fa-bullhorn"></i> <span>Announcement</span></a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1>Dashboard</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> <%= adminName %></span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3><i class="fas fa-users"></i> Total Users</h3>
                <div class="stat-number"><%= data.getTotalUsers() %></div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-user-md"></i> Total Doctors</h3>
                <div class="stat-number"><%= data.getTotalDoctors() %></div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-user"></i> Total Patients</h3>
                <div class="stat-number"><%= data.getTotalPatients() %></div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-clock"></i> Pending Approvals</h3>
                <div class="stat-number"><%= data.getPendingDoctors() %></div>
            </div>
        </div>

        <!-- Financial Summary -->
        <div class="financial-summary">
            <div class="financial-item">
                <div class="label">Total Revenue</div>
                <div class="value">Rs <%= String.format("%,.2f", data.getTotalRevenue()) %></div>
            </div>
            <div class="financial-item">
                <div class="label">Total Appointments</div>
                <div class="value"><%= data.getTotalCompletedAppointments() %></div>
            </div>
            <div class="financial-item">
                <div class="label">Avg Revenue/Appointment</div>
                <div class="value">Rs <%= String.format("%,.2f", data.getAvgRevenuePerAppointment()) %></div>
            </div>
        </div>

        <!-- Dashboard Grid -->
        <div class="dashboard-grid">
            <!-- Pending Doctors -->
            <div class="dashboard-card">
                <h3><i class="fas fa-user-clock"></i> Pending Doctor Approvals</h3>
                <% if (data.getPendingDoctorsList() != null && !data.getPendingDoctorsList().isEmpty()) { %>
                    <% for (Map<String, Object> doctor : data.getPendingDoctorsList()) { %>
                        <div class="doctor-item">
                            <div class="doctor-info">
                                <h4><%= doctor.get("full_name") %></h4>
                                <p><%= doctor.get("specialization") %> | <%= doctor.get("experience_years") %> yrs exp | License: <%= doctor.get("license_number") %></p>
                            </div>
                            <div class="doctor-actions">
                                <button class="btn-approve" onclick="approveDoctor(<%= doctor.get("id") %>)">Approve</button>
                                <button class="btn-reject" onclick="rejectDoctor(<%= doctor.get("id") %>)">Reject</button>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <p style="text-align: center; color: #64748b; padding: 20px;">No pending approvals</p>
                <% } %>
            </div>

            <!-- Today's Appointments -->
            <div class="dashboard-card">
                <h3><i class="fas fa-calendar-day"></i> Today's Appointments (<%= data.getTodayAppointments() %>)</h3>
                <% if (data.getTodayAppointmentsList() != null && !data.getTodayAppointmentsList().isEmpty()) { %>
                    <% for (Map<String, Object> apt : data.getTodayAppointmentsList()) { %>
                        <div class="appointment-item">
                            <span class="appointment-time"><%= apt.get("appointment_time") %></span>
                            <div class="appointment-info">
                                <p><strong><%= apt.get("doctor_name") %></strong> - <%= apt.get("patient_name") %></p>
                            </div>
                            <span class="appointment-status"><%= apt.get("status") %></span>
                        </div>
                    <% } %>
                <% } else { %>
                    <p style="text-align: center; color: #64748b; padding: 20px;">No appointments today</p>
                <% } %>
            </div>
        </div>

        <!-- Top Doctors -->
        <div class="dashboard-card" style="margin-bottom: 24px;">
            <h3><i class="fas fa-trophy"></i> Top Doctors (By Completed Appointments)</h3>
            <% if (data.getTopDoctorsList() != null && !data.getTopDoctorsList().isEmpty()) { %>
                <% for (Map<String, Object> doctor : data.getTopDoctorsList()) { %>
                    <div class="doctor-item">
                        <div class="doctor-info">
                            <h4><%= doctor.get("rank") %>. <%= doctor.get("full_name") %></h4>
                            <p><%= doctor.get("appointment_count") %> completed appointments</p>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <p style="text-align: center; color: #64748b; padding: 20px;">No data available</p>
            <% } %>
        </div>

        <!-- Monthly Revenue -->
        <div class="dashboard-card">
            <h3><i class="fas fa-chart-line"></i> Monthly Revenue</h3>
            <table class="revenue-table">
                <thead>
                    <tr><th>Month</th><th>Revenue</th></tr>
                </thead>
                <tbody>
                    <% if (data.getMonthlyRevenueList() != null && !data.getMonthlyRevenueList().isEmpty()) { %>
                        <% for (Map<String, Object> month : data.getMonthlyRevenueList()) { %>
                            <tr>
                                <td><%= month.get("month") %></td>
                                <td>Rs <%= String.format("%,.2f", month.get("revenue")) %></td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr><td colspan="2" style="text-align: center;">No revenue data available</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function approveDoctor(doctorId) {
        if(confirm('Approve this doctor?')) {
            window.location.href = '${pageContext.request.contextPath}/admin/approve-doctor?id=' + doctorId;
        }
    }
    
    function rejectDoctor(doctorId) {
        if(confirm('Reject this doctor?')) {
            window.location.href = '${pageContext.request.contextPath}/admin/reject-doctor?id=' + doctorId;
        }
    }
</script>

</body>
</html>