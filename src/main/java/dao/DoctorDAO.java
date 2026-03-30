package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import models.DoctorProfile;
import utils.DBConnection;

public class DoctorDAO {
    
    // Save doctor profile
    public boolean saveDoctorProfile(DoctorProfile profile) {
    	String query = "INSERT INTO doctor_profiles (user_id, specialization, qualification, license_number, experience_years, consultation_fee, bio, approval_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, profile.getUserId());
            pstmt.setString(2, profile.getSpecialization());
            pstmt.setString(3, profile.getQualification());
            pstmt.setString(4, profile.getLicenseNumber());
            pstmt.setInt(5, profile.getExperienceYears());
            pstmt.setDouble(6, profile.getConsultationFee());
            pstmt.setString(7, profile.getBio());
            pstmt.setString(8, profile.getApprovalStatus()); // 'pending'
            
            System.out.println("=== Inserting Doctor Profile ===");
            System.out.println("user_id: " + profile.getUserId());
            System.out.println("specialization: " + profile.getSpecialization());
            System.out.println("qualification: " + profile.getQualification());
            System.out.println("license_number: " + profile.getLicenseNumber());
            System.out.println("experience_years: " + profile.getExperienceYears());
            System.out.println("consultation_fee: " + profile.getConsultationFee());
            System.out.println("approval_status: " + profile.getApprovalStatus());
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        profile.setId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("Doctor profile saved successfully!");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("SQL Error in DoctorDAO: " + e.getMessage());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        
        return false;
    }
}