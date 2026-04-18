<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="isLoggedIn" value="${not empty sessionScope.user_id}" />
<c:set var="userRole" value="${sessionScope.user_type}" />
<c:set var="firstName" value="${sessionScope.full_name != null ? sessionScope.full_name : ''}" />

<%-- Scriptlet only for DAO call (JSTL cannot call Java methods directly) --%>
<%
    int unreadCount = 0;
    if (session.getAttribute("user_id") != null) {
        try {
            dao.NotificationDAO notifDAO = new dao.NotificationDAO();
            int userId = (int) session.getAttribute("user_id");
            unreadCount = notifDAO.getUnreadCount(userId);
        } catch (Exception e) {
            unreadCount = 0;
        }
    }
    pageContext.setAttribute("unreadCount", unreadCount);
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
                <c:choose>
                    <c:when test="${isLoggedIn and userRole == 'patient'}">
                        <li><a href="${contextPath}/patient/dashboard">Dashboard</a></li>
                        <li><a href="${contextPath}/patient/book-appointment">Book Appointment</a></li>
                        <li><a href="${contextPath}/patient/appointments">My Appointments</a></li>
                        <li><a href="${contextPath}/contact">Contact Us</a></li>
                    </c:when>
                    <c:when test="${isLoggedIn and userRole == 'doctor'}">
                        <li><a href="${contextPath}/doctor/dashboard">Dashboard</a></li>
                        <li><a href="${contextPath}/doctor/patients">My Patients</a></li>
                        <li><a href="${pageContext.request.contextPath}/doctor/profile"> My Profile</a></li>
                        <li><a href="${contextPath}/contact">Contact Us</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${contextPath}/">Home</a></li>
                        <li><a href="${contextPath}/about_us">About Us</a></li>
                        <li><a href="${contextPath}/research">Research</a></li>
                        <li><a href="${contextPath}/contact">Contact Us</a></li>
                        <li><a href="${contextPath}/blog">News</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
        <div class="nav-buttons">
            <c:choose>
                <c:when test="${isLoggedIn}">
                    <a href="${contextPath}/notifications" class="notification-bell-link">
                        <i class="fas fa-bell"></i>
                        <c:if test="${unreadCount > 0}">
                            <span class="notification-badge">${unreadCount}</span>
                        </c:if>
                    </a>
                    <span class="welcome-text">Welcome, ${firstName}</span>
                    <a href="${contextPath}/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> LOGOUT</a>
                </c:when>
                <c:otherwise>
                    <a href="${contextPath}/login" class="btn-login"><i class="fas fa-sign-in-alt"></i> LOGIN</a>
                    <a href="${contextPath}/register" class="btn-register"><i class="fas fa-user-plus"></i> REGISTER</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>