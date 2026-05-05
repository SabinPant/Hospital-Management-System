<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <style>
        .details-container {
            max-width: 600px;
            margin: 60px auto;
            padding: 0 20px;
        }
        
        .details-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .details-header {
            background: #0a5c8e;
            padding: 25px;
            text-align: center;
        }
        
        .details-header h1 {
            color: white;
            margin: 0;
            font-size: 1.5rem;
        }
        
        .details-body {
            padding: 30px;
        }
        
        .detail-row {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .detail-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-size: 1rem;
            color: #1e293b;
            font-weight: 500;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-pending { background: #fef3c7; color: #d97706; }
        .status-confirmed { background: #dcfce7; color: #16a34a; }
        .status-completed { background: #e0e7ff; color: #4f46e5; }
        .status-cancelled { background: #fee2e2; color: #dc2626; }
        
        .btn-back {
            background: #0a5c8e;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 30px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back:hover {
            background: #074268;
        }
        
        .btn-cancel {
            background: white;
            color: #dc2626;
            border: 1.5px solid #dc2626;
            padding: 12px 24px;
            border-radius: 30px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            margin-left: 10px;
        }
        
        .btn-cancel:hover {
            background: #dc2626;
            color: white;
        }
        
        .action-buttons {
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="details-container">
        <div class="details-card">
            <div class="details-header">
                <h1><i class="fas fa-file-medical"></i> Appointment Details</h1>
            </div>
            <div class="details-body">
                <div class="detail-row">
                    <div class="detail-label">Appointment ID</div>
                    <div class="detail-value">${appointment.appointmentId}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Doctor</div>
                    <div class="detail-value">Dr. ${appointment.doctorName} — ${appointment.doctorSpecialization}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Date & Time</div>
                    <div class="detail-value">
                        <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM dd, yyyy"/> • ${appointment.appointmentTime}
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Status</div>
                    <div class="detail-value">
                        <span class="status-badge status-${appointment.status}">${appointment.status}</span>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Symptoms / Reason</div>
                    <div class="detail-value">${appointment.symptoms != null ? appointment.symptoms : 'Not specified'}</div>
                </div>
                
                <c:if test="${not empty appointment.diagnosis}">
                    <div class="detail-row">
                        <div class="detail-label">Diagnosis</div>
                        <div class="detail-value">${appointment.diagnosis}</div>
                    </div>
                </c:if>
                
                <c:if test="${not empty appointment.prescription}">
                    <div class="detail-row">
                        <div class="detail-label">Prescription</div>
                        <div class="detail-value">${appointment.prescription}</div>
                    </div>
                </c:if>
                
                <c:if test="${not empty appointment.cancellationReason && appointment.status == 'cancelled'}">
                    <div class="detail-row">
                        <div class="detail-label">Cancellation Reason</div>
                        <div class="detail-value">${appointment.cancellationReason}</div>
                    </div>
                </c:if>
                
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/patient/appointments" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Back to Appointments
                    </a>
                    <c:if test="${appointment.status == 'pending'}">
                        <button class="btn-cancel" onclick="cancelAppointment(${appointment.id})">
                            <i class="fas fa-times"></i> Cancel Appointment
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

    <script>
        function cancelAppointment(id) {
            var reason = prompt('Please enter a reason for cancellation:');
            if (reason !== null && reason.trim() !== '') {
                window.location.href = '${pageContext.request.contextPath}/patient/cancel-appointment?id=' + id + '&reason=' + encodeURIComponent(reason);
            } else if (reason !== null) {
                alert('Please provide a reason for cancellation.');
            }
        }
    </script>

</body>
</html>