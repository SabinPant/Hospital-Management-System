package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import models.User;
import services.UserService;
import jakarta.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
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
        
        // If already logged in, redirect to dashboard
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
        
        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userType = request.getParameter("userType");
        
        // Get common fields
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Validate input
        String validationError = userService.validateRegistration(username, email, password, confirmPassword, 
                                                                   fullName, phone, userType);
        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Check existing
        if (userService.isUsernameExists(username)) {
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        if (userService.isEmailExists(email)) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Register user
        User user = userService.registerUser(username, email, password, fullName, phone, address, userType);
        
        if (user == null) {
            request.setAttribute("error", "Database error. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Handle patient or doctor profile
        if (userType.equals("patient")) {
            String dob = request.getParameter("dob");
            String bloodGroup = request.getParameter("bloodGroup");
            String emergencyContact = request.getParameter("emergencyContact");
            String medicalHistory = request.getParameter("medicalHistory");
            String allergies = request.getParameter("allergies");
            
            boolean profileSaved = userService.registerPatientProfile(user.getId(), dob, bloodGroup, 
                                                                       emergencyContact, medicalHistory, allergies);
            
            if (!profileSaved) {
                System.out.println("Warning: Patient profile not saved but user was created");
            }
            
            request.setAttribute("success", "Registration successful! You can now login.");
            
        } else if (userType.equals("doctor")) {
            String specialization = request.getParameter("specialization");
            String otherSpecialization = request.getParameter("otherSpecialization");
            String qualification = request.getParameter("qualification");
            String licenseNumber = request.getParameter("licenseNumber");
            String experienceYears = request.getParameter("experienceYears");
            String consultationFee = request.getParameter("consultationFee");
            String bio = request.getParameter("bio");
            
            boolean profileSaved = userService.registerDoctorProfile(user.getId(), specialization, otherSpecialization,
                                                                      qualification, licenseNumber,
                                                                      Integer.parseInt(experienceYears),
                                                                      Double.parseDouble(consultationFee), bio);
            
            if (!profileSaved) {
                System.out.println("Warning: Doctor profile not saved but user was created");
            }
            
            request.setAttribute("success", "Registration submitted! Your application is pending admin approval.");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
}