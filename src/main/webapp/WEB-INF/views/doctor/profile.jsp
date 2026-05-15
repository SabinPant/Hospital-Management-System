<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Doctor Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/doctors/doctor-profile.css">
  
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="profile-wrapper">

        <!-- ── Hero Banner ── -->
<div class="profile-hero">
    <div class="hero-avatar-wrapper">
        <div class="hero-avatar">
            <c:choose>
                <c:when test="${not empty sessionScope.profile_image}">
<img src="${pageContext.request.contextPath}/uploads/${sessionScope.profile_image}" alt="Profile" class="profile-img">                </c:when>
                <c:otherwise>
                    <i class="fas fa-user-md"></i>
                </c:otherwise>
            </c:choose>
        </div>
        <form action="${pageContext.request.contextPath}/upload-image" method="post" enctype="multipart/form-data" class="upload-form">
            <input type="hidden" name="imageType" value="profile">
            <label for="profileImageUpload" class="upload-btn">
                <i class="fas fa-camera"></i>
            </label>
            <input type="file" id="profileImageUpload" name="image" accept="image/jpeg,image/png,image/gif" style="display: none;" onchange="this.form.submit()">
        </form>
    </div>
    <div class="hero-info">
        <h2>Dr. ${profile.full_name}</h2>
        <p><i class="fas fa-stethoscope"></i> ${profile.specialization} &nbsp;·&nbsp; ${profile.experience_years} Years Experience</p>
        <div class="hero-badges">
            <span class="hero-badge"><i class="fas fa-id-badge"></i> ${profile.user_id}</span>
            <span class="hero-badge"><i class="fas fa-certificate"></i> ${profile.qualification}</span>
            <span class="hero-badge"><i class="fas fa-money-bill-wave"></i> Rs ${profile.consultation_fee} / visit</span>
        </div>
    </div>
</div>

        <!-- ── Stats Row ── -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-users"></i></div>
                <div class="stat-info">
                    <div class="stat-number">${earnings.total_patients != null ? earnings.total_patients : 0}</div>
                    <div class="stat-label">Total Patients</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-calendar-check"></i></div>
                <div class="stat-info">
                    <div class="stat-number">${earnings.completed_appointments != null ? earnings.completed_appointments : 0}</div>
                    <div class="stat-label">Completed Appointments</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon amber"><i class="fas fa-rupee-sign"></i></div>
                <div class="stat-info">
                    <div class="stat-number earning">
                        Rs <fmt:formatNumber value="${earnings.total_earnings != null ? earnings.total_earnings : 0}" type="number" minFractionDigits="0" maxFractionDigits="0"/>
                    </div>
                    <div class="stat-label">Total Earnings</div>
                </div>
            </div>
        </div>

        <!-- ── Info Cards ── -->
        <div class="info-grid">

            <!-- Personal Info -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-user-circle"></i>
                    <h3>Personal Information</h3>
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <div class="info-label">Full Name</div>
                        <div class="info-value">Dr. ${profile.full_name}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Doctor ID</div>
                        <div class="info-value">${profile.user_id}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email</div>
                        <div class="info-value">${profile.email}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Phone</div>
                        <div class="info-value">${not empty profile.phone ? profile.phone : '—'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Gender</div>
                        <div class="info-value">${not empty profile.gender ? profile.gender : '—'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Address</div>
                        <div class="info-value">${not empty profile.address ? profile.address : '—'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Member Since</div>
                        <div class="info-value">
                            <fmt:formatDate value="${profile.created_at}" pattern="MMM dd, yyyy"/>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Professional Info -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-stethoscope"></i>
                    <h3>Professional Information</h3>
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <div class="info-label">Specialization</div>
                        <div class="info-value">${profile.specialization}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Qualification</div>
                        <div class="info-value">${profile.qualification}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">License No.</div>
                        <div class="info-value">${profile.license_number}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Experience</div>
                        <div class="info-value">${profile.experience_years} years</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Consult. Fee</div>
                        <div class="info-value">
                            Rs <fmt:formatNumber value="${profile.consultation_fee}" type="number" minFractionDigits="0" maxFractionDigits="0"/>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Bio</div>
                        <div class="info-value">${not empty profile.bio ? profile.bio : '—'}</div>
                    </div>
                    <c:if test="${not empty profile.license_image}">
                        <div class="info-row">
                            <div class="info-label">License Doc</div>
                            <div class="info-value">
<img src="${pageContext.request.contextPath}/uploads/${profile.license_image}" class="license-img" alt="License Document">                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- ── Monthly Earnings ── -->
        <div class="card">
            <div class="card-header">
                <i class="fas fa-chart-line"></i>
                <h3>Monthly Earnings</h3>
            </div>
            <c:choose>
                <c:when test="${not empty monthlyEarnings}">
                    <table class="earnings-table">
                        <thead>
                            <tr>
                                <th>Month</th>
                                <th>Appointments</th>
                                <th>Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="month" items="${monthlyEarnings}">
                                <tr>
                                    <td>${month.month}</td>
                                    <td><span class="appt-badge"><i class="fas fa-calendar-check"></i> ${month.appointments}</span></td>
                                    <td class="revenue-val">Rs <fmt:formatNumber value="${month.revenue}" type="number" minFractionDigits="0" maxFractionDigits="0"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-chart-line"></i>
                        <p>No earnings data available yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <jsp:include page="../../../components/footer.jsp" />

</body>
</html>
