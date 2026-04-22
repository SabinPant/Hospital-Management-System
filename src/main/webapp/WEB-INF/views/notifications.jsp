<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <!-- JSTL core tags -->
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <!-- JSTL formatting tags (for date/time) -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Character encoding -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Responsive design -->
    
    <title>My Notifications | MediLife</title> <!-- Page title -->

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- External CSS files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/notifications.css">
</head>

<body>

    <!-- Include header -->
    <jsp:include page="../../components/header.jsp" />

    <!-- Main Notifications Container -->
    <div class="notifications-container">

        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-bell"></i> My Notifications</h1>

            <!-- Show unread count if greater than 0 -->
            <c:if test="${unreadCount > 0}">
                <span class="unread-badge">${unreadCount} unread</span>
            </c:if>
        </div>
        
        <!-- Notification Card -->
        <div class="notification-card">

            <!-- Check if notifications list is not empty -->
            <c:choose>

                <!-- If notifications exist -->
                <c:when test="${not empty notifications}">

                    <!-- Loop through each notification -->
                    <c:forEach var="notif" items="${notifications}">

                        <!-- Each notification item -->
                        <div class="notification-item ${notif.is_read ? '' : 'unread'}">

                            <!-- Notification Content -->
                            <div class="notification-content">

                                <!-- Title and type -->
                                <div class="notification-title">
                                    <span class="notification-type type-${notif.type}">
                                        ${notif.type}
                                    </span>
                                    ${notif.title}
                                </div>

                                <!-- Message -->
                                <div class="notification-message">
                                    ${notif.message}
                                </div>

                                <!-- Formatted Date & Time -->
                                <div class="notification-time">
                                    <fmt:formatDate 
                                        value="${notif.created_at}" 
                                        pattern="MMM dd, yyyy HH:mm"/>
                                </div>
                            </div>

                            <!-- Action Section -->
                            <div class="notification-action">

                                <!-- Show button only if notification is unread -->
                                <c:if test="${not notif.is_read}">
                                    <form action="${pageContext.request.contextPath}/notification/read" method="post">
                                        
                                        <!-- Hidden input to send notification ID -->
                                        <input type="hidden" name="id" value="${notif.id}">
                                        
                                        <!-- Mark as read button -->
                                        <button type="submit" class="btn-mark-read">
                                            <i class="fas fa-check"></i> Mark as read
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>

                    </c:forEach>
                </c:when>

                <!-- If no notifications -->
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-bell-slash"></i>
                        <p>No notifications yet</p>
                        <p>
                            When you receive announcements or appointment confirmations, 
                            they will appear here.
                        </p>
                    </div>
                </c:otherwise>

            </c:choose>
        </div>
        
        <!-- Back Button -->
        <div class="back-link">
            <a href="javascript:history.back()">← Back</a>
        </div>
    </div>

    <!-- Include footer -->
    <jsp:include page="../../components/footer.jsp" />

</body>
</html>