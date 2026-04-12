package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import utils.DBConnection;

public class BillingDAO {
    
    // Simplified generate billing ID
    private String generateBillingId() {
        return "BIL-" + System.currentTimeMillis();
    }
    
    // Create billing record when appointment is completed
    public boolean createBilling(int appointmentId, int patientId, int doctorId, double amount) {
        String query = "INSERT INTO billings (billing_id, appointment_id, patient_id, doctor_id, amount, payment_status, payment_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            String billingId = generateBillingId();
            
            
            pstmt.setString(1, billingId);
            pstmt.setInt(2, appointmentId);
            pstmt.setInt(3, patientId);
            pstmt.setInt(4, doctorId);
            pstmt.setDouble(5, amount);
            pstmt.setString(6, "paid");
            pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Billing created - Rows affected: " + rowsAffected);
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating billing: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get consultation fee for doctor
    public double getDoctorConsultationFee(int doctorId) {
        String query = "SELECT consultation_fee FROM doctor_profiles WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                double fee = rs.getDouble("consultation_fee");
                System.out.println("Doctor consultation fee: " + fee);
                return fee;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting consultation fee: " + e.getMessage());
        }
        
        return 500.00; // Default fee
    }
}