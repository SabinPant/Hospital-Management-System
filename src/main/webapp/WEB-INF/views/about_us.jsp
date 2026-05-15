<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | MediLife Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/global.css">
    <link rel="stylesheet" href="CSS/about_us.css">
</head>
<body>

<jsp:include page="../../components/header.jsp" />

    <!-- ================================================
         HERO — background image + dark overlay + text
         ================================================ -->
    <section class="au-hero">
        <div class="au-hero-bg">
            <img src="Public/Hospital/aboutus.png" alt="MediLife Hospital"
                 onerror="this.src='https://placehold.co/1400x520/074268/ffffff?text=MediLife+Hospital'">
        </div>
        <div class="au-hero-overlay"></div>
        <div class="container au-hero-content">
            <h1>About <span class="au-hl">MediLife</span></h1>
            <p>Delivering compassionate, cutting-edge healthcare since 1998. We treat every
               patient like family with personalized care and advanced medical technology.</p>
            <a href="#story" class="au-hero-btn">Explore Our Story</a>
        </div>
    </section>

    <!-- ================================================
         THE MEDILIFE STORY
         Icon + centred title → two equal text columns
         ================================================ -->
    <section class="au-story" id="story">
        <div class="container">
            <div class="au-story-head">
                <div class="au-story-icon"><i class="fas fa-hospital-user"></i></div>
                <h2>The MediLife Story</h2>
            </div>
            <div class="au-story-cols">
                <div class="au-col">
                    <p><strong>Kathmandu, Nepal</strong> — serving the community since 1998 from our flagship campus.
                    	MediLife Hospital, located in Kathmandu, Nepal, stands as a trusted symbol of quality healthcare
                    	and community service. Established in 1998, MediLife began as a modest clinic with only a handful
                    	of dedicated physicians who shared a common vision—to provide accessible, compassionate, and reliable
                    	medical care to the people of Kathmandu. Despite its small beginnings, the hospital quickly earned a
                    	reputation for patient-centered treatment and ethical medical practices.</p>
                    <p> Over the past two decades, MediLife has grown significantly, evolving into a full-service hospital 
                    equipped with modern facilities and advanced medical technology. Today, it is home to more than 500 
                    medical professionals, including highly trained doctors, nurses, and specialists across various departments 
                    such as cardiology, neurology, emergency care, and diagnostics. This growth reflects MediLife's commitment 
                    to continuously improving healthcare services and meeting the increasing demands of the community.</p>	
                 </div>
                <div class="au-col">
                    <p>
                    Situated in the heart of Kathmandu, the hospital serves as a vital healthcare hub for both urban and 
                    surrounding populations. Its flagship campus is designed to ensure patient comfort while maintaining high 
                    standards of medical excellence. MediLife's journey from a small clinic to a leading healthcare institution 
                    is rooted in its dedication to innovation, trust, and compassion.
                    </p>
                    <p>Through years of service, MediLife has remained focused on its core mission—enhancing lives through quality 
                    healthcare. Its strong foundation, combined with a forward-looking approach, continues to make it a cornerstone 
                    of medical care in Nepal.</p>
                </div>
        </div>
    </section>

    <!-- ================================================
         OUR SERVICES — 3 clickable image cards
         ================================================ -->
    <section class="au-services">
        <div class="container">
            <h2 class="au-sec-title">Our Services</h2>
            <div class="au-svc-grid">

                <a href="emergency-services.jsp" class="au-svc-card">
                    <img src="Public/Hospital/Emergency.png" alt="Emergency Services"
                         onerror="this.src='https://placehold.co/440x260/b0bec5/37474f?text=Emergency+Services'">
                    <div class="au-svc-caption">
                        <i class="fas fa-ambulance"></i> Emergency Services
                    </div>
                </a>

                <a href="consultation-services.jsp" class="au-svc-card">
                    <img src="Public/Hospital/Diagnostic Services.jpeg" alt="Diagnostic Services"
                         onerror="this.src='https://placehold.co/440x260/b0bec5/37474f?text=Diagnostic+Services'">
                    <div class="au-svc-caption">
                        <i class="fas fa-stethoscope"></i> Diagnostic Services
                    </div>
                </a>

                <a href="maternity-services.jsp" class="au-svc-card">
                    <img src="Public/Hospital/Maternity and Child Care department.jpeg" alt="Maternity and Child Care"
                         onerror="this.src='https://placehold.co/440x260/b0bec5/37474f?text=Maternity+and+Child+Care'">
                    <div class="au-svc-caption">
                        <i class="fas fa-baby-carriage"></i> Maternity and Child Care
                    </div>
                </a>

            </div>
        </div>
    </section>

    <!-- ================================================
         MISSION & VALUE
         Centred heading → left text | right image
         ================================================ -->
