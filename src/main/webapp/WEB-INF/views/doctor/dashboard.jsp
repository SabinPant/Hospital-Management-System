<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/doctor-dashboard.css">
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="doctor-dashboard">

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

        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <div class="welcome-left">
                <div class="welcome-tag">Good morning</div>
                <h1>Dr. ${sessionScope.full_name}</h1>
                <p class="welcome-dept"><i class="fas fa-hospital-alt"></i> ${department} Department</p>
            </div>
            <div class="welcome-right">
                <div class="welcome-pill">
                    <span class="pill-icon"><i class="fas fa-calendar-check"></i></span>
                    <div>
                        <div class="pill-number">${todayCount}</div>
                        <div class="pill-label">Today</div>
                    </div>
                </div>
                <div class="welcome-pill">
                    <span class="pill-icon pending-icon"><i class="fas fa-clock"></i></span>
                    <div>
                        <div class="pill-number">${pendingCount}</div>
                        <div class="pill-label">Pending</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Stats Row -->
        <div class="stats-row">
            <div class="stat-tile">
                <div class="stat-icon-wrap blue-wrap"><i class="fas fa-users"></i></div>
                <div class="stat-info">
                    <div class="stat-val">${totalPatients}</div>
                    <div class="stat-lbl">Total Patients</div>
                </div>
            </div>
            <div class="stat-tile">
                <div class="stat-icon-wrap teal-wrap"><i class="fas fa-calendar-day"></i></div>
                <div class="stat-info">
                    <div class="stat-val">${todayCount}</div>
                    <div class="stat-lbl">Today's Appts</div>
                </div>
            </div>
            <div class="stat-tile">
                <div class="stat-icon-wrap amber-wrap"><i class="fas fa-hourglass-half"></i></div>
                <div class="stat-info">
                    <div class="stat-val">${pendingCount}</div>
                    <div class="stat-lbl">Pending</div>
                </div>
            </div>
            <div class="stat-tile">
                <div class="stat-icon-wrap green-wrap"><i class="fas fa-check-double"></i></div>
                <div class="stat-info">
                    <div class="stat-val">${completedCount}</div>
                    <div class="stat-lbl">Completed</div>
                </div>
            </div>
        </div>

        <!-- Two Column: Today + Upcoming -->
        <div class="appt-columns">

            <!-- Today's Appointments -->
            <div class="appt-panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <span class="panel-dot dot-blue"></span>
                        <h2>Today's Appointments</h2>
                    </div>
                    <span class="panel-count">${todayCount}</span>
                </div>
                <div class="panel-body">
                    <c:choose>
                        <c:when test="${not empty todayAppointments}">
                            <c:forEach var="apt" items="${todayAppointments}">
                                <div class="appt-item">
                                    <div class="appt-time-col">
                                        <div class="appt-time"><fmt:formatDate value="${apt.appointmentTime}" pattern="hh:mm"/></div>
                                        <div class="appt-ampm"><fmt:formatDate value="${apt.appointmentTime}" pattern="a"/></div>
                                    </div>
                                    <div class="appt-divider"></div>
                                    <div class="appt-details">
                                        <div class="appt-name">${apt.patientName}</div>
                                        <div class="appt-note">${apt.symptoms != null ? apt.symptoms : "No symptoms noted"}</div>
                                    </div>
                                    <div class="appt-action">
                                        <button class="btn-complete" onclick="openCompleteModal(${apt.id})">
                                            <i class="fas fa-check"></i> Complete
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-panel">
                                <i class="fas fa-calendar-day"></i>
                                <p>No appointments today</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Upcoming Appointments -->
            <div class="appt-panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <span class="panel-dot dot-teal"></span>
                        <h2>Upcoming Appointments</h2>
                    </div>
                </div>
                <div class="panel-body">
                    <c:choose>
                        <c:when test="${not empty upcomingAppointments}">
                            <c:forEach var="apt" items="${upcomingAppointments}">
                                <div class="appt-item">
                                    <div class="appt-time-col">
                                        <div class="appt-date-badge">
                                            <span class="badge-month"><fmt:formatDate value="${apt.appointmentDate}" pattern="MMM"/></span>
                                            <span class="badge-day"><fmt:formatDate value="${apt.appointmentDate}" pattern="dd"/></span>
                                        </div>
                                    </div>
                                    <div class="appt-divider"></div>
                                    <div class="appt-details">
                                        <div class="appt-name">${apt.patientName}</div>
                                        <div class="appt-note"><fmt:formatDate value="${apt.appointmentTime}" pattern="hh:mm a"/></div>
                                    </div>
                                    <div class="appt-action">
                                        <c:if test="${apt.status == 'pending'}">
                                            <form action="${pageContext.request.contextPath}/doctor/confirm-appointment" method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="${apt.id}">
                                                <button type="submit" class="btn-confirm">Confirm</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${apt.status == 'confirmed'}">
                                            <span class="status-confirmed">Confirmed</span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-panel">
                                <i class="fas fa-calendar-alt"></i>
                                <p>No upcoming appointments</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Recent Appointments -->
        <div class="history-panel">
            <div class="panel-header">
                <div class="panel-title">
                    <span class="panel-dot dot-slate"></span>
                    <h2>Recent Appointments</h2>
                </div>
            </div>
            <c:choose>
                <c:when test="${not empty recentAppointments}">
                    <div class="table-wrap">
                        <table class="appointments-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Patient</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="apt" items="${recentAppointments}">
                                    <tr>
                                        <td><fmt:formatDate value="${apt.appointmentDate}" pattern="MMM dd, yyyy"/></td>
                                        <td><fmt:formatDate value="${apt.appointmentTime}" pattern="hh:mm a"/></td>
                                        <td class="patient-cell">
                                            <div class="patient-avatar">${apt.patientName.substring(0,1)}</div>
                                            ${apt.patientName}
                                        </td>
                                        <td><span class="status-${apt.status}">${apt.status}</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-panel">
                        <i class="fas fa-history"></i>
                        <p>No appointment history</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <!-- Complete Modal -->
    <div id="completeModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-clipboard-check"></i> Complete Appointment</h3>
                <span class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></span>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/doctor/complete-appointment" method="post">
                    <input type="hidden" name="id" id="completeAppointmentId">
                    <div class="form-group">
                        <label><i class="fas fa-stethoscope"></i> Diagnosis</label>
                        <textarea name="diagnosis" rows="3" placeholder="Enter diagnosis..." required></textarea>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-pills"></i> Prescription</label>
                        <textarea name="prescription" rows="3" placeholder="Enter prescription..." required></textarea>
                    </div>
                    <button type="submit" class="btn-submit">Mark as Completed</button>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

    <script>
        function openCompleteModal(id) {
            document.getElementById('completeAppointmentId').value = id;
            document.getElementById('completeModal').classList.add('show');
        }
        function closeModal() {
            document.getElementById('completeModal').classList.remove('show');
        }
        window.onclick = function(e) {
            if (e.target.classList.contains('modal')) e.target.classList.remove('show');
        }
    </script>
</body>
</html>