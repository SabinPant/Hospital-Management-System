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
    <div class="admin-sidebar">
        <jsp:include page="/components/admin-sidebar.jsp">
            <jsp:param name="page" value="appointments" />
        </jsp:include>
    </div>

    <div class="admin-main">
        <div class="admin-topbar">
            <h1><i class="fas fa-calendar-check"></i> Appointments</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        
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
                                <tr class="apt-row"
                                    data-apt-id="${apt.appointment_id}"
                                    data-appointment-date="<fmt:formatDate value="${apt.appointment_date}" pattern="MMM dd, yyyy"/>"
                                    data-appointment-time="${apt.appointment_time}"
                                    data-patient-name="${apt.patient_name}"
                                    data-patient-email="${apt.patient_email != null ? apt.patient_email : 'N/A'}"
                                    data-patient-phone="${apt.patient_phone != null ? apt.patient_phone : 'N/A'}"
                                    data-doctor-name="${apt.doctor_name}"
                                    data-specialization="${apt.specialization != null ? apt.specialization : 'General'}"
                                    data-status="${apt.status}"
                                    data-symptoms="${apt.symptoms != null ? apt.symptoms : ''}"
                                    data-diagnosis="${apt.diagnosis != null ? apt.diagnosis : ''}"
                                    data-prescription="${apt.prescription != null ? apt.prescription : ''}"
                                    data-cancellation-reason="${apt.cancellation_reason != null ? apt.cancellation_reason : ''}">
                                    <td>${apt.appointment_id}</td>
                                    <td><fmt:formatDate value="${apt.appointment_date}" pattern="MMM dd, yyyy"/></td>
                                    <td>${apt.appointment_time}</td>
                                    <td>${apt.patient_name} <small>(${apt.patient_phone})</small></td>
                                    <td>Dr. ${apt.doctor_name}</td>
                                    <td>${apt.specialization != null ? apt.specialization : 'General'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${apt.status == 'pending'}"><span class="status-pending">Pending</span></c:when>
                                            <c:when test="${apt.status == 'confirmed'}"><span class="status-confirmed">Confirmed</span></c:when>
                                            <c:when test="${apt.status == 'completed'}"><span class="status-completed">Completed</span></c:when>
                                            <c:when test="${apt.status == 'cancelled'}"><span class="status-cancelled">Cancelled</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn-view" onclick="openAptModal(this)">
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
<div id="aptModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-file-medical"></i> Appointment Details</h3>
            <span class="modal-close" onclick="closeAptModal()">&times;</span>
        </div>
        <div class="modal-body" id="aptModalBody"></div>
    </div>
</div>

<script>
    // Open modal - reads all data from row's data-* attributes 
    function openAptModal(btn) {
        var row = btn.closest('.apt-row');
        
        var html = '';
        
        // Always visible fields
        html += '<div class="detail-row"><div class="detail-label">Appointment ID</div><div class="detail-value">' + row.getAttribute('data-apt-id') + '</div></div>';
        html += '<div class="detail-row"><div class="detail-label">Patient</div><div class="detail-value">' + row.getAttribute('data-patient-name') + ' (' + row.getAttribute('data-patient-email') + ')</div></div>';
        html += '<div class="detail-row"><div class="detail-label">Doctor</div><div class="detail-value">Dr. ' + row.getAttribute('data-doctor-name') + ' - ' + row.getAttribute('data-specialization') + '</div></div>';
        html += '<div class="detail-row"><div class="detail-label">Date & Time</div><div class="detail-value">' + row.getAttribute('data-appointment-date') + ' at ' + row.getAttribute('data-appointment-time') + '</div></div>';
        html += '<div class="detail-row"><div class="detail-label">Status</div><div class="detail-value">' + row.getAttribute('data-status') + '</div></div>';
        
        var symptoms = row.getAttribute('data-symptoms');
        if (symptoms) {
            html += '<div class="detail-row"><div class="detail-label">Symptoms</div><div class="detail-value">' + symptoms + '</div></div>';
        } else {
            html += '<div class="detail-row"><div class="detail-label">Symptoms</div><div class="detail-value">Not specified</div></div>';
        }
        
        var diagnosis = row.getAttribute('data-diagnosis');
        if (diagnosis) {
            html += '<div class="detail-row"><div class="detail-label">Diagnosis</div><div class="detail-value">' + diagnosis + '</div></div>';
        }
        
        var prescription = row.getAttribute('data-prescription');
        if (prescription) {
            html += '<div class="detail-row"><div class="detail-label">Prescription</div><div class="detail-value">' + prescription + '</div></div>';
        }
        
        var cancellationReason = row.getAttribute('data-cancellation-reason');
        var status = row.getAttribute('data-status');
        if (cancellationReason && status === 'cancelled') {
            html += '<div class="detail-row"><div class="detail-label">Cancellation Reason</div><div class="detail-value">' + cancellationReason + '</div></div>';
        }
        
        document.getElementById('aptModalBody').innerHTML = html;
        document.getElementById('aptModal').classList.add('show');
    }
    
    function closeAptModal() {
        document.getElementById('aptModal').classList.remove('show');
    }
    
    window.onclick = function(event) {
        if (event.target === document.getElementById('aptModal')) {
            closeAptModal();
        }
    }
</script>

</body>
</html>