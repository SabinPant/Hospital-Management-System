package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import models.PatientProfile;
import utils.DBConnection;

public class PatientDAO {
    
    public boolean savePatientProfile(PatientProfile profile) {
        String query = "INSERT INTO patient_profiles (user_id, date_of_birth, blood_group, emergency_contact, medical_history, allergies) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, profile.getUserId());
            
            if (profile.getDateOfBirth() != null) {
                pstmt.setDate(2, profile.getDateOfBirth());
            } else {
                pstmt.setNull(2, java.sql.Types.DATE);
            }
            
            pstmt.setString(3, profile.getBloodGroup());
            pstmt.setString(4, profile.getEmergencyContact());
            pstmt.setString(5, profile.getMedicalHistory());
            pstmt.setString(6, profile.getAllergies());
            
            System.out.println("Saving patient profile for user_id: " + profile.getUserId());
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        profile.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("SQL Error in savePatientProfile: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
 // Get patient profile by user_id
    public PatientProfile getPatientProfileByUserId(int userId) {
        String query = "SELECT * FROM patient_profiles WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                PatientProfile profile = new PatientProfile();
                profile.setId(rs.getInt("id"));
                profile.setUserId(rs.getInt("user_id"));
                profile.setDateOfBirth(rs.getDate("date_of_birth"));
                profile.setBloodGroup(rs.getString("blood_group"));
                profile.setEmergencyContact(rs.getString("emergency_contact"));
                profile.setMedicalHistory(rs.getString("medical_history"));
                profile.setAllergies(rs.getString("allergies"));
                return profile;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting patient profile: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
}