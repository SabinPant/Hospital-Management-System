package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.AdminDashboardDAO;
import models.AdminDashboardData;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminDashboardDAO dashboardDAO;
    
    @Override
    public void init() throws ServletException {
        dashboardDAO = new AdminDashboardDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        // Fetch real data from database
        AdminDashboardData dashboardData = dashboardDAO.getDashboardData();
        request.setAttribute("dashboardData", dashboardData);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-dashboard.jsp")
               .forward(request, response);
    }
}