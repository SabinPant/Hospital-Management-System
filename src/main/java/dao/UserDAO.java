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
        String query = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, username);
            return pstmt.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if email exists
    public boolean isEmailExists(String email) {
        String query = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, email);
            return pstmt.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get user by ID — BUG FIX: now maps all fields
    public User getUserById(int userId) {
        String query = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get user by email — BUG FIX: now maps all fields including profile_image
    public User getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
 // Get full user details for admin modal (patient or doctor)
    public Map<String, Object> getUserFullDetails(int userId) {
        Map<String, Object> user = new HashMap<>();
        String query = "SELECT u.*, " +
                       "dp.specialization, dp.qualification, dp.license_number, " +
                       "dp.experience_years, dp.consultation_fee, dp.bio, dp.approval_status, " +
                       "pp.date_of_birth, pp.blood_group, pp.emergency_contact, " +
                       "pp.medical_history, pp.allergies " +
                       "FROM users u " +
                       "LEFT JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "LEFT JOIN patient_profiles pp ON u.id = pp.user_id " +
                       "WHERE u.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user.put("id", rs.getInt("id"));
                user.put("user_id", rs.getString("user_id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("full_name", rs.getString("full_name"));
                user.put("gender", rs.getString("gender"));
                user.put("phone", rs.getString("phone"));
                user.put("address", rs.getString("address"));
                user.put("user_type", rs.getString("user_type"));
                user.put("status", rs.getString("status"));
                user.put("lock_reason", rs.getString("lock_reason"));
                user.put("locked_at", rs.getTimestamp("locked_at"));
                user.put("created_at", rs.getTimestamp("created_at"));
                // Doctor fields
                user.put("specialization", rs.getString("specialization"));
                user.put("qualification", rs.getString("qualification"));
                user.put("license_number", rs.getString("license_number"));
                user.put("experience_years", rs.getInt("experience_years"));
                user.put("consultation_fee", rs.getDouble("consultation_fee"));
                user.put("bio", rs.getString("bio"));
                user.put("approval_status", rs.getString("approval_status"));
                // Patient fields
                user.put("date_of_birth", rs.getDate("date_of_birth"));
                user.put("blood_group", rs.getString("blood_group"));
                user.put("emergency_contact", rs.getString("emergency_contact"));
                user.put("medical_history", rs.getString("medical_history"));
                user.put("allergies", rs.getString("allergies"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user full details: " + e.getMessage());
        }
        
        return user;
    }

    // Shared mapper — single place to update if columns change
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUserId(rs.getString("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setGender(rs.getString("gender"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setUserType(rs.getString("user_type"));
        user.setStatus(rs.getString("status"));
        user.setLockReason(rs.getString("lock_reason"));
        user.setProfileImage(rs.getString("profile_image")); // ← BUG FIX
        user.setLockedAt(rs.getTimestamp("locked_at"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }

    // Generate user ID
    public String generateUserId(String userType) {
        String prefix = userType.equals("patient") ? "PAT" : "DOC";
        String query = "SELECT user_id FROM users WHERE user_id LIKE ? ORDER BY user_id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, prefix + "%");
            ResultSet rs = pstmt.executeQuery();
            int maxNumber = 0;
            if (rs.next()) {
                String lastUserId = rs.getString("user_id");
                try {
                    maxNumber = Integer.parseInt(lastUserId.substring(prefix.length() + 1));
                } catch (NumberFormatException e) {
                    maxNumber = 0;
                }
            }
            String nextUserId = String.format("%s-%03d", prefix, maxNumber + 1);
            return nextUserId;
        } catch (SQLException e) {
            System.err.println("Error generating user_id: " + e.getMessage());
            return prefix + "-" + System.currentTimeMillis();
        }
    }

    // Save user — BUG FIX: now saves gender column
    public boolean saveUser(User user) {
        String query = "INSERT INTO users (user_id, username, email, password, full_name, gender, phone, address, user_type, status) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getUsername());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPassword());
            pstmt.setString(5, user.getFullName());
            pstmt.setString(6, user.getGender()); // ← BUG FIX: was missing
            pstmt.setString(7, user.getPhone());
            pstmt.setString(8, user.getAddress());
            pstmt.setString(9, user.getUserType());
            pstmt.setString(10, user.getStatus());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error saving user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    

    // Get doctor approval status
    public String getDoctorApprovalStatus(int userId) {
        String query = "SELECT approval_status FROM doctor_profiles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getString("approval_status");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get doctor rejection reason
    public String getDoctorRejectionReason(int userId) {
        String query = "SELECT rejection_reason FROM doctor_profiles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getString("rejection_reason");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get profile image path
    public String getProfileImage(int userId) {
        String query = "SELECT profile_image FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getString("profile_image");
        } catch (SQLException e) {
            System.err.println("Error getting profile image: " + e.getMessage());
        }
        return null;
    }

    // Update profile image
    public void updateProfileImage(int userId, String imagePath) {
        String query = "UPDATE users SET profile_image = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, imagePath);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating profile image: " + e.getMessage());
        }
    }

    // Lock user
    public boolean lockUser(int userId, String reason) {
        String query = "UPDATE users SET status = 'locked', lock_reason = ?, locked_at = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, reason);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(3, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error locking user: " + e.getMessage());
            return false;
        }
    }

    // Unlock user
    public boolean unlockUser(int userId) {
        String query = "UPDATE users SET status = 'active', lock_reason = NULL, locked_at = NULL WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error unlocking user: " + e.getMessage());
            return false;
        }
    }

    // Get all users with optional filter and search
    public List<Map<String, Object>> getAllUsers(String filter, String search) {
        List<Map<String, Object>> users = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT u.id, u.user_id, u.username, u.email, u.full_name, u.phone, u.user_type, u.status, " +
            "dp.specialization, dp.consultation_fee, pp.blood_group " +
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

        boolean hasSearch = search != null && !search.trim().isEmpty();
        if (hasSearch) {
            query.append(" AND (u.full_name LIKE ? OR u.email LIKE ? OR u.username LIKE ? OR u.user_id LIKE ?)");
        }

        query.append(" ORDER BY u.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {

            if (hasSearch) {
                String s = "%" + search.trim() + "%";
                pstmt.setString(1, s);
                pstmt.setString(2, s);
                pstmt.setString(3, s);
                pstmt.setString(4, s);
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
}
