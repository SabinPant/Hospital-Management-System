<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Patient Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/patients/patient-profile.css">
    <style>
       
    </style>
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="profile-wrapper">
        <!-- Hero Banner with Profile Picture -->
        <div class="profile-hero">
            <div class="hero-avatar-wrapper">
                <div class="hero-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.profile_image}">
<img src="${pageContext.request.contextPath}/uploads/${sessionScope.profile_image}" alt="Profile" class="profile-img">                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user-circle"></i>
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
                <h2>${sessionScope.full_name}</h2>
                <p>Patient ID: ${sessionScope.user_id_display}</p>
                <div class="hero-badges">
                    <span class="hero-badge"><i class="fas fa-tint"></i> Blood: ${sessionScope.blood_group != null ? sessionScope.blood_group : 'Not specified'}</span>
                    <span class="hero-badge"><i class="fas fa-calendar-alt"></i> Member since: <fmt:formatDate value="${sessionScope.joined_date}" pattern="MMM dd, yyyy"/></span>
                </div>
            </div>
        </div>

        <!-- Personal Information -->
        <div class="info-grid">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-user-circle"></i>
                    <h3>Personal Information</h3>
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <div class="info-label">Full Name</div>
                        <div class="info-value">${sessionScope.full_name}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email</div>
                        <div class="info-value">${sessionScope.email}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Phone</div>
                        <div class="info-value">${sessionScope.phone != null ? sessionScope.phone : 'Not provided'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Blood Group</div>
                        <div class="info-value">${sessionScope.blood_group != null ? sessionScope.blood_group : 'Not specified'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Member Since</div>
                        <div class="info-value"><fmt:formatDate value="${sessionScope.joined_date}" pattern="MMM dd, yyyy"/></div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <i class="fas fa-address-card"></i>
                    <h3>Contact & Medical</h3>
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <div class="info-label">Address</div>
                        <div class="info-value">${sessionScope.address != null ? sessionScope.address : 'Not provided'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Emergency Contact</div>
                        <div class="info-value">${sessionScope.emergency_contact != null ? sessionScope.emergency_contact : 'Not provided'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Medical History</div>
                        <div class="info-value">${sessionScope.medical_history != null ? sessionScope.medical_history : 'Not recorded'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Allergies</div>
                        <div class="info-value">${sessionScope.allergies != null ? sessionScope.allergies : 'None'}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

</body>
</html>