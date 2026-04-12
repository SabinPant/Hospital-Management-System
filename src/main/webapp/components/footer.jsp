<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String contextPath = request.getContextPath();
%>

<!-- ==================== FOOTER ==================== -->
<footer>
    <div class="container footer-grid">
        <div class="footer-col">
            <h3><i class="fas fa-hospital-user"></i> MediLife</h3>
            <p>Delivering compassionate, cutting-edge healthcare since 1998. We treat every patient like family with personalized care and advanced medical technology.</p>
            <div class="footer-social">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>
        <div class="footer-col">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="<%= contextPath %>/">Home</a></li>
                <li><a href="<%= contextPath %>/about.jsp">About Us</a></li>
                <li><a href="<%= contextPath %>/blog.jsp">Blog</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Our Services</h4>
            <ul>
                <li>Emergency & Trauma Care</li>
                <li>OPD & IPD Services</li>
                <li>Advanced Diagnostics</li>
                <li>Maternity & Childcare</li>
                <li>Specialized Surgeries</li>
                <li>24/7 Pharmacy</li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Contact Info</h4>
            <p><i class="fas fa-map-marker-alt"></i> Kathmandu, Nepal</p>
            <p><i class="fas fa-phone"></i> +977 1-1234567</p>
            <p><i class="fas fa-envelope"></i> info@medilife.com.np</p>
            <p><i class="fas fa-clock"></i> 24/7 Emergency Service</p>
            <p><i class="fas fa-ambulance"></i> Ambulance: 102</p>
        </div>
    </div>
    <div class="footer-bottom">
        <p>© 2025 MediLife Hospital Management System. All rights reserved. | Designed with <i class="fas fa-heart"></i> for better healthcare.</p>
    </div>
</footer>