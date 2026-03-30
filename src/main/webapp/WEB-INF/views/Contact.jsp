<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | MediLife Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/contact.css">
</head>
<body>

    <!-- Include Header - need to go up 3 levels from WEB-INF/views/ to webapp/ -->
    <jsp:include page="../../components/header.jsp" />

    <!-- Page Banner -->
    <section class="page-banner">
        <div class="container">
            <h1><i class="fas fa-envelope-open-text"></i> Contact <span class="highlight">Us</span></h1>
            <p>We're here to help and answer any questions you might have.</p>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="contact-section">
        <div class="container">
            <div class="contact-grid">
                <!-- Left side - Contact Info -->
                <div class="contact-info">
                    <div class="info-card">
                        <i class="fas fa-map-marker-alt"></i>
                        <h3>Our Location</h3>
                        <p>Kathmandu Metropolitan City</p>
                        <p>Bagmati Province, Nepal</p>
                        <p>Near Civil Mall, New Baneshwor</p>
                    </div>
                    <div class="info-card">
                        <i class="fas fa-phone-alt"></i>
                        <h3>Phone & Helpline</h3>
                        <p><strong>Emergency:</strong> +977 1-1234567890</p>
                        <p><strong>Ambulance:</strong> 102</p>
                    </div>
                    <div class="info-card">
                        <i class="fas fa-envelope"></i>
                        <h3>Email Us</h3>
                        <p>info@medilife.com.np</p>
                    </div>
                    <div class="info-card">
                        <i class="fas fa-clock"></i>
                        <h3>Working Hours</h3>
                        <p>Emergency: 24/7</p>
                        <p>OPD: Mon-Sat: 8AM-8PM</p>
                    </div>
                </div>

                <!-- Right side - Contact Form -->
                <div class="contact-form-container">
                    <h2><i class="fas fa-paper-plane"></i> Send us a <span class="highlight">Message</span></h2>
                    
                    <%-- Show success message --%>
                    <%
                        String success = request.getParameter("success");
                        if (success != null && success.equals("1")) {
                    %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            Thank you! We'll get back to you within 24 hours.
                        </div>
                    <%
                        }
                    %>
                    
                    <form action="${pageContext.request.contextPath}/contact" method="post">
                        <div class="form-group">
                            <label>Full Name *</label>
                            <input type="text" name="name" required>
                        </div>
                        <div class="form-group">
                            <label>Email *</label>
                            <input type="email" name="email" required>
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="tel" name="phone">
                        </div>
                        <div class="form-group">
                            <label>Subject *</label>
                            <input type="text" name="subject" required>
                        </div>
                        <div class="form-group">
                            <label>Message *</label>
                            <textarea name="message" rows="5" required></textarea>
                        </div>
                        <button type="submit" class="btn-submit">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="../../components/footer.jsp" />

</body>
</html>