<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/my-appointments.css">
    <style>
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        .modal.show {
            display: flex !important;
        }
    </style>
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="appointments-page">
        <div class="page-header">
            <h1><i class="fas fa-calendar-alt"></i> My Appointments</h1>
            <a href="${pageContext.request.contextPath}/patient/book-appointment" class="btn-new">
                <i class="fas fa-plus"></i> New Appointment
            </a>
        </div>
        
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
        
        <div class="card">
            <c:choose>
                <c:when test="${not empty appointments}">
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th>Appointment ID</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Doctor</th>
                                <th>Specialization</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="apt" items="${appointments}">
                                <c:set var="aptDate"><fmt:formatDate value="${apt.appointmentDate}" pattern="MMM dd, yyyy"/></c:set>
                                <c:set var="aptTime" value="${apt.appointmentTime}"/>
                                <c:set var="aptStatus" value="${apt.status}"/>
                                <c:set var="aptSymptoms" value="${apt.symptoms != null ? apt.symptoms : 'Not specified'}"/>
                                <c:set var="aptDiagnosis" value="${apt.diagnosis != null ? apt.diagnosis : 'Not recorded'}"/>
                                <c:set var="aptPrescription" value="${apt.prescription != null ? apt.prescription : 'Not recorded'}"/>
                                <c:set var="aptCancelReason" value="${apt.cancellationReason != null ? apt.cancellationReason : ''}"/>
                                
                                <tr>
                                    <td>${apt.appointmentId}</td>
                                    <td>${aptDate}</td>
                                    <td>${aptTime}</td>
                                    <td>Dr. ${apt.doctorName}</td>
                                    <td>${apt.doctorSpecialization}</td>
                                    <td><span class="status-${aptStatus}">${aptStatus}</span></td>
                                    <td class="action-buttons">
                                        <button class="btn-view" 
                                            onclick="showAppointmentDetails(
                                                '${apt.doctorName}',
                                                '${apt.doctorSpecialization}',
                                                '${aptDate}',
                                                '${aptTime}',
                                                '${aptStatus}',
                                                '${aptSymptoms}',
                                                '${aptDiagnosis}',
                                                '${aptPrescription}',
                                                '${aptCancelReason}'
                                            )">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                        <c:if test="${apt.status == 'pending'}">
                                            <button class="cancel-btn" onclick="cancelAppointment(${apt.id})">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </c:if>
                                    </td>
                                 </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <p>No appointments found.</p>
                        <a href="${pageContext.request.contextPath}/patient/book-appointment" class="btn-card">Book Your First Appointment</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Appointment Details Modal -->
    <div id="detailsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-file-medical"></i> Appointment Details</h3>
                <span class="modal-close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body" id="modalBody">
                <!-- Dynamic content -->
            </div>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

    <script>
        // Simple function to show modal with data
        function showAppointmentDetails(doctorName, specialization, date, time, status, symptoms, diagnosis, prescription, cancelReason) {
            console.log('Showing details for Dr. ' + doctorName);
            
            const modalBody = document.getElementById('modalBody');
            const modal = document.getElementById('detailsModal');
            
            let cancelHtml = '';
            if (cancelReason && cancelReason !== '' && status === 'cancelled') {
                cancelHtml = '<div class="detail-row">' +
                    '<div class="detail-label">Cancellation Reason</div>' +
                    '<div class="detail-value">' + cancelReason + '</div>' +
                '</div>';
            }
            
            modalBody.innerHTML = 
                '<div class="detail-row">' +
                    '<div class="detail-label">Doctor</div>' +
                    '<div class="detail-value">Dr. ' + doctorName + ' (' + specialization + ')</div>' +
                '</div>' +
                '<div class="detail-row">' +
                    '<div class="detail-label">Date & Time</div>' +
                    '<div class="detail-value">' + date + ' at ' + time + '</div>' +
                '</div>' +
                '<div class="detail-row">' +
                    '<div class="detail-label">Status</div>' +
                    '<div class="detail-value"><span class="status-' + status + '">' + status + '</span></div>' +
                '</div>' +
                '<div class="detail-row">' +
                    '<div class="detail-label">Symptoms / Reason</div>' +
                    '<div class="detail-value">' + symptoms + '</div>' +
                '</div>' +
                '<div class="detail-row">' +
                    '<div class="detail-label">Diagnosis</div>' +
                    '<div class="detail-value">' + diagnosis + '</div>' +
                '</div>' +
                '<div class="detail-row">' +
                    '<div class="detail-label">Prescription</div>' +
                    '<div class="detail-value">' + prescription + '</div>' +
                '</div>' +
                cancelHtml;
            
            modal.classList.add('show');
        }
        
        // Close modal function
        function closeModal() {
            const modal = document.getElementById('detailsModal');
            modal.classList.remove('show');
        }
        
        // Cancel appointment function
        function cancelAppointment(appointmentId) {
            const reason = prompt('Please enter reason for cancellation:');
            if (reason !== null && reason.trim() !== '') {
                window.location.href = '${pageContext.request.contextPath}/patient/cancel-appointment?id=' + appointmentId + '&reason=' + encodeURIComponent(reason);
            } else if (reason !== null) {
                alert('Please provide a reason for cancellation');
            }
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('detailsModal');
            if (event.target === modal) {
                modal.classList.remove('show');
            }
        }
    </script>

</body>
</html>