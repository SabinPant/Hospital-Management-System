package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check if user is a doctor
        String userType = (String) session.getAttribute("user_type");
        if (userType == null || !"doctor".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Forward to doctor dashboard JSP
        request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp")
               .forward(request, response);
    }
}