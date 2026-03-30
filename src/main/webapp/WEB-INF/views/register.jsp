<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | MediLife Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/register.css">
</head>
<body>

    <jsp:include page="../../components/header.jsp" />

    <div class="register-container">
        <div class="register-header">
            <h1><i class="fas fa-user-plus"></i> Create Account</h1>
            <p>Join MediLife Hospital - Your Health, Our Priority</p>
        </div>
        
        <div class="register-body">
            <%-- Display messages --%>
            <%
                String success = (String) request.getAttribute("success");
                String error = (String) request.getAttribute("error");
                
                if (success != null) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= success %>
                    <div style="margin-top: 10px;">
                        <a href="${pageContext.request.contextPath}/login" class="btn-login" style="display: inline-block; padding: 8px 20px; margin-top: 5px;">Go to Login</a>
                    </div>
                </div>
            <%
                } else if (error != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= error %>
                </div>
            <%
                }
            %>
            
            <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                <!-- User Type Selection -->
                <div class="user-type-selector">
                    <div class="user-type-btn" data-type="patient">
                        <i class="fas fa-user"></i>
                        <span>Patient Registration</span>
                    </div>
                    <div class="user-type-btn" data-type="doctor">
                        <i class="fas fa-user-md"></i>
                        <span>Doctor Registration</span>
                    </div>
                </div>
                <input type="hidden" name="userType" id="userType" value="patient">
                
                <!-- Common Fields -->
                <div class="form-grid">
                    <div class="form-group">
                        <label><i class="fas fa-user-circle"></i> Username *</label>
                        <input type="text" name="username" placeholder="Choose a username (3-20 chars)" required>
                        <small style="color: var(--gray); font-size: 0.7rem;">Letters, numbers, underscore only</small>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-envelope"></i> Email Address *</label>
                        <input type="email" name="email" placeholder="your@email.com" required>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-lock"></i> Password *</label>
                        <div class="password-wrapper">
                            <input type="password" name="password" id="password" placeholder="Create a strong password" required>
                            <i class="fas fa-eye password-toggle" onclick="togglePassword()"></i>
                        </div>
                        <div class="strength-meter">
                            <div class="strength-bar" id="strengthBar"></div>
                        </div>
                        <div class="strength-text">
                            <span>Password Strength:</span>
                            <span id="strengthText" class="weak-text">Weak</span>
                        </div>
                        <div class="password-requirements">
                            <p>Password must contain:</p>
                            <ul>
                                <li id="reqLength"><i class="fas fa-circle"></i> At least 8 characters</li>
                                <li id="reqUpper"><i class="fas fa-circle"></i> Uppercase letter (A-Z)</li>
                                <li id="reqLower"><i class="fas fa-circle"></i> Lowercase letter (a-z)</li>
                                <li id="reqNumber"><i class="fas fa-circle"></i> Number (0-9)</li>
                                <li id="reqSpecial"><i class="fas fa-circle"></i> Special character (!@#$%^&*)</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-check-circle"></i> Confirm Password *</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm your password" required>
                        <small id="confirmMatch" style="font-size: 0.7rem;"></small>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-user"></i> Full Name *</label>
                        <input type="text" name="fullName" placeholder="Enter your full name" required>
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-phone"></i> Phone Number</label>
                        <input type="tel" name="phone" placeholder="10 digits number">
                    </div>
                    
                    <div class="form-group full-width">
                        <label><i class="fas fa-map-marker-alt"></i> Address</label>
                        <input type="text" name="address" placeholder="Your address">
                    </div>
                </div>
                
            <!-- Patient Fields (Conditional) -->
<div id="patientFields" class="conditional-fields active">
    <h3 style="margin: 20px 0 15px; color: var(--primary-blue);"><i class="fas fa-notes-medical"></i> Patient Details</h3>
    <div class="form-grid">
        <div class="form-group">
            <label><i class="fas fa-calendar-alt"></i> Date of Birth</label>
            <input type="date" name="dob">
        </div>
        
        <div class="form-group">
            <label><i class="fas fa-tint"></i> Blood Group</label>
            <select name="bloodGroup">
                <option value="">Select Blood Group</option>
                <option value="A+">A+</option>
                <option value="A-">A-</option>
                <option value="B+">B+</option>
                <option value="B-">B-</option>
                <option value="O+">O+</option>
                <option value="O-">O-</option>
                <option value="AB+">AB+</option>
                <option value="AB-">AB-</option>
            </select>
        </div>
        
        <div class="form-group">
            <label><i class="fas fa-phone-alt"></i> Emergency Contact</label>
            <input type="tel" name="emergencyContact" placeholder="Emergency phone number">
        </div>
        
        <div class="form-group full-width">
            <label><i class="fas fa-file-alt"></i> Medical History</label>
            <textarea name="medicalHistory" placeholder="Any past medical conditions, surgeries, etc."></textarea>
        </div>
        
        <div class="form-group full-width">
            <label><i class="fas fa-allergies"></i> Allergies</label>
            <textarea name="allergies" placeholder="Any known allergies (medications, food, etc.)"></textarea>
        </div>
    </div>
</div>
                
                <!-- Doctor Fields (Conditional) -->
                <div id="doctorFields" class="conditional-fields">
                    <h3 style="margin: 20px 0 15px; color: var(--primary-blue);"><i class="fas fa-stethoscope"></i> Professional Details</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label><i class="fas fa-brain"></i> Specialization *</label>
                            <select name="specialization" id="specialization">
                                <option value="">Select Specialization</option>
                                <option value="Cardiology">Cardiology</option>
                                <option value="Neurology">Neurology</option>
                                <option value="Orthopedics">Orthopedics</option>
                                <option value="Pediatrics">Pediatrics</option>
                                <option value="Dermatology">Dermatology</option>
                                <option value="Gynecology">Gynecology</option>
                                <option value="Ophthalmology">Ophthalmology</option>
                                <option value="Dentistry">Dentistry</option>
                                <option value="Radiology">Radiology</option>
                                <option value="Emergency Medicine">Emergency Medicine</option>
                                <option value="Other">Other (Please specify)</option>
                            </select>
                        </div>
                        
                        <div class="form-group" id="otherSpecializationGroup" style="display: none;">
                            <label><i class="fas fa-pen"></i> Specify Specialization *</label>
                            <input type="text" name="otherSpecialization" placeholder="Enter your specialization">
                        </div>
                        
                        <div class="form-group">
                            <label><i class="fas fa-graduation-cap"></i> Qualification *</label>
                            <input type="text" name="qualification" placeholder="e.g., MD, MBBS, PhD" required>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="fas fa-id-card"></i> License Number *</label>
                            <input type="text" name="licenseNumber" placeholder="Medical license number" required>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="fas fa-chart-line"></i> Experience (Years) *</label>
                            <input type="number" name="experienceYears" placeholder="Years of experience" min="0" max="60" required>
                        </div>
                        
                        <div class="form-group">
                            <label><i class="fas fa-money-bill-wave"></i> Consultation Fee (Rs.) *</label>
                            <input type="number" name="consultationFee" placeholder="Fee per consultation" min="0" required>
                        </div>
                        
                        <div class="form-group full-width">
                            <label><i class="fas fa-user-md"></i> Bio / Biography</label>
                            <textarea name="bio" placeholder="Tell us about your experience, expertise, and approach to patient care..."></textarea>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="btn-register-submit">
                    <i class="fas fa-user-plus"></i> Register Account
                </button>
                
                <div class="login-link">
                    Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../../components/footer.jsp" />

    <script>
        // Toggle password visibility
        function togglePassword() {
            const password = document.getElementById('password');
            const icon = document.querySelector('.password-toggle');
            if (password.type === 'password') {
                password.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                password.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Password strength checker
        const passwordInput = document.getElementById('password');
        const confirmInput = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        
        const reqLength = document.getElementById('reqLength');
        const reqUpper = document.getElementById('reqUpper');
        const reqLower = document.getElementById('reqLower');
        const reqNumber = document.getElementById('reqNumber');
        const reqSpecial = document.getElementById('reqSpecial');
        
        function checkPasswordStrength(password) {
            let score = 0;
            
            // Length check
            if (password.length >= 8) {
                reqLength.innerHTML = '<i class="fas fa-check-circle"></i> At least 8 characters';
                reqLength.classList.add('valid');
                score++;
            } else {
                reqLength.innerHTML = '<i class="fas fa-circle"></i> At least 8 characters';
                reqLength.classList.remove('valid');
            }
            
            // Uppercase
            if (/[A-Z]/.test(password)) {
                reqUpper.innerHTML = '<i class="fas fa-check-circle"></i> Uppercase letter (A-Z)';
                reqUpper.classList.add('valid');
                score++;
            } else {
                reqUpper.innerHTML = '<i class="fas fa-circle"></i> Uppercase letter (A-Z)';
                reqUpper.classList.remove('valid');
            }
            
            // Lowercase
            if (/[a-z]/.test(password)) {
                reqLower.innerHTML = '<i class="fas fa-check-circle"></i> Lowercase letter (a-z)';
                reqLower.classList.add('valid');
                score++;
            } else {
                reqLower.innerHTML = '<i class="fas fa-circle"></i> Lowercase letter (a-z)';
                reqLower.classList.remove('valid');
            }
            
            // Number
            if (/[0-9]/.test(password)) {
                reqNumber.innerHTML = '<i class="fas fa-check-circle"></i> Number (0-9)';
                reqNumber.classList.add('valid');
                score++;
            } else {
                reqNumber.innerHTML = '<i class="fas fa-circle"></i> Number (0-9)';
                reqNumber.classList.remove('valid');
            }
            
            // Special character
            if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
                reqSpecial.innerHTML = '<i class="fas fa-check-circle"></i> Special character (!@#$%^&*)';
                reqSpecial.classList.add('valid');
                score++;
            } else {
                reqSpecial.innerHTML = '<i class="fas fa-circle"></i> Special character (!@#$%^&*)';
                reqSpecial.classList.remove('valid');
            }
            
            // Update strength meter
            if (score >= 5) {
                strengthBar.className = 'strength-bar strong';
                strengthText.innerHTML = 'Strong';
                strengthText.className = 'strong-text';
            } else if (score >= 3) {
                strengthBar.className = 'strength-bar medium';
                strengthText.innerHTML = 'Medium';
                strengthText.className = 'medium-text';
            } else {
                strengthBar.className = 'strength-bar weak';
                strengthText.innerHTML = 'Weak';
                strengthText.className = 'weak-text';
            }
            
            return score;
        }
        
        passwordInput.addEventListener('input', function() {
            checkPasswordStrength(this.value);
            checkConfirmMatch();
        });
        
        // Confirm password match
        function checkConfirmMatch() {
            if (confirmInput.value === passwordInput.value && confirmInput.value !== '') {
                document.getElementById('confirmMatch').innerHTML = '<i class="fas fa-check-circle" style="color: #10b981;"></i> Passwords match';
                document.getElementById('confirmMatch').style.color = '#10b981';
            } else if (confirmInput.value !== '') {
                document.getElementById('confirmMatch').innerHTML = '<i class="fas fa-exclamation-circle" style="color: #ef4444;"></i> Passwords do not match';
                document.getElementById('confirmMatch').style.color = '#ef4444';
            } else {
                document.getElementById('confirmMatch').innerHTML = '';
            }
        }
        
        confirmInput.addEventListener('input', checkConfirmMatch);
        
        // User Type Toggle
        const patientBtn = document.querySelector('[data-type="patient"]');
        const doctorBtn = document.querySelector('[data-type="doctor"]');
        const patientFields = document.getElementById('patientFields');
        const doctorFields = document.getElementById('doctorFields');
        const userTypeInput = document.getElementById('userType');
        
        function setUserType(type) {
            if (type === 'patient') {
                patientBtn.classList.add('active');
                doctorBtn.classList.remove('active');
                patientFields.classList.add('active');
                doctorFields.classList.remove('active');
                userTypeInput.value = 'patient';
                
                // Make doctor required fields optional
                document.querySelectorAll('#doctorFields input, #doctorFields select, #doctorFields textarea').forEach(field => {
                    if (field.hasAttribute('required')) {
                        field.removeAttribute('required');
                    }
                });
                
                // Make patient required fields
                document.querySelectorAll('#patientFields input[type="text"], #patientFields select, #patientFields textarea').forEach(field => {
                    if (field.name === 'emergencyContact' || field.name === 'medicalHistory' || field.name === 'allergies') {
                        // Optional
                    }
                });
            } else {
                doctorBtn.classList.add('active');
                patientBtn.classList.remove('active');
                doctorFields.classList.add('active');
                patientFields.classList.remove('active');
                userTypeInput.value = 'doctor';
                
                // Make doctor required fields required
                document.querySelectorAll('#doctorFields input, #doctorFields select, #doctorFields textarea').forEach(field => {
                    if (field.name === 'specialization' || field.name === 'qualification' || 
                        field.name === 'licenseNumber' || field.name === 'experienceYears' || 
                        field.name === 'consultationFee') {
                        field.setAttribute('required', 'required');
                    }
                });
            }
        }
        
        patientBtn.addEventListener('click', () => setUserType('patient'));
        doctorBtn.addEventListener('click', () => setUserType('doctor'));
        
        // Specialization dropdown "Other" handling
        const specializationSelect = document.getElementById('specialization');
        const otherGroup = document.getElementById('otherSpecializationGroup');
        
        specializationSelect.addEventListener('change', function() {
            if (this.value === 'Other') {
                otherGroup.style.display = 'block';
                document.querySelector('input[name="otherSpecialization"]').setAttribute('required', 'required');
            } else {
                otherGroup.style.display = 'none';
                document.querySelector('input[name="otherSpecialization"]').removeAttribute('required');
            }
        });
        
        // Set default (patient)
        setUserType('patient');
    </script>
</body>
</html>