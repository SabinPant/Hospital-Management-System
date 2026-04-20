package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import models.User;
import services.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/register")
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 2,
	    maxFileSize = 1024 * 1024 * 5,
	    maxRequestSize = 1024 * 1024 * 10
	)

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
        String gender = request.getParameter("gender");  
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
        User user = userService.registerUser(username, email, password, fullName, gender, phone, address, userType);
        
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
            
            // Handle profile image upload for patient
            Part profileImagePart = request.getPart("profileImage");
            String appPath = getServletContext().getRealPath("");
            String profileImagePath = null;
            
            if (profileImagePart != null && profileImagePart.getSize() > 0) {
                if (utils.FileUploadUtil.isValidImage(profileImagePart)) {
                    try {
                        profileImagePath = utils.FileUploadUtil.saveFile(profileImagePart, "profile_" + user.getId(), appPath);
                        userService.updateProfileImage(user.getId(), profileImagePath);
                    } catch (IOException e) {
                        System.err.println("Error saving profile image: " + e.getMessage());
                    }
                }
            }
            
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
            
            // Get the file part for license image
            Part licenseImagePart = request.getPart("licenseImage");
            String appPath = getServletContext().getRealPath("");
            
            // Validate image first
            if (licenseImagePart == null || licenseImagePart.getSize() == 0) {
                request.setAttribute("error", "License document is required");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            if (!utils.FileUploadUtil.isValidImage(licenseImagePart)) {
                request.setAttribute("error", "Invalid file type! Please upload an image (JPG, PNG, GIF only, Max 5MB)");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            boolean profileSaved = userService.registerDoctorProfile(user.getId(), specialization, otherSpecialization,
                                                                      qualification, licenseNumber,
                                                                      Integer.parseInt(experienceYears),
                                                                      Double.parseDouble(consultationFee), bio, licenseImagePart, appPath);
            
            if (!profileSaved) {
                System.out.println("Warning: Doctor profile not saved but user was created");
            }
            
            request.setAttribute("success", "Registration submitted! Your application is pending admin approval.");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
}