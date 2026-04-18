<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Sidebar -->
<div class="admin-sidebar">
    <div class="admin-sidebar-header">
        <h2><i class="fas fa-hospital-user"></i> <span>MediLife</span></h2>
        <p><span>Admin Panel</span></p>
    </div>
    <ul class="admin-nav">
        <li class="${param.page == 'dashboard' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
            </a>
        </li>
        <li class="${param.page == 'users' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users"></i> <span>Users</span>
            </a>
        </li>
        <li class="${param.page == 'appointments' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/appointments">
                <i class="fas fa-calendar-check"></i> <span>Appointments</span>
            </a>
        </li>
        <li class="${param.page == 'finance' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/finance">
                <i class="fas fa-chart-line"></i> <span>Finance</span>
            </a>
        </li>
        <li class="${param.page == 'departments' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/departments">
                <i class="fas fa-building"></i> <span>Departments</span>
            </a>
        </li>
        <li class="${param.page == 'messages' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/messages">
                <i class="fas fa-envelope"></i> <span>Messages</span>
            </a>
        </li>
        <li class="${param.page == 'logs' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/logs">
                <i class="fas fa-history"></i> <span>System Logs</span>
            </a>
        </li>
        <li class="${param.page == 'announcement' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/announcement">
                <i class="fas fa-bullhorn"></i> <span>Announcement</span>
            </a>
        </li>
    </ul>
</div>