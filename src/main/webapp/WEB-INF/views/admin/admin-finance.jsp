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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin/admin-finance.css">
</head>
<body>

<div class="admin-container">
    <!-- Sidebar -->
    <div class="admin-sidebar">
<jsp:include page="/components/admin-sidebar.jsp">
    <jsp:param name="page" value="finance" />
</jsp:include>
    </div>

    <!-- Main Content -->
   <div class="admin-main">
        <div class="admin-topbar">
                  <h1><i class="fas fa-chart-line"></i> Financial Reports</h1>    
                  <div class="admin-user" style="display: flex; gap: 20px; align-items: center;">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        
              <div class="finance-stats">
            <div class="stat-card">
                <div class="stat-icon" style="background: #e0f2fe; color: #0ea5e9;">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="stat-details">
                    <p style="color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin: 0 0 4px 0;">Total Revenue</p>
                    <h3 style="font-size: 1.5rem; margin: 0; color: #1e293b;">Rs <fmt:formatNumber value="${totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h3>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #dcfce7; color: #10b981;">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div class="stat-details">
                    <p style="color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin: 0 0 4px 0;">This Month</p>
                    <h3 style="font-size: 1.5rem; margin: 0; color: #1e293b;">Rs <fmt:formatNumber value="${monthlyRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h3>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #f3e8ff; color: #a855f7;">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="stat-details">
                    <p style="color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin: 0 0 4px 0;">Appointments</p>
                    <h3 style="font-size: 1.5rem; margin: 0; color: #1e293b;">${totalAppointments}</h3>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #ffedd5; color: #f97316;">
                    <i class="fas fa-chart-pie"></i>
                </div>
                <div class="stat-details">
                    <p style="color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin: 0 0 4px 0;">Avg Per Appt</p>
                    <h3 style="font-size: 1.5rem; margin: 0; color: #1e293b;">Rs <fmt:formatNumber value="${avgRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h3>
                </div>
            </div>
        </div>
        
        <div class="finance-two-columns">
            <div class="dashboard-section" style="margin-bottom: 0;">
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
                        <div class="empty-state" style="text-align: center; padding: 30px; color: #94a3b8;">
                            <i class="fas fa-chart-bar" style="font-size: 2rem; margin-bottom: 10px; opacity: 0.5;"></i>
                            <p style="margin: 0;">No revenue data available</p>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <div class="dashboard-section" style="margin-bottom: 0;">
                <div class="section-header">
                    <h2><i class="fas fa-user-md"></i> Top Doctors by Revenue</h2>
                </div>
                <div class="doctor-list">
                    <c:forEach var="doctor" items="${topDoctors}">
                        <div class="doctor-list-item">
                            <div class="doctor-info-wrap">
                                <div class="doctor-rank-badge">#${doctor.rank}</div>
                                <div>
                                    <div style="font-weight: 600; color: #1e293b; font-size: 0.95rem;">Dr. ${doctor.name}</div>
                                    <div style="font-size: 0.8rem; color: #64748b;">${doctor.appointments} appointments</div>
                                </div>
                            </div>
                            <div class="doctor-revenue-text">
                                Rs <fmt:formatNumber value="${doctor.revenue}" type="number" minFractionDigits="0"/>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty topDoctors}">
                        <div class="empty-state" style="text-align: center; padding: 30px; color: #94a3b8;">
                            <i class="fas fa-user-md" style="font-size: 2rem; margin-bottom: 10px; opacity: 0.5;"></i>
                            <p style="margin: 0;">No doctor revenue data available</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <div class="dashboard-section">
            <div class="section-header">
                <h2><i class="fas fa-table"></i> Monthly Revenue</h2>
                <a href="${pageContext.request.contextPath}/admin/export-finance" class="btn-export">
                    <i class="fas fa-file-excel"></i> Export CSV
                </a>
            </div>
            <c:choose>
                <c:when test="${not empty monthlyRevenueList}">
                    <div class="finance-table-wrapper">
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
                                        <td style="font-weight: 600;">${month.month}</td>
                                        <td style="color: #0ea5e9; font-weight: 600;">Rs <fmt:formatNumber value="${month.revenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        <td>${month.count}</td>
                                        <td>Rs <fmt:formatNumber value="${avg}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" style="text-align: center; padding: 30px; color: #94a3b8;">No revenue data available</div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="dashboard-section">
            <div class="section-header">
                <h2><i class="fas fa-receipt"></i> Recent Billings</h2>
            </div>
            <c:choose>
                <c:when test="${not empty recentBillings}">
                    <div class="finance-table-wrapper">
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
                                        <td style="font-family: monospace; color: #64748b;">#${billing.billing_id}</td>
                                        <td style="font-weight: 500;">${billing.patient_name}</td>
                                        <td>Dr. ${billing.doctor_name}</td>
                                        <td style="font-weight: 600; color: #1e293b;">Rs <fmt:formatNumber value="${billing.amount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        <td><fmt:formatDate value="${billing.payment_date}" pattern="MMM dd, yyyy"/></td>
                                        <td>
                                            <span class="status-badge ${billing.status.toLowerCase() == 'pending' ? 'pending' : 'paid'}">
                                                ${billing.status}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" style="text-align: center; padding: 30px; color: #94a3b8;">No billing records found</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>