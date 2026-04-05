package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.UserDAO;
import models.User;
import utils.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Changed from username to email
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validation
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Get user by email (changed from username)
        User user = userDAO.getUserByEmail(email);
        
        if (user == null) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Check if account is locked
        if ("locked".equals(user.getStatus())) {
            String lockReason = user.getLockReason();
            String message = "Your account has been locked.";
            if (lockReason != null && !lockReason.isEmpty()) {
                message += " Reason: " + lockReason;
            }
            message += " Please contact admin for assistance.";
            request.setAttribute("error", message);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Check if account is inactive
        if ("inactive".equals(user.getStatus())) {
            request.setAttribute("error", "Your account is inactive. Please contact admin.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Verify password
        boolean passwordValid = PasswordUtil.verifyPassword(password, user.getPassword());
        
        if (!passwordValid) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Doctor approval check
        if ("doctor".equals(user.getUserType())) {
            String approvalStatus = userDAO.getDoctorApprovalStatus(user.getId());
            
            if (approvalStatus == null) {
                request.setAttribute("error", "Doctor profile not found. Please contact admin.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                       .forward(request, response);
                return;
            }
            
            if ("pending".equals(approvalStatus)) {
                request.setAttribute("error", "Your account is pending admin approval. Please wait for confirmation.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                       .forward(request, response);
                return;
            }
            
            if ("rejected".equals(approvalStatus)) {
                String rejectionReason = userDAO.getDoctorRejectionReason(user.getId());
                String message = "Your doctor application has been rejected.";
                if (rejectionReason != null && !rejectionReason.isEmpty()) {
                    message += " Reason: " + rejectionReason;
                }
                request.setAttribute("error", message);
                request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                       .forward(request, response);
                return;
            }
        }
        
        // Create session
        HttpSession session = request.getSession();
        session.setAttribute("user_id", user.getId());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("full_name", user.getFullName());
        session.setAttribute("user_type", user.getUserType());
        session.setAttribute("status", user.getStatus());
        
        System.out.println("User logged in: " + user.getEmail() + " (" + user.getUserType() + ")");
        
        // Redirect based on user type
        if ("patient".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        } else if ("doctor".equals(user.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}