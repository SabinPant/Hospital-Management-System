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
                    
                    <!-- Success/Error Messages will be shown via URL parameters -->
                    <%
                        String status = request.getParameter("status");
                        if ("success".equals(status)) {
                    %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            Thank you! Your message has been sent. We'll get back to you within 24 hours.
                        </div>
                    <%
                        } else if ("error".equals(status)) {
                    %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            Unable to send message. Please try again or call us directly.
                        </div>
                    <%
                        }
                    %>
                    
                    <!-- Direct form submission to Web3Forms -->
                    <form action="https://api.web3forms.com/submit" method="POST" onsubmit="return validateForm(this)">
                        <input type="hidden" name="access_key" value="5376f545-c67e-4cac-8c11-8414d72ba17b">
                        <input type="hidden" name="subject" value="MediLife Hospital Contact Form">
                        <input type="hidden" name="redirect" value="<%= request.getContextPath() %>/contact?status=success">
                        
                        <div class="form-group">
                            <label>Full Name *</label>
                            <input type="text" name="name" id="name" required>
                        </div>
                        <div class="form-group">
                            <label>Email *</label>
                            <input type="email" name="email" id="email" required>
                        </div>
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="tel" name="phone" id="phone">
                        </div>
                        <div class="form-group">
                            <label>Subject *</label>
                            <input type="text" name="subject" id="subject" required>
                        </div>
                        <div class="form-group">
                            <label>Message *</label>
                            <textarea name="message" id="message" rows="5" required></textarea>
                        </div>
                        <button type="submit" class="btn-submit">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="../../components/footer.jsp" />

    <script>
        function validateForm(form) {
            // Basic validation before submission
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const subject = document.getElementById('subject').value.trim();
            const message = document.getElementById('message').value.trim();
            
            if (name === '') {
                alert('Please enter your full name');
                return false;
            }
            if (email === '') {
                alert('Please enter your email address');
                return false;
            }
            if (subject === '') {
                alert('Please enter a subject');
                return false;
            }
            if (message === '') {
                alert('Please enter your message');
                return false;
            }
            return true;
        }
    </script>

</body>
</html>