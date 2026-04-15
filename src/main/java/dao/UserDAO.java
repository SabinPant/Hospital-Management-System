package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import models.User;
import utils.DBConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
    
 // Get user by ID
    public User getUserById(int userId) {
        String query = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                // Set other fields as needed
                return user;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
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
    
    
 // Get all users with optional filter and search
    public List<Map<String, Object>> getAllUsers(String filter, String search) {
        List<Map<String, Object>> users = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT u.id, u.user_id, u.username, u.email, u.full_name, u.phone, u.user_type, u.status, " +
            "dp.specialization, dp.consultation_fee, " +
            "pp.blood_group " +
            "FROM users u " +
            "LEFT JOIN doctor_profiles dp ON u.id = dp.user_id " +
            "LEFT JOIN patient_profiles pp ON u.id = pp.user_id " +
            "WHERE 1=1"
        );
        
        if ("doctor".equals(filter)) {
            query.append(" AND u.user_type = 'doctor'");
        } else if ("patient".equals(filter)) {
            query.append(" AND u.user_type = 'patient'");
        }
        
        if (search != null && !search.trim().isEmpty()) {
            query.append(" AND (u.full_name LIKE ? OR u.email LIKE ? OR u.username LIKE ? OR u.user_id LIKE ?)");
        }
        
        query.append(" ORDER BY u.created_at DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getInt("id"));
                user.put("user_id", rs.getString("user_id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("full_name", rs.getString("full_name"));
                user.put("phone", rs.getString("phone"));
                user.put("user_type", rs.getString("user_type"));
                user.put("status", rs.getString("status"));
                user.put("specialization", rs.getString("specialization"));
                user.put("consultation_fee", rs.getDouble("consultation_fee"));
                user.put("blood_group", rs.getString("blood_group"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
 // Lock user account
    public boolean lockUser(int userId, String reason) {
        String query = "UPDATE users SET status = 'locked', lock_reason = ?, locked_at = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, reason);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(3, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error locking user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Unlock user account
    public boolean unlockUser(int userId) {
        String query = "UPDATE users SET status = 'active', lock_reason = NULL, locked_at = NULL WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error unlocking user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
 // Get user by email (for login)
    public User getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, email);
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
            System.err.println("Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
}