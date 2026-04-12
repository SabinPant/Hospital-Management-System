<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/my-booking.css">
    
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="booking-page">
     <c:if test="${not empty sessionScope.bookingError}">
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> ${sessionScope.bookingError}
            <% session.removeAttribute("bookingError"); %>
        </div>
    </c:if>
        <div class="booking-header">
            <h1><i class="fas fa-calendar-plus"></i> Book an Appointment</h1>
            <p>Schedule a consultation with our experienced doctors</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <div class="booking-layout">
            <!-- Left Column - Doctor Selection -->
            <div class="doctor-section">
                <div class="section-title">
                    <h2><i class="fas fa-user-md"></i> Select a Doctor</h2>
                </div>
                <div class="doctors-list" id="doctorsList">
                    <c:forEach var="doctor" items="${doctors}">
                        <div class="doctor-card" data-doctor-id="${doctor.doctorId}" data-doctor-name="${doctor.doctorName}" data-doctor-specialization="${doctor.doctorSpecialization}" data-doctor-fee="${doctor.consultationFee}">
                            <div class="doctor-avatar">
                                <i class="fas fa-user-circle"></i>
                            </div>
                            <div class="doctor-info">
                                <h3>Dr. ${doctor.doctorName}</h3>
                                <div class="doctor-specialty">${doctor.doctorSpecialization}</div>
                                <span class="doctor-experience"><i class="fas fa-stethoscope"></i> Specialist</span>
                            </div>
                            <div class="doctor-fee">
                                Rs ${doctor.consultationFee}
                                <small>/consultation</small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Right Column - Booking Form -->
            <div class="booking-section">
                <div class="booking-form">
                    <!-- Selected Doctor Display -->
                    <div class="selected-doctor" id="selectedDoctorDisplay">
                        <div class="selected-doctor-label"><i class="fas fa-check-circle"></i> Selected Doctor</div>
                        <div class="selected-doctor-name" id="selectedDoctorName">No doctor selected</div>
                        <div class="selected-doctor-specialty" id="selectedDoctorSpecialty">Please select a doctor from the list</div>
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/patient/book-appointment" method="post" id="bookingForm">
                        <input type="hidden" name="doctorId" id="doctorId" value="">
                        
                        <div class="datetime-row">
                            <div class="form-group">
                                <label><i class="fas fa-calendar-day"></i> Appointment Date</label>
                                <input type="date" name="appointmentDate" id="appointmentDate" min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                            </div>
                            
                            <div class="form-group">
                                <label><i class="fas fa-clock"></i> Appointment Time</label>
                                <select name="appointmentTime" id="appointmentTime" required>
                                    <option value="">Select time</option>
                                    <option value="09:00">09:00 AM</option>
                                    <option value="10:00">10:00 AM</option>
                                    <option value="11:00">11:00 AM</option>
                                    <option value="12:00">12:00 PM</option>
                                    <option value="14:00">02:00 PM</option>
                                    <option value="15:00">03:00 PM</option>
                                    <option value="16:00">04:00 PM</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="fas fa-notes-medical"></i> Symptoms / Reason</label>
                            <textarea name="symptoms" placeholder="Please describe your symptoms or reason for visit..." required></textarea>
                        </div>
                        
                        <div class="fee-display">
                            <span class="fee-label"><i class="fas fa-money-bill-wave"></i> Consultation Fee</span>
                            <span class="fee-amount" id="feeAmount">Rs 0</span>
                        </div>
                        
                        <button type="submit" class="btn-book" id="bookBtn" disabled>
                            <i class="fas fa-check-circle"></i> Confirm Booking
                        </button>
                    </form>
                    
                    <div class="back-link">
                        <a href="${pageContext.request.contextPath}/patient/dashboard">← Back to Dashboard</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

    <script>
        const doctorsList = document.querySelectorAll('.doctor-card');
        const doctorIdInput = document.getElementById('doctorId');
        const selectedDoctorName = document.getElementById('selectedDoctorName');
        const selectedDoctorSpecialty = document.getElementById('selectedDoctorSpecialty');
        const feeAmount = document.getElementById('feeAmount');
        const bookBtn = document.getElementById('bookBtn');
        
        // Doctor selection 
        doctorsList.forEach(card => {
            card.addEventListener('click', function() {
                // Remove selected class from all
                doctorsList.forEach(c => c.classList.remove('selected'));
                // Add selected class to clicked
                this.classList.add('selected');
                
                // Update form with selected doctor data
                const doctorId = this.dataset.doctorId;
                const doctorName = this.dataset.doctorName;
                const doctorSpecialty = this.dataset.doctorSpecialization;
                const doctorFee = this.dataset.doctorFee;
                
                doctorIdInput.value = doctorId;
                selectedDoctorName.textContent = 'Dr. ' + doctorName;
                selectedDoctorSpecialty.textContent = doctorSpecialty;
                feeAmount.textContent = 'Rs ' + parseFloat(doctorFee).toLocaleString('en-IN');
                bookBtn.disabled = false;
            });
        });
        
        // Set min date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointmentDate').min = today;
    </script>

</body>
</html>