<section class="au-mv">
    <div class="container">
        <h2 class="au-sec-title">Our mission and value</h2>
        <div class="au-mv-grid">

            <!-- LEFT: Mission -->
            <div class="au-mv-col">
                <h3>Mission</h3>
                <ul>
                    <li>To provide exceptional, patient-centered healthcare through innovation,
                        compassion, and clinical excellence, ensuring every patient receives the
                        right care at the right time.</li>
                    <li>To promote and protect, as both innovator and advocate, the health,
                        welfare, and safety of the people of the City of Kathmandu.</li>
                </ul>
            </div>

            <!-- RIGHT: Values -->
            <div class="au-mv-col">
                <h3>Values</h3>
                <ul>
                    <li>It will help us offer our patients a better experience when under our
                        care and will increase staff awareness to become better engaged with the
                        mission and vision of the organization.</li>
                </ul>
            </div>

        </div>
    </div>
</section>
    <!-- ================================================
         RESEARCH AT MEDILIFE
         Grey card: image left | title + text + Read More right
         ================================================ -->
    <section class="au-research">
        <div class="container">
            <div class="au-research-card">
                <div class="au-research-img">
                    <img src="Public/Hospital/Research.png" alt="Research at MediLife"
                         onerror="this.src='https://placehold.co/400x300/9e9e9e/ffffff?text=Image'">
                </div>
                <div class="au-research-text">
                    <h2>Research at MediLife</h2>
                    <p>MediLife is committed to advancing medical science through rigorous clinical
                       research, partnerships with leading universities, and evidence-based practice.
                       Our research wing focuses on oncology, cardiology, and infectious disease
                       management.</p>
                    <p>Every year our team publishes findings that shape healthcare policy and
                       improve patient outcomes across the region.</p>
                    <a href="${pageContext.request.contextPath}/research">Read More <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </section>

    <!-- ================================================
         MEET OUR SPECIALISTS
         Professional row layout — one specialist per row
         Fixed square images for perfect consistency
         ================================================ -->
    <section class="au-specialists">
        <div class="container">
            <div class="au-spec-header">
                <h2>Meet Our Specialists</h2>
                <p>Compassionate, highly skilled doctors ready to give you the best care.</p>
            </div>

            <!-- Dr. Sabin Pant -->
            <div class="au-spec-card">
                <div class="au-spec-img">
                    <img src="Public/Doctors/SabinPant.jpg" alt="Dr. Sabin Pant"
                         onerror="this.src='https://placehold.co/440x440/9e9e9e/ffffff?text=Dr.+Sabin'">
                </div>
                <div class="au-spec-info">
                    <span class="au-spec-tag">Chief Cardiologist</span>
                    <h3>Dr. Sabin Pant</h3>
                    <div class="au-spec-meta">
                        <span><i class="fas fa-graduation-cap"></i> MBBS, MD – Cardiology</span>
                        <span><i class="fas fa-clock"></i> 15+ Years Experience</span>
                        <span><i class="fas fa-hospital"></i> Cardiology Dept, MediLife</span>
                    </div>
                    <div class="au-spec-divider"></div>
                    <p>Leading interventional cardiologist specialising in heart failure management,
                       angioplasty, and preventive cardiac care. Performed over 2,000 successful
                       cardiac procedures and is visiting faculty at Tribhuvan University.</p>
                    <div class="au-spec-actions">
                        <a href="${pageContext.request.contextPath}/portfolio/sabin-pant" class="au-profile-btn">
                            View Profile <i class="fas fa-arrow-right"></i>
                        </a>
                        <div class="au-spec-social">
                            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dr. Priyanshu Mahat -->
            <div class="au-spec-card">
                <div class="au-spec-img">
                    <img src="Public/Doctors/PriyanshuMahat.jpeg" alt="Dr. Priyanshu Mahat"
                         onerror="this.src='https://placehold.co/440x440/9e9e9e/ffffff?text=Dr.+Priyanshu'">
                </div>
                <div class="au-spec-info">
                    <span class="au-spec-tag">Senior Neurologist</span>
                    <h3>Dr. Priyanshu Mahat</h3>
                    <div class="au-spec-meta">
                        <span><i class="fas fa-graduation-cap"></i> MBBS, DM – Neurology</span>
                        <span><i class="fas fa-clock"></i> 12+ Years Experience</span>
                        <span><i class="fas fa-hospital"></i> Neurology Dept, MediLife</span>
                    </div>
                    <div class="au-spec-divider"></div>
                    <p>Expert in stroke management, epilepsy, and movement disorders. Research on
                       early stroke intervention published in multiple international journals. Leads
                       MediLife's neurology outreach programme.</p>
                    <div class="au-spec-actions">
                        <a href="${pageContext.request.contextPath}/portfolio/priyanshu-mahat" class="au-profile-btn">
                            View Profile <i class="fas fa-arrow-right"></i>
                        </a>
                        <div class="au-spec-social">
                            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dr. Aryan Shakya -->
            <div class="au-spec-card">
                <div class="au-spec-img">
                    <img src="Public/Doctors/AryanShakya.jpeg" alt="Dr. Aryan Shakya"
                         onerror="this.src='https://placehold.co/440x440/9e9e9e/ffffff?text=Dr.+Aryan'">
                </div>
                <div class="au-spec-info">
                    <span class="au-spec-tag">Orthopedic Surgeon</span>
                    <h3>Dr. Aryan Shakya</h3>
                    <div class="au-spec-meta">
                        <span><i class="fas fa-graduation-cap"></i> MBBS, MS – Orthopedics</span>
                        <span><i class="fas fa-clock"></i> 10+ Years Experience</span>
                        <span><i class="fas fa-hospital"></i> Surgery Dept, MediLife</span>
                    </div>
                    <div class="au-spec-divider"></div>
                    <p>Specialist in joint replacement, complex spine procedures, and sports injury
                       rehabilitation. Trained at AIIMS New Delhi — introduced minimally invasive
                       orthopedic techniques to MediLife.</p>
                    <div class="au-spec-actions">
                        <a href="${pageContext.request.contextPath}/portfolio/aryan-shakya" class="au-profile-btn">
                            View Profile <i class="fas fa-arrow-right"></i>
                        </a>
                        <div class="au-spec-social">
                            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dr. Rabin Pant -->
            <div class="au-spec-card">
                <div class="au-spec-img">
                    <img src="Public/Doctors/RabinPant.jpeg" alt="Dr. Rabin Pant"
                         onerror="this.src='https://placehold.co/440x440/9e9e9e/ffffff?text=Dr.+Rabin'">
                </div>
                <div class="au-spec-info">
                    <span class="au-spec-tag">Pediatrician</span>
                    <h3>Dr. Rabin Pant</h3>
                    <div class="au-spec-meta">
                        <span><i class="fas fa-graduation-cap"></i> MBBS, MD – Pediatrics</span>
                        <span><i class="fas fa-clock"></i> 13+ Years Experience</span>
                        <span><i class="fas fa-hospital"></i> Pediatrics Dept, MediLife</span>
                    </div>
                    <div class="au-spec-divider"></div>
                    <p>Dedicated to child health, vaccination programmes, and neonatal care. Heads
                       MediLife's child wellness initiative and has conducted free health camps across
                       rural communities in Bagmati Province.</p>
                    <div class="au-spec-actions">
                        <a href="${pageContext.request.contextPath}/portfolio/rabin-pant" class="au-profile-btn">
                            View Profile <i class="fas fa-arrow-right"></i>
                        </a>
                        <div class="au-spec-social">
                            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dr. Shreya Pokharel -->
            <div class="au-spec-card">
                <div class="au-spec-img">
                    <img src="Public/Doctors/ShreyaPokharel.jpeg" alt="Dr. Shreya Pokharel"
                         onerror="this.src='https://placehold.co/440x440/9e9e9e/ffffff?text=Dr.+Shreya'">
                </div>
                <div class="au-spec-info">
                    <span class="au-spec-tag">Dentist &amp; Maxillofacial Surgeon</span>
                    <h3>Dr. Shreya Pokharel</h3>
                    <div class="au-spec-meta">
                        <span><i class="fas fa-graduation-cap"></i> BDS, MDS – Oral Surgery</span>
                        <span><i class="fas fa-clock"></i> 9+ Years Experience</span>
                        <span><i class="fas fa-hospital"></i> Dental Dept, MediLife</span>
                    </div>
                    <div class="au-spec-divider"></div>
                    <p>Specialist in cosmetic dentistry, dental implants, corrective jaw surgery, and
                       complex oral procedures. Her advanced training has made MediLife the leading
                       dental centre in the Kathmandu Valley.</p>
                    <div class="au-spec-actions">
                        <a href="${pageContext.request.contextPath}/portfolio/shreya-pokharel" class="au-profile-btn">
                            View Profile <i class="fas fa-arrow-right"></i>
                        </a>
                        <div class="au-spec-social">
                            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                            <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <jsp:include page="../../components/footer.jsp" />

</body>
</html>