<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <style>
        .admin-login-container {
            max-width: 450px;
            margin: 80px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .admin-login-header {
            background: linear-gradient(135deg, #1e293b, #0f172a);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .admin-login-header h1 {
            color: white;
            margin-bottom: 10px;
        }
        
        .admin-login-header i {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        .admin-login-body {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #334155;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #1e293b;
            box-shadow: 0 0 0 3px rgba(30, 41, 59, 0.1);
        }
        
        .btn-admin-login {
            width: 100%;
            background: #1e293b;
            color: white;
            padding: 14px;
            border: none;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-admin-login:hover {
            background: #0f172a;
            transform: translateY(-2px);
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #64748b;
            text-decoration: none;
            font-size: 0.85rem;
        }
        
        .back-link a:hover {
            color: #1e293b;
        }
    </style>
</head>
<body>

    <div class="admin-login-container">
        <div class="admin-login-header">
            <i class="fas fa-shield-alt"></i>
            <h1>Admin Portal</h1>
            <p>MediLife Hospital Management System</p>
        </div>
        
        <div class="admin-login-body">
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/login" method="post">
                <div class="form-group">
                    <label><i class="fas fa-user"></i> Username</label>
                    <input type="text" name="username" placeholder="Enter admin username" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-lock"></i> Password</label>
                    <input type="password" name="password" placeholder="Enter admin password" required>
                </div>
                
                <button type="submit" class="btn-admin-login">
                    <i class="fas fa-sign-in-alt"></i> Login as Admin
                </button>
            </form>
            
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/login">← Back to User Login</a>
            </div>
        </div>
    </div>

</body>
</html>