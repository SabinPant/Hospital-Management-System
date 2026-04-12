<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/my-appointments.css">
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="appointments-page">

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

        <div class="page-header">
            <div>
                <h1>My Appointments</h1>
                <p class="page-subtitle">Track and manage your appointments</p>
            </div>
            <a href="${pageContext.request.contextPath}/patient/book-appointment" class="btn-new">
                <i class="fas fa-plus"></i> New Appointment
            </a>
        </div>

        <div class="card">
            <c:choose>
                <c:when test="${not empty appointments}">
                    <div class="table-wrap">
                        <table class="appointments-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Doctor</th>
                                    <th>Specialization</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="apt" items="${appointments}">
                                    <c:set var="aptDate"><fmt:formatDate value="${apt.appointmentDate}" pattern="MMM dd, yyyy"/></c:set>
                                    <tr>
                                        <td class="id-cell">${apt.appointmentId}</td>
                                        <td>${aptDate}</td>
                                        <td>${apt.appointmentTime}</td>
                                        <td class="doctor-cell">
                                            <div class="doctor-avatar">${fn:substring(apt.doctorName, 0, 1)}</div>
                                            Dr. ${apt.doctorName}
                                        </td>
                                        <td>${apt.doctorSpecialization}</td>
                                        <td><span class="status-${apt.status}">${apt.status}</span></td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/patient/appointment-details?id=${apt.id}" class="btn-view">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                     
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fas fa-calendar-times"></i></div>
                        <p>No appointments found.</p>
                        <a href="${pageContext.request.contextPath}/patient/book-appointment" class="btn-new">Book Your First Appointment</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

    <script>
        function cancelAppointment(id) {
            var reason = prompt('Please enter a reason for cancellation:');
            if (reason !== null && reason.trim() !== '') {
                window.location.href = '${pageContext.request.contextPath}/patient/cancel-appointment?id=' + id + '&reason=' + encodeURIComponent(reason);
            } else if (reason !== null) {
                alert('Please provide a reason for cancellation.');
            }
        }
    </script>

</body>
</html>