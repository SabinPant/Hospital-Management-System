<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediLife Hospital | Advanced Care</title>
    <!-- Google Fonts & Font Awesome -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,600;14..32,700;14..32,800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="CSS/global.css">
    <link rel="stylesheet" href="CSS/index.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

    <!-- Include Header Component -->
    <jsp:include page="components/header.jsp" />

    <!-- ==================== HERO SECTION ==================== -->
    <section class="hero">
        <div class="container hero-grid">
            <div class="hero-content">
                <span class="hero-badge"><i class="fas fa-heartbeat"></i> Trusted Care Since 1998</span>
                <h1>A Brighter <span class="highlight">Healthcare</span> Experience</h1>
                <p>Providing compassionate, world-class medical care with advanced technology and a patient-first approach. Your health is our priority, 24/7.</p>
                <div class="hero-buttons">
    <a href="#" class="btn-primary" onclick="checkLoginAndRedirect(event)">BOOK APPOINTMENT <i class="fas fa-calendar-check"></i></a>
</div>
                <div class="stats">
                    <div><span>25+</span> Years of Excellence</div>
                    <div><span>500+</span> Expert Doctors</div>
                    <div><span>50k+</span> Happy Patients</div>
                </div>
            </div>
            <div class="hero-image">
                <img src="Public/Hospital/MediLife.png" alt="Medical Team" onerror="this.src='https://placehold.co/600x500/e3f2fd/0a5c8e?text=MediLife+Hospital'">
            </div>
        </div>
    </section>

    <!-- ==================== SERVICES SECTION ==================== -->
    <section class="services">
        <div class="container">
            <div class="section-header">
                <span class="subtitle">Our Expertise</span>
                <h2>We Offer Best <span class="highlight">Medical Services</span></h2>
                <p>Comprehensive healthcare solutions tailored to your needs, from emergency to specialized departments.</p>
            </div>
            <div class="services-grid">
                <div class="service-card"><i class="fas fa-ambulance"></i><h3>Emergency Services</h3><p>24/7 emergency care, ambulance services, trauma care, and critical response team.</p></div>
                <div class="service-card"><i class="fas fa-stethoscope"></i><h3>Outpatient (OPD)</h3><p>Doctor consultations without admission, routine checkups, and follow-up visits.</p></div>
                <div class="service-card"><i class="fas fa-procedures"></i><h3>Inpatient (IPD)</h3><p>Full-time stay with room/bed, nursing care, meals, and continuous monitoring.</p></div>
                <div class="service-card"><i class="fas fa-microscope"></i><h3>Diagnostic Services</h3><p>Laboratory tests, X-ray, MRI, CT scan, Ultrasound, and advanced imaging.</p></div>
                <div class="service-card"><i class="fas fa-scalpel"></i><h3>Surgical Services</h3><p>Minor to major surgeries: Orthopedic, Cardiac, Neurology, and specialized operations.</p></div>
                <div class="service-card"><i class="fas fa-prescription-bottle-alt"></i><h3>Pharmacy Services</h3><p>Medicines provided inside hospital, prescription management, 24/7 pharmacy.</p></div>
                <div class="service-card"><i class="fas fa-baby-carriage"></i><h3>Maternity & Child Care</h3><p>Pregnancy care, normal & C-section delivery, neonatal care for newborns.</p></div>
                <div class="service-card"><i class="fas fa-brain"></i><h3>Specialized Departments</h3><p>Cardiology, Neurology, Oncology, Dermatology, ENT, and more specialized care.</p></div>
            </div>
        </div>
    </section>

    <!-- ==================== DOCTORS SECTION ==================== -->
    <section class="doctors">
        <div class="container">
            <div class="section-header">
                <span class="subtitle">Expert Team</span>
                <h2>Meet Our <span class="highlight">Specialists</span></h2>
                <p>Compassionate, highly skilled doctors ready to give you the best care.</p>
            </div>
            <div class="doctors-grid">
                <div class="doctor-card">
                    <div class="doc-img">
                        <img src="Public/Doctors/SabinPant.jpg" alt="Dr. Sabin Pant" onerror="this.src='https://placehold.co/400x400/e3f2fd/0a5c8e?text=Dr.+Sabin'">
                    </div>
                    <h3>Dr. Sabin Pant</h3>
                    <span class="specialty">Chief Cardiologist</span>
                    <p>15+ years experience in interventional cardiology, heart failure, and preventive cardiac care.</p>
                    <div class="social-icons">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doc-img">
                        <img src="Public/Doctors/PriyanshuMahat.jpeg" alt="Dr. Priyanshu Mahat" onerror="this.src='https://placehold.co/400x400/e3f2fd/0a5c8e?text=Dr.+Priyanshu'">
                    </div>
                    <h3>Dr. Priyanshu Mahat</h3>
                    <span class="specialty">Senior Neurologist</span>
                    <p>Expert in stroke management, epilepsy, movement disorders, and complex brain surgeries.</p>
                    <div class="social-icons">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doc-img">
                        <img src="Public/Doctors/AryanShakya.jpeg" alt="Dr. Aryan Shakya" onerror="this.src='https://placehold.co/400x400/e3f2fd/0a5c8e?text=Dr.+Aryan'">
                    </div>
                    <h3>Dr. Aryan Shakya</h3>
                    <span class="specialty">Orthopedic Surgeon</span>
                    <p>Specialist in joint replacement, sports injuries, spine surgeries, and trauma care.</p>
                    <div class="social-icons">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doc-img">
                        <img src="Public/Doctors/RabinPant.jpeg" alt="Dr. Rabin Pant" onerror="this.src='https://placehold.co/400x400/e3f2fd/0a5c8e?text=Dr.+Rabin'">
                    </div>
                    <h3>Dr. Rabin Pant</h3>
                    <span class="specialty">Pediatrician</span>
                    <p>Expert in child healthcare, vaccinations, growth monitoring, and pediatric emergencies.</p>
                    <div class="social-icons">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="doctor-card">
                    <div class="doc-img">
                        <img src="Public/Doctors/ShreyaPokharel.jpeg" alt="Dr. Shreya Pokharel" onerror="this.src='https://placehold.co/400x400/e3f2fd/0a5c8e?text=Dr.+Shreya'">
                    </div>
                    <h3>Dr. Shreya Pokharel</h3>
                    <span class="specialty">Dentist & Maxillofacial Surgeon</span>
                    <p>Specialist in cosmetic dentistry, dental implants, root canal, and oral surgeries.</p>
                    <div class="social-icons">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==================== TESTIMONIAL SECTION ==================== -->
    <section class="testimonial">
        <div class="container testimonial-wrapper">
            <div class="testimonial-content">
                <i class="fas fa-quote-left quote-icon"></i>
                <h3>Patient First Approach</h3>
                <p>"MediLife Hospital provided exceptional care during my treatment. The doctors were compassionate, the facilities were world-class, and the staff made me feel at home. Truly the best healthcare experience!"</p>
                <div class="patient-rating">
                    <span>⭐ 4.9/5 based on 2,000+ patient reviews</span>
                </div>
                <div class="trust-badge">
                    <i class="fas fa-shield-alt"></i> NABH Accredited 
                    <i class="fas fa-clock"></i> 24/7 Emergency Service 
                    <i class="fas fa-microscope"></i> Advanced Technology
                </div>
            </div>
            <div class="testimonial-img">
                <img src="Public/Hospital/PatientCare.png" alt="Happy patient receiving care" onerror="this.src='https://placehold.co/450x350/e3f2fd/0a5c8e?text=Happy+Patient'">
            </div>
        </div>
    </section>

    <!-- Include Footer Component -->
    <jsp:include page="components/footer.jsp" />

<script>
    function checkLoginAndRedirect(event) {
        event.preventDefault();
        var isLoggedIn = ${not empty sessionScope.user_id};
        
        if (isLoggedIn) {
            window.location.href = '${pageContext.request.contextPath}/patient/book-appointment';
        } else {
            Swal.fire({
                title: 'Login Required',
                text: 'Please login or create an account to book an appointment.',
                icon: 'info',
                confirmButtonColor: '#0a5c8e',
                confirmButtonText: 'Go to Login',
                showCancelButton: true,
                cancelButtonText: 'Register',
                cancelButtonColor: '#10b981'
            }).then((result) => {
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