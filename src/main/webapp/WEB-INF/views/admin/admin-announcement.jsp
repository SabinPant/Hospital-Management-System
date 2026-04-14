<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcement | Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-announcement.css">
</head>
<body>

<div class="admin-container">
    <!-- Sidebar -->
    <div class="admin-sidebar">
        <div class="admin-sidebar-header">
            <h2><i class="fas fa-hospital-user"></i> <span>MediLife</span></h2>
            <p><span>Admin Panel</span></p>
        </div>
        <ul class="admin-nav">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> <span>Users</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="fas fa-calendar-check"></i> <span>Appointments</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/finance"><i class="fas fa-chart-line"></i> <span>Finance</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/messages"><i class="fas fa-envelope"></i> <span>Messages</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/logs"><i class="fas fa-history"></i> <span>System Logs</span></a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/announcement"><i class="fas fa-bullhorn"></i> <span>Announcement</span></a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1><i class="fas fa-bullhorn"></i> Send Announcement</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${sessionScope.success}
                <% session.removeAttribute("success"); %>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                <% session.removeAttribute("error"); %>
            </div>
        </c:if>
        
        <!-- Announcement Form -->
        <div class="announcement-form">
            <form action="${pageContext.request.contextPath}/admin/announcement" method="post">
                <div class="form-group">
                    <label><i class="fas fa-users"></i> Send to:</label>
                    <div class="radio-group">
                        <label>
                            <input type="radio" name="sendTo" value="all" checked> All Users
                        </label>
                        <label>
                            <input type="radio" name="sendTo" value="patients"> Only Patients
                        </label>
                        <label>
                            <input type="radio" name="sendTo" value="doctors"> Only Doctors
                        </label>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Announcement Type:</label>
                    <div class="type-buttons">
                        <div class="type-btn type-btn-info" data-type="info">ℹ️ Info</div>
                        <div class="type-btn type-btn-success" data-type="success">✅ Success</div>
                        <div class="type-btn type-btn-warning" data-type="warning">⚠️ Warning</div>
                        <div class="type-btn type-btn-error" data-type="error">❌ Error</div>
                    </div>
                    <input type="hidden" name="type" id="selectedType" value="info">
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-heading"></i> Title:</label>
                    <input type="text" name="title" placeholder="Enter announcement title" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-comment"></i> Message:</label>
                    <textarea name="message" placeholder="Enter announcement message..." required></textarea>
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fas fa-paper-plane"></i> Send Announcement
                </button>
            </form>
        </div>
        
        <%--
        <!-- Previous Announcements -->
        <div class="announcements-list">
            <h3><i class="fas fa-history"></i> Previous Announcements</h3>
            <c:choose>
                <c:when test="${not empty announcements}">
                    <c:forEach var="ann" items="${announcements}">
                        <div class="announcement-item">
                            <div class="announcement-header">
                                <span class="announcement-title">${ann.title}</span>
                                <span class="announcement-date">
                                    <fmt:formatDate value="${ann.created_at}" pattern="MMM dd, yyyy HH:mm"/>
                                </span>
                            </div>
                            <div class="announcement-message">${ann.message}</div>
                            <div class="announcement-meta">
                                <span class="announcement-type type-${ann.type}">${ann.type}</span>
                                | By: ${ann.admin_name}
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-bullhorn"></i>
                        <p>No announcements sent yet</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        --%>
        
    </div>
</div>

<script>
    // Type selection
    const typeButtons = document.querySelectorAll('.type-btn');
    const typeInput = document.getElementById('selectedType');
    
    typeButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            typeButtons.forEach(b => b.classList.remove('selected'));
            this.classList.add('selected');
            typeInput.value = this.dataset.type;
        });
    });
    
    // Select first type by default
    typeButtons[0].classList.add('selected');
</script>

</body>
</html>