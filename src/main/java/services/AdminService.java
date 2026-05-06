package services;

import dao.AdminDAO;
import models.Admin;
import utils.PasswordUtil;

public class AdminService {
    private AdminDAO adminDAO;
    
    public AdminService() {
        this.adminDAO = new AdminDAO();
    }
    
    // Business logic: Authenticate admin
    public Admin authenticate(String username, String password) {
        Admin admin = adminDAO.getAdminByUsername(username);
        
        if (admin == null) {
            return null;
        }
        
        // Check if admin account is active
        if ("inactive".equals(admin.getStatus())) {
            return null;
        }
        
     // Verify password
        if (!PasswordUtil.verifyPassword(password, admin.getPassword())) {
            return null;
        }
        
        return admin;
    }
    
    // Business logic: Update last login
    public void updateLastLogin(int adminId) {
        adminDAO.updateLastLogin(adminId);
    }
}