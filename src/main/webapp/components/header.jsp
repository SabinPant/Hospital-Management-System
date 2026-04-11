<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    boolean isLoggedIn = (userSession != null && userSession.getAttribute("user_id") != null);
    String userRole = isLoggedIn ? (String) userSession.getAttribute("user_type") : null;
    String firstName = isLoggedIn ? (String) userSession.getAttribute("full_name") : null;
    
    // Handle null values
    if (firstName == null) firstName = "";
    if (userRole == null) userRole = "";
    
    // Get context path for proper URL building
    String contextPath = request.getContextPath();
%>

<!-- ==================== TOP EMERGENCY BAR ==================== -->
<div class="top-emergency-bar">
    <div class="container emergency-top">
        <div class="emergency-contact">
            <i class="fas fa-phone-alt"></i>
            <span>24/7 Emergency Service:</span>
            <strong>+977 1-1234567890</strong>
            <span class="separator">|</span>
            <i class="fas fa-ambulance"></i>
            <span>Ambulance: 102</span>
        </div>
        <div class="hospital-hours">
            <i class="fas fa-clock"></i>
            <span>Open 24 Hours | 7 Days a Week</span>
        </div>
    </div>
</div>

<!-- ==================== NAVBAR ==================== -->
<header>
    <div class="container nav-container">
        <div class="logo">
            <h1><i class="fas fa-hospital-user"></i> MediLife</h1>
            <span>Hospital & Research Center</span>
        </div>
        <nav>
            <ul class="nav-links">
               <% if (isLoggedIn && "patient".equals(userRole)) { %>
    <li><a href="<%= contextPath %>/patient/dashboard">Dashboard</a></li>
    <li><a href="<%= contextPath %>/patient/book-appointment">Book Appointment</a></li>
    <li><a href="<%= contextPath %>/patient/appointments">My Appointments</a></li>
    <li><a href="<%= contextPath %>/contact">Contact Us</a></li>
<% } else if (isLoggedIn && "doctor".equals(userRole)) { %>
    <li><a href="<%= contextPath %>/doctor/dashboard">Dashboard</a></li>
    <li><a href="<%= contextPath %>/doctor/appointments">My Appointments</a></li>
    <li><a href="<%= contextPath %>/contact">Contact Us</a></li>
<% } else { %>
    <li><a href="<%= contextPath %>/">Home</a></li>
    <li><a href="<%= contextPath %>/about.jsp">About Us</a></li>
    <li><a href="<%= contextPath %>/blog.jsp">Blog</a></li>
    <li><a href="<%= contextPath %>/contact">Contact Us</a></li>
<% } %>
            </ul>
        </nav>
        <div class="nav-buttons">
            <% if (isLoggedIn) { %>
                <span class="welcome-text">Welcome, <%= firstName %></span>
                <a href="<%= contextPath %>/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> LOGOUT</a>
            <% } else { %>
                <a href="<%= contextPath %>/login" class="btn-login"><i class="fas fa-sign-in-alt"></i> LOGIN</a>
                <a href="<%= contextPath %>/register" class="btn-register"><i class="fas fa-user-plus"></i> REGISTER</a>
            <% } %>
        </div>
    </div>
</header>