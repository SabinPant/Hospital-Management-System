<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <!-- JSTL core tag library -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"> <!-- Character encoding -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Responsive design -->
    
    <title>Contact Us | MediLife Hospital</title> <!-- Page title -->

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- External CSS files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/contact.css">
</head>

<body>

    <!-- Include header JSP file -->
    <jsp:include page="../../components/header.jsp" />

    <!-- Page Banner Section -->
    <section class="page-banner">
        <div class="container">
            <!-- Title with icon -->
            <h1><i class="fas fa-envelope-open-text"></i> Contact <span class="highlight">Us</span></h1>
            <p>We're here to help and answer any questions you might have.</p>
        </div>
    </section>

    <!-- Main Contact Section -->
    <section class="contact-section">
        <div class="container">
            <div class="contact-grid">

                <!-- LEFT SIDE: Contact Information -->
                <div class="contact-info">

                    <!-- Location Info -->
                    <div class="info-card">
                        <i class="fas fa-map-marker-alt"></i>
                        <h3>Our Location</h3>
                        <p>Kathmandu Metropolitan City</p>
                        <p>Bagmati Province, Nepal</p>
                        <p>Near Civil Mall, New Baneshwor</p>
                    </div>

                    <!-- Phone Info -->
                    <div class="info-card">
                        <i class="fas fa-phone-alt"></i>
                        <h3>Phone & Helpline</h3>
                        <p><strong>Emergency:</strong> +977 1-1234567890</p>
                        <p><strong>Ambulance:</strong> 102</p>
                    </div>

                    <!-- Email Info -->
                    <div class="info-card">
                        <i class="fas fa-envelope"></i>
                        <h3>Email Us</h3>
                        <p>info@medilife.com.np</p>
                    </div>

                    <!-- Working Hours -->
                    <div class="info-card">
                        <i class="fas fa-clock"></i>
                        <h3>Working Hours</h3>
                        <p>Emergency: 24/7</p>
                        <p>OPD: Mon-Sat: 8AM-8PM</p>
                    </div>
                </div>

                <!-- RIGHT SIDE: Contact Form -->
                <div class="contact-form-container">

                    <!-- Form Title -->
                    <h2>
                        <i class="fas fa-paper-plane"></i> 
                        Send us a <span class="highlight">Message</span>
                    </h2>
                    
                    <!-- Show success message if available -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            ${success}
                        </div>
                    </c:if>
                    
                    <!-- Show error message if available -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>
                    
                    <!-- Contact Form -->
                    <form action="${pageContext.request.contextPath}/contact" method="post">

                        <!-- Full Name -->
                        <div class="form-group">
                            <label>Full Name *</label>
                            <input type="text" name="name" required>
                        </div>

                        <!-- Email -->
                        <div class="form-group">
                            <label>Email *</label>
                            <input type="email" name="email" required>
                        </div>

                        <!-- Phone -->
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="tel" name="phone">
                        </div>

                        <!-- Subject -->
                        <div class="form-group">
                            <label>Subject *</label>
                            <input type="text" name="subject" required>
                        </div>

                        <!-- Message -->
                        <div class="form-group">
                            <label>Message *</label>
                            <textarea name="message" rows="5" required></textarea>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn-submit">Send Message</button>
                    </form>
                </div>

            </div>
        </div>
    </section>

    <!-- Include footer JSP file -->
    <jsp:include page="../../components/footer.jsp" />

</body>
</html>