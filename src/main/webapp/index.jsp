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

<!-- ==================== WHY CHOOSE US ==================== -->
<section class="why-us">
    <div class="container">
        <div class="section-header">
            <span class="subtitle">Why MediLife</span>
            <h2>What Makes Us <span class="highlight">Different</span></h2>
            <p>We combine advanced technology with compassionate care to deliver the best patient experience.</p>
        </div>
        
        <div class="why-us-grid">
            <div class="why-us-card">
                <div class="why-us-icon blue">
                    <i class="fas fa-user-md"></i>
                </div>
                <h3>Expert Medical Team</h3>
                <p>500+ highly qualified doctors, surgeons, and specialists with international training and decades of experience.</p>
            </div>
            
            <div class="why-us-card">
                <div class="why-us-icon green">
                    <i class="fas fa-microchip"></i>
                </div>
                <h3>Advanced Technology</h3>
                <p>State-of-the-art imaging, robotic surgery, and diagnostic labs equipped with the latest medical technology.</p>
            </div>
            
            <div class="why-us-card">
                <div class="why-us-icon amber">
                    <i class="fas fa-heart"></i>
                </div>
                <h3>Patient-Centered Care</h3>
                <p>Every treatment plan is personalized. We treat patients like family with dignity, respect, and empathy.</p>
            </div>
            
            <div class="why-us-card">
                <div class="why-us-icon purple">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3>Accredited & Certified</h3>
                <p>NABH accredited hospital following international healthcare quality and patient safety standards.</p>
            </div>
        </div>
    </div>
</section>

<!-- ==================== STATS COUNTER ==================== -->
<section class="stats-counter">
    <div class="container">
        <div class="stats-counter-grid">
            <div class="stat-item">
                <div class="stat-number">25+</div>
                <p>Years of Excellence</p>
            </div>
            <div class="stat-item">
                <div class="stat-number">500+</div>
                <p>Expert Doctors</p>
            </div>
            <div class="stat-item">
                <div class="stat-number">50,000+</div>
                <p>Happy Patients</p>
            </div>
            <div class="stat-item">
                <div class="stat-number">15,000+</div>
                <p>Successful Surgeries</p>
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

<!-- ==================== NEWS / HEALTH TIPS ==================== -->
<section class="news-section">
    <div class="container">
        <div class="section-header">
            <span class="subtitle">Health Hub</span>
            <h2>Latest <span class="highlight">Health Updates</span></h2>
            <p>Stay informed with tips, news, and insights from our medical experts.</p>
        </div>
        
        <div class="news-grid">
            <div class="news-card">
                <div class="news-img">
                    <img src="Public/Hospital/Research.png" alt="Heart Health" onerror="this.src='https://placehold.co/600x400/e2e8f0/0a5c8e?text=Heart+Health'">
                </div>
                <div class="news-body">
                    <span class="news-category">Cardiology</span>
                    <h3>5 Daily Habits for a Healthy Heart</h3>
                    <p>Simple lifestyle changes that can significantly reduce your risk of heart disease.</p>
                    <a href="${pageContext.request.contextPath}/research" class="news-link">Read More <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
            
            <div class="news-card">
                <div class="news-img">
                    <img src="Public/Hospital/Diagnostic Services.jpeg" alt="Diagnostics" onerror="this.src='https://placehold.co/600x400/e2e8f0/0a5c8e?text=Diagnostics'">
                </div>
                <div class="news-body">
                    <span class="news-category">Wellness</span>
                    <h3>Why Regular Health Checkups Matter</h3>
                    <p>Early detection saves lives. Learn which screenings you need at every age.</p>
                    <a href="${pageContext.request.contextPath}/research" class="news-link">Read More <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
            
            <div class="news-card">
                <div class="news-img">
                    <img src="Public/Hospital/Maternity and Child Care department.jpeg" alt="Maternity" onerror="this.src='https://placehold.co/600x400/e2e8f0/0a5c8e?text=Maternity+Care'">
                </div>
                <div class="news-body">
                    <span class="news-category">Maternity</span>
                    <h3>A Complete Guide to Prenatal Care</h3>
                    <p>Everything expecting mothers need to know for a healthy pregnancy journey.</p>
                    <a href="${pageContext.request.contextPath}/research" class="news-link">Read More <i class="fas fa-arrow-right"></i></a>
                </div>
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

<!-- ==================== CTA BANNER ==================== -->
<section class="cta-banner">
    <div class="container">
        <div class="cta-banner-inner">
            <h2>Ready to Experience the Best in Healthcare?</h2>
            <p>Book your appointment today and take the first step towards better health with MediLife's expert medical team.</p>
            <a href="#" class="btn-primary" onclick="checkLoginAndRedirect(event)">
                Book Appointment <i class="fas fa-arrow-right"></i>
            </a>
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