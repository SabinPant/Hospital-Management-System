<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | MediLife Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/register-page.css">
</head>
<body>

    <jsp:include page="../../components/header.jsp" />

    <div class="register-page">
        <div class="register-card">

            <!-- Header -->
            <div class="reg-header">
                <div class="reg-header-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <h1>Create Your Account</h1>
                <p>Join MediLife Hospital &mdash; Your Health, Our Priority</p>
            </div>

            <!-- Body -->
            <div class="reg-body">

                <!-- Alerts -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <div class="alert-content">
                            ${success}
                            <br>
                            <a href="${pageContext.request.contextPath}/login" class="alert-link">
                                <i class="fas fa-sign-in-alt"></i> Go to Login
                            </a>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <div class="alert-content">${error}</div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm" enctype="multipart/form-data">
                    <input type="hidden" name="userType" id="userType" value="patient">

                    <!-- Type Selector -->
                    <div class="type-selector">
                        <div class="type-btn active" data-type="patient">
                            <i class="fas fa-user"></i>
                            <span>Patient Registration</span>
                        </div>
                        <div class="type-btn" data-type="doctor">
                            <i class="fas fa-user-md"></i>
                            <span>Doctor Registration</span>
                        </div>
                    </div>

                    <!-- Common Fields -->
                    <div class="section-divider">
                        <span><i class="fas fa-user-circle"></i> Account Information</span>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label><i class="fas fa-at"></i> Username <span class="req">*</span></label>
                            <input type="text" name="username" placeholder="Choose a username" required>
                            <span class="form-hint">3–20 chars · letters, numbers, underscore only</span>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-envelope"></i> Email Address <span class="req">*</span></label>
                            <input type="email" name="email" placeholder="your@email.com" required>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-lock"></i> Password <span class="req">*</span></label>
                            <div class="pw-wrapper">
                                <input type="password" name="password" id="password" placeholder="Create a strong password" required>
                                <i class="fas fa-eye pw-toggle" onclick="togglePassword()"></i>
                            </div>
                            <div class="strength-bar-wrap">
                                <div class="strength-bar" id="strengthBar"></div>
                            </div>
                            <div class="strength-label">
                                <span>Password Strength</span>
                                <span id="strengthText" class="val weak">—</span>
                            </div>
                               <div class="pw-requirements">                                <p>Must contain:</p>
                                <ul>
                                    <li id="reqLength"><i class="fas fa-circle"></i> 8+ characters</li>
                                    <li id="reqUpper"><i class="fas fa-circle"></i> Uppercase (A-Z)</li>
                                    <li id="reqLower"><i class="fas fa-circle"></i> Lowercase (a-z)</li>
                                    <li id="reqNumber"><i class="fas fa-circle"></i> Number (0-9)</li>
                                    <li id="reqSpecial" style="grid-column: span 2;"><i class="fas fa-circle"></i> Special character (!@#$%)</li>
                                </ul>
                            </div>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-check-circle"></i> Confirm Password <span class="req">*</span></label>
                            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Re-enter your password" required>
                            <span id="confirmMatch" class="confirm-msg"></span>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Full Name <span class="req">*</span></label>
                            <input type="text" name="fullName" placeholder="Enter your full name" required>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-venus-mars"></i> Gender</label>
                            <select name="gender">
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-phone"></i> Phone Number <span class="req">*</span></label>
                            <input type="tel" name="phone" placeholder="10-digit number" required>
                        </div>

                        <div class="form-group">
                            <label><i class="fas fa-map-marker-alt"></i> Address</label>
                            <input type="text" name="address" placeholder="Your address">
                        </div>
                    </div>

                    <!-- ── Patient Fields ── -->
                    <div id="patientFields" class="conditional-fields active">
                        <div class="section-divider">
                            <span><i class="fas fa-notes-medical"></i> Patient Details</span>
                        </div>
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

                            <div class="form-group">
                                <label><i class="fas fa-camera"></i> Profile Picture</label>
                                <div class="file-input-wrap">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <div class="file-input-text">
                                        <span id="profileFileName">Click to upload photo</span>
                                        <small>JPG, PNG, GIF · Max 5MB</small>
                                    </div>
                                    <input type="file" name="profileImage" accept="image/jpeg,image/png,image/gif"
                                           onchange="handleFileSelect(this, 'profileFileName', 'profileImageError')">
                                </div>
                                <span id="profileImageError" class="field-error"></span>
                            </div>

                            <div class="form-group span-2">
                                <label><i class="fas fa-file-alt"></i> Medical History</label>
                                <textarea name="medicalHistory" placeholder="Any past medical conditions, surgeries, etc."></textarea>
                            </div>

                            <div class="form-group span-2">
                                <label><i class="fas fa-allergies"></i> Allergies</label>
                                <textarea name="allergies" placeholder="Any known allergies (medications, food, etc.)"></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- ── Doctor Fields ── -->
                    <div id="doctorFields" class="conditional-fields">
                        <div class="section-divider">
                            <span><i class="fas fa-stethoscope"></i> Professional Details</span>
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label><i class="fas fa-brain"></i> Specialization <span class="req">*</span></label>
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
                                <label><i class="fas fa-pen"></i> Specify Specialization <span class="req">*</span></label>
                                <input type="text" name="otherSpecialization" placeholder="Enter your specialization">
                            </div>

                            <div class="form-group">
                                <label><i class="fas fa-graduation-cap"></i> Qualification <span class="req">*</span></label>
                                <input type="text" name="qualification" placeholder="e.g., MD, MBBS, PhD" required>
                            </div>

                            <div class="form-group">
                                <label><i class="fas fa-id-card"></i> License Number <span class="req">*</span></label>
                                <input type="text" name="licenseNumber" placeholder="Medical license number" required>
                            </div>

                            <div class="form-group">
                                <label><i class="fas fa-chart-line"></i> Experience (Years) <span class="req">*</span></label>
                                <input type="number" name="experienceYears" placeholder="Years of experience" min="0" max="60" required>
                            </div>

                            <div class="form-group">
                                <label><i class="fas fa-money-bill-wave"></i> Consultation Fee (Rs.) <span class="req">*</span></label>
                                <input type="number" name="consultationFee" placeholder="Fee per consultation" min="0" required>
                            </div>

                            <div class="form-group span-2">
                                <label><i class="fas fa-image"></i> License Document <span class="req">*</span></label>
                                <div class="file-input-wrap">
                                    <i class="fas fa-file-upload"></i>
                                    <div class="file-input-text">
                                        <span id="licenseFileName">Click to upload license document</span>
                                        <small>JPG, PNG, GIF · Max 5MB · Scanned copy</small>
                                    </div>
                                    <input type="file" name="licenseImage" accept="image/jpeg,image/png,image/gif"
                                           onchange="handleFileSelect(this, 'licenseFileName', 'fileError')">
                                </div>
                                <span id="fileError" class="field-error"></span>
                            </div>

                            <div class="form-group span-2">
                                <label><i class="fas fa-user-md"></i> Bio / Biography</label>
                                <textarea name="bio" placeholder="Tell us about your experience, expertise, and approach to patient care..."></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Submit -->
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>

                    <div class="login-link">
                        Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="../../components/footer.jsp" />

   <script>
    // ── Toggle Password ──
    function togglePassword() {
        const pw = document.getElementById('password');
        const icon = document.querySelector('.pw-toggle');
        if (pw.type === 'password') {
            pw.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            pw.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }

    // ── Password Strength ──
    const passwordInput  = document.getElementById('password');
    const confirmInput   = document.getElementById('confirmPassword');
    const strengthBar    = document.getElementById('strengthBar');
    const strengthText   = document.getElementById('strengthText');

    function checkPasswordStrength(pw) {
        const reqLength  = document.getElementById('reqLength');
        const reqUpper   = document.getElementById('reqUpper');
        const reqLower   = document.getElementById('reqLower');
        const reqNumber  = document.getElementById('reqNumber');
        const reqSpecial = document.getElementById('reqSpecial');
        
        if (pw.length === 0) {
            reqLength.innerHTML  = '<i class="fas fa-circle"></i> 8+ characters';
            reqUpper.innerHTML   = '<i class="fas fa-circle"></i> Uppercase (A-Z)';
            reqLower.innerHTML   = '<i class="fas fa-circle"></i> Lowercase (a-z)';
            reqNumber.innerHTML  = '<i class="fas fa-circle"></i> Number (0-9)';
            reqSpecial.innerHTML = '<i class="fas fa-circle"></i> Special character (!@#$%)';
            [reqLength, reqUpper, reqLower, reqNumber, reqSpecial].forEach(el => {
                el.style.color = '#94a3b8';
            });
            strengthBar.className = 'strength-bar';
            strengthBar.style.width = '0%';
            strengthText.textContent = '—';
            strengthText.style.color = '#94a3b8';
            return;
        }
        
        let score = 0;
        
        if (pw.length >= 8) {
            reqLength.innerHTML = '<i class="fas fa-check-circle"></i> 8+ characters';
            reqLength.style.color = '#10b981';
            score++;
        } else {
            reqLength.innerHTML = '<i class="fas fa-times-circle"></i> 8+ characters';
            reqLength.style.color = '#ef4444';
        }
        
        if (/[A-Z]/.test(pw)) {
            reqUpper.innerHTML = '<i class="fas fa-check-circle"></i> Uppercase (A-Z)';
            reqUpper.style.color = '#10b981';
            score++;
        } else {
            reqUpper.innerHTML = '<i class="fas fa-times-circle"></i> Uppercase (A-Z)';
            reqUpper.style.color = '#ef4444';
        }
        
        if (/[a-z]/.test(pw)) {
            reqLower.innerHTML = '<i class="fas fa-check-circle"></i> Lowercase (a-z)';
            reqLower.style.color = '#10b981';
            score++;
        } else {
            reqLower.innerHTML = '<i class="fas fa-times-circle"></i> Lowercase (a-z)';
            reqLower.style.color = '#ef4444';
        }
        
        if (/[0-9]/.test(pw)) {
            reqNumber.innerHTML = '<i class="fas fa-check-circle"></i> Number (0-9)';
            reqNumber.style.color = '#10b981';
            score++;
        } else {
            reqNumber.innerHTML = '<i class="fas fa-times-circle"></i> Number (0-9)';
            reqNumber.style.color = '#ef4444';
        }
        
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pw)) {
            reqSpecial.innerHTML = '<i class="fas fa-check-circle"></i> Special character (!@#$%)';
            reqSpecial.style.color = '#10b981';
            score++;
        } else {
            reqSpecial.innerHTML = '<i class="fas fa-times-circle"></i> Special character (!@#$%)';
            reqSpecial.style.color = '#ef4444';
        }
        
        strengthBar.className = 'strength-bar';
        if (score >= 5) {
            strengthBar.classList.add('strong');
            strengthText.textContent = 'Strong';
            strengthText.style.color = '#10b981';
        } else if (score >= 3) {
            strengthBar.classList.add('medium');
            strengthText.textContent = 'Medium';
            strengthText.style.color = '#f59e0b';
        } else {
            strengthBar.classList.add('weak');
            strengthText.textContent = 'Weak';
            strengthText.style.color = '#ef4444';
        }
    }

    // ── Confirm Password Match ──
    function checkConfirmMatch() {
        const el = document.getElementById('confirmMatch');
        if (!confirmInput.value) {
            el.innerHTML = '';
            return;
        }
        if (confirmInput.value === passwordInput.value) {
            el.innerHTML = '<i class="fas fa-check-circle" style="color:#10b981"></i> Passwords match';
            el.style.color = '#10b981';
        } else {
            el.innerHTML = '<i class="fas fa-exclamation-circle" style="color:#ef4444"></i> Passwords do not match';
            el.style.color = '#ef4444';
        }
    }

    passwordInput.addEventListener('input', function() {
        checkPasswordStrength(this.value);
        checkConfirmMatch();
    });
    confirmInput.addEventListener('input', checkConfirmMatch);

    // ── File Select Handler ──
    function handleFileSelect(input, nameId, errorId) {
        const file = input.files[0];
        const errorEl = document.getElementById(errorId);
        const nameEl  = document.getElementById(nameId);
        const allowed = ['image/jpeg', 'image/png', 'image/gif'];
        const maxSize = 5 * 1024 * 1024;

        if (!file) return;
        if (!allowed.includes(file.type)) {
            errorEl.textContent = 'Only JPG, PNG, GIF images are allowed.';
            input.value = ''; return;
        }
        if (file.size > maxSize) {
            errorEl.textContent = 'File size must be under 5MB.';
            input.value = ''; return;
        }
        errorEl.textContent = '';
        nameEl.textContent = file.name;
    }

    // ── User Type Toggle ──
    const patientBtn    = document.querySelector('[data-type="patient"]');
    const doctorBtn     = document.querySelector('[data-type="doctor"]');
    const patientFields = document.getElementById('patientFields');
    const doctorFields  = document.getElementById('doctorFields');
    const userTypeInput = document.getElementById('userType');

    function setUserType(type) {
        const isDoctor = type === 'doctor';
        patientBtn.classList.toggle('active', !isDoctor);
        doctorBtn.classList.toggle('active',   isDoctor);
        patientFields.classList.toggle('active', !isDoctor);
        doctorFields.classList.toggle('active',   isDoctor);
        userTypeInput.value = type;

        document.querySelectorAll('#doctorFields input, #doctorFields select, #doctorFields textarea').forEach(f => {
            const required = ['specialization','qualification','licenseNumber','experienceYears','consultationFee'];
            if (isDoctor && required.includes(f.name)) f.setAttribute('required','required');
            else f.removeAttribute('required');
        });
    }

    patientBtn.addEventListener('click', () => setUserType('patient'));
    doctorBtn.addEventListener('click',  () => setUserType('doctor'));

    // ── Specialization "Other" ──
    document.getElementById('specialization').addEventListener('change', function() {
        const group = document.getElementById('otherSpecializationGroup');
        const input = document.querySelector('input[name="otherSpecialization"]');
        if (this.value === 'Other') {
            group.style.display = 'flex';
            input.setAttribute('required','required');
        } else {
            group.style.display = 'none';
            input.removeAttribute('required');
        }
    });

    setUserType('patient');
</script>
</body>
</html>
