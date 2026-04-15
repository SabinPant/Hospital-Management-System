package services;

import dao.DoctorDAO;
import dao.UserDAO;
import dao.NotificationDAO;

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
}