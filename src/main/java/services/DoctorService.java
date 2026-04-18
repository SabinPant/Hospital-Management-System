package services;

import java.io.IOException;

import dao.UserDAO;
import dao.DoctorDAO;
import dao.NotificationDAO;
import models.User;
import models.DoctorProfile;
import utils.PasswordUtil;
import utils.FileUploadUtil;
import jakarta.servlet.http.Part;

public class DoctorService {
    private DoctorDAO doctorDAO;
    private UserDAO userDAO;
    private NotificationDAO notificationDAO;
    
    public DoctorService() {
        this.doctorDAO = new DoctorDAO();
        this.userDAO = new UserDAO();
        this.notificationDAO = new NotificationDAO();
    }
    
    // Business logic: Approve doctor
    public boolean approveDoctor(int doctorId, int adminId) {
        boolean updated = doctorDAO.approveDoctor(doctorId, adminId);
        
        if (updated) {
            // Get doctor name for notification
            String doctorName = userDAO.getUserById(doctorId).getFullName();
            
            // Send notification to doctor
            notificationDAO.addNotification(doctorId, "Account Approved", 
                "Your doctor account has been approved. You can now login to the system.", "success");
        }
        
        return updated;
    }
    
    // Business logic: Reject doctor
    public boolean rejectDoctor(int doctorId, int adminId, String rejectionReason) {
        if (rejectionReason == null || rejectionReason.isEmpty()) {
            rejectionReason = "Application does not meet our requirements";
        }
        
        boolean updated = doctorDAO.rejectDoctor(doctorId, adminId, rejectionReason);
        
        if (updated) {
            // Get doctor name for notification
            String doctorName = userDAO.getUserById(doctorId).getFullName();
            
            // Send notification to doctor
            notificationDAO.addNotification(doctorId, "Account Rejected", 
                "Your doctor application has been rejected. Reason: " + rejectionReason, "error");
        }
        
        return updated;
    }
    
 // Business logic: Create doctor by admin
    public boolean createDoctorByAdmin(String fullName, String gender, String phone, String email,
                                       String username, String password, String address,
                                       String specialization, String experienceYears, String qualification,
                                       String licenseNumber, String consultationFee, String bio,
                                       Part licenseImage, String appPath) {
        
        // Check if email or username already exists
        if (userDAO.isEmailExists(email)) {
            return false;
        }
        if (userDAO.isUsernameExists(username)) {
            return false;
        }
        
        // Hash password
        String hashedPassword = PasswordUtil.hashPassword(password);
        String generatedUserId = userDAO.generateUserId("doctor");
        
        // Create user
        User user = new User(username, email, hashedPassword, fullName, "doctor");
        user.setUserId(generatedUserId);
        user.setPhone(phone);
        user.setAddress(address);
        user.setGender(gender);
        user.setStatus("active");
        
        boolean userSaved = userDAO.saveUser(user);
        if (!userSaved) {
            return false;
        }
        
        // Handle license image upload
        String licenseImagePath = null;
        if (licenseImage != null && licenseImage.getSize() > 0) {
            if (FileUploadUtil.isValidImage(licenseImage)) {
                try {
                    licenseImagePath = FileUploadUtil.saveFile(licenseImage, "license_" + user.getId(), appPath);
                } catch (IOException e) {
                    System.err.println("Error saving license image: " + e.getMessage());
                }
            }
        }
        
        // Create doctor profile
        DoctorProfile profile = new DoctorProfile(
            user.getId(),
            specialization,
            qualification,
            licenseNumber,
            Integer.parseInt(experienceYears),
            Double.parseDouble(consultationFee)
        );
        profile.setBio(bio);
        profile.setApprovalStatus("approved"); // Admin-created doctors are auto-approved
        profile.setLicenseImage(licenseImagePath);
        
        return doctorDAO.saveDoctorProfile(profile);
    }
    
}