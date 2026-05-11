<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Patients | Doctor Panel</title>
   <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/doctors/doctor_my_patients.css">
</head>
<body>

    <jsp:include page="../../../components/header.jsp" />

    <div class="patients-container">
        <div class="page-header">
            <h1><i class="fas fa-users"></i> My Patients</h1>
            <a href="${pageContext.request.contextPath}/doctor/dashboard" style="color: #64748b;">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        
        <div class="search-bar">
            <form method="get" action="${pageContext.request.contextPath}/doctor/patients">
                <input type="text" name="search" placeholder="Search by name, email or phone..." value="${search}">
                <button type="submit"><i class="fas fa-search"></i> Search</button>
                <c:if test="${not empty search}">
                    <a href="${pageContext.request.contextPath}/doctor/patients" style="padding: 10px 15px; background: #f1f5f9; color: #64748b; border-radius: 8px; text-decoration: none;">Clear</a>
                </c:if>
            </form>
        </div>
        
       <c:choose>
    <c:when test="${not empty patients}">
        <table class="patients-table">
            <thead>
                <tr>
                    <th>Patient ID</th>
                    <th>Name</th>
                    <th>Contact</th>
                    <th>Total Visits</th>
                    <th>Last Visit</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="patient" items="${patients}">
                    <tr>
                        <td>${patient.user_id}</td>
                        <td><strong>${patient.full_name}</strong></td>
                        <td>
                            <small>📧 ${patient.email}</small><br>
                            <small>📞 ${patient.phone != null ? patient.phone : 'Not provided'}</small>
                        </td>
                        <td><span class="visit-count"><i class="fas fa-calendar-check"></i> ${patient.total_visits} visits</span></td>
                        <td><fmt:formatDate value="${patient.last_visit}" pattern="MMM dd, yyyy"/></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/doctor/patient-details?id=${patient.id}&name=${patient.full_name}" class="btn-view">
                                <i class="fas fa-eye"></i> View History
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <div class="empty-state">
            <i class="fas fa-user-friends"></i>
            <p>No patients found.</p>
            <p style="font-size: 0.85rem;">When you complete appointments with patients, they will appear here.</p>
        </div>
    </c:otherwise>
</c:choose>
</div>

<jsp:include page="../../../components/footer.jsp" />

</body>
</html>