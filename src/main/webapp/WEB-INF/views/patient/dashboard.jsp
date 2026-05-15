<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | MediLife</title>
   <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/patients/patient-dashboard.css">
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="patient-dashboard">
        <div class="dashboard-layout">
            
            <!-- LEFT SIDEBAR -->
            <div class="dashboard-sidebar">
                
 <div class="profile-card">
    <div class="profile-avatar">
        <c:choose>
            <c:when test="${not empty sessionScope.profile_image}">
<img src="${pageContext.request.contextPath}/uploads/${sessionScope.profile_image}" alt="Profile" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover;">            </c:when>
            <c:otherwise>
                <i class="fas fa-user-circle"></i>
            </c:otherwise>
        </c:choose>
    </div>



    <h3>${sessionScope.full_name}</h3>
    <p class="patient-id">Patient ID: ${sessionScope.user_id_display}</p>
    
    <div class="profile-details">
        <p><i class="fas fa-tint"></i> Blood Group: ${sessionScope.blood_group != null ? sessionScope.blood_group : 'Not specified'}</p>
        <p><i class="fas fa-calendar-alt"></i> Member since: 
            <fmt:formatDate value="${sessionScope.joined_date}" pattern="MMM dd, yyyy"/>
        </p>
        <p><i class="fas fa-phone"></i> Phone: ${sessionScope.phone != null ? sessionScope.phone : 'Not provided'}</p>
        <p><i class="fas fa-envelope"></i> Email: ${sessionScope.email}</p>
    </div>
</div>
                
                <!-- Quick Stats -->
                <div class="quick-stats outline">
    <h4>TOTAL APPOINTMENTS</h4>
    <div class="stat-number">${totalAppointments != null ? totalAppointments : 0}</div>
</div>
                <!-- Quick Actions -->
                <div class="quick-actions">
                    <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/patient/book-appointment'">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Book Appointment</span>
                    </button>
                    <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/patient/appointments'">
                        <i class="fas fa-calendar-check"></i>
                        <span>My Appointments</span>
                    </button>
        
                    <button class="action-btn" onclick="location.href='${pageContext.request.contextPath}/patient/profile'">
                        <i class="fas fa-user-edit"></i>
                        <span>Edit Profile</span>
                    </button>
                </div>
            </div>
            
            <!-- RIGHT MAIN CONTENT -->
            <div class="dashboard-main">
                
                <!-- Upcoming Appointments Section -->
                <div class="section-card">
                    <div class="section-header">
                        <h2><i class="fas fa-calendar-alt"></i> Upcoming Appointments</h2>
                        <a href="${pageContext.request.contextPath}/patient/appointments">View All →</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty upcomingAppointments}">
                            <div class="appointment-list">
                                <c:forEach var="apt" items="${upcomingAppointments}">
                                    <div class="appointment-item">
                                        <div class="appointment-info">
                                            <h4>Dr. ${apt.doctorName}</h4>
                                            <p>${apt.doctorSpecialization}</p>
                                            <span class="status-badge status-${apt.status}">${apt.status}</span>
                                        </div>
                                        <div class="appointment-date">
                                            <div class="date"><fmt:formatDate value="${apt.appointmentDate}" pattern="MMM dd, yyyy"/></div>
                                            <div class="time">${apt.appointmentTime}</div>
                                          
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p style="text-align: center; color: #64748b; padding: 30px;">No upcoming appointments. <a href="${pageContext.request.contextPath}/patient/book-appointment">Book one now →</a></p>
                        </c:otherwise>
                    </c:choose>
                </div>
                
           <!-- Recent Medical History -->
<div class="section-card">
    <div class="section-header">
        <h2><i class="fas fa-notes-medical"></i> Recent Medical History</h2>
        <a href="${pageContext.request.contextPath}/patient/medical-records">View All →</a>
    </div>
    
    <c:choose>
        <c:when test="${not empty medicalHistory}">
            <div class="history-list">
                <c:forEach var="record" items="${medicalHistory}">
                    <div class="history-item">
                        
                        <!-- Top: Doctor Info -->
                        <div class="history-item-top">
                            <div class="history-doctor-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="history-doctor-info">
                                <h4>Dr. ${record.doctorName}</h4>
                                <span>${record.doctorSpecialization}</span>
                            </div>
                        </div>
                        
                        <!-- Body: Diagnosis & Prescription -->
                        <div class="history-item-body">
                            <div class="history-field">
                                <div class="history-field-label">
                                    <i class="fas fa-stethoscope"></i> Diagnosis
                                </div>
                                <div class="history-field-value">
                                    ${record.diagnosis != null ? record.diagnosis : 'Not recorded'}
                                </div>
                            </div>
                            
                            <div class="history-field">
                                <div class="history-field-label">
                                    <i class="fas fa-prescription-bottle-alt"></i> Prescription
                                </div>
                                <div class="history-field-value">
                                    ${record.prescription != null ? record.prescription : 'Not recorded'}
                                </div>
                            </div>
                        </div>
                        
                        <!-- Footer: Date & ID -->
                        <div class="history-item-footer">
                            <span class="history-date">
                                <i class="fas fa-calendar"></i>
                                <fmt:formatDate value="${record.appointmentDate}" pattern="MMM dd, yyyy"/>
                            </span>
                            <span class="history-appt-id">
                                <i class="fas fa-hashtag"></i> ${record.appointmentId}
                            </span>
                        </div>
                        
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="fas fa-notes-medical"></i>
                <p>No medical records found.</p>
                <p style="font-size: 0.8rem;">Complete appointments with doctors to see your medical history here.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

                
            </div>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />



</body>
</html>