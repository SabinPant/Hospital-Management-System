package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import models.DoctorProfile;
import utils.DBConnection;

public class DoctorDAO {
    
	// Save doctor profile
	public boolean saveDoctorProfile(DoctorProfile profile) {
	    String query = "INSERT INTO doctor_profiles (user_id, specialization, qualification, license_number, license_image, experience_years, consultation_fee, bio, approval_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
	        
	        pstmt.setInt(1, profile.getUserId());
	        pstmt.setString(2, profile.getSpecialization());
	        pstmt.setString(3, profile.getQualification());
	        pstmt.setString(4, profile.getLicenseNumber());
	        pstmt.setString(5, profile.getLicenseImage());  
	        pstmt.setInt(6, profile.getExperienceYears());
	        pstmt.setDouble(7, profile.getConsultationFee());
	        pstmt.setString(8, profile.getBio());
	        pstmt.setString(9, profile.getApprovalStatus());
	        
	        int rowsAffected = pstmt.executeUpdate();
	        
	        if (rowsAffected > 0) {
	            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
	                if (generatedKeys.next()) {
	                    profile.setId(generatedKeys.getInt(1));
	                }
	            }
	           
	            return true;
	        }
	        
	    } catch (SQLException e) {
	        System.err.println("Error saving doctor profile: " + e.getMessage());
	        e.printStackTrace();
	    }
	    
	    return false;
	}
    
    // Approve doctor
    public boolean approveDoctor(int userId, int adminId) {
        String query = "UPDATE doctor_profiles SET approval_status = 'approved', approved_by = ?, approved_at = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, adminId);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(3, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error approving doctor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Reject doctor
    public boolean rejectDoctor(int userId, int adminId, String reason) {
        String query = "UPDATE doctor_profiles SET approval_status = 'rejected', rejection_reason = ?, approved_by = ?, approved_at = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, reason);
            pstmt.setInt(2, adminId);
            pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(4, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error rejecting doctor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
 // Get doctor's department (using specialization since no department_id)
    public String getDoctorDepartment(int userId) {
        String query = "SELECT specialization FROM doctor_profiles WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("specialization");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor department: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "General Medicine";
    }
    
 // Get doctor details by ID for admin review
    public Map<String, Object> getDoctorDetailsForReview(int doctorId) {
        Map<String, Object> doctor = new HashMap<>();
        String query = "SELECT u.id, u.full_name, u.email, u.phone, u.address, u.created_at, " +
                       "dp.specialization, dp.experience_years, dp.qualification, dp.license_number, " +
                       "dp.consultation_fee, dp.bio, dp.license_image " +
                       "FROM users u " +
                       "JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "WHERE u.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                doctor.put("id", rs.getInt("id"));
                doctor.put("full_name", rs.getString("full_name"));
                doctor.put("email", rs.getString("email"));
                doctor.put("phone", rs.getString("phone"));
                doctor.put("address", rs.getString("address"));
                doctor.put("created_at", rs.getTimestamp("created_at").toString());
                doctor.put("specialization", rs.getString("specialization"));
                doctor.put("experience_years", rs.getInt("experience_years"));
                doctor.put("qualification", rs.getString("qualification"));
                doctor.put("license_number", rs.getString("license_number"));
                doctor.put("consultation_fee", rs.getDouble("consultation_fee"));
                doctor.put("bio", rs.getString("bio"));
                doctor.put("license_image", rs.getString("license_image"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor details: " + e.getMessage());
        }
        
        return doctor;
    }
    
 // Update license image
    public void updateLicenseImage(int userId, String imagePath) {
        String query = "UPDATE doctor_profiles SET license_image = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, imagePath);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating license image: " + e.getMessage());
        }
    }
    
 // Get doctor profile by user ID
    public Map<String, Object> getDoctorProfile(int userId) {
        Map<String, Object> profile = new HashMap<>();
        String query = "SELECT u.user_id, u.username, u.email, u.full_name, u.phone, u.address, u.gender, u.created_at, " +
                       "dp.specialization, dp.qualification, dp.license_number, dp.experience_years, dp.consultation_fee, dp.bio, dp.license_image " +
                       "FROM users u " +
                       "JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "WHERE u.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                profile.put("user_id", rs.getString("user_id"));
                profile.put("username", rs.getString("username"));
                profile.put("email", rs.getString("email"));
                profile.put("full_name", rs.getString("full_name"));
                profile.put("phone", rs.getString("phone"));
                profile.put("address", rs.getString("address"));
                profile.put("gender", rs.getString("gender"));
                profile.put("created_at", rs.getTimestamp("created_at"));
                profile.put("specialization", rs.getString("specialization"));
                profile.put("qualification", rs.getString("qualification"));
                profile.put("license_number", rs.getString("license_number"));
                profile.put("experience_years", rs.getInt("experience_years"));
                profile.put("consultation_fee", rs.getDouble("consultation_fee"));
                profile.put("bio", rs.getString("bio"));
                profile.put("license_image", rs.getString("license_image"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor profile: " + e.getMessage());
        }
        
        return profile;
    }

    // Get doctor earnings summary
    public Map<String, Object> getDoctorEarnings(int doctorId) {
        Map<String, Object> earnings = new HashMap<>();
        String query = "SELECT " +
                       "COUNT(DISTINCT patient_id) as total_patients, " +
                       "COUNT(*) as total_appointments, " +
                       "SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_appointments, " +
                       "SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_appointments, " +
                       "(SELECT SUM(amount) FROM billings WHERE doctor_id = ?) as total_earnings " +
                       "FROM appointments WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            pstmt.setInt(2, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                double totalEarnings = rs.getDouble("total_earnings");
                int completed = rs.getInt("completed_appointments");
                
                earnings.put("total_patients", rs.getInt("total_patients"));
                earnings.put("total_appointments", rs.getInt("total_appointments"));
                earnings.put("completed_appointments", completed);
                earnings.put("pending_appointments", rs.getInt("pending_appointments"));
                earnings.put("total_earnings", totalEarnings);
                earnings.put("avg_per_visit", completed > 0 ? totalEarnings / completed : 0);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor earnings: " + e.getMessage());
        }
        
        return earnings;
    }

   
    
}