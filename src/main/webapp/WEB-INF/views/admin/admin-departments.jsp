<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Department Management | MediLife Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin_Department.css">
    
</head>
<body>

<div class="admin-container">

    <!-- Sidebar -->
    <div class="admin-sidebar">
<jsp:include page="/components/admin-sidebar.jsp">
    <jsp:param name="page" value="departments" />
</jsp:include>
    </div>

    <!-- Main -->
    <div class="admin-main">
        <div class="dept-wrapper">

            <!-- Page Header -->
            <div class="page-header">
                <div class="page-header-left">
                    <h1><i class="fas fa-building"></i> Department Management</h1>
                    <p>Create and manage hospital departments</p>
                </div>
                <div class="admin-user">
                    <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                    <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>

            <!-- Alerts -->
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

            <!-- Add Department Form -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-plus-circle"></i>
                    <h3>Add New Department</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/departments" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Department Code *</label>
                                <input type="text" name="deptCode" placeholder="e.g., CARD" required maxlength="10">
                            </div>
                            <div class="form-group">
                                <label>Department Name *</label>
                                <input type="text" name="name" placeholder="e.g., Cardiology" required>
                            </div>
                            <div class="form-group">
                                <label>Head Doctor</label>
                                <select name="headDoctorId">
                                    <option value="">— Select Head Doctor —</option>
                                    <c:forEach var="doctor" items="${doctors}">
                                        <option value="${doctor.id}">Dr. ${doctor.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group span-3">
                                <label>Description</label>
                                <textarea name="description" placeholder="Brief description of this department..."></textarea>
                            </div>
                        </div>
                        <div class="form-footer">
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-save"></i> Add Department
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Departments Table -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-list"></i>
                    <h3>All Departments</h3>
                </div>
                <c:choose>
                    <c:when test="${not empty departments}">
                        <div class="table-wrapper">
                            <table class="dept-table">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Department</th>
                                        <th>Head Doctor</th>
                                        <th>Doctors</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="dept" items="${departments}">
                                        <tr>
                                            <td><span class="badge-code">${dept.deptCode}</span></td>
                                            <td>
                                                <div class="dept-name">${dept.name}</div>
                                                <div class="dept-desc">${dept.description}</div>
                                            </td>
                                            <td>${not empty dept.headDoctorName ? dept.headDoctorName : '—'}</td>
                                            <td>
                                                <span class="badge-count">
                                                    <i class="fas fa-user-md"></i> ${dept.doctorCount}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge-status ${dept.status == 'active' ? 'badge-active' : 'badge-inactive'}">
                                                    ${dept.status}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <button class="btn-edit"
                                                        onclick="openEditModal(${dept.id}, '${dept.deptCode}', '${dept.name}', '${dept.description}', '${dept.headDoctorId}', '${dept.status}')">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </button>
                                                    <button class="btn-delete" onclick="confirmDelete(${dept.id}, '${dept.name}')">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-building"></i>
                            <p>No departments yet. Add your first department above.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</div>

<!-- Edit Modal -->
<div id="editModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <h3><i class="fas fa-edit"></i> Edit Department</h3>
            <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/departments" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">
            <div class="modal-body">
                <div class="form-group">
                    <label>Department Code</label>
                    <input type="text" name="deptCode" id="editCode" required maxlength="10">
                </div>
                <div class="form-group">
                    <label>Department Name</label>
                    <input type="text" name="name" id="editName" required>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" id="editDesc"></textarea>
                </div>
                <div class="form-group">
                    <label>Head Doctor</label>
                    <select name="headDoctorId" id="editHeadDoctor">
                        <option value="">— Select Head Doctor —</option>
                        <c:forEach var="doctor" items="${doctors}">
                            <option value="${doctor.id}">Dr. ${doctor.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select name="status" id="editStatus">
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal()">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Update</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, code, name, description, headDoctorId, status) {
        document.getElementById('editId').value = id;
        document.getElementById('editCode').value = code;
        document.getElementById('editName').value = name;
        document.getElementById('editDesc').value = description || '';
        document.getElementById('editHeadDoctor').value = headDoctorId || '';
        document.getElementById('editStatus').value = status || 'active';
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    function confirmDelete(id, name) {
        if (confirm('Delete "' + name + '"? This will also remove all associated doctors from this department.')) {
            window.location.href = '${pageContext.request.contextPath}/admin/departments?action=delete&id=' + id;
        }
    }

    // Close modal on backdrop click
    document.getElementById('editModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    // Auto-dismiss alerts after 4 seconds
    setTimeout(function() {
        document.querySelectorAll('.alert').forEach(function(el) {
            el.style.transition = 'opacity 0.4s';
            el.style.opacity = '0';
            setTimeout(function() { el.remove(); }, 400);
        });
    }, 4000);
</script>

</body>
</html>
