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

    <!-- ================= SERVICES SECTION ================= -->
    <!-- Displays all available hospital services -->
    <section class="services">
        <div class="container">

            <div class="section-header">
                <span class="subtitle">Our Expertise</span>
                <h2>We Offer the Best <span class="highlight">Medical Services</span></h2>
            </div>

            <!-- Service cards grid -->
            <div class="services-grid">
                
                <!-- Example service -->
                <div class="service-card">
                    <div class="icon-wrapper">
                        <i class="fas fa-ambulance"></i>
                    </div>
                    <h3>Emergency Services</h3>
                    <p>24/7 emergency care and trauma support.</p>
                </div>

                <!-- 
                    Repeatable card structure for scalability.
                    Easily extendable for dynamic DB-driven content later.
                -->

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
            </div>

            <div class="doctors-grid">

                <!-- Doctor Card -->
                <div class="doctor-card">
                    <div class="doc-img">
                        <!-- Fallback image handling -->
                        <img src="Public/Doctors/SabinPant.jpg" alt="Dr. Sabin Pant"
                             onerror="this.src='https://placehold.co/400x400/...';">
                    </div>
                    <h3>Dr. Sabin Pant</h3>
                    <span class="specialty">Chief Cardiologist</span>
                    <p>15+ years in cardiology.</p>
                </div>

                <!-- 
                    Note:
                    These doctor entries are hardcoded.
                    In production, fetch from database using JSTL/Servlet.
                -->

            </div>
        </div>
    </section>

    <!-- ================= TESTIMONIAL SECTION ================= -->
    <!-- Displays patient feedback and trust indicators -->
    <section class="testimonial">
        <div class="container testimonial-wrapper">

            <div class="testimonial-content">
                <span class="subtitle">Patient Feedback</span>

                <!-- Example testimonial -->
                <p>
                    "MediLife Hospital provided exceptional care..."
                </p>

                <!-- Ratings -->
                <div class="patient-rating">
                    <span>⭐ 4.9/5 based on reviews</span>
                </div>

                <!-- Trust badges -->
                <div class="trust-badge">
                    <span><i class="fas fa-shield-alt"></i> Accredited</span>
                </div>
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