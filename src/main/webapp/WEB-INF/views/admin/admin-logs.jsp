<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Logs | Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-logs.css">
</head>
<body>

<div class="admin-container">
    <!-- Sidebar -->
    <div class="admin-sidebar">
<jsp:include page="/components/admin-sidebar.jsp">
    <jsp:param name="page" value="logs" />
</jsp:include>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1><i class="fas fa-history"></i> System Logs</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar">
            <form method="get" action="${pageContext.request.contextPath}/admin/logs" class="filter-form">
                <div class="filter-row">
                    <div class="filter-group">
                        <label>Action Type:</label>
                        <select name="action">
                            <option value="all">All Actions</option>
                            <option value="important" ${actionFilter == 'important' ? 'selected' : ''}>⚠️ Important Only (No Page Views)</option>
                            <c:forEach var="action" items="${actions}">
                                <option value="${action}" ${actionFilter == action ? 'selected' : ''}>${action}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label>User Type:</label>
                        <select name="userType">
                            <option value="all">All Users</option>
                            <option value="Admin" ${userTypeFilter == 'Admin' ? 'selected' : ''}>Admin</option>
                            <option value="patient" ${userTypeFilter == 'patient' ? 'selected' : ''}>Patient</option>
                            <option value="doctor" ${userTypeFilter == 'doctor' ? 'selected' : ''}>Doctor</option>
                            <option value="System" ${userTypeFilter == 'System' ? 'selected' : ''}>System</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label>Search:</label>
                        <input type="text" name="search" placeholder="Search logs..." value="${search}">
                    </div>
                </div>

                <div class="filter-row">
                    <div class="filter-group">
                        <label>Date From:</label>
                        <input type="date" name="dateFrom" value="${dateFrom}">
                    </div>

                    <div class="filter-group">
                        <label>Date To:</label>
                        <input type="date" name="dateTo" value="${dateTo}">
                    </div>

                    <div class="filter-group">
                        <button type="submit"><i class="fas fa-filter"></i> Apply Filters</button>
                        <a href="${pageContext.request.contextPath}/admin/logs" class="btn-reset">Reset</a>
                    </div>

                    <div class="filter-group">
                        <a href="${pageContext.request.contextPath}/admin/export-logs" class="btn-export">
                            <i class="fas fa-file-excel"></i> Export CSV
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Stats Summary -->
        <div class="stats-summary">
            <div class="stat-item">
                <span class="stat-label">Total Logs:</span>
                <span class="stat-value">${totalRecords}</span>
            </div>
            <div class="stat-item">
                <span class="stat-label">Showing:</span>
                <span class="stat-value">Page ${currentPage} of ${totalPages}</span>
            </div>
        </div>

        <!-- Logs Table -->
        <div class="dashboard-card">
            <c:choose>
                <c:when test="${not empty logs}">
                    <table class="logs-table">
                        <thead>
                            <tr>
                                <th>Timestamp</th>
                                <th>User</th>
                                <th>Type</th>
                                <th>Action</th>
                                <th>Details</th>
                                <th>IP Address</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${logs}">
                                <c:set var="rowClass" value=""/>
                                <c:if test="${log.action == 'VIEW_PAGE'}">
                                    <c:set var="rowClass" value="log-view-page"/>
                                </c:if>
                                <c:if test="${log.action == 'LOGIN_FAILED' || log.action == 'ADMIN_LOGIN_FAILED'}">
                                    <c:set var="rowClass" value="log-failed"/>
                                </c:if>

                                <tr class="${rowClass}">
                                    <td><fmt:formatDate value="${log.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.actorType == 'Admin'}">
                                                <span class="action-badge action-admin">${log.actorName}</span>
                                            </c:when>
                                            <c:when test="${log.actorType == 'patient'}">
                                                <span class="action-badge action-user">${log.actorName}</span>
                                            </c:when>
                                            <c:when test="${log.actorType == 'doctor'}">
                                                <span class="action-badge action-user">Dr. ${log.actorName}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="action-badge action-system">System</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${log.actorType}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.action == 'VIEW_PAGE'}">
                                                <span class="action-view">${log.action}</span>
                                            </c:when>
                                            <c:when test="${log.action == 'LOGIN_FAILED' || log.action == 'ADMIN_LOGIN_FAILED'}">
                                                <span class="action-failed">${log.action}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="action-important">${log.action}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${log.details}</td>
                                    <td>${log.ipAddress != null ? log.ipAddress : '-'}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-history"></i>
                        <p>No logs found</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="?page=${currentPage - 1}&action=${actionFilter}&userType=${userTypeFilter}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">&laquo; Previous</a>
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
                            <a href="?page=${i}&action=${actionFilter}&userType=${userTypeFilter}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="?page=${currentPage + 1}&action=${actionFilter}&userType=${userTypeFilter}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">Next &raquo;</a>
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

</body>
</html>
