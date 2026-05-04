package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import models.User;
import models.PatientProfile;
import services.UserService;
import utils.SessionUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // If already logged in, redirect to appropriate dashboard
        if (session != null && session.getAttribute("user_id") != null) {
            String userType = (String) session.getAttribute("user_type");
            if ("patient".equals(userType)) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            } else if ("doctor".equals(userType)) {
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
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
        
        // call the service package for business logic
        User user = userService.authenticate(email, password);
        
        if (user == null) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }
        
        // Check if account is locked (additional check from service)
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
        
        // Doctor approval check
        if ("doctor".equals(user.getUserType())) {
            String approvalStatus = userService.checkDoctorApproval(user.getId());
            
            if ("not_found".equals(approvalStatus)) {
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
                String rejectionReason = userService.getDoctorRejectionReason(user.getId());
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
        
        // ========== CREATE SESSION ==========
        HttpSession session = request.getSession();
        
        // Load optional session data
        String profileImage = userService.getProfileImage(user.getId());
        String bloodGroup = null;
        
        if ("patient".equals(user.getUserType())) {
            PatientProfile profile = userService.getPatientProfile(user.getId());
            if (profile != null && profile.getBloodGroup() != null) {
                bloodGroup = profile.getBloodGroup();
            } else {
                bloodGroup = "Not specified";
            }
        }
        
        SessionUtil.createUserSession(session, user, profileImage, bloodGroup);
        
        // Redirect based on user type
        if (SessionUtil.isPatient(session)) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        } else if (SessionUtil.isDoctor(session)) {
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}