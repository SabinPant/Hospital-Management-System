<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | MediLife</title>
   <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/patients/my-booking.css">
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="booking-page">
        <c:if test="${not empty sessionScope.bookingError}">
    <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> ${sessionScope.bookingError}
    </div>
</c:if>
        
        <div class="booking-header">
            <h1><i class="fas fa-calendar-plus"></i> Book an Appointment</h1>
            <p>Schedule a consultation with our experienced doctors</p>
        </div>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${sessionScope.success}
                <% session.removeAttribute("success"); %>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                <% session.removeAttribute("error"); %>
            </div>
        </c:if>
        
        <!-- Booking Type Toggle -->
        <div class="booking-type-toggle">
            <button class="toggle-btn active" data-type="request" onclick="switchBookingType('request')">
                <i class="fas fa-clipboard-list"></i> Request Appointment
            </button>
            <button class="toggle-btn" data-type="direct" onclick="switchBookingType('direct')">
                <i class="fas fa-bolt"></i> Quick Consult
            </button>
        </div>
        
       <!-- ==================== REQUEST APPOINTMENT FORM ==================== -->
<div id="requestForm" class="booking-type-form active">
    <div class="rq-shell">
        
        <!-- Steps Indicator -->
        <div class="rq-steps">
            <div class="rq-step">
                <div class="rq-bubble done"><i class="fas fa-calendar"></i></div>
                <span class="rq-slabel done">Schedule</span>
            </div>
            <div class="rq-conn filled"></div>
            <div class="rq-step">
                <div class="rq-bubble active"><i class="fas fa-comment-medical"></i></div>
                <span class="rq-slabel active">Describe</span>
            </div>
            <div class="rq-conn"></div>
            <div class="rq-step">
                <div class="rq-bubble"><i class="fas fa-paper-plane"></i></div>
                <span class="rq-slabel">Submit</span>
            </div>
        </div>

        <!-- Main Card -->
        <div class="rq-card">
            <!-- Header -->
            <div class="rq-hdr">
                <div class="rq-hdr-icon"><i class="fas fa-clipboard-list"></i></div>
                <div class="rq-hdr-text">
                    <h2>Request an Appointment</h2>
                    <p>Describe your concern — our team will match you with the right specialist</p>
                </div>
            </div>

            <!-- Body -->
            <div class="rq-body">
                <!-- Info Banner -->
                <div class="rq-banner">
                    <div class="rq-banner-icon"><i class="fas fa-info-circle"></i></div>
                    <div class="rq-banner-text">
                        <strong>How this works</strong>
                        <span>Fill in your preferred schedule and describe your health concern. Our admin will review your request and assign the most suitable doctor.</span>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/patient/book-request" method="post">
                    <!-- Section 1: Schedule -->
                    <div class="rq-sec">
                        <div class="rq-sec-lbl">
                            <div class="rq-sec-num">1</div>
                            <span class="rq-sec-title">Preferred Schedule</span>
                        </div>
                        <div class="rq-dt-grid">
                            <div class="rq-field">
                                <div class="rq-lbl"><i class="fas fa-calendar-day"></i> Preferred Date <span class="rq-badge-req">Required</span></div>
                                <input type="date" name="appointmentDate" id="requestDate" required>
                            </div>
                            <div class="rq-field">
                                <div class="rq-lbl"><i class="fas fa-clock"></i> Preferred Time <span class="rq-badge-req">Required</span></div>
                                <select name="appointmentTime" required style="width:100%;padding:12px 14px;border:1.5px solid #e2e8f0;border-radius:13px;font-family:'Plus Jakarta Sans',sans-serif;font-size:.85rem;color:#0f172a;background:#fafbfc;">
                                    <option value="">Select a time slot</option>
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
                    </div>

                    <div class="rq-divider"></div>

                    <!-- Section 2: Problem -->
                    <div class="rq-sec">
                        <div class="rq-sec-lbl">
                            <div class="rq-sec-num">2</div>
                            <span class="rq-sec-title">Describe Your Problem</span>
                        </div>
                        <div class="rq-field">
                            <div class="rq-lbl"><i class="fas fa-stethoscope"></i> What brings you in today? <span class="rq-badge-req">Required</span></div>
                            <textarea name="problemDescription" class="rq-problem-ta" placeholder="Tell us what's bothering you. The more detail you share, the better we can match you with the right specialist…" required></textarea>
                            <div class="rq-hints">
                                <span class="rq-hint" onclick="fillProblem('I have persistent headaches for the past few days.')">Headache</span>
                                <span class="rq-hint" onclick="fillProblem('I have chest discomfort and shortness of breath.')">Chest pain</span>
                                <span class="rq-hint" onclick="fillProblem('I have joint pain and swelling in my knees and ankles.')">Joint pain</span>
                                <span class="rq-hint" onclick="fillProblem('Persistent cough and mild fever for over a week.')">Cough & fever</span>
                                <span class="rq-hint" onclick="fillProblem('Digestive issues — bloating, nausea, and stomach cramps.')">Digestive issues</span>
                                <span class="rq-hint" onclick="fillProblem('A skin rash or irritation that has not cleared up.')">Skin rash</span>
                            </div>
                        </div>
                    </div>

                    <div class="rq-divider"></div>

                    <!-- Section 3: Symptoms -->
                    <div class="rq-sec" style="margin-bottom:0">
                        <div class="rq-sec-lbl">
                            <div class="rq-sec-num">3</div>
                            <span class="rq-sec-title">Additional Symptoms</span>
                        </div>
                        <div class="rq-field">
                            <div class="rq-lbl"><i class="fas fa-notes-medical"></i> Specific symptoms <span class="rq-badge-opt">Optional</span></div>
                            <textarea name="symptoms" class="rq-sym-ta" placeholder="List any specific symptoms — duration, severity, frequency. E.g. fever 38°C for 3 days, dizziness in the morning…"></textarea>
                        </div>
                    </div>

                    <div class="rq-divider"></div>

                    <!-- Submit -->
                    <button type="submit" class="rq-sub-btn">
                        <i class="fas fa-paper-plane"></i>
                        Submit Appointment Request
                        <span class="rq-arr"><i class="fas fa-arrow-right"></i></span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
        
        <!-- ==================== DIRECT BOOKING FORM (EXISTING) ==================== -->
        <div id="directForm" class="booking-type-form">
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
                                    <input type="date" name="appointmentDate" id="appointmentDate" required>
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
    <span class="time-hint">
        <i class="fas fa-info-circle"></i> Time slots are first-come, first-served. Book early to secure your preferred time.
    </span>
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
                    </div>
                </div>
            </div>
        </div>
        
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/patient/dashboard">← Back to Dashboard</a>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

    <script>
    
    // Auto-switch to Quick Consult if there's a booking error
    <c:if test="${not empty sessionScope.bookingError}">
        switchBookingType('direct');
    </c:if>
    
    
        // ── Booking Type Toggle ──
        function switchBookingType(type) {
            document.querySelectorAll('.toggle-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelector('[data-type="' + type + '"]').classList.add('active');
            
            document.getElementById('requestForm').classList.toggle('active', type === 'request');
            document.getElementById('directForm').classList.toggle('active', type === 'direct');
        }
        
        // ── Direct Booking - Doctor Selection ──
        const doctorsList = document.querySelectorAll('#directForm .doctor-card');
        const doctorIdInput = document.getElementById('doctorId');
        const selectedDoctorName = document.getElementById('selectedDoctorName');
        const selectedDoctorSpecialty = document.getElementById('selectedDoctorSpecialty');
        const feeAmount = document.getElementById('feeAmount');
        const bookBtn = document.getElementById('bookBtn');
        
        doctorsList.forEach(card => {
            card.addEventListener('click', function() {
                doctorsList.forEach(c => c.classList.remove('selected'));
                this.classList.add('selected');
                
                doctorIdInput.value = this.dataset.doctorId;
                selectedDoctorName.textContent = 'Dr. ' + this.dataset.doctorName;
                selectedDoctorSpecialty.textContent = this.dataset.doctorSpecialization;
                feeAmount.textContent = 'Rs ' + parseFloat(this.dataset.doctorFee).toLocaleString('en-IN');
                bookBtn.disabled = false;
            });
        });
        
        // Set min date to today for both forms
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointmentDate').min = today;
        document.getElementById('requestDate').min = today;
        
        function fillProblem(text) {
            document.querySelector('.rq-problem-ta').value = text;
            document.querySelector('.rq-problem-ta').focus();
        }
        
     // Clear booking error when user changes date or time
        document.getElementById('appointmentDate').addEventListener('change', function() {
            var errorEl = document.querySelector('.alert-error');
            if (errorEl) errorEl.style.display = 'none';
        });

        document.getElementById('appointmentTime').addEventListener('change', function() {
            var errorEl = document.querySelector('.alert-error');
            if (errorEl) errorEl.style.display = 'none';
        });
        
    </script>

</body>
</html>