<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 
    Main landing page for MediLife Hospital system.
    Uses JSP for dynamic session handling and component reused.
-->

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Meta configuration for responsiveness and encoding -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>MediLife Hospital | Advanced Care</title>

    <!-- External fonts and icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:..." rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Project-specific styles -->
    <link rel="stylesheet" href="CSS/global.css">
    <link rel="stylesheet" href="CSS/index.css">

    <!-- SweetAlert for modern popup alerts -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>

    <!-- Reusable header component -->
    <jsp:include page="components/header.jsp" />

    <!-- ================= HERO SECTION ================= -->
    <!-- 
        Main banner introducing hospital.
        Contains CTA (Call To Action) for booking appointment.
    -->
    <section class="hero">
        <div class="container hero-grid">

            <!-- Left Content -->
            <div class="hero-content">
                <span class="hero-badge">
                    <i class="fas fa-heartbeat"></i> Trusted Care Since 1998
                </span>

                <h1>
                    A Brighter <br>
                    <span class="highlight">Healthcare</span> Experience
                </h1>

                <p>
                    Providing compassionate, world-class medical care with advanced technology.
                </p>

                <!-- CTA Button -->
                <div class="hero-buttons">
                    <!-- 
                        Calls JS function to check login before redirecting.
                        Prevents unauthorized booking access.
                    -->
                    <a href="#" class="btn-primary" onclick="checkLoginAndRedirect(event)">
                        Book Appointment <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <!-- Hospital statistics -->
                <div class="stats">
                    <div><span>25+</span> Years of Excellence</div>
                    <div><span>500+</span> Expert Doctors</div>
                    <div><span>50k+</span> Happy Patients</div>
                </div>
            </div>

            <!-- Right Image -->
            <div class="hero-image">
                <!-- 
                    onerror ensures fallback image if local asset fails.
                -->
                <img src="Public/Hospital/MediLife.png" alt="Medical Team"
                     onerror="this.src='https://placehold.co/800x600/...';">
            </div>

        </div>
    </section>

   <!-- ==================== SERVICES SECTION ==================== -->
<section class="services">
    <div class="container">
        <div class="section-header">
            <span class="subtitle">Our Expertise</span>
            <h2>We Offer the Best <span class="highlight">Medical Services</span></h2>
            <p>Comprehensive healthcare solutions tailored to your needs, from emergency to specialized departments.</p>
        </div>
        
        <div class="services-grid">
            <div class="service-card">
                <div class="icon-wrapper"><i class="fas fa-ambulance"></i></div>
                <h3>Emergency Services</h3>
                <p>24/7 emergency care, ambulance services, trauma care, and critical response team.</p>
            </div>
            
            <div class="service-card">
                <div class="icon-wrapper"><i class="fas fa-stethoscope"></i></div>
                <h3>Outpatient (OPD)</h3>
                <p>Doctor consultations without admission, routine checkups, and follow-up visits.</p>
            </div>
            
            <div class="service-card">
                <div class="icon-wrapper"><i class="fas fa-procedures"></i></div>
                <h3>Inpatient (IPD)</h3>
                <p>Full-time stay with room/bed, nursing care, meals, and continuous monitoring.</p>
            </div>
            
            <div class="service-card">
                <div class="icon-wrapper"><i class="fas fa-microscope"></i></div>
                <h3>Diagnostic Services</h3>
                <p>Laboratory tests, X-ray, MRI, CT scan, Ultrasound, and advanced imaging.</p>
            </div>
            
            <div class="service-card">
                <div class="icon-wrapper"><i class="fas fa-syringe"></i></div>
                <h3>Surgical Services</h3>
                <p>Minor to major surgeries: Orthopedic, Cardiac, Neurology, and specialized operations.</p>
            </div>
            
            <div class="service-card">
                <div class="icon-wrapper"><i class="fas fa-prescription-bottle-alt"></i></div>
                <h3>Pharmacy Services</h3>
                <p>Medicines provided inside hospital, prescription management, 24/7 pharmacy.</p>
            </div>
            
            <div class="service-card">
                <div class="icon-wrapper"><i class="fas fa-baby-carriage"></i></div>
                <h3>Maternity & Child Care</h3>
                <p>Pregnancy care, normal & C-section delivery, neonatal care for newborns.</p>
            </div>
            
            <div class="service-card">
                <div class="icon-wrapper"><i class="fas fa-brain"></i></div>
                <h3>Special Departments</h3>
                <p>Cardiology, Neurology, Oncology, Dermatology, ENT, and more specialized care.</p>
            </div>
        </div>
    </div>
