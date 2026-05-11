<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/notifications.css">
</head>
<body>

    <jsp:include page="../../components/header.jsp" />

    <div class="notif-page">

        <!-- Page Header -->
        <div class="notif-header">
            <div class="notif-header__left">
               <c:choose>
    <c:when test="${sessionScope.user_type == 'doctor'}">
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="back-btn">
    </c:when>
    <c:otherwise>
        <a href="${pageContext.request.contextPath}/patient/dashboard" class="back-btn">
    </c:otherwise>
</c:choose>
    <i class="fa-solid fa-arrow-left"></i>
</a>
                <div class="notif-header__title">
                    <div class="notif-header__icon">
                        <i class="fa-solid fa-bell"></i>
                    </div>
                    <div>
                        <h1>Notifications</h1>
                        <p class="notif-header__sub">Stay up to date with your health activity</p>
                    </div>
                </div>
            </div>
            <div class="notif-header__right">
                <c:if test="${unreadCount > 0}">
                    <span class="unread-pill">
                        <span class="unread-pill__dot"></span>
                        ${unreadCount} unread
                    </span>
                    <form action="${pageContext.request.contextPath}/notification/read-all" method="post" class="mark-all-form">
                        <button type="submit" class="btn-mark-all">
                            <i class="fa-solid fa-check-double"></i>
                            Mark all as read
                        </button>
                    </form>
                </c:if>
            </div>
        </div>

        <!-- Notification List -->
        <div class="notif-list">
            <c:choose>
                <c:when test="${not empty notifications}">
                    <c:forEach var="notif" items="${notifications}" varStatus="loop">

                        <%-- Determine icon and accent class by type --%>
                        <c:set var="typeIcon" value="fa-circle-info"/>
                        <c:set var="typeClass" value="info"/>
                        <c:if test="${notif.type eq 'success'}">
                            <c:set var="typeIcon" value="fa-circle-check"/>
                            <c:set var="typeClass" value="success"/>
                        </c:if>
                        <c:if test="${notif.type eq 'warning'}">
                            <c:set var="typeIcon" value="fa-triangle-exclamation"/>
                            <c:set var="typeClass" value="warning"/>
                        </c:if>
                        <c:if test="${notif.type eq 'error'}">
                            <c:set var="typeIcon" value="fa-circle-xmark"/>
                            <c:set var="typeClass" value="error"/>
                        </c:if>

                        <div class="notif-card ${notif.is_read ? 'is-read' : 'is-unread'} accent-${typeClass}"
                             style="animation-delay: ${loop.index * 60}ms">

                            <!-- Left accent bar -->
                            <div class="notif-card__accent"></div>

                            <!-- Icon -->
                            <div class="notif-card__icon-wrap type-${typeClass}">
                                <i class="fa-solid ${typeIcon}"></i>
                            </div>

                            <!-- Content -->
                            <div class="notif-card__body">
                                <div class="notif-card__meta">
                                    <span class="type-badge type-badge--${typeClass}">
                                        <i class="fa-solid ${typeIcon}"></i>
                                        ${notif.type}
                                    </span>
                                    <c:if test="${not notif.is_read}">
                                        <span class="unread-dot" title="Unread"></span>
                                    </c:if>
                                </div>
                                <h3 class="notif-card__title">${notif.title}</h3>
                                <p class="notif-card__message">${notif.message}</p>
                                <div class="notif-card__time">
                                    <i class="fa-regular fa-clock"></i>
                                    <fmt:formatDate value="${notif.created_at}" pattern="MMM dd, yyyy · hh:mm a"/>
                                </div>
                            </div>

                            <!-- Action -->
                            <div class="notif-card__action">
                                <c:choose>
                                    <c:when test="${not notif.is_read}">
                                        <form action="${pageContext.request.contextPath}/notification/read" method="post">
                                            <input type="hidden" name="id" value="${notif.id}">
                                            <button type="submit" class="btn-read" title="Mark as read">
                                                <i class="fa-solid fa-check"></i>
                                                <span>Mark read</span>
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="read-indicator">
                                            <i class="fa-solid fa-check-double"></i>
                                            Read
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state__icon">
                            <i class="fa-solid fa-bell-slash"></i>
                        </div>
                        <h2 class="empty-state__title">All caught up!</h2>
                        <p class="empty-state__desc">You have no notifications at the moment. Appointment confirmations, reminders, and system alerts will appear here.</p>
                        <a href="javascript:history.back()" class="btn-back-home">
                            <i class="fa-solid fa-arrow-left"></i> Go Back
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <jsp:include page="../../components/footer.jsp" />

</body>
</html>
