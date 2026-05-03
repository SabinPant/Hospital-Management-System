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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/patient-dashboard.css">
    <style>
        .profile-wrapper {
            max-width: 1000px;
            margin: 32px auto;
            padding: 0 20px 60px;
        }

        /* Hero Banner */
        .profile-hero {
            background: linear-gradient(135deg, #0a5c8e 0%, #0369a1 60%, #0284c7 100%);
            border-radius: 20px;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 28px;
            position: relative;
        }

        .hero-avatar-wrapper {
            position: relative;
        }

        .hero-avatar {
            width: 100px;
            height: 100px;
            background: rgba(255,255,255,0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 3px solid rgba(255,255,255,0.3);
            overflow: hidden;
        }

        .hero-avatar i {
            font-size: 3rem;
            color: white;
        }

        .hero-avatar .profile-img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
        }

        .upload-form {
            position: absolute;
            bottom: 5px;
            right: 5px;
        }

        .upload-btn {
            background: #0ea5e9;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .upload-btn i {
            color: white;
            font-size: 0.8rem;
        }

        .upload-btn:hover {
            background: #0284c7;
            transform: scale(1.05);
        }

        .hero-info h2 {
            color: #fff;
            font-size: 1.5rem;
            font-weight: 800;
            margin: 0 0 5px;
        }

        .hero-badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .hero-badge {
            background: rgba(255,255,255,0.15);
            color: #fff;
            padding: 5px 13px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* Info Cards */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #e8edf2;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .card-header {
            padding: 16px 22px;
            border-bottom: 1px solid #f1f5f9;
            background: #f8fafc;
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .card-header i {
            color: #0a5c8e;
        }

        .card-header h3 {
            font-size: 0.9rem;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }

        .card-body {
            padding: 22px;
        }

        .info-row {
            display: flex;
            align-items: flex-start;
            padding: 8px 0;
            border-bottom: 1px solid #f8fafc;
            gap: 12px;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            width: 130px;
            font-size: 0.75rem;
            font-weight: 700;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            flex-shrink: 0;
        }

        .info-value {
            flex: 1;
            font-size: 0.85rem;
            color: #1e293b;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .profile-hero {
                flex-direction: column;
                text-align: center;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .hero-badges {
                justify-content: center;
            }
        }
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
<<<<<<< HEAD
<img src="${pageContext.request.contextPath}/uploads/${sessionScope.profile_image}" alt="Profile" class="profile-img">                        </c:when>
=======
                            <img src="${pageContext.request.contextPath}/${sessionScope.profile_image}" alt="Profile" class="profile-img">
                        </c:when>
>>>>>>> 0ae8e6a (feat: Add Patient Profile with picture upload & enhance registration)
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