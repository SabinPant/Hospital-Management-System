<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
</head>
<body>

<div class = "admin-container">
<div class="admin-container">
        <!-- Sidebar - Using component -->
<jsp:include page="/components/admin-sidebar.jsp">
    <jsp:param name="page" value="dashboard" />
</jsp:include>
    </div>

    <!-- Main Content -->
  <div class="admin-main">
        <div class="admin-topbar" style="margin-bottom: 32px;">
            <h1 style="color: #1e293b; font-size: 1.8rem; font-weight: 700;">Dashboard</h1>
            <div class="admin-user" style="display: flex; gap: 20px; align-items: center;">
                <span style="color: #64748b; font-weight: 500;"><i class="fas fa-user-shield" style="color: #0ea5e9;"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout" style="color: #ef4444; text-decoration: none; font-weight: 600; padding: 8px 16px; background: #fef2f2; border-radius: 8px; transition: 0.2s;"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: #e0f2fe; color: #0ea5e9;">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-details">
                    <p style="color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin: 0 0 4px 0; letter-spacing: 0.5px;">Total Users</p>
                    <h3 style="font-size: 1.5rem; margin: 0; color: #1e293b;">${dashboardData.totalUsers}</h3>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #dcfce7; color: #10b981;">
                    <i class="fas fa-user-md"></i>
                </div>
                <div class="stat-details">
                    <p style="color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin: 0 0 4px 0; letter-spacing: 0.5px;">Total Doctors</p>
                    <h3 style="font-size: 1.5rem; margin: 0; color: #1e293b;">${dashboardData.totalDoctors}</h3>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #f3e8ff; color: #a855f7;">
                    <i class="fas fa-user"></i>
                </div>
                <div class="stat-details">
                    <p style="color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin: 0 0 4px 0; letter-spacing: 0.5px;">Total Patients</p>
                    <h3 style="font-size: 1.5rem; margin: 0; color: #1e293b;">${dashboardData.totalPatients}</h3>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #ffedd5; color: #f97316;">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-details">
                    <p style="color: #64748b; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; margin: 0 0 4px 0; letter-spacing: 0.5px;">Pending Approvals</p>
                    <h3 style="font-size: 1.5rem; margin: 0; color: #1e293b;">${dashboardData.pendingDoctors}</h3>
                </div>
            </div>
        </div>

        <div class="dashboard-section">
            <div class="section-header">
                <h2><i class="fas fa-wallet" style="color: #10b981;"></i> Financial Overview</h2>
            </div>
            <div class="financial-summary" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; background: #f8fafc; padding: 20px; border-radius: 8px; border: 1px solid #f1f5f9;">
                <div class="financial-item" style="padding-right: 20px; border-right: 1px solid #e2e8f0;">
                    <div class="label" style="color: #64748b; font-size: 0.85rem; font-weight: 600; margin-bottom: 8px;">Total Revenue</div>
                    <div class="value" style="font-size: 1.4rem; color: #1e293b; font-weight: 700;">Rs <fmt:formatNumber value="${dashboardData.totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                </div>
                <div class="financial-item" style="padding-right: 20px; border-right: 1px solid #e2e8f0;">
                    <div class="label" style="color: #64748b; font-size: 0.85rem; font-weight: 600; margin-bottom: 8px;">Completed Appointments</div>
                    <div class="value" style="font-size: 1.4rem; color: #1e293b; font-weight: 700;">${dashboardData.totalCompletedAppointments}</div>
                </div>
                <div class="financial-item">
                    <div class="label" style="color: #64748b; font-size: 0.85rem; font-weight: 600; margin-bottom: 8px;">Avg. Revenue/Appt</div>
                    <div class="value" style="font-size: 1.4rem; color: #1e293b; font-weight: 700;">Rs <fmt:formatNumber value="${dashboardData.avgRevenuePerAppointment}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                </div>
            </div>
        </div>

        <div class="dashboard-section">
            <div class="section-header">
                <h2><i class="fas fa-user-clock" style="color: #f97316;"></i> Action Required: Pending Doctor Approvals</h2>
            </div>
            <div class="activity-list">
                <c:choose>
                    <c:when test="${not empty dashboardData.pendingDoctorsList}">
                        <c:forEach var="doctor" items="${dashboardData.pendingDoctorsList}">
                            <div class="doctor-item" 
                                 data-doctor-id="${doctor.id}"
                                 data-doctor-name="${doctor.full_name}"
                                 data-doctor-email="${doctor.email}"
                                 data-doctor-phone="${doctor.phone}"
                                 data-doctor-address="${doctor.address}"
                                 data-doctor-specialization="${doctor.specialization}"
                                 data-doctor-experience="${doctor.experience_years}"
                                 data-doctor-qualification="${doctor.qualification}"
                                 data-doctor-license="${doctor.license_number}"
                                 data-doctor-fee="${doctor.consultation_fee}"
                                 data-doctor-bio="${doctor.bio}"
                                 data-doctor-image="${doctor.license_image}">
                                <div class="doctor-info">
                                    <h4 style="margin: 0 0 5px 0; font-size: 1rem;">${doctor.full_name}</h4>
                                    <p style="margin: 0;">${doctor.specialization} &bull; ${doctor.experience_years} yrs exp &bull; License: ${doctor.license_number}</p>
                                </div>
                                <div class="doctor-actions">
                                    <button class="btn-view-details" onclick="viewDoctorDetails(this)" style="background: white; color: #0ea5e9; border: 1px solid #0ea5e9; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 0.8rem; transition: 0.2s;" onmouseover="this.style.background='#0ea5e9'; this.style.color='white'" onmouseout="this.style.background='white'; this.style.color='#0ea5e9'">View Details</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; color: #94a3b8; padding: 30px; background: #f8fafc; border-radius: 8px; border: 1px dashed #cbd5e1;">
                            <i class="fas fa-check-circle" style="font-size: 2rem; color: #cbd5e1; margin-bottom: 10px;"></i>
                            <p style="margin: 0; font-weight: 500;">All caught up! No pending approvals.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="dashboard-section">
            <div class="section-header">
                <h2><i class="fas fa-calendar-day" style="color: #0ea5e9;"></i> Today's Appointments <span style="background: #e0f2fe; color: #0ea5e9; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem; margin-left: 8px;">${dashboardData.todayAppointments}</span></h2>
            </div>
            <div class="activity-list">
                <c:choose>
                    <c:when test="${not empty dashboardData.todayAppointmentsList}">
                        <c:forEach var="apt" items="${dashboardData.todayAppointmentsList}">
                            <div class="appointment-item">
                                <span class="appointment-time" style="background: #f1f5f9; padding: 6px 12px; border-radius: 6px; font-weight: 600; color: #334155; font-size: 0.85rem;">${apt.appointment_time}</span>
                                <div class="appointment-info" style="flex-grow: 1; margin-left: 20px;">
                                    <p style="margin: 0; color: #1e293b;"><strong style="color: #0ea5e9;">${apt.doctor_name}</strong> treating <strong>${apt.patient_name}</strong></p>
                                </div>
                                <span class="appointment-status" style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase; color: #64748b; background: #f8fafc; padding: 4px 10px; border-radius: 20px; border: 1px solid #e2e8f0;">${apt.status}</span>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; color: #64748b; padding: 20px;">No appointments scheduled for today.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="dashboard-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 32px;">
            
            <div class="dashboard-section" style="margin-bottom: 0;">
                <div class="section-header">
                    <h2><i class="fas fa-bolt" style="color: #eab308;"></i> Quick Actions</h2>
                </div>
                <div class="quick-actions-grid">
                    
                    <a href="${pageContext.request.contextPath}/admin/add-doctor" class="quick-action-card">
                        <span class="qa-icon" style="background: #dcfce7; color: #16a34a;">
                            <i class="fas fa-user-plus"></i>
                        </span>
                        <span class="qa-text">
                            <span class="qa-title">Add New Doctor</span>
                            <span class="qa-desc">Register a new medical professional</span>
                        </span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/announcement" class="quick-action-card">
                        <span class="qa-icon" style="background: #e0f2fe; color: #0ea5e9;">
                            <i class="fas fa-bullhorn"></i>
                        </span>
                        <span class="qa-text">
                            <span class="qa-title">Announcement</span>
                            <span class="qa-desc">Broadcast a message to patients</span>
                        </span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/export-finance" class="quick-action-card qa-full-width">
                        <span class="qa-icon" style="background: #f3e8ff; color: #a855f7;">
                            <i class="fas fa-file-invoice-dollar"></i>
                        </span>
                        <span class="qa-text">
                            <span class="qa-title">Download Finance Report</span>
                            <span class="qa-desc">Export the latest revenue and billing data as CSV</span>
                        </span>
                    </a>

                </div>
            </div>

            <div class="dashboard-section" style="margin-bottom: 0;">
                <div class="section-header">
                    <h2><i class="fas fa-trophy" style="color: #eab308;"></i> Top Doctors</h2>
                </div>
                <div class="activity-list">
                    <c:choose>
                        <c:when test="${not empty dashboardData.topDoctorsList}">
                            <c:forEach var="doctor" items="${dashboardData.topDoctorsList}">
                                <div class="doctor-item" style="display: flex; align-items: center; padding: 12px; background: #f8fafc; border-radius: 8px; margin-bottom: 10px; border: 1px solid #f1f5f9;">
                                    <div style="background: #fffbeb; color: #d97706; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; margin-right: 15px;">
                                        #${doctor.rank}
                                    </div>
                                    <div class="doctor-info">
                                        <h4 style="margin: 0 0 4px 0; color: #1e293b;">${doctor.full_name}</h4>
                                        <p style="margin: 0; font-size: 0.8rem; color: #10b981; font-weight: 600;"><i class="fas fa-check-circle"></i> ${doctor.appointment_count} completed</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="text-align: center; color: #64748b; padding: 20px;">No ranking data available</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .modern-modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px; }
    .modern-modal-section-title { font-size: 1rem; color: #0a5c8e; border-bottom: 2px solid #e2e8f0; padding-bottom: 8px; margin-bottom: 15px; font-weight: 600; }
    .modern-detail-box { background: #f8fafc; padding: 12px 15px; border-radius: 8px; border: 1px solid #e2e8f0; }
    .modern-detail-box.full-width { grid-column: 1 / -1; }
    .modern-detail-label { font-size: 0.75rem; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px; font-weight: 700; }
    .modern-detail-value { font-size: 0.95rem; color: #1e293b; font-weight: 500; word-break: break-word; }
    .modern-action-btn { padding: 10px 20px; border-radius: 6px; cursor: pointer; font-size: 0.85rem; font-weight: 600; border: none; transition: 0.2s; }
    @media (max-width: 600px) {
        .modern-modal-grid { grid-template-columns: 1fr; }
        .modern-modal-actions { flex-direction: column; }
        .modern-action-btn { width: 100%; margin-bottom: 8px; }
    }
</style>

<div id="doctorModal" class="modal doctor-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15,23,42,0.6); z-index: 1000; 
                                                        justify-content: center; align-items: center; backdrop-filter: blur(4px);">
    <div class="modal-content" style="background: white; border-radius: 12px; max-width: 650px; width: 90%; max-height: 85vh; overflow-y: auto; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);">
        <div class="modal-header" style="padding: 18px 24px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; background: #f8fafc; border-radius: 12px 12px 0 0;">
            <h3 style="color: #1e293b; margin: 0; font-size: 1.15rem;"><i class="fas fa-user-md" style="color: #0ea5e9; margin-right: 8px;"></i> Doctor Application Details</h3>
            <span class="modal-close" onclick="closeDoctorModal()" style="cursor: pointer; font-size: 1.5rem; color: #64748b; line-height: 1;">&times;</span>
        </div>
        <div class="modal-body" id="doctorModalBody" style="padding: 24px;"></div>
    </div>
</div>

<script>
    function viewDoctorDetails(btn) {
        var doctorItem = btn.closest('.doctor-item');
        
        var id = doctorItem.getAttribute('data-doctor-id');
        var name = doctorItem.getAttribute('data-doctor-name');
        var email = doctorItem.getAttribute('data-doctor-email');
        var phone = doctorItem.getAttribute('data-doctor-phone');
        var address = doctorItem.getAttribute('data-doctor-address');
        var specialization = doctorItem.getAttribute('data-doctor-specialization');
        var experience = doctorItem.getAttribute('data-doctor-experience');
        var qualification = doctorItem.getAttribute('data-doctor-qualification');
        var license = doctorItem.getAttribute('data-doctor-license');
        var fee = doctorItem.getAttribute('data-doctor-fee');
        var bio = doctorItem.getAttribute('data-doctor-bio');
        var licenseImage = doctorItem.getAttribute('data-doctor-image');
        
        // Setup Image HTML
        var imageHtml = '';
        if (licenseImage && licenseImage !== 'null' && licenseImage !== '') {
            imageHtml = '<div class="modern-detail-box full-width">' +
                '<div class="modern-detail-label">License Document</div>' +
                '<img src="${pageContext.request.contextPath}/' + licenseImage + '" style="max-width:100%; max-height:250px; margin-top:8px; border-radius:8px; border: 1px solid #e2e8f0; padding: 4px;">' +
            '</div>';
        } else {
            imageHtml = '<div class="modern-detail-box full-width">' +
                '<div class="modern-detail-label">License Document</div>' +
                '<div class="modern-detail-value" style="color: #94a3b8; font-style: italic;">No document uploaded</div>' +
            '</div>';
        }
        
        // Build the modern grid layout using safe standard string concatenation
        var html = 
            '<div class="modern-modal-section-title">Personal & Contact Info</div>' +
            '<div class="modern-modal-grid">' +
                '<div class="modern-detail-box"><div class="modern-detail-label">Full Name</div><div class="modern-detail-value">' + (name || 'N/A') + '</div></div>' +
                '<div class="modern-detail-box"><div class="modern-detail-label">Email Address</div><div class="modern-detail-value">' + (email || 'N/A') + '</div></div>' +
                '<div class="modern-detail-box"><div class="modern-detail-label">Phone Number</div><div class="modern-detail-value">' + (phone || 'N/A') + '</div></div>' +
                '<div class="modern-detail-box"><div class="modern-detail-label">Address</div><div class="modern-detail-value">' + (address || 'Not provided') + '</div></div>' +
            '</div>' +
            
            '<div class="modern-modal-section-title" style="margin-top: 25px;">Professional Profile</div>' +
            '<div class="modern-modal-grid">' +
                '<div class="modern-detail-box"><div class="modern-detail-label">Specialization</div><div class="modern-detail-value">' + (specialization || 'N/A') + '</div></div>' +
                '<div class="modern-detail-box"><div class="modern-detail-label">Qualification</div><div class="modern-detail-value">' + (qualification || 'N/A') + '</div></div>' +
                '<div class="modern-detail-box"><div class="modern-detail-label">License Number</div><div class="modern-detail-value">' + (license || 'N/A') + '</div></div>' +
                '<div class="modern-detail-box"><div class="modern-detail-label">Experience & Fee</div><div class="modern-detail-value">' + (experience || '0') + ' Years | Rs ' + (fee || '0') + '</div></div>' +
                '<div class="modern-detail-box full-width"><div class="modern-detail-label">Biography</div><div class="modern-detail-value" style="font-size: 0.9rem; line-height: 1.5;">' + (bio || 'Not provided') + '</div></div>' +
                imageHtml +
            '</div>' +
            
            '<div class="modern-modal-actions" style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 25px; padding-top: 20px; border-top: 1px solid #e2e8f0;">' +
                '<button onclick="closeDoctorModal()" class="modern-action-btn" style="background: #f1f5f9; color: #64748b; margin-right: auto;">Cancel</button>' +
                '<button onclick="rejectDoctor(' + id + ')" class="modern-action-btn" style="background: #fff; color: #ef4444; border: 1px solid #ef4444;">Reject Application</button>' +
                '<button onclick="approveDoctor(' + id + ')" class="modern-action-btn" style="background: #10b981; color: white; box-shadow: 0 4px 6px rgba(16, 185, 129, 0.2);">Approve Doctor</button>' +
            '</div>';
        
        document.getElementById('doctorModalBody').innerHTML = html;
        document.getElementById('doctorModal').style.display = 'flex'; 
    }
    
    function closeDoctorModal() {
        document.getElementById('doctorModal').style.display = 'none'; 
    }
    
    function approveDoctor(doctorId) {
        if(confirm('Approve this doctor?')) {
            window.location.href = '${pageContext.request.contextPath}/admin/approve-doctor?id=' + doctorId;
        }
    }
    
    function rejectDoctor(doctorId) {
        var reason = prompt('Please enter reason for rejection:');
        if(reason !== null && reason.trim() !== '') {
            window.location.href = '${pageContext.request.contextPath}/admin/reject-doctor?id=' + doctorId + '&reason=' + encodeURIComponent(reason);
        } else if(reason !== null) {
            alert('Please provide a reason for rejection');
        }
    }
    
    window.onclick = function(event) {
        var modal = document.getElementById('doctorModal');
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    }
</script>

</body>
</html>