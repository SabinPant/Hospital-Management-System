<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${doctor.name} | MediLife Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/portfolio.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<jsp:include page="../../../components/header.jsp" />

<div class="dp-wrapper">

    <!-- Back Link -->
    <a href="${pageContext.request.contextPath}/about_us" class="dp-back">
        <i class="fas fa-arrow-left"></i> Back to About Us
    </a>

    <!-- ── Hero Banner ── -->
    <div class="dp-hero">
        <div class="dp-hero-avatar">
            <c:choose>
                <c:when test="${not empty doctor.image}">
                    <img src="${pageContext.request.contextPath}/${doctor.image}" alt="${doctor.name}">
                </c:when>
                <c:otherwise>
                    <i class="fas fa-user-md"></i>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="dp-hero-info">
            <h1>${doctor.name}</h1>
            <p class="dp-specialty">${doctor.specialization}</p>
            <div class="dp-hero-tags">
                <span class="dp-tag"><i class="fas fa-graduation-cap"></i> ${doctor.qualification}</span>
                <span class="dp-tag"><i class="fas fa-clock"></i> ${doctor.experience}</span>
                <span class="dp-tag"><i class="fas fa-hospital"></i> ${doctor.department}</span>
            </div>
        </div>
    </div>

    <!-- ── Main Content: left column + sidebar ── -->
    <div class="dp-content">

        <!-- ════ LEFT COLUMN ════ -->
        <div class="dp-main-col">

            <!-- 1. About / Biography  (full width) -->
            <div class="dp-card">
                <div class="dp-card-header">
                    <i class="fas fa-user-circle"></i>
                    <h2>About Dr. ${doctor.lastName}</h2>
                </div>
                <div class="dp-card-body">
                    <c:forEach var="para" items="${doctor.biography}">
                        <p>${para}</p>
                    </c:forEach>
                </div>
            </div>

            <!-- 2. Education + Experience  (side-by-side) -->
            <div class="dp-card-row">

                <!-- Education & Qualifications -->
                <div class="dp-card">
                    <div class="dp-card-header">
                        <i class="fas fa-university"></i>
                        <h2>Education &amp; Qualifications</h2>
                    </div>
                    <div class="dp-card-body">
                        <div class="dp-timeline">
                            <c:forEach var="edu" items="${doctor.education}">
                                <div class="dp-timeline-item">
                                    <div class="dp-timeline-year">${edu.year}</div>
                                    <div class="dp-timeline-title">${edu.degree}</div>
                                    <div class="dp-timeline-desc">${edu.institution}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Professional Experience -->
                <div class="dp-card">
                    <div class="dp-card-header">
                        <i class="fas fa-briefcase"></i>
                        <h2>Professional Experience</h2>
                    </div>
                    <div class="dp-card-body">
                        <div class="dp-timeline">
                            <c:forEach var="exp" items="${doctor.experienceTimeline}">
                                <div class="dp-timeline-item">
                                    <div class="dp-timeline-year">${exp.period}</div>
                                    <div class="dp-timeline-title">${exp.role}</div>
                                    <div class="dp-timeline-desc">${exp.organization}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

            </div><!-- /.dp-card-row -->

            <!-- 3. Expertise + Certifications  (side-by-side) -->
            <div class="dp-card-row">

                <!-- Areas of Expertise -->
                <div class="dp-card">
                    <div class="dp-card-header">
                        <i class="fas fa-star"></i>
                        <h2>Areas of Expertise</h2>
                    </div>
                    <div class="dp-card-body">
                        <div class="dp-expertise-list">
                            <c:forEach var="skill" items="${doctor.expertise}">
                                <span class="dp-expertise-tag">${skill}</span>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Certifications & Awards -->
                <div class="dp-card">
                    <div class="dp-card-header">
                        <i class="fas fa-award"></i>
                        <h2>Certifications &amp; Awards</h2>
                    </div>
                    <div class="dp-card-body">
                        <ul class="dp-cert-list">
                            <c:forEach var="cert" items="${doctor.certifications}">
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span><strong>${cert.title}</strong> &mdash; ${cert.issuer} (${cert.year})</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

            </div><!-- /.dp-card-row -->

            <!-- 4. Publications & Research  (full width) -->
            <div class="dp-card">
                <div class="dp-card-header">
                    <i class="fas fa-book-open"></i>
                    <h2>Publications &amp; Research</h2>
                </div>
                <div class="dp-card-body">
                    <ul class="dp-pub-list">
                        <c:forEach var="pub" items="${doctor.publications}">
                            <li>
                                ${pub.title}
                                <div class="dp-pub-journal">${pub.journal} &mdash; ${pub.year}</div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>

        </div><!-- /.dp-main-col -->

        <!-- ════ SIDEBAR ════ -->
        <div class="dp-sidebar">

            <!-- Contact Info -->
            <div class="dp-sidebar-card">
                <h3><i class="fas fa-address-card"></i> Contact Information</h3>
                <div class="dp-contact-item">
                    <i class="fas fa-hospital"></i>
                    <span>${doctor.department}, MediLife Hospital</span>
                </div>
                <div class="dp-contact-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>Kathmandu, Nepal</span>
                </div>
                <div class="dp-contact-item">
                    <i class="fas fa-envelope"></i>
                    <span>${doctor.email}</span>
                </div>
                <div class="dp-contact-item">
                    <i class="fas fa-phone"></i>
                    <span>+977 1-1234567</span>
                </div>
            </div>

            <!-- Book Appointment CTA -->
            <div class="dp-sidebar-card">
                <h3><i class="fas fa-calendar-check"></i> Schedule a Visit</h3>
                <p style="font-size:0.85rem;color:#64748b;margin-bottom:14px;">
                    Book an appointment with Dr. ${doctor.lastName} at MediLife Hospital.
                </p>
                <a href="#" class="dp-cta-btn" onclick="checkLoginAndRedirect(event)">
                    <i class="fas fa-calendar-plus"></i> Book Appointment
                </a>
            </div>

            <!-- Social Links -->
            <div class="dp-sidebar-card">
                <h3><i class="fas fa-share-alt"></i> Connect</h3>
                <div class="dp-social-links">
                    <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" title="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#" title="ResearchGate"><i class="fab fa-researchgate"></i></a>
                </div>
            </div>
            
            <!-- Quick Stats -->
