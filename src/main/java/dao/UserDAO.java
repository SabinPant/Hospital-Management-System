package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import models.User;
import utils.DBConnection;

public class UserDAO {
    
    // Check if username exists
    public boolean isUsernameExists(String username) {
        String query = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if email exists
    public boolean isEmailExists(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
 // Generate user ID 
    public String generateUserId(String userType) {
        String prefix = userType.equals("patient") ? "PAT" : "DOC";
        
        // Query to get the highest existing number
        String query = "SELECT user_id FROM users WHERE user_id LIKE ? ORDER BY user_id DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, prefix + "%");
            ResultSet rs = pstmt.executeQuery();
            
            int maxNumber = 0;
            if (rs.next()) {
                String lastUserId = rs.getString("user_id");
                // Extract the number part (e.g., from "PAT-003" get 3)
                String numberPart = lastUserId.substring(prefix.length() + 1); // +1 for the hyphen
                try {
                    maxNumber = Integer.parseInt(numberPart);
                } catch (NumberFormatException e) {
                    maxNumber = 0;
                }
            }
            
            // Generate next number
            int nextNumber = maxNumber + 1;
            String nextUserId = String.format("%s-%03d", prefix, nextNumber);
            System.out.println("Generated new user_id: " + nextUserId);
            return nextUserId;
            
        } catch (SQLException e) {
            System.err.println("Error generating user_id: " + e.getMessage());
            e.printStackTrace();
            // Fallback: use timestamp
            return prefix + "-" + System.currentTimeMillis();
        }
    }
    
    // Save user to database
 // Save user to database
    public boolean saveUser(User user) {
        String query = "INSERT INTO users (user_id, username, email, password, full_name, phone, address, user_type, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("ERROR: Connection is null!");
                return false;
            }
            
            pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getUsername());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPassword());
            pstmt.setString(5, user.getFullName());
            pstmt.setString(6, user.getPhone());
            pstmt.setString(7, user.getAddress());
            pstmt.setString(8, user.getUserType());
            pstmt.setString(9, user.getStatus());
            
            System.out.println("=== Inserting User ===");
            System.out.println("user_id: " + user.getUserId());
            System.out.println("username: " + user.getUsername());
            System.out.println("email: " + user.getEmail());
            System.out.println("full_name: " + user.getFullName());
            System.out.println("phone: " + user.getPhone());
            System.out.println("user_type: " + user.getUserType());
            System.out.println("status: " + user.getStatus());
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                        System.out.println("Generated ID: " + user.getId());
                    }
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("=== SQL ERROR ===");
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    public String getDoctorApprovalStatus(int userId) {
        String query = "SELECT approval_status FROM doctor_profiles WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("approval_status");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null; // Not a doctor or no profile
    }
    
 // Get doctor rejection reason
    public String getDoctorRejectionReason(int userId) {
        String query = "SELECT rejection_reason FROM doctor_profiles WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("rejection_reason");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    
    // Get user by username (for login)
    public User getUserByUsername(String username) {
        String query = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUserId(rs.getString("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setUserType(rs.getString("user_type"));
                user.setStatus(rs.getString("status"));
                user.setLockReason(rs.getString("lock_reason"));
                user.setLockedAt(rs.getTimestamp("locked_at"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
                return user;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}