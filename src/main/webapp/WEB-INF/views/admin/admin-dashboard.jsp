<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
            <li><a href="${pageContext.request.contextPath}/admin/messages"><i class="fas fa-envelope"></i> <span>Messages</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/logs"><i class="fas fa-history"></i> <span>System Logs</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/announcement"><i class="fas fa-bullhorn"></i> <span>Announcement</span></a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <!-- Success/Error Messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${param.success}
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${param.error}
            </div>
        </c:if>
        
        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1>Dashboard</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3><i class="fas fa-users"></i> Total Users</h3>
                <div class="stat-number">${dashboardData.totalUsers}</div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-user-md"></i> Total Doctors</h3>
                <div class="stat-number">${dashboardData.totalDoctors}</div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-user"></i> Total Patients</h3>
                <div class="stat-number">${dashboardData.totalPatients}</div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-clock"></i> Pending Approvals</h3>
                <div class="stat-number">${dashboardData.pendingDoctors}</div>
            </div>
        </div>

        <!-- Financial Summary -->
        <div class="financial-summary">
            <div class="financial-item">
                <div class="label">Total Revenue</div>
                <div class="value">Rs <fmt:formatNumber value="${dashboardData.totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
            </div>
            <div class="financial-item">
                <div class="label">Total Appointments</div>
                <div class="value">${dashboardData.totalCompletedAppointments}</div>
            </div>
            <div class="financial-item">
                <div class="label">Avg Revenue/Appointment</div>
                <div class="value">Rs <fmt:formatNumber value="${dashboardData.avgRevenuePerAppointment}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
            </div>
        </div>

        <!-- Dashboard Grid -->
        <div class="dashboard-grid">
            <!-- Pending Doctors -->
            <div class="dashboard-card">
                <h3><i class="fas fa-user-clock"></i> Pending Doctor Approvals</h3>
                <c:choose>
                    <c:when test="${not empty dashboardData.pendingDoctorsList}">
                        <c:forEach var="doctor" items="${dashboardData.pendingDoctorsList}">
                            <div class="doctor-item">
                                <div class="doctor-info">
                                    <h4>${doctor.full_name}</h4>
                                    <p>${doctor.specialization} | ${doctor.experience_years} yrs exp | License: ${doctor.license_number}</p>
                                </div>
                                <div class="doctor-actions">
                                    <button class="btn-approve" onclick="approveDoctor(${doctor.id})">Approve</button>
                                    <button class="btn-reject" onclick="rejectDoctor(${doctor.id})">Reject</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; color: #64748b; padding: 20px;">No pending approvals</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Today's Appointments -->
            <div class="dashboard-card">
                <h3><i class="fas fa-calendar-day"></i> Today's Appointments (${dashboardData.todayAppointments})</h3>
                <c:choose>
                    <c:when test="${not empty dashboardData.todayAppointmentsList}">
                        <c:forEach var="apt" items="${dashboardData.todayAppointmentsList}">
                            <div class="appointment-item">
                                <span class="appointment-time">${apt.appointment_time}</span>
                                <div class="appointment-info">
                                    <p><strong>${apt.doctor_name}</strong> - ${apt.patient_name}</p>
                                </div>
                                <span class="appointment-status">${apt.status}</span>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; color: #64748b; padding: 20px;">No appointments today</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Top Doctors -->
        <div class="dashboard-card" style="margin-bottom: 24px;">
            <h3><i class="fas fa-trophy"></i> Top Doctors (By Completed Appointments)</h3>
            <c:choose>
                <c:when test="${not empty dashboardData.topDoctorsList}">
                    <c:forEach var="doctor" items="${dashboardData.topDoctorsList}">
                        <div class="doctor-item">
                            <div class="doctor-info">
                                <h4>${doctor.rank}. ${doctor.full_name}</h4>
                                <p>${doctor.appointment_count} completed appointments</p>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="text-align: center; color: #64748b; padding: 20px;">No data available</p>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Recent Messages & Monthly Revenue Grid -->
        <div class="dashboard-grid">
            <!-- Recent Contact Messages -->
            <div class="dashboard-card">
                <h3><i class="fas fa-envelope"></i> Recent Contact Messages</h3>
                <c:choose>
                    <c:when test="${not empty recentMessages}">
                        <c:forEach var="msg" items="${recentMessages}">
                            <div class="message-item">
                                <h4>${msg.name} - ${msg.subject}</h4>
                                <p>
                                    <c:choose>
                                        <c:when test="${msg.message.length() > 60}">
                                            ${msg.message.substring(0, 60)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${msg.message}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <span class="message-date">${msg.createdAt}</span>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <p>No messages yet</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Monthly Revenue -->
            <div class="dashboard-card">
                <h3><i class="fas fa-chart-line"></i> Monthly Revenue</h3>
                
                <table class="revenue-table">
                    <thead>
                        <tr><th>Month</th><th>Revenue</th></tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty dashboardData.monthlyRevenueList}">
                                <c:forEach var="month" items="${dashboardData.monthlyRevenueList}">
                                    <tr>
                                        <td>${month.month}</td>
                                        <td>Rs <fmt:formatNumber value="${month.revenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="2" class="empty-state">No revenue data available</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
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
        let reason = prompt('Please enter reason for rejection:');
        if(reason !== null && reason.trim() !== '') {
            window.location.href = '${pageContext.request.contextPath}/admin/reject-doctor?id=' + doctorId + '&reason=' + encodeURIComponent(reason);
        } else if(reason !== null) {
            alert('Please provide a reason for rejection');
        }
    }
</script>

</body>
</html>