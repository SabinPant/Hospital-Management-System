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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
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
                                    </td>
                                    <td><fmt:formatDate value="${msg.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>
                                        <button class="view-btn" onclick='viewMessage(${msg.id}, "${msg.name}", "${msg.email}", "${msg.subject}", "${msg.message.replace("\"", "&quot;")}", "${msg.createdAt}")'>
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
                        <i class="fas fa-inbox" style="font-size: 2rem; color: #cbd5e1; margin-bottom: 10px; display: block;"></i>
                        <p>No messages yet</p>
                    </div>
                </c:otherwise>
            </c:choose>
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