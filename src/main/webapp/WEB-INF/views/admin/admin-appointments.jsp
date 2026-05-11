<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments | Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-appointments.css">
</head>
<body>

<div class="admin-container">
    <div class="admin-sidebar">
        <jsp:include page="/components/admin-sidebar.jsp">
            <jsp:param name="page" value="appointments" />
        </jsp:include>
    </div>

    <div class="admin-main">
        <div class="admin-topbar">
            <h1><i class="fas fa-calendar-check"></i> Appointments</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${param.error}</div>
        </c:if>

        <%-- Determine which view to open on page load.
             If the server routed us here via ?status=requests, start on the requests view.
             Any other status (or none) lands on the details view. --%>
        <c:set var="initView" value="${currentStatus == 'requests' ? 'requests' : 'details'}" />

        <!-- ── Main Toggle ───────────────────────────────────────── -->
        <div class="adm-toggle">
            <button class="adm-toggle-btn ${initView == 'requests' ? 'active' : ''}"
                    id="toggleRequests"
                    onclick="switchAdminView('requests')">
                <i class="fas fa-clipboard-list"></i>
                Appointment Requests
                <c:if test="${not empty appointmentRequests}">
                    <span class="adm-toggle-badge">${fn:length(appointmentRequests)}</span>
                </c:if>
            </button>
            <button class="adm-toggle-btn ${initView == 'details' ? 'active' : ''}"
                    id="toggleDetails"
                    onclick="switchAdminView('details')">
                <i class="fas fa-calendar-alt"></i>
                Appointment Details
            </button>
        </div>
        <%-- fn: taglib is needed for the length call above — add this at top if not present:
             <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
             If you prefer not to use it, simply remove the badge <c:if> block. --%>

        <!-- 
             VIEW 1 — APPOINTMENT REQUESTS (card layout)
                                                               -->
        <div id="viewRequests" class="adm-view ${initView == 'requests' ? 'active' : ''}">

            <div class="dashboard-card">
                <c:choose>
                    <c:when test="${not empty appointmentRequests}">
                        <div class="req-grid">
                            <c:forEach var="req" items="${appointmentRequests}">
                                <div class="req-card">
                                    <!-- LEFT: all info -->
                                    <div class="req-card-left">

                                        <!-- Patient + date/time pills -->
                                        <div class="req-patient-row">
                                            <div class="req-avatar">
                                                <i class="fas fa-user-injured"></i>
                                            </div>
                                            <div class="req-patient-info">
                                                <div class="req-patient-name">${req.patient_name}</div>
                                                <div class="req-patient-phone">
                                                    <c:if test="${not empty req.patient_phone}">
                                                        <i class="fas fa-phone" style="font-size:.6rem;"></i> ${req.patient_phone}
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="req-pills">
                                                <span class="req-pill req-pill-date">
                                                    <i class="fas fa-calendar-day"></i>
                                                    <fmt:formatDate value="${req.appointment_date}" pattern="MMM dd, yyyy"/>
                                                </span>
                                                <span class="req-pill req-pill-time">
                                                    <i class="fas fa-clock"></i>
                                                    ${req.appointment_time}
                                                </span>
                                            </div>
                                        </div>

                                        <!-- Problem description — the hero field -->
                                        <div class="req-problem-block">
                                            <div class="req-problem-label">
                                                <i class="fas fa-comment-medical" style="margin-right:4px;"></i>Chief Complaint
                                            </div>
                                            <div class="req-problem-text">${req.problem_description}</div>
                                            <c:if test="${not empty req.symptoms}">
                                                <div class="req-symptoms-text">
                                                    <i class="fas fa-notes-medical" style="margin-right:4px;color:#94a3b8;"></i>${req.symptoms}
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Submitted date -->
                                        <div class="req-meta-row">
                                            <i class="fas fa-paper-plane"></i>
                                            Submitted on <fmt:formatDate value="${req.created_at}" pattern="MMM dd, yyyy"/>
                                        </div>

                                    </div><!-- /.req-card-left -->

                                    <!-- RIGHT: ID + assign button -->
                                    <div class="req-card-right">
                                        <div class="req-id-tag">#${req.appointment_id}</div>
                                       <button class="btn-assign-card"
                                        data-req-id="${req.id}"
                                          data-patient-name="${fn:escapeXml(req.patient_name)}"
                                          data-problem="${fn:escapeXml(req.problem_description)}"
                                         onclick="openAssignModalFromBtn(this)">
                                         <i class="fas fa-user-plus"></i> Assign Doctor
                                         </button>
                                    </div>

                                </div><!-- /.req-card -->
                            </c:forEach>
                        </div><!-- /.req-grid -->
                    </c:when>
                    <c:otherwise>
                        <div class="req-empty">
                            <i class="fas fa-inbox"></i>
                            <p>No pending appointment requests</p>
                            <span>New requests from patients will appear here</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div><!-- /#viewRequests -->

        <!-- ================================================================
             VIEW 2 — APPOINTMENT DETAILS (filter tabs + table)
             ================================================================ -->
        <div id="viewDetails" class="adm-view ${initView == 'details' ? 'active' : ''}">

            <!-- Filter bar — "Requests" tab removed -->
            <div class="filter-bar">
                <div class="filter-buttons">
                    <a href="${pageContext.request.contextPath}/admin/appointments"
                       class="filter-btn ${empty currentStatus || currentStatus == 'requests' ? 'active' : ''}">All</a>
                    <a href="${pageContext.request.contextPath}/admin/appointments?status=pending"
                       class="filter-btn ${currentStatus == 'pending' ? 'active' : ''}">Pending</a>
                    <a href="${pageContext.request.contextPath}/admin/appointments?status=confirmed"
                       class="filter-btn ${currentStatus == 'confirmed' ? 'active' : ''}">Confirmed</a>
                    <a href="${pageContext.request.contextPath}/admin/appointments?status=completed"
                       class="filter-btn ${currentStatus == 'completed' ? 'active' : ''}">Completed</a>
                    <a href="${pageContext.request.contextPath}/admin/appointments?status=cancelled"
                       class="filter-btn ${currentStatus == 'cancelled' ? 'active' : ''}">Cancelled</a>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/admin/appointments" class="search-form">
                    <c:if test="${not empty currentStatus && currentStatus != 'requests'}">
                        <input type="hidden" name="status" value="${currentStatus}">
                    </c:if>
                    <input type="text" name="search"
                           placeholder="Search by patient, doctor, or ID..."
                           value="${currentSearch}">
                    <button type="submit"><i class="fas fa-search"></i></button>
                </form>
            </div>

            <!-- Appointments table -->
            <div class="dashboard-card">
                <c:choose>
                    <c:when test="${not empty appointments}">
                        <table class="appointments-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Patient</th>
                                    <th>Doctor</th>
                                    <th>Specialization</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="apt" items="${appointments}">
                                    <tr class="apt-row"
                                        data-apt-id="${apt.appointment_id}"
                                        data-appointment-date="<fmt:formatDate value="${apt.appointment_date}" pattern="MMM dd, yyyy"/>"
                                        data-appointment-time="${apt.appointment_time}"
                                        data-patient-name="${apt.patient_name}"
                                        data-patient-email="${apt.patient_email != null ? apt.patient_email : 'N/A'}"
                                        data-patient-phone="${apt.patient_phone != null ? apt.patient_phone : 'N/A'}"
                                        data-doctor-name="${apt.doctor_name}"
                                        data-specialization="${apt.specialization != null ? apt.specialization : 'General'}"
                                        data-status="${apt.status}"
                                        data-symptoms="${apt.symptoms != null ? apt.symptoms : ''}"
                                        data-diagnosis="${apt.diagnosis != null ? apt.diagnosis : ''}"
                                        data-prescription="${apt.prescription != null ? apt.prescription : ''}"
                                        data-cancellation-reason="${apt.cancellation_reason != null ? apt.cancellation_reason : ''}">
                                        <td>${apt.appointment_id}</td>
                                        <td><fmt:formatDate value="${apt.appointment_date}" pattern="MMM dd, yyyy"/></td>
                                        <td>${apt.appointment_time}</td>
                                        <td>${apt.patient_name} <small>(${apt.patient_phone})</small></td>
                                        <td>Dr. ${apt.doctor_name}</td>
                                        <td>${apt.specialization != null ? apt.specialization : 'General'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${apt.status == 'pending'}"><span class="status-pending">Pending</span></c:when>
                                                <c:when test="${apt.status == 'confirmed'}"><span class="status-confirmed">Confirmed</span></c:when>
                                                <c:when test="${apt.status == 'completed'}"><span class="status-completed">Completed</span></c:when>
                                                <c:when test="${apt.status == 'cancelled'}"><span class="status-cancelled">Cancelled</span></c:when>
                                                <c:otherwise><span class="status-pending">${apt.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button class="btn-view" onclick="openAptModal(this)">
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
                            <i class="fas fa-calendar-times"></i>
                            <p>No appointments found</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div><!-- /#viewDetails -->

    </div><!-- /.admin-main -->
</div><!-- /.admin-container -->

<!-- ==================== APPOINTMENT DETAILS MODAL ==================== -->
<div id="aptModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-file-medical"></i> Appointment Details</h3>
            <span class="modal-close" onclick="closeAptModal()">&times;</span>
        </div>
        <div class="modal-body" id="aptModalBody"></div>
    </div>
</div>

<!-- ==================== ASSIGN DOCTOR MODAL ==================== -->
<div id="assignModal" class="modal">
    <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header">
            <h3><i class="fas fa-user-plus"></i> Assign Doctor</h3>
            <span class="modal-close" onclick="closeAssignModal()">&times;</span>
        </div>
        <div class="modal-body">
           <div id="assignPatientInfo" style="margin-bottom:16px;"></div>
<form id="assignForm" method="POST" action="${pageContext.request.contextPath}/admin/assign-doctor">
    <input type="hidden" name="appointmentId" id="assignAppointmentId">
    
    <div class="form-group" style="margin-bottom:16px;">
    <label><i class="fas fa-user-md"></i> Select Doctor</label>
    <select name="doctorId" required
            style="width:100%;padding:10px;border:1px solid #e2e8f0;border-radius:8px;font-family:inherit;">
        <option value="">-- Choose a doctor --</option>
        <c:forEach var="doc" items="${approvedDoctors}">
            <option value="${doc.id}">Dr. ${doc.full_name} - ${doc.specialization}</option>
        </c:forEach>
    </select>
</div>
    
    <!-- Schedule adjustment -->
    <div style="background:#f8fafc;border-radius:12px;padding:14px 16px;margin-bottom:16px;border:1px solid #e2e8f0;">
        <label style="font-size:0.75rem;font-weight:700;color:#64748b;text-transform:uppercase;letter-spacing:0.5px;display:block;margin-bottom:10px;">
            <i class="fas fa-calendar-alt"></i> Adjust Schedule (optional)
        </label>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
            <div>
                <label style="font-size:0.7rem;color:#94a3b8;display:block;margin-bottom:4px;">Date</label>
                <input type="date" name="newDate" id="assignNewDate" 
                       style="width:100%;padding:8px 10px;border:1px solid #e2e8f0;border-radius:8px;font-family:inherit;font-size:0.85rem;">
            </div>
            <div>
                <label style="font-size:0.7rem;color:#94a3b8;display:block;margin-bottom:4px;">Time</label>
                <select name="newTime" id="assignNewTime"
                        style="width:100%;padding:8px 10px;border:1px solid #e2e8f0;border-radius:8px;font-family:inherit;font-size:0.85rem;">
                    <option value="">No change</option>
                    <option value="09:00">09:00 AM</option>
                    <option value="10:00">10:00 AM</option>
                    <option value="11:00">11:00 AM</option>
                    <option value="12:00">12:00 PM</option>
                    <option value="14:00">02:00 PM</option>
                    <option value="15:00">03:00 PM</option>
                    <option value="16:00">04:00 PM</option>
                </select>
            </div>
        </div>
    </div>
                <div style="margin-top:20px;text-align:right;">
                    <button type="button" class="btn-view"
                            style="background:#94a3b8;margin-right:8px;"
                            onclick="closeAssignModal()">Cancel</button>
                    <button type="submit" class="btn-assign">
                        <i class="fas fa-check"></i> Assign Doctor
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    /* ── View Toggle ─────────────────────────────────────── */
    function switchAdminView(view) {
        document.getElementById('viewRequests').classList.toggle('active', view === 'requests');
        document.getElementById('viewDetails').classList.toggle('active', view === 'details');
        document.getElementById('toggleRequests').classList.toggle('active', view === 'requests');
        document.getElementById('toggleDetails').classList.toggle('active', view === 'details');
    }

    /* ── Appointment Details Modal ───────────────────────── */
    function openAptModal(btn) {
        var row = btn.closest('.apt-row');
        var html = '';
        html += '<div class="detail-row"><div class="detail-label">Appointment ID</div><div class="detail-value">' + row.getAttribute('data-apt-id') + '</div></div>';
        html += '<div class="detail-row"><div class="detail-label">Patient</div><div class="detail-value">' + row.getAttribute('data-patient-name') + ' (' + row.getAttribute('data-patient-email') + ')</div></div>';
        html += '<div class="detail-row"><div class="detail-label">Doctor</div><div class="detail-value">Dr. ' + row.getAttribute('data-doctor-name') + ' - ' + row.getAttribute('data-specialization') + '</div></div>';
        html += '<div class="detail-row"><div class="detail-label">Date & Time</div><div class="detail-value">' + row.getAttribute('data-appointment-date') + ' at ' + row.getAttribute('data-appointment-time') + '</div></div>';
        html += '<div class="detail-row"><div class="detail-label">Status</div><div class="detail-value">' + row.getAttribute('data-status') + '</div></div>';
        var symptoms = row.getAttribute('data-symptoms');
        html += '<div class="detail-row"><div class="detail-label">Symptoms</div><div class="detail-value">' + (symptoms || 'Not specified') + '</div></div>';
        var diagnosis = row.getAttribute('data-diagnosis');
        if (diagnosis) html += '<div class="detail-row"><div class="detail-label">Diagnosis</div><div class="detail-value">' + diagnosis + '</div></div>';
        var prescription = row.getAttribute('data-prescription');
        if (prescription) html += '<div class="detail-row"><div class="detail-label">Prescription</div><div class="detail-value">' + prescription + '</div></div>';
        var reason = row.getAttribute('data-cancellation-reason');
        if (reason && row.getAttribute('data-status') === 'cancelled') {
            html += '<div class="detail-row"><div class="detail-label">Cancellation Reason</div><div class="detail-value">' + reason + '</div></div>';
        }
        document.getElementById('aptModalBody').innerHTML = html;
        document.getElementById('aptModal').classList.add('show');
    }

    function closeAptModal() {
        document.getElementById('aptModal').classList.remove('show');
    }

    /* ── Assign Doctor Modal ─────────────────────────────── */
function openAssignModal(id, patientName, problem) {
    document.getElementById('assignAppointmentId').value = id;
    document.getElementById('assignPatientInfo').innerHTML =
        '<div class="detail-row"><div class="detail-label">Patient</div><div class="detail-value">' + patientName + '</div></div>' +
        '<div class="detail-row"><div class="detail-label">Chief Complaint</div><div class="detail-value">' + problem + '</div></div>';
    document.getElementById('assignModal').classList.add('show');
}

    function closeAssignModal() {
        document.getElementById('assignModal').classList.remove('show');
    }

    /* ── Close modals on backdrop click ─────────────────── */
    window.onclick = function (event) {
        if (event.target === document.getElementById('aptModal')) closeAptModal();
        if (event.target === document.getElementById('assignModal')) closeAssignModal();
    };
    
    function openAssignModalFromBtn(btn) {
        var id = btn.getAttribute('data-req-id');
        var patientName = btn.getAttribute('data-patient-name');
        var problem = btn.getAttribute('data-problem');
        openAssignModal(id, patientName, problem);
    }
</script>

</body>
</html>
