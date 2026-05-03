<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- =============================================
     Public Footer Component
     Shared across all public-facing pages via JSP include.
     Contains: branding, quick links, services list,
     contact details, social links, and copyright notice.
     ============================================= -->

<!-- ==================== FOOTER ==================== -->
<footer>
    <div class="container footer-grid">

        <!-- Col 1: Branding & Social Links -->
        <div class="footer-col">

            <!-- Hospital logo/name -->
            <h3><i class="fas fa-hospital-user"></i> MediLife</h3>

            <!-- Short hospital tagline / about blurb -->
            <p>Delivering compassionate, cutting-edge healthcare since 1998. We treat every patient like family with personalized care and advanced medical technology.</p>

            <!-- Social media icon links — hrefs should be updated with real profile URLs -->
            <div class="footer-social">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>

        <!-- Col 2: Quick Navigation Links -->
        <div class="footer-col">
            <h4>Quick Links</h4>
            <!-- Internal site navigation; uses contextPath for portability across deployments -->
            <ul>
                <li><a href="${contextPath}/">Home</a></li>
                <li><a href="${contextPath}/about_us">About Us</a></li>
                <li><a href="${contextPath}/research">Research</a></li>
                <li><a href="${contextPath}/contact">Contact Us</a></li>
                <li><a href="${contextPath}/News">News</a></li>
            </ul>
        </div>

        <!-- Col 3: Services List (static/informational, not linked) -->
        <div class="footer-col">
            <h4>Our Services</h4>
            <ul>
                <li>Emergency &amp; Trauma Care</li>
                <li>OPD &amp; IPD Services</li>       <!-- Outpatient / Inpatient Departments -->
                <li>Advanced Diagnostics</li>
                <li>Maternity &amp; Childcare</li>
                <li>Specialized Surgeries</li>
                <li>24/7 Pharmacy</li>
            </ul>
        </div>

        <!-- Col 4: Contact Details & Emergency Info -->
        <div class="footer-col">
            <h4>Contact Info</h4>
            <p><i class="fas fa-map-marker-alt"></i> Kathmandu, Nepal</p>         <!-- Physical address -->
            <p><i class="fas fa-phone"></i> +977 1-1234567</p>                    <!-- Main reception line -->
            <p><i class="fas fa-envelope"></i> info@medilife.com.np</p>           <!-- General enquiries email -->
            <p><i class="fas fa-clock"></i> 24/7 Emergency Service</p>           <!-- Availability notice -->
            <p><i class="fas fa-ambulance"></i> Ambulance: 102</p>               <!-- Emergency hotline -->
        </div>

    </div>

    <!-- Footer Bottom Bar: Copyright Notice -->
    <div class="footer-bottom">
        <p>© 2025 MediLife Hospital Management System. All rights reserved. | Designed with <i class="fas fa-heart"></i> for better healthcare.</p>
    </div>

</footer>