</section>

    <!-- ================= DOCTORS SECTION ================= -->
    <!-- Displays list of doctors (currently static, can be dynamic later) -->
    <section class="doctors">
    <div class="container">
        <div class="section-header">
            <span class="subtitle">Expert Team</span>
            <h2>Meet Our <span class="highlight">Medical Specialists</span></h2>
            <p>Compassionate, highly skilled doctors dedicated to your care</p>
        </div>
        
        <div class="doctors-grid">
            <div class="doctor-card">
                <div class="doc-img">
                    <img src="Public/Doctors/SabinPant.jpg" alt="Dr. Sabin Pant" onerror="this.src='https://placehold.co/400x400/e2e8f0/0a5c8e?text=Dr.+Sabin'">
                </div>
                <h3>Dr. Sabin Pant</h3>
                <span class="specialty">Chief Cardiologist</span>
                <p>15+ years in interventional cardiology and heart failure management.</p>
            </div>
            
            <div class="doctor-card">
                <div class="doc-img">
                    <img src="Public/Doctors/PriyanshuMahat.jpeg" alt="Dr. Priyanshu Mahat" onerror="this.src='https://placehold.co/400x400/e2e8f0/0a5c8e?text=Dr.+Priyanshu'">
                </div>
                <h3>Dr. Priyanshu Mahat</h3>
                <span class="specialty">Senior Neurologist</span>
                <p>Expert in stroke management, epilepsy, and complex brain surgeries.</p>
            </div>
            
            <div class="doctor-card">
                <div class="doc-img">
                    <img src="Public/Doctors/AryanShakya.jpeg" alt="Dr. Aryan Shakya" onerror="this.src='https://placehold.co/400x400/e2e8f0/0a5c8e?text=Dr.+Aryan'">
                </div>
                <h3>Dr. Aryan Shakya</h3>
                <span class="specialty">Orthopedic Surgeon</span>
                <p>Specialist in joint replacement, sports injuries, and spine surgeries.</p>
            </div>
            
            <div class="doctor-card">
                <div class="doc-img">
                    <img src="Public/Doctors/RabinPant.jpeg" alt="Dr. Rabin Pant" onerror="this.src='https://placehold.co/400x400/e2e8f0/0a5c8e?text=Dr.+Rabin'">
                </div>
                <h3>Dr. Rabin Pant</h3>
                <span class="specialty">Pediatrician</span>
                <p>Expert in child healthcare, vaccinations, and pediatric emergencies.</p>
            </div>
            
            <div class="doctor-card">
                <div class="doc-img">
                    <img src="Public/Doctors/ShreyaPokharel.jpeg" alt="Dr. Shreya Pokharel" onerror="this.src='https://placehold.co/400x400/e2e8f0/0a5c8e?text=Dr.+Shreya'">
                </div>
                <h3>Dr. Shreya Pokharel</h3>
                <span class="specialty">Dentist & Maxillofacial</span>
                <p>Specialist in cosmetic dentistry, implants, and oral surgeries.</p>
            </div>
        </div>
    </div>
</section>

    <!-- ==================== TESTIMONIAL SECTION ==================== -->
<section class="testimonial">
    <div class="container testimonial-wrapper">
        <div class="testimonial-content">
            <span class="subtitle">Patient Feedback</span>
            <h3>Patient First Approach</h3>
            <p>"MediLife Hospital provided exceptional care during my treatment. The doctors were compassionate, the facilities were world-class, and the staff made me feel at home. Truly the best healthcare experience!"</p>
            
            <div class="patient-rating">
                <span>⭐ 4.9/5 based on 2,000+ patient reviews</span>
            </div>
            
            <div class="trust-badge">
                <span><i class="fas fa-shield-alt"></i> NABH Accredited</span>
                <span><i class="fas fa-clock"></i> 24/7 Emergency Service</span>
                <span><i class="fas fa-microscope"></i> Advanced Technology</span>
            </div>
        </div>
        <div class="testimonial-img">
            <img src="Public/Hospital/PatientCare.png" alt="Happy patient receiving care" onerror="this.src='https://placehold.co/600x500/e2e8f0/2563eb?text=Happy+Patient'">
        </div>
    </div>
</section>

    <!-- Reusable footer component -->
    <jsp:include page="components/footer.jsp" />

    <!-- ================= JAVASCRIPT SECTION ================= -->
    <script>

        /*
         * Function: checkLoginAndRedirect
         * --------------------------------
         * Checks if user session exists before allowing appointment booking.
         * 
         * Behavior:
         * - If logged in → redirect to booking page
         * - If not → show SweetAlert popup with login/register options
         */
        function checkLoginAndRedirect(event) {

            // Prevent default anchor navigation
            event.preventDefault();

            // JSP expression evaluates session value at server-side
            var isLoggedIn = ${not empty sessionScope.user_id};

            if (isLoggedIn) {

                // Redirect authenticated user
                window.location.href = '${pageContext.request.contextPath}/patient/book-appointment';

            } else {

                // Show login/register popup
                Swal.fire({
                    title: 'Login Required',
                    text: 'Please login or create an account.',
                    icon: 'info',

                    // UI customization
                    confirmButtonColor: '#2563eb',
                    cancelButtonColor: '#0ea5e9',

                    confirmButtonText: 'Go to Login',
                    showCancelButton: true,
                    cancelButtonText: 'Register'

                }).then((result) => {

                    // Handle user decision
                    if (result.isConfirmed) {
                        window.location.href = '${pageContext.request.contextPath}/login';

                    } else if (result.dismiss === Swal.DismissReason.cancel) {
                        window.location.href = '${pageContext.request.contextPath}/register';
                    }
                });
            }
        }

    </script>

</body>
</html>