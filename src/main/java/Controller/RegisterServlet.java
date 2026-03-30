package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

import dao.UserDAO;
import dao.PatientDAO;
import dao.DoctorDAO;
import models.User;
import models.PatientProfile;
import models.DoctorProfile;
import utils.PasswordUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private PatientDAO patientDAO;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        patientDAO = new PatientDAO();
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n=== NEW REGISTRATION ATTEMPT ===");
        
        String userType = request.getParameter("userType");
        System.out.println("User Type: " + userType);
        
        // Get common fields
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        System.out.println("Username: " + username);
        System.out.println("Email: " + email);
        System.out.println("Phone: " + phone);
        
        // Validation
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username is required");
            forwardWithError(request, response);
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required");
            forwardWithError(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required");
            forwardWithError(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            forwardWithError(request, response);
            return;
        }
        
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required");
            forwardWithError(request, response);
            return;
        }
        
        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Phone number is required");
            forwardWithError(request, response);
            return;
        }
        
        // Check existing
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "Username already exists");
            forwardWithError(request, response);
            return;
        }
        
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email already registered");
            forwardWithError(request, response);
            return;
        }
        
        // Create user
        String hashedPassword = PasswordUtil.hashPassword(password);
        String generatedUserId = userDAO.generateUserId(userType);
        
        User user = new User(username, email, hashedPassword, fullName, userType);
        user.setUserId(generatedUserId);
        user.setPhone(phone);
        user.setAddress(address);
        
        if (userType.equals("patient")) {
            user.setStatus("active");
        } else {
            user.setStatus("active");
        }
        
        // Save user
        boolean userSaved = userDAO.saveUser(user);
        System.out.println("User saved: " + userSaved);
        
        if (!userSaved) {
            request.setAttribute("error", "Database error. Please try again.");
            forwardWithError(request, response);
            return;
        }
        
        // Handle patient or doctor
        if (userType.equals("patient")) {
            String dob = request.getParameter("dob");
            String bloodGroup = request.getParameter("bloodGroup");
            String emergencyContact = request.getParameter("emergencyContact");
            String medicalHistory = request.getParameter("medicalHistory");
            String allergies = request.getParameter("allergies");
            
            PatientProfile profile = new PatientProfile(user.getId());
            
            if (dob != null && !dob.isEmpty()) {
                try {
                    profile.setDateOfBirth(Date.valueOf(dob));
                } catch (Exception e) {
                    System.out.println("Invalid date: " + dob);
                }
            }
            
            profile.setBloodGroup(bloodGroup);
            profile.setEmergencyContact(emergencyContact);
            profile.setMedicalHistory(medicalHistory);
            profile.setAllergies(allergies);
            
            boolean profileSaved = patientDAO.savePatientProfile(profile);
            System.out.println("Patient profile saved: " + profileSaved);
            
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
            
            // Handle "Other" specialization
            if ("Other".equals(specialization) && otherSpecialization != null && !otherSpecialization.isEmpty()) {
                specialization = otherSpecialization;
            }
            
            DoctorProfile profile = new DoctorProfile(
                user.getId(),
                specialization,
                qualification,
                licenseNumber,
                Integer.parseInt(experienceYears),
                Double.parseDouble(consultationFee)
            );
            profile.setBio(bio);
            profile.setApprovalStatus("pending");
            
            boolean profileSaved = doctorDAO.saveDoctorProfile(profile);
            System.out.println("Doctor profile saved: " + profileSaved);
            
            if (!profileSaved) {
                System.out.println("Warning: Doctor profile not saved but user was created");
            }
            
            request.setAttribute("success", "Registration submitted! Your application is pending admin approval.");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
    
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
}