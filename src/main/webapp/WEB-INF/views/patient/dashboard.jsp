<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String userType = (String) session.getAttribute("user_type");
    if (!"patient".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String fullName = (String) session.getAttribute("full_name");
    if (fullName == null) fullName = "Patient";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/dashboard.css">
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="dashboard-container">
        <div class="welcome-card">
            <h1>Welcome, <%= fullName %>!</h1>
            <p>Your health is our priority. Manage your appointments and health records here.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <i class="fas fa-calendar-plus"></i>
                <h3>Book Appointment</h3>
                <p>Schedule a consultation with our expert doctors</p>
                <a href="#" class="btn-card">Book Now</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-calendar-check"></i>
                <h3>My Appointments</h3>
                <p>View and manage your upcoming appointments</p>
                <a href="#" class="btn-card">View All</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-file-medical"></i>
                <h3>Medical Records</h3>
                <p>Access your health history and prescriptions</p>
                <a href="#" class="btn-card">View Records</a>
            </div>
            
            <div class="dashboard-card">
                <i class="fas fa-user-edit"></i>
                <h3>My Profile</h3>
                <p>Update your personal information</p>
                <a href="#" class="btn-card">Edit Profile</a>
            </div>
        </div>
    </div>

    <jsp:include page="../../../components/footer.jsp" />

</body>
</html>