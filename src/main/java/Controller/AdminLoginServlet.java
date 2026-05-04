package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import models.Admin;
import services.AdminService;
import utils.SessionUtil;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminService adminService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        adminService = new AdminService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // If already logged in as admin, redirect to dashboard
        if (session != null && session.getAttribute("admin_id") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-login.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validation
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username is required");
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-login.jsp")
                   .forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required");
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Authenticate admin
        Admin admin = adminService.authenticate(username, password);
        
        if (admin == null) {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-login.jsp")
                   .forward(request, response);
            return;
        }
        // Create session
        HttpSession session = request.getSession();
        SessionUtil.createAdminSession(session, admin);
        
        // Update last login
        adminService.updateLastLogin(admin.getId());
        
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}