package services;

import dao.UserDAO;

import java.io.IOException;
import java.sql.Date;

import dao.PatientDAO;
import models.User;
import models.DoctorProfile;
import models.PatientProfile;
import utils.FileUploadUtil;
import utils.PasswordUtil;
import jakarta.servlet.http.HttpSession;
import dao.DoctorDAO;
import dao.NotificationDAO;
import jakarta.servlet.http.Part;

public class UserService {
    private UserDAO userDAO;
    private PatientDAO patientDAO;
    private DoctorDAO doctorDAO;
    private NotificationDAO notificationDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
        this.patientDAO = new PatientDAO();
        this.doctorDAO = new DoctorDAO();
        this.notificationDAO = new NotificationDAO();

    }
    
 // Business logic: Validate registration input
    public String validateRegistration(String username, String email, String password, String confirmPassword, 
                                       String fullName, String phone, String userType) {
        if (username == null || username.trim().isEmpty()) {
            return "Username is required";
        }
        if (email == null || email.trim().isEmpty()) {
            return "Email is required";
        }
        if (password == null || password.trim().isEmpty()) {
            return "Password is required";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match";
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required";
        }
        if (phone == null || phone.trim().isEmpty()) {
            return "Phone number is required";
        }
        return null; // No error
    }

    // Business logic: Check if username or email exists
    public boolean isUsernameExists(String username) {
        return userDAO.isUsernameExists(username);
    }

    public boolean isEmailExists(String email) {
        return userDAO.isEmailExists(email);
    }

    // Business logic: Register new user
    public User registerUser(String username, String email, String password, String fullName, 
            String gender, String phone, String address, String userType) {
        String hashedPassword = PasswordUtil.hashPassword(password);
        String generatedUserId = userDAO.generateUserId(userType);
        
        User user = new User(username, email, hashedPassword, fullName, userType);
        user.setUserId(generatedUserId);
        user.setPhone(phone);
        user.setAddress(address);
        user.setGender(gender);  
        user.setStatus("active"); // Both patient and doctor start as active (doctor approval is separate)
        
        boolean saved = userDAO.saveUser(user);
        
        if (saved) {
            return user;
        }
        return null;
    }

    // Business logic: Register patient profile
    public boolean registerPatientProfile(int userId, String dob, String bloodGroup, 
                                          String emergencyContact, String medicalHistory, String allergies) {
        PatientProfile profile = new PatientProfile(userId);
        
        if (dob != null && !dob.isEmpty()) {
            try {
                profile.setDateOfBirth(Date.valueOf(dob));
            } catch (Exception e) {
                // Invalid date, ignore
            }
        }
        
        profile.setBloodGroup(bloodGroup);
        profile.setEmergencyContact(emergencyContact);
        profile.setMedicalHistory(medicalHistory);
        profile.setAllergies(allergies);
        
        return patientDAO.savePatientProfile(profile);
    }

 ///  logic: Register doctor profile
    public boolean registerDoctorProfile(int userId, String specialization, String otherSpecialization,
            String qualification, String licenseNumber, 
            int experienceYears, double consultationFee, String bio, Part licenseImagePart, String appPath) {
// Handle "Other" specialization
if ("Other".equals(specialization) && otherSpecialization != null && !otherSpecialization.isEmpty()) {
specialization = otherSpecialization;
}

// Handle license image upload with validation
String licenseImagePath = null;
if (licenseImagePart != null && licenseImagePart.getSize() > 0) {
if (FileUploadUtil.isValidImage(licenseImagePart)) {
try {
licenseImagePath = FileUploadUtil.saveFile(licenseImagePart, "license_" + userId, appPath);
System.out.println("License image saved: " + licenseImagePath);
} catch (IOException e) {
System.err.println("Error saving license image: " + e.getMessage());
}
} else {
System.err.println("Invalid license image file - rejected");
}
}

DoctorProfile profile = new DoctorProfile(userId, specialization, qualification, 
                     licenseNumber, experienceYears, consultationFee);
profile.setBio(bio);
profile.setApprovalStatus("pending");
profile.setLicenseImage(licenseImagePath);

return doctorDAO.saveDoctorProfile(profile);
}
    
    
    public User authenticate(String email, String password) {
        User user = userDAO.getUserByEmail(email);
        
        if (user == null) {
            return null;
        }
        
        // Verify password first
        boolean passwordValid = PasswordUtil.verifyPassword(password, user.getPassword());
        
        if (!passwordValid) {
            return null; // Wrong password — don't reveal account status
        }
        
        // Password is correct — return user so servlet can check status
        return user;
    }
    
    // Business logic: Check doctor approval status
    public String checkDoctorApproval(int userId) {
        String approvalStatus = userDAO.getDoctorApprovalStatus(userId);
        
        if (approvalStatus == null) {
            return "not_found";
        }
        
        return approvalStatus;
    }
    
    // Business logic: Get doctor rejection reason
    public String getDoctorRejectionReason(int userId) {
        return userDAO.getDoctorRejectionReason(userId);
    }
    
    // Business logic: Set patient blood group in session
    public void setPatientBloodGroup(HttpSession session, int userId) {
        PatientProfile profile = patientDAO.getPatientProfileByUserId(userId);
        if (profile != null && profile.getBloodGroup() != null) {
            session.setAttribute("blood_group", profile.getBloodGroup());
        } else {
            session.setAttribute("blood_group", "Not specified");
        }
    }
    
    // Business logic: Get user by email
    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }
    
 // Business logic: Lock user account
    public boolean lockUser(int userId, String reason, int adminId) {
        if (reason == null || reason.isEmpty()) {
            reason = "Violation of hospital policies";
        }
        
        boolean locked = userDAO.lockUser(userId, reason);
        
        if (locked) {
            // Send notification to user
            notificationDAO.addNotification(userId, "Account Locked", 
                "Your account has been locked by admin. Reason: " + reason + ". Please contact support.", "warning");
        }
        
        return locked;
    }
    
 // Business logic: Update user profile image
    public String updateProfileImage(int userId, Part filePart, String appPath) {
        if (!FileUploadUtil.isValidImage(filePart)) {
            return null;
        }
        
        try {
            String imagePath = FileUploadUtil.saveFile(filePart, "profile_" + userId, appPath);
            userDAO.updateProfileImage(userId, imagePath);
            return imagePath;
        } catch (IOException e) {
            System.err.println("Error saving profile image: " + e.getMessage());
            return null;
        }
    }
    
 // Update profile image by path (for registration)
    public void updateProfileImage(int userId, String imagePath) {
        userDAO.updateProfileImage(userId, imagePath);
    }

    // Business logic: Update doctor license image
    public String updateLicenseImage(int userId, Part filePart, String appPath) {
        if (!FileUploadUtil.isValidImage(filePart)) {
            return null;
        }
        
        try {
            String imagePath = FileUploadUtil.saveFile(filePart, "license_" + userId, appPath);
            doctorDAO.updateLicenseImage(userId, imagePath);
            return imagePath;
        } catch (IOException e) {
            System.err.println("Error saving license image: " + e.getMessage());
            return null;
        }
    }

    // Business logic: Unlock user account
    public boolean unlockUser(int userId, int adminId) {
        boolean unlocked = userDAO.unlockUser(userId);
        
        if (unlocked) {
            // Send notification to user
            notificationDAO.addNotification(userId, "Account Unlocked", 
                "Your account has been unlocked. You can now login again.", "success");
        }
        
        return unlocked;
    }
    
 // Handle image upload (profile or license)
    public String handleImageUpload(int userId, String userType, String imageType, Part filePart, String appPath) {
        if (!FileUploadUtil.isValidImage(filePart)) {
            return null;
        }
        
        try {
            if ("profile".equals(imageType)) {
                String imagePath = FileUploadUtil.saveFile(filePart, "profile_" + userId, appPath);
                userDAO.updateProfileImage(userId, imagePath);
                return imagePath;
            } else if ("license".equals(imageType) && "doctor".equals(userType)) {
                String imagePath = FileUploadUtil.saveFile(filePart, "license_" + userId, appPath);
                doctorDAO.updateLicenseImage(userId, imagePath);
                return imagePath;
            }
        } catch (IOException e) {
            System.err.println("Error saving file: " + e.getMessage());
        }
        
        return null;
    }
    
 // Business logic: Get user by ID with full details
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    // Business logic: Get patient profile for session
    public PatientProfile getPatientProfile(int userId) {
        return patientDAO.getPatientProfileByUserId(userId);
    }

    // Business logic: Get profile image for session
    public String getProfileImage(int userId) {
        return userDAO.getProfileImage(userId);
    }
    
}