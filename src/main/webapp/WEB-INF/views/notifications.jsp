<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Notifications | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/notifications.css">
</head>
<body>

    <jsp:include page="../../components/header.jsp" />

    <div class="notifications-container">
        <div class="page-header">
            <h1><i class="fas fa-bell"></i> My Notifications</h1>
            <c:if test="${unreadCount > 0}">
                <span class="unread-badge">${unreadCount} unread</span>
            </c:if>
        </div>
        
        <div class="notification-card">
            <c:choose>
                <c:when test="${not empty notifications}">
                    <c:forEach var="notif" items="${notifications}">
                        <div class="notification-item ${notif.is_read ? '' : 'unread'}">
                            <div class="notification-content">
                                <div class="notification-title">
                                    <span class="notification-type type-${notif.type}">${notif.type}</span>
                                    ${notif.title}
                                </div>
                                <div class="notification-message">${notif.message}</div>
                                <div class="notification-time">
                                    <fmt:formatDate value="${notif.created_at}" pattern="MMM dd, yyyy HH:mm"/>
                                </div>
                            </div>
                            <div class="notification-action">
                                <c:if test="${not notif.is_read}">
                                    <form action="${pageContext.request.contextPath}/notification/read" method="post">
                                        <input type="hidden" name="id" value="${notif.id}">
                                        <button type="submit" class="btn-mark-read">
                                            <i class="fas fa-check"></i> Mark as read
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-bell-slash"></i>
                        <p>No notifications yet</p>
                        <p>When you receive announcements or appointment confirmations, they will appear here.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="back-link">
            <a href="javascript:history.back()">← Back</a>
        </div>
    </div>

    <jsp:include page="../../components/footer.jsp" />

</body>
</html>