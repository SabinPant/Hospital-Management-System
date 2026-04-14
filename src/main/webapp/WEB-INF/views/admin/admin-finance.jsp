<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finance | Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-finance.css">
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
            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> <span>Users</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="fas fa-calendar-check"></i> <span>Appointments</span></a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/finance"><i class="fas fa-chart-line"></i> <span>Finance</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/messages"><i class="fas fa-envelope"></i> <span>Messages</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/logs"><i class="fas fa-history"></i> <span>System Logs</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/announcement"><i class="fas fa-bullhorn"></i> <span>Announcement</span></a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1><i class="fas fa-chart-line"></i> Financial Reports</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3><i class="fas fa-dollar-sign"></i> Total Revenue</h3>
                <div class="stat-value">Rs <fmt:formatNumber value="${totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-calendar-month"></i> This Month</h3>
                <div class="stat-value">Rs <fmt:formatNumber value="${monthlyRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-calendar-check"></i> Total Appointments</h3>
                <div class="stat-value">${totalAppointments}</div>
            </div>
            <div class="stat-card">
                <h3><i class="fas fa-chart-simple"></i> Avg per Appointment</h3>
                <div class="stat-value">Rs <fmt:formatNumber value="${avgRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
            </div>
        </div>
        
        <!-- Two Column Layout -->
        <div class="finance-two-columns">
            <!-- Revenue Overview (Bar Chart) -->
            <div class="section-card">
                <div class="section-header">
                    <h2><i class="fas fa-chart-bar"></i> Revenue Overview</h2>
                </div>
                <div class="bar-chart">
                    <c:forEach var="month" items="${monthlyRevenueList}">
                        <c:set var="width" value="${month.revenue / maxRevenue * 100}"/>
                        <div class="bar-item">
                            <span class="bar-label">${month.month}</span>
                            <div class="bar-container">
                                <div class="bar-fill" style="width: ${width}%;">
                                    <c:if test="${width > 15}">${Math.round(width)}%</c:if>
                                </div>
                            </div>
                            <span class="bar-value">Rs <fmt:formatNumber value="${month.revenue}" type="number" minFractionDigits="0"/></span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty monthlyRevenueList}">
                        <div class="empty-state">No revenue data available</div>
                    </c:if>
                </div>
            </div>
            
            <!-- Revenue by Doctor -->
            <div class="section-card">
                <div class="section-header">
                    <h2><i class="fas fa-user-md"></i> Top Doctors by Revenue</h2>
                </div>
                <div class="doctor-list">
                    <c:forEach var="doctor" items="${topDoctors}">
                        <div class="doctor-item">
                            <div class="doctor-info">
                                <div class="doctor-rank">${doctor.rank}</div>
                                <div class="doctor-name">Dr. ${doctor.name}</div>
                            </div>
                            <div class="doctor-stats">
                                <div class="doctor-revenue">Rs <fmt:formatNumber value="${doctor.revenue}" type="number" minFractionDigits="0"/></div>
                                <div class="doctor-appointments">${doctor.appointments} appointments</div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty topDoctors}">
                        <div class="empty-state">No doctor revenue data available</div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <!-- Monthly Revenue Table with Export -->
        <div class="section-card">
            <div class="section-header">
                <h2><i class="fas fa-table"></i> Monthly Revenue</h2>
                <a href="${pageContext.request.contextPath}/admin/export-finance" class="btn-export">
                    <i class="fas fa-file-excel"></i> Export CSV
                </a>
            </div>
            <c:choose>
                <c:when test="${not empty monthlyRevenueList}">
                    <table class="revenue-table">
                        <thead>
                            <tr>
                                <th>Month</th>
                                <th>Revenue</th>
                                <th>Appointments</th>
                                <th>Average</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="month" items="${monthlyRevenueList}">
                                <c:set var="avg" value="${month.revenue / month.count}"/>
                                <tr>
                                    <td>${month.month}</td>
                                    <td>Rs <fmt:formatNumber value="${month.revenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td>${month.count}</td>
                                    <td>Rs <fmt:formatNumber value="${avg}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">No revenue data available</div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Recent Billings -->
        <div class="section-card">
            <div class="section-header">
                <h2><i class="fas fa-receipt"></i> Recent Billings</h2>
            </div>
            <c:choose>
                <c:when test="${not empty recentBillings}">
                    <table class="billings-table">
                        <thead>
                            <tr>
                                <th>Billing ID</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Amount</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="billing" items="${recentBillings}">
                                <tr>
                                    <td>${billing.billing_id}</td>
                                    <td>${billing.patient_name}</td>
                                    <td>Dr. ${billing.doctor_name}</td>
                                    <td>Rs <fmt:formatNumber value="${billing.amount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td><fmt:formatDate value="${billing.payment_date}" pattern="MMM dd, yyyy"/></td>
                                    <td><span class="status-active">${billing.status}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">No billing records found</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>