<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Medical History | Doctor Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/doctor-dashboard.css">
    <style>
        .history-container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .patient-info-card {
            background: linear-gradient(135deg, #0a5c8e, #074268);
            color: white;
            padding: 25px;
            border-radius: 16px;
            margin-bottom: 30px;
        }
        
        .patient-info-card h2 {
            color: white;
            margin-bottom: 5px;
        }
        
        .history-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .history-table th {
            text-align: left;
            padding: 14px;
            background: #f8fafc;
            color: #1e293b;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .history-table td {
            padding: 12px 14px;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: top;
        }
        
        .diagnosis-cell {
            background: #f0fdf4;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.85rem;
        }
        
        .prescription-cell {
            background: #fef3c7;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.85rem;
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #0a5c8e;
            text-decoration: none;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px;
            color: #64748b;
            background: white;
            border-radius: 12px;
        }
    </style>
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="history-container">
        <div class="patient-info-card">
            <h2><i class="fas fa-user-circle"></i> ${patientName}</h2>
            <p>Medical history of all completed appointments</p>
        </div>
        
        <c:choose>
            <c:when test="${not empty medicalHistory}">
                <table class="history-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Appointment ID</th>
                            <th>Diagnosis</th>
                            <th>Prescription</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="record" items="${medicalHistory}">
    <tr>
        <td><fmt:formatDate value="${record.appointment_date}" pattern="MMM dd, yyyy"/></td>
        <td>${record.appointment_id}</td>
        <td><span class="diagnosis-cell">${record.diagnosis != null ? record.diagnosis : '—'}</span></td>
        <td><span class="prescription-cell">${record.prescription != null ? record.prescription : '—'}</span></td>
        <td>${record.notes != null ? record.notes : '—'}</td>
    </tr>
</c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-notes-medical"></i>
                    <p>No medical history found for this patient.</p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <a href="${pageContext.request.contextPath}/doctor/patients" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to My Patients
        </a>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

</body>
</html>