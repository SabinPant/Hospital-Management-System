<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments | Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-appointments.css">
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
            <li class="active"><a href="${pageContext.request.contextPath}/admin/appointments"><i class="fas fa-calendar-check"></i> <span>Appointments</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/finance"><i class="fas fa-chart-line"></i> <span>Finance</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/messages"><i class="fas fa-envelope"></i> <span>Messages</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/logs"><i class="fas fa-history"></i> <span>System Logs</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/announcement"><i class="fas fa-bullhorn"></i> <span>Announcement</span></a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1><i class="fas fa-calendar-check"></i> Appointments</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        
        <!-- Filters and Search -->
        <div class="filter-bar">
            <div class="filter-buttons">
                <a href="${pageContext.request.contextPath}/admin/appointments" class="filter-btn ${empty currentStatus ? 'active' : ''}">All</a>
                <a href="${pageContext.request.contextPath}/admin/appointments?status=pending" class="filter-btn ${currentStatus == 'pending' ? 'active' : ''}">Pending</a>
                <a href="${pageContext.request.contextPath}/admin/appointments?status=confirmed" class="filter-btn ${currentStatus == 'confirmed' ? 'active' : ''}">Confirmed</a>
                <a href="${pageContext.request.contextPath}/admin/appointments?status=completed" class="filter-btn ${currentStatus == 'completed' ? 'active' : ''}">Completed</a>
                <a href="${pageContext.request.contextPath}/admin/appointments?status=cancelled" class="filter-btn ${currentStatus == 'cancelled' ? 'active' : ''}">Cancelled</a>
            </div>
            
            <form method="get" action="${pageContext.request.contextPath}/admin/appointments" class="search-form">
                <c:if test="${not empty currentStatus}">
                    <input type="hidden" name="status" value="${currentStatus}">
                </c:if>
                <input type="text" name="search" placeholder="Search by patient, doctor, or ID..." value="${currentSearch}">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>
        
        <!-- Appointments Table -->
        <div class="dashboard-card">
            <c:choose>
                <c:when test="${not empty appointments}">
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Specialization</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="apt" items="${appointments}">
                                <tr>
    <td>${apt.appointment_id}</td>
    <td><fmt:formatDate value="${apt.appointment_date}" pattern="MMM dd, yyyy"/></td>
    <td>${apt.appointment_time}</td>
    <td>${apt.patient_name} (<small>${apt.patient_phone}</small>)</td>
    <td>Dr. ${apt.doctor_name}</td>
    <td>${apt.specialization != null ? apt.specialization : 'General'}</td>
    <td>
        <c:choose>
            <c:when test="${apt.status == 'pending'}">
                <span class="status-pending">Pending</span>
            </c:when>
            <c:when test="${apt.status == 'confirmed'}">
                <span class="status-confirmed">Confirmed</span>
            </c:when>
            <c:when test="${apt.status == 'completed'}">
                <span class="status-completed">Completed</span>
            </c:when>
            <c:when test="${apt.status == 'cancelled'}">
                <span class="status-cancelled">Cancelled</span>
            </c:when>
        </c:choose>
    </td>
    <td>
        <button class="btn-view" onclick="viewDetails(${apt.id})">
            <i class="fas fa-eye"></i> View
        </button>
    </td>
</tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <p>No appointments found</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Appointment Details Modal -->
<div id="detailsModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-file-medical"></i> Appointment Details</h3>
            <span class="modal-close" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body" id="modalBody"></div>
    </div>
</div>

<script>
    function viewDetails(id) {
        fetch('${pageContext.request.contextPath}/admin/appointment-details?id=' + id)
            .then(response => response.json())
            .then(data => {
                let html = 
                    '<div class="detail-row">' +
                        '<div class="detail-label">Appointment ID</div>' +
                        '<div class="detail-value">' + data.appointment_id + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Patient</div>' +
                        '<div class="detail-value">' + data.patient_name + ' (' + data.patient_email + ')</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Doctor</div>' +
                        '<div class="detail-value">Dr. ' + data.doctor_name + ' - ' + (data.specialization || 'General') + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Date & Time</div>' +
                        '<div class="detail-value">' + data.appointment_date + ' at ' + data.appointment_time + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Status</div>' +
                        '<div class="detail-value">' + data.status + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">Symptoms</div>' +
                        '<div class="detail-value">' + (data.symptoms || 'Not specified') + '</div>' +
                    '</div>';
                    
                if (data.diagnosis) {
                    html += '<div class="detail-row">' +
                        '<div class="detail-label">Diagnosis</div>' +
                        '<div class="detail-value">' + data.diagnosis + '</div>' +
                    '</div>';
                }
                
                if (data.prescription) {
                    html += '<div class="detail-row">' +
                        '<div class="detail-label">Prescription</div>' +
                        '<div class="detail-value">' + data.prescription + '</div>' +
                    '</div>';
                }
                
                if (data.cancellation_reason && data.status === 'cancelled') {
                    html += '<div class="detail-row">' +
                        '<div class="detail-label">Cancellation Reason</div>' +
                        '<div class="detail-value">' + data.cancellation_reason + '</div>' +
                    '</div>';
                }
                
                document.getElementById('modalBody').innerHTML = html;
                document.getElementById('detailsModal').classList.add('show');
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to load appointment details');
            });
    }
    
    function closeModal() {
        document.getElementById('detailsModal').classList.remove('show');
    }
    
    window.onclick = function(event) {
        if (event.target === document.getElementById('detailsModal')) {
            closeModal();
        }
    }
</script>

</body>
</html>