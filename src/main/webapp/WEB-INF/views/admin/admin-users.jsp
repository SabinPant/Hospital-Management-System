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
    <div class="admin-sidebar">
        <jsp:include page="/components/admin-sidebar.jsp">
            <jsp:param name="page" value="users" />
        </jsp:include>
    </div>

    <div class="admin-main">
        <div class="admin-topbar">
            <h1><i class="fas fa-users"></i> User Management</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${param.error}</div>
        </c:if>
        
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
                                <tr class="user-row"
                                    data-id="${user.id}"
                                    data-user-id="${user.user_id}"
                                    data-username="${user.username}"
                                    data-email="${user.email}"
                                    data-fullname="${user.full_name}"
                                    data-phone="${user.phone}"
                                    data-usertype="${user.user_type}"
                                    data-status="${user.status}"
                                    data-specialization="${user.specialization}"
                                    data-consultationfee="${user.consultation_fee}"
                                    data-bloodgroup="${user.blood_group}">
                                    <td>${user.user_id}</td>
                                    <td>${user.full_name} <small>(${user.username})</small></td>
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
                                                ${user.specialization}<br><small>Fee: Rs ${user.consultation_fee}</small>
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
                                        <button class="btn-view-details" onclick="openUserModal(this)">
                                            <i class="fas fa-eye"></i> View
                                        </button>
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

<!-- ==================== USER DETAIL MODAL ==================== -->
<div id="userModal" class="modal-overlay" style="display:none;">
    <div class="modal-container">
        <div class="modal-header">
            <h2 id="modalTitle"><i class="fas fa-user"></i> User Details</h2>
            <button class="modal-close" onclick="closeUserModal()">&times;</button>
        </div>
        <div class="modal-body">
            <!-- Basic Info -->
            <div class="modal-section">
                <h3><i class="fas fa-info-circle"></i> Basic Information</h3>
                <div class="modal-grid">
                    <div class="modal-field"><label>Full Name</label><span id="mFullName">-</span></div>
                    <div class="modal-field"><label>Username</label><span id="mUsername">-</span></div>
                    <div class="modal-field"><label>User ID</label><span id="mUserId">-</span></div>
                    <div class="modal-field"><label>Email</label><span id="mEmail">-</span></div>
                    <div class="modal-field"><label>Phone</label><span id="mPhone">-</span></div>
                    <div class="modal-field"><label>Type</label><span id="mType">-</span></div>
                    <div class="modal-field"><label>Status</label><span id="mStatus">-</span></div>
                    <div class="modal-field"><label>Blood Group</label><span id="mBloodGroup">-</span></div>
                </div>
            </div>
            
            <!-- Doctor Section (hidden for patients) -->
            <div class="modal-section" id="doctorSection" style="display:none;">
                <h3><i class="fas fa-stethoscope"></i> Professional Details</h3>
                <div class="modal-grid">
                    <div class="modal-field"><label>Specialization</label><span id="mSpecialization">-</span></div>
                    <div class="modal-field"><label>Consultation Fee</label><span id="mConsultationFee">-</span></div>
                </div>
            </div>
            
            <!-- Actions -->
            <div class="modal-actions">
                <form id="lockForm" method="POST" action="${pageContext.request.contextPath}/admin/lock-user" style="display:inline;">
                    <input type="hidden" name="id" id="lockUserId">
                    <input type="hidden" name="reason" id="lockReason">
                    <button type="button" class="btn-lock" id="btnLock" onclick="handleLock()">
                        <i class="fas fa-lock"></i> Lock Account
                    </button>
                </form>
                <form id="unlockForm" method="POST" action="${pageContext.request.contextPath}/admin/unlock-user" style="display:inline;">
                    <input type="hidden" name="id" id="unlockUserId">
                    <button type="button" class="btn-unlock" id="btnUnlock" onclick="handleUnlock()">
                        <i class="fas fa-unlock-alt"></i> Unlock Account
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Open modal - reads data from the clicked row's data attributes
    function openUserModal(btn) {
        var row = btn.closest('.user-row');
        
        // Read basic info
        document.getElementById('mFullName').textContent = row.getAttribute('data-fullname') || '-';
        document.getElementById('mUsername').textContent = row.getAttribute('data-username') || '-';
        document.getElementById('mUserId').textContent = row.getAttribute('data-user-id') || '-';
        document.getElementById('mEmail').textContent = row.getAttribute('data-email') || '-';
        document.getElementById('mPhone').textContent = row.getAttribute('data-phone') || '-';
        document.getElementById('mType').textContent = row.getAttribute('data-usertype') || '-';
        document.getElementById('mStatus').textContent = row.getAttribute('data-status') || '-';
        document.getElementById('mBloodGroup').textContent = row.getAttribute('data-bloodgroup') || 'Not specified';
        
        var userType = row.getAttribute('data-usertype');
        var status = row.getAttribute('data-status');
        
        // Show/hide doctor section
        if (userType === 'doctor') {
            document.getElementById('doctorSection').style.display = 'block';
            document.getElementById('mSpecialization').textContent = row.getAttribute('data-specialization') || '-';
            document.getElementById('mConsultationFee').textContent = 'Rs ' + (row.getAttribute('data-consultationfee') || '0');
        } else {
            document.getElementById('doctorSection').style.display = 'none';
        }
        
        // Show/hide lock/unlock buttons based on status
        var userId = row.getAttribute('data-id');
        document.getElementById('lockUserId').value = userId;
        document.getElementById('unlockUserId').value = userId;
        
        if (status === 'locked') {
            document.getElementById('btnLock').style.display = 'none';
            document.getElementById('btnUnlock').style.display = 'inline-block';
        } else {
            document.getElementById('btnLock').style.display = 'inline-block';
            document.getElementById('btnUnlock').style.display = 'none';
        }
        
        document.getElementById('userModal').style.display = 'flex';
    }
    
    function closeUserModal() {
        document.getElementById('userModal').style.display = 'none';
    }
    
    function handleLock() {
        var reason = prompt('Please enter reason for locking this account:');
        if (reason !== null && reason.trim() !== '') {
            document.getElementById('lockReason').value = reason;
            document.getElementById('lockForm').submit();
        } else if (reason !== null) {
            alert('Please provide a reason for locking');
        }
    }
    
    function handleUnlock() {
        if (confirm('Unlock this user account?')) {
            document.getElementById('unlockForm').submit();
        }
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
        var modal = document.getElementById('userModal');
        if (event.target === modal) {
            closeUserModal();
        }
    }
</script>

</body>
</html>