<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>Health Blog — MedCare Hospital</title>
    
   <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"> 
   
<!-- External CSS files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/News.css">
</head>
<body>

 <!-- Include header JSP file -->
    <jsp:include page="../../components/header.jsp" />

<!-- ==================== BLOG HERO SECTION ==================== -->
<section class="blog-hero">
    <div class="blog-hero-container">
        <h1>Health & Wellness News</h1>
        <p class="hero-subtitle">Expert medical advice from our team of certified specialists</p>
        <div class="hero-search">
            <input type="text" placeholder="Search articles, conditions, treatments...">
            <button><i class="fas fa-search"></i> Search</button>
        </div>
    </div>
</section>

<!-- ==================== MAIN BLOG CONTENT ==================== -->
<main class="blog-container">

    <!-- Featured Post -->
    <section class="featured-post">
        <div class="featured-content">
            <span class="category-badge">Featured</span>
            <h2>Understanding Heart Disease: Prevention Starts Today</h2>
            <p class="post-meta">
                <span class="author"><i class="fas fa-user-md"></i> Dr. Arun Sharma, MD</span> &nbsp;|&nbsp;
                <span class="date"><i class="far fa-calendar-alt"></i> April 5, 2026</span>
            </p>
            <p class="excerpt">Cardiovascular disease remains the leading cause of mortality worldwide. Our Chief Cardiologist shares a comprehensive guide to risk factors, early warning signs, and lifestyle modifications every patient should know.</p>
            <a href="#" class="read-more-btn">Read Full Article <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="featured-image">
            <div class="img-placeholder">
                <img src="${pageContext.request.contextPath}/Public/Hospital/Cardiology & Heart Health.png" alt="Cardiology & Heart Health">
                
            </div>
        </div>
    </section>

    <!-- Blog Content Grid -->
    <div class="blog-content-grid">

        <!-- Main Content Column -->
        <div class="main-content">

            <!-- Category Filter -->
            <div class="category-filter">
                <h3>Browse by Department</h3>
                <div class="filter-buttons">
                    <button class="active">All</button>
                    <button>Cardiology</button>
                    <button>Neurology</button>
                    <button>Pediatrics</button>
                    <button>Orthopedics</button>
                    <button>Nutrition</button>
                    <button>Mental Health</button>
                </div>
            </div>

            <!-- Blog Posts Grid -->
            <div class="posts-grid">

                <article class="blog-post">
                    <div class="post-image">
                        <img src="${pageContext.request.contextPath}/Public/Hospital/neurology-stroke-signs.png" alt="Neurology Stroke Signs">
                        <span class="category-tag">Neurology</span>
                    </div>
                    <div class="post-content">
                        <h3>Early Signs of Stroke You Should Never Ignore</h3>
                        <p class="post-meta"><span class="author">Dr. Priya Joshi</span> | <span class="date">Apr 1, 2026</span></p>
                        <p class="post-excerpt">Recognizing the FAST warning signs of a stroke can mean the difference between full recovery and lasting damage.</p>
                        <div class="post-footer">
                            <a href="https://www.sciencenewstoday.org/the-warning-signs-of-stroke-you-should-never-ignore" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                            <span class="read-time"><i class="far fa-clock"></i> 5 min</span>
                        </div>
                    </div>
                </article>

                <article class="blog-post">
                    <div class="post-image">
                        <img src="${pageContext.request.contextPath}/Public/Hospital/pediatrics-vaccination.png" alt="Pediatrics Vaccination">
                        <span class="category-tag">Pediatrics</span>
                    </div>
                    <div class="post-content">
                        <h3>Childhood Vaccination Schedule: A Parent's Guide</h3>
                        <p class="post-meta"><span class="author">Dr. Anita Rai</span> | <span class="date">Mar 27, 2026</span></p>
                        <p class="post-excerpt">Stay on top of your child's immunizations with this updated guide covering every critical vaccine from birth to age 12.</p>
                        <div class="post-footer">
                            <a href="https://www.cdc.gov/vaccines/imz-schedules/index.html" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                            <span class="read-time"><i class="far fa-clock"></i> 7 min</span>
                        </div>
                    </div>
                </article>

                <article class="blog-post">
                    <div class="post-image">
                        <img src="${pageContext.request.contextPath}/Public/Hospital/orthopedics-knee-pain.png" alt="Orthopedics Knee Pain">
                        <span class="category-tag">Orthopedics</span>
                    </div>
                    <div class="post-content">
                        <h3>Knee Pain at 40: Causes, Treatment & When to See a Doctor</h3>
                        <p class="post-meta"><span class="author">Dr. Ramesh KC</span> | <span class="date">Mar 20, 2026</span></p>
                        <p class="post-excerpt">From osteoarthritis to ligament tears — understand the most common causes of knee pain and your best treatment options.</p>
                        <div class="post-footer">
                            <a href="https://www.verywellhealth.com/knee-pain-symptoms-2549628" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                            <span class="read-time"><i class="far fa-clock"></i> 6 min</span>
                        </div>
                    </div>
                </article>

                <article class="blog-post">
                    <div class="post-image">
                        <img src="${pageContext.request.contextPath}/Public/Hospital/nutrition-anti-inflammatory.png" alt="Nutrition Anti-Inflammatory Diet">
                        <span class="category-tag">Nutrition</span>
                    </div>
                    <div class="post-content">
                        <h3>Anti-Inflammatory Diet: Foods That Fight Chronic Disease</h3>
                        <p class="post-meta"><span class="author">Dr. Sunita Tamang</span> | <span class="date">Mar 14, 2026</span></p>
                        <p class="post-excerpt">Our clinical nutritionist explains how specific foods can reduce inflammation and lower risk of diabetes and heart disease.</p>
                        <div class="post-footer">
                            <a href="https://health.clevelandclinic.org/anti-inflammatory-diet" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                            <span class="read-time"><i class="far fa-clock"></i> 8 min</span>
                        </div>
                    </div>
                </article>

                <article class="blog-post">
                    <div class="post-image">
                        <img src="${pageContext.request.contextPath}/Public/Hospital/mental-health-anxiety.png" alt="Mental Health Anxiety Management">
                        <span class="category-tag">Mental Health</span>
                    </div>
                    <div class="post-content">
                        <h3>Managing Anxiety: Evidence-Based Techniques</h3>
                        <p class="post-meta"><span class="author">Dr. Mohan Adhikari</span> | <span class="date">Mar 8, 2026</span></p>
                        <p class="post-excerpt">Our psychiatry team shares clinically proven methods including CBT, mindfulness, and medication management.</p>
                        <div class="post-footer">
                            <a href="https://www.sciencenewstoday.org/10-most-effective-science-backed-anxiety-treatments" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                            <span class="read-time"><i class="far fa-clock"></i> 9 min</span>
                        </div>
                    </div>
                </article>

                <article class="blog-post">
                    <div class="post-image">
                        <img src="${pageContext.request.contextPath}/Public/Hospital/pulmonology-asthma-trigger.png" alt="Pulmonology Asthma Triggers">
                        <span class="category-tag">Pulmonology</span>
                    </div>
                    <div class="post-content">
                        <h3>Asthma Triggers at Home: Creating a Safer Environment</h3>
                        <p class="post-meta"><span class="author">Dr. Sita Gurung</span> | <span class="date">Mar 1, 2026</span></p>
                        <p class="post-excerpt">Hidden household triggers can worsen asthma symptoms. Our pulmonologist identifies the top culprits and practical steps.</p>
                        <div class="post-footer">
                            <a href="https://www.healthline.com/health/asthma/asthma-friendly-home#1" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                            <span class="read-time"><i class="far fa-clock"></i> 6 min</span>
                        </div>
                    </div>
                </article>

            </div><!-- /posts-grid -->

            <!-- Pagination - Completely removed as requested -->
            <!-- No page numbers slider -->

        </div><!-- /main-content -->

        <!-- Sidebar -->
        <aside class="sidebar">

            <div class="sidebar-widget about-widget">
                <h3>About Our Blog</h3>
                <div class="widget-content">
                    <div class="widget-img">
                        <img src="${pageContext.request.contextPath}/Public/Doctors/Doctors.png" alt="Our Doctors">
                    </div>
                    <p>Written exclusively by our board-certified physicians. Every article is peer-reviewed for accuracy and clinical relevance.</p>
                    <a href="#" class="learn-more">Meet Our Doctors <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>

            <div class="sidebar-widget">
                <h3>Most Read Articles</h3>
                <div class="widget-content">
                    <div class="popular-post">
                        <div class="pop-thumb">
                            <img src="${pageContext.request.contextPath}/Public/Hospital/blood-pressure-thumb.png" alt="Blood Pressure">
                        </div>
                        <div class="post-info">
                            <h4><a href="#">Blood Pressure Numbers Explained</a></h4>
                            <span class="date">March 5, 2026</span>
                        </div>
                    </div>
                    <div class="popular-post">
                        <div class="pop-thumb">
                            <img src="${pageContext.request.contextPath}/Public/Hospital/diabetes-management-thumb.png" alt="Diabetes Management">
                        </div>
                        <div class="post-info">
                            <h4><a href="#">Diabetes Management: Day-by-Day Plan</a></h4>
                            <span class="date">February 18, 2026</span>
                        </div>
                    </div>
                    <div class="popular-post">
                        <div class="pop-thumb">
                            <img src="${pageContext.request.contextPath}/Public/Hospital/drug-interactions-thumb.png" alt="Drug Interactions">
                        </div>
                        <div class="post-info">
                            <h4><a href="#">Common Drug Interactions to Know</a></h4>
                            <span class="date">February 2, 2026</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="sidebar-widget">
                <h3>Departments</h3>
                <div class="widget-content">
                    <ul class="dept-list">
                        <li><a href="#">Cardiology <span class="dept-count">42</span></a></li>
                        <li><a href="#">Neurology <span class="dept-count">28</span></a></li>
                        <li><a href="#">Pediatrics <span class="dept-count">35</span></a></li>
                        <li><a href="#">Orthopedics <span class="dept-count">19</span></a></li>
                        <li><a href="#">Nutrition <span class="dept-count">31</span></a></li>
                        <li><a href="#">Mental Health <span class="dept-count">26</span></a></li>
                    </ul>
                </div>
            </div>

            <!-- ==================== PATIENT APPOINTMENT STATUS CONTAINER ==================== -->
            <!-- This replaces the newsletter and follow us widgets -->
            <div class="sidebar-widget appointment-widget">
                <h3><i class="fas fa-calendar-check"></i> Appointment Status</h3>
                <div class="widget-content">
                    <div class="appointment-status-container">
                        <!-- Example Patient 1 - Registered/Confirmed -->
                        <div class="appointment-card status-registered">
                            <div class="appointment-icon">
                                <i class="fas fa-user-check"></i>
                            </div>
                            <div class="appointment-details">
                                <div class="patient-name">Ramesh Adhikari</div>
                                <div class="appointment-info">
                                    <span class="dept-badge"><i class="fas fa-heartbeat"></i> Cardiology</span>
                                    <span class="appointment-date"><i class="far fa-calendar"></i> Apr 15, 2026</span>
                                </div>
                                <div class="status-badge registered">
                                    <i class="fas fa-check-circle"></i> Appointment Registered
                                </div>
                            </div>
                        </div>

                        <!-- Example Patient 2 - Registered/Confirmed -->
                        <div class="appointment-card status-registered">
                            <div class="appointment-icon">
                                <i class="fas fa-user-check"></i>
                            </div>
                            <div class="appointment-details">
                                <div class="patient-name">Sita Gurung</div>
                                <div class="appointment-info">
                                    <span class="dept-badge"><i class="fas fa-stethoscope"></i> General Medicine</span>
                                    <span class="appointment-date"><i class="far fa-calendar"></i> Apr 16, 2026</span>
                                </div>
                                <div class="status-badge registered">
                                    <i class="fas fa-check-circle"></i> Appointment Registered
                                </div>
                            </div>
                        </div>

                        <!-- Example Patient 3 - Pending/Processing -->
                        <div class="appointment-card status-pending">
                            <div class="appointment-icon">
                                <i class="fas fa-hourglass-half"></i>
                            </div>
                            <div class="appointment-details">
                                <div class="patient-name">Bikram Thapa</div>
                                <div class="appointment-info">
                                    <span class="dept-badge"><i class="fas fa-brain"></i> Neurology</span>
                                    <span class="appointment-date"><i class="far fa-calendar"></i> Apr 18, 2026</span>
                                </div>
                                <div class="status-badge pending">
                                    <i class="fas fa-clock"></i> Processing / Pending
                                </div>
                            </div>
                        </div>

                        <!-- Example Patient 4 - Completed/Checked Out -->
                        <div class="appointment-card status-completed">
                            <div class="appointment-icon">
                                <i class="fas fa-flag-checkered"></i>
                            </div>
                            <div class="appointment-details">
                                <div class="patient-name">Laxmi Poudel</div>
                                <div class="appointment-info">
                                    <span class="dept-badge"><i class="fas fa-baby"></i> Pediatrics</span>
                                    <span class="appointment-date"><i class="far fa-calendar"></i> Apr 10, 2026</span>
                                </div>
                                <div class="status-badge completed">
                                    <i class="fas fa-check-double"></i> Completed
                                </div>
                            </div>
                        </div>

                        <!-- View All Link / Track Appointment -->
                        <div class="track-appointment-link">
                            <a href="#">
                                Track Your Appointment <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </aside>
    </div>
</main>

 <!-- Include header JSP file -->
    <jsp:include page="../../components/footer.jsp" />
    
<!-- Back to Top Button -->
<button id="back-to-top" title="Back to top"><i class="fas fa-chevron-up"></i></button>

<!-- JavaScript -->
<script>
    // Back to top button
    var btn = document.getElementById('back-to-top');
    if (btn) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 300) {
                btn.classList.add('visible');
            } else {
                btn.classList.remove('visible');
            }
        });
        btn.addEventListener('click', function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }

    // Category filter buttons
    var filterButtons = document.querySelectorAll('.filter-buttons button');
    filterButtons.forEach(function(b) {
        b.addEventListener('click', function() {
            filterButtons.forEach(function(x) {
                x.classList.remove('active');
            });
            this.classList.add('active');
        });
    });
</script>

</body>
</html>