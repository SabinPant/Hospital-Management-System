<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Records | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/medical-records.css">
</head>
<body>

<jsp:include page="../../../components/header.jsp" />

<div class="mr-container">
    
    <!-- Page Header -->
    <div class="mr-page-header">
        <div>
            <h1><i class="fas fa-notes-medical"></i> Medical Records</h1>
            <p>Complete history of your diagnoses and prescriptions</p>
        </div>
        <a href="${pageContext.request.contextPath}/patient/dashboard" class="mr-back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty medicalRecords}">
            <div class="mr-list">
                <c:forEach var="record" items="${medicalRecords}">
                    <div class="mr-card">
                        <div class="mr-card-header">
                            <div class="mr-doctor-info">
                                <div class="mr-doctor-avatar">
                                    <i class="fas fa-user-md"></i>
                                </div>
                                <div>
                                    <h3>Dr. ${record.doctorName}</h3>
                                    <span>${record.doctorSpecialization}</span>
                                </div>
                            </div>
                            <div class="mr-date-badge">
                                <i class="fas fa-calendar"></i>
                                <fmt:formatDate value="${record.appointmentDate}" pattern="MMM dd, yyyy"/>
                            </div>
                        </div>
                        
                        <div class="mr-card-body">
                            <div class="mr-section">
                                <div class="mr-label">
                                    <i class="fas fa-stethoscope"></i> Diagnosis
                                </div>
                                <div class="mr-value">
                                    ${record.diagnosis != null ? record.diagnosis : 'Not recorded'}
                                </div>
                            </div>
                            
                            <div class="mr-divider"></div>
                            
                            <div class="mr-section">
                                <div class="mr-label">
                                    <i class="fas fa-prescription-bottle-alt"></i> Prescription
                                </div>
                                <div class="mr-value">
                                    ${record.prescription != null ? record.prescription : 'Not recorded'}
                                </div>
                            </div>
                            
                            <c:if test="${not empty record.symptoms}">
                                <div class="mr-divider"></div>
                                <div class="mr-section">
                                    <div class="mr-label">
                                        <i class="fas fa-clipboard-list"></i> Symptoms Reported
                                    </div>
                                    <div class="mr-value">${record.symptoms}</div>
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="mr-card-footer">
                            <span class="mr-appointment-id">
                                <i class="fas fa-hashtag"></i> ${record.appointmentId}
                            </span>
                            <span class="mr-status-badge">Completed</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="mr-empty">
                <i class="fas fa-folder-open"></i>
                <h2>No Medical Records Yet</h2>
                <p>Your completed appointment history will appear here. Book an appointment to get started.</p>
                <a href="${pageContext.request.contextPath}/patient/book-appointment" class="mr-cta-btn">
                    <i class="fas fa-calendar-plus"></i> Book Appointment
                </a>
            </div>
        </c:otherwise>
    </c:choose>
    
</div>

<jsp:include page="../../../components/footer.jsp" />

</body>
</html>