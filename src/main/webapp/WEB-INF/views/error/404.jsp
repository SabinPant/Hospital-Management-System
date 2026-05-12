<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Not Found | MediLife</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #f8fafc;
            display: flex; align-items: center; justify-content: center;
            min-height: 100vh; text-align: center; padding: 20px;
        }
        .err-card {
            background: #fff; border-radius: 24px; padding: 48px 40px;
            max-width: 500px; width: 100%;
            box-shadow: 0 4px 24px rgba(0,0,0,0.06);
        }
        .err-code {
            font-size: 6rem; font-weight: 800; color: #0a5c8e;
            line-height: 1; margin-bottom: 8px;
        }
        .err-icon { font-size: 3rem; color: #94a3b8; margin-bottom: 20px; }
        .err-title { font-size: 1.3rem; font-weight: 700; color: #0f172a; margin-bottom: 12px; }
        .err-msg { font-size: 0.9rem; color: #64748b; line-height: 1.6; margin-bottom: 28px; }
        .err-btn {
            display: inline-flex; align-items: center; gap: 8px;
            background: #0a5c8e; color: #fff; padding: 12px 24px;
            border-radius: 12px; text-decoration: none; font-weight: 700;
            font-size: 0.9rem; transition: all 0.2s;
        }
        .err-btn:hover { background: #074268; transform: translateY(-1px); }
    </style>
</head>
<body>
    <div class="err-card">
        <div class="err-code">404</div>
        <div class="err-icon"><i class="fas fa-map-signs"></i></div>
        <h1 class="err-title">Page Not Found</h1>
        <p class="err-msg">
            The page you're looking for doesn't exist or has been moved.
            Let's get you back on track.
        </p>
        <a href="${pageContext.request.contextPath}/" class="err-btn">
            <i class="fas fa-home"></i> Back to Home
        </a>
    </div>
</body>
</html>