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

    <!-- Internal CSS Styling for Login Page -->
    <style>
        /* Main container for login box */
        .login-container {
            max-width: 500px;
            margin: 80px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        /* Header section */
        .login-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .login-header h1 {
            color: white;
            margin-bottom: 10px;
        }
        
        /* Body section */
        .login-body {
            padding: 40px;
        }
        
        /* Form input group */
        .form-group {
            margin-bottom: 25px;
        }
        
        /* Labels */
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--gray-dark);
        }
        
        /* Input fields */
        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
        }
        
        /* Input focus effect */
        .form-group input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(10, 92, 142, 0.1);
        }
        
        /* Login button */
        .btn-login-submit {
            width: 100%;
            background: var(--primary-blue);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        /* Button hover effect */
        .btn-login-submit:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }
        
        /* Alert message box */
        .alert {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        /* Error alert */
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }
        
        /* Register section */
        .register-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }
        
        /* Register link */
        .register-link a {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
        }
        
        /* Admin login section */
        .admin-link {
            text-align: center;
            margin-top: 15px;
            font-size: 0.85rem;
        }
        
        .admin-link a {
            color: var(--gray);
            text-decoration: none;
        }A
        
        /* Admin link hover */
        .admin-link a:hover {
            color: var(--primary-blue);
        }
    </style>
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