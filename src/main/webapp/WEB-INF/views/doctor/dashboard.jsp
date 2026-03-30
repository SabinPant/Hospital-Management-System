<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String userType = (String) session.getAttribute("user_type");
    if (!"doctor".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String fullName = (String) session.getAttribute("full_name");
    if (fullName == null) fullName = "Doctor";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/dashboard.css">
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="dashboard-container">
        <div class="welcome-card">
            <h1>Welcome, Dr. <%= fullName %>!</h1>
            <p>Manage your appointments and patient records here.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <i class="fas fa-calendar-alt"></i>
                <h3>Today's Appointments</h3>
                <p>View and manage your appointments for today</p>
                <a href="#" class="btn-card">View Schedule</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-users"></i>
                <h3>My Patients</h3>
                <p>View your patient list and medical history</p>
                <a href="#" class="btn-card">View Patients</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-clock"></i>
                <h3>Set Availability</h3>
                <p>Update your consultation hours and availability</p>
                <a href="#" class="btn-card">Update Schedule</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-user-md"></i>
                <h3>My Profile</h3>
                <p>Update your professional information</p>
                <a href="#" class="btn-card">Edit Profile</a>
            </div>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

</body>
</html>