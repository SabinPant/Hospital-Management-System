<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages | Admin Panel</title>
     <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin/admin.css">
    <style>
        .messages-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .messages-table th {
            text-align: left;
            padding: 12px;
            background: #f8fafc;
            color: #1e293b;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .messages-table td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: top;
        }
        
        .messages-table tr:hover {
            background: #f8fafc;
        }
        
        .message-preview {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .view-btn {
            background: #0ea5e9;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.75rem;
        }
        
        .view-btn:hover {
            background: #0284c7;
        }
        
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background: white;
            border-radius: 12px;
            max-width: 500px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
        }
        
        .modal-header {
            padding: 16px 20px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .close-modal {
            cursor: pointer;
            font-size: 1.2rem;
            color: #94a3b8;
        }
        
        .close-modal:hover {
            color: #ef4444;
        }
        
        .pagination {
    display: flex;
    justify-content: center;
    gap: 8px;
    margin-top: 20px;
    flex-wrap: wrap;
}

.pagination a, .pagination span {
    padding: 6px 12px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    text-decoration: none;
    color: #0a5c8e;
    font-size: 0.85rem;
}

.pagination a:hover {
    background: #0a5c8e;
    color: white;
}

.pagination .active {
    background: #0a5c8e;
    color: white;
    border-color: #0a5c8e;
}

.pagination .disabled {
    color: #94a3b8;
    cursor: not-allowed;
}

.record-info {
    text-align: center;
    margin-top: 15px;
    font-size: 0.8rem;
    color: #64748b;
}

    </style>
</head>
<body>

<div class="admin-container">
    <!-- Sidebar -->
    <div class="admin-sidebar">
<jsp:include page="/components/admin-sidebar.jsp">
    <jsp:param name="page" value="messages" />
</jsp:include>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1><i class="fas fa-envelope"></i> Contact Messages</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

               <!-- Messages Table -->
        <div class="dashboard-card">
            <h3><i class="fas fa-list"></i> All Messages</h3>
            
            <c:choose>
                <c:when test="${not empty messages}">
    <table class="messages-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Subject</th>
                <th>Message</th>
                <th>Date</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
           <c:forEach var="msg" items="${messages}">
    <tr>
        <td>${msg.id}</td>
        <td>${msg.name}</td>
        <td>${msg.email}</td>
        <td>${msg.subject}</td>
        <td class="message-preview">
            <c:choose>
                <c:when test="${msg.message.length() > 50}">
                    ${msg.message.substring(0, 50)}...
                </c:when>
                <c:otherwise>
                    ${msg.message}
                </c:otherwise>
            </c:choose>
        </td> <!-- FIXED: Added missing > -->
        <td><fmt:formatDate value="${msg.createdAt}" pattern="yyyy-MM-dd HH:mm"/> </td> <!-- FIXED: Added missing > -->
        <td>
            <button class="view-btn" onclick='viewMessage(${msg.id}, "${msg.name}", "${msg.email}", "${msg.subject}", "${msg.message.replace("\"", "&quot;")}", "${msg.createdAt}")'>
                <i class="fas fa-eye"></i> View
            </button>
         </td> <!-- FIXED: Added missing > -->
    </tr>
</c:forEach>
        </tbody>
    </table>
</c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <p>No messages yet</p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <!-- PAGINATION -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}">&laquo; Previous</a>
                    </c:if>
                    <c:if test="${currentPage <= 1}">
                        <span class="disabled">&laquo; Previous</span>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}">Next &raquo;</a>
                    </c:if>
                    <c:if test="${currentPage >= totalPages}">
                        <span class="disabled">Next &raquo;</span>
                    </c:if>
                </div>
                <div class="record-info">
                    Showing page ${currentPage} of ${totalPages} (${totalRecords} total records)
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Message View Modal -->
<div id="messageModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Message Details</h3>
            <span class="close-modal" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <div style="margin-bottom: 15px;">
                <strong>From:</strong>
                <p id="modalFrom" style="margin: 5px 0 0 0; color: #1e293b;"></p>
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Subject:</strong>
                <p id="modalSubject" style="margin: 5px 0 0 0; color: #1e293b;"></p>
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Date:</strong>
                <p id="modalDate" style="margin: 5px 0 0 0; color: #1e293b;"></p>
            </div>
            <div style="margin-bottom: 15px;">
                <strong>Message:</strong>
                <p id="modalMessage" style="margin: 5px 0 0 0; color: #1e293b; background: #f8fafc; padding: 12px; border-radius: 8px; white-space: pre-wrap;"></p>
            </div>
        </div>
    </div>
</div>

<script>
    function viewMessage(id, name, email, subject, message, date) {
        document.getElementById('modalFrom').innerHTML = name + ' (' + email + ')';
        document.getElementById('modalSubject').innerHTML = subject;
        document.getElementById('modalDate').innerHTML = date;
        document.getElementById('modalMessage').innerHTML = message;
        document.getElementById('messageModal').style.display = 'flex';
    }
    
    function closeModal() {
        document.getElementById('messageModal').style.display = 'none';
    }
    
    window.onclick = function(event) {
        const modal = document.getElementById('messageModal');
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    }
</script>

</body>
</html>