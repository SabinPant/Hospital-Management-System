<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <!-- JSTL core tags -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Character encoding -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Responsive design -->
    
    <title>Login | MediLife Hospital</title> <!-- Page title -->

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- External CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">

    
</head>

<body>

    <!-- Include header -->
    <jsp:include page="../../components/header.jsp" />

    <!-- Main Login Container -->
    <div class="login-container">

        <!-- Header Section -->
        <div class="login-header">
            <h1><i class="fas fa-sign-in-alt"></i> Welcome Back</h1>
            <p>Login to your MediLife account</p>
        </div>
        
        <!-- Body Section -->
        <div class="login-body">

            <!-- Display error message if exists -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>
            
            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post">

                <!-- Email Input -->
                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Email Address</label>
                    <input type="email" name="email" placeholder="Enter your registered email" required>
                </div>
                
                <!-- Password Input -->
                <div class="form-group">
                    <label><i class="fas fa-lock"></i> Password</label>
                    <input type="password" name="password" placeholder="Enter your password" required>
                </div>
                
                <!-- Submit Button -->
                <button type="submit" class="btn-login-submit">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>
            
            <!-- Register Link -->
            <div class="register-link">
                Don't have an account? 
                <a href="${pageContext.request.contextPath}/register">Register here</a>
            </div>
            
            <!-- Admin Login Link -->
            <div class="admin-link">
                <a href="${pageContext.request.contextPath}/admin/login">Admin Login →</a>
            </div>
        </div>
    </div>

</body>
</html>