<div class="dp-sidebar-card">
    <h3><i class="fas fa-chart-bar"></i> Quick Stats</h3>
    <div class="dp-contact-item">
        <i class="fas fa-procedures"></i>
        <span><strong>${doctor.statProcedures}</strong> Procedures</span>
    </div>
    <div class="dp-contact-item">
        <i class="fas fa-users"></i>
        <span><strong>${doctor.statPatients}</strong> Patients Treated</span>
    </div>
    <div class="dp-contact-item">
        <i class="fas fa-calendar-alt"></i>
        <span><strong>${doctor.experience}</strong> Experience</span>
    </div>
</div>

<!-- Availability -->
<div class="dp-sidebar-card">
    <h3><i class="fas fa-clock"></i> Consultation Hours</h3>
    <div class="dp-contact-item">
        <i class="fas fa-calendar-check"></i>
        <span>Sunday – Friday</span>
    </div>
    <div class="dp-contact-item">
        <i class="fas fa-clock"></i>
        <span>9:00 AM – 5:00 PM</span>
    </div>
    <div class="dp-contact-item">
        <i class="fas fa-door-closed"></i>
        <span>Saturday: Closed</span>
    </div>
</div>
            

        </div><!-- /.dp-sidebar -->

    </div><!-- /.dp-content -->
</div><!-- /.dp-wrapper -->

<jsp:include page="../../../components/footer.jsp" />



</body>
</html>
