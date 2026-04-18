<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management | Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-users.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    
</head>
<body>

<div class="admin-container">
    <!-- Sidebar -->
    <div class="admin-sidebar">
        
<jsp:include page="/components/admin-sidebar.jsp">
    <jsp:param name="page" value="users" />
</jsp:include>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1><i class="fas fa-users"></i> User Management</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${param.success}
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${param.error}
            </div>
        </c:if>
        
        <!-- Filters and Search -->
        <div class="filter-bar">
            <div class="filter-buttons">
                <a href="${pageContext.request.contextPath}/admin/users" class="filter-btn ${empty currentFilter ? 'active' : ''}">All</a>
                <a href="${pageContext.request.contextPath}/admin/users?filter=patient" class="filter-btn ${currentFilter == 'patient' ? 'active' : ''}">Patients</a>
                <a href="${pageContext.request.contextPath}/admin/users?filter=doctor" class="filter-btn ${currentFilter == 'doctor' ? 'active' : ''}">Doctors</a>
            </div>
            
            <form method="get" action="${pageContext.request.contextPath}/admin/users" class="search-form">
                <c:if test="${not empty currentFilter}">
                    <input type="hidden" name="filter" value="${currentFilter}">
                </c:if>
                <input type="text" name="search" placeholder="Search by name, email, or ID..." value="${currentSearch}">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>
        
        <!-- Users Table -->
        <div class="dashboard-card">
            <c:choose>
                <c:when test="${not empty users}">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Type</th>
                                <th>Specialization / Blood Group</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.user_id}</td>
                                    <td>${user.full_name} (<small>${user.username}</small>)</td>
                                    <td>${user.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.user_type == 'doctor'}">
                                                <span class="badge-doctor">Doctor</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-patient">Patient</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.user_type == 'doctor'}">
                                                ${user.specialization} <br>
                                                <small>Fee: Rs ${user.consultation_fee}</small>
                                            </c:when>
                                            <c:otherwise>
                                                Blood: ${user.blood_group != null ? user.blood_group : 'Not specified'}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.status == 'active'}">
                                                <span class="status-active">Active</span>
                                            </c:when>
                                            <c:when test="${user.status == 'locked'}">
                                                <span class="status-locked">Locked</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-inactive">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="action-buttons">
                                        <c:if test="${user.status == 'active'}">
                                            <button class="btn-lock" onclick="lockUser(${user.id})">
                                                <i class="fas fa-lock"></i> Lock
                                            </button>
                                        </c:if>
                                        <c:if test="${user.status == 'locked'}">
                                            <button class="btn-unlock" onclick="unlockUser(${user.id})">
                                                <i class="fas fa-unlock-alt"></i> Unlock
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-users-slash"></i>
                        <p>No users found</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    function lockUser(userId) {
        let reason = prompt('Please enter reason for locking this account:');
        if (reason !== null && reason.trim() !== '') {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/lock-user';
            var inputId = document.createElement('input');
            inputId.type = 'hidden';
            inputId.name = 'id';
            inputId.value = userId;
            var inputReason = document.createElement('input');
            inputReason.type = 'hidden';
            inputReason.name = 'reason';
            inputReason.value = reason;
            form.appendChild(inputId);
            form.appendChild(inputReason);
            document.body.appendChild(form);
            form.submit();
        } else if (reason !== null) {
            alert('Please provide a reason for locking');
        }
    }
    
    function unlockUser(userId) {
        if(confirm('Unlock this user account?')) {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/unlock-user';
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'id';
            input.value = userId;
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

</body>
</html>