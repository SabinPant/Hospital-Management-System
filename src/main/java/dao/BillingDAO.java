package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import utils.DBConnection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

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
    
 // Get all billings for export
    public List<Map<String, Object>> getAllBillingsForExport() {
        List<Map<String, Object>> billings = new ArrayList<>();
        String query = "SELECT b.billing_id, b.appointment_id, b.amount, b.payment_status, b.payment_date, " +
                       "p.full_name as patient_name, d.full_name as doctor_name " +
                       "FROM billings b " +
                       "JOIN users p ON b.patient_id = p.id " +
                       "JOIN users d ON b.doctor_id = d.id " +
                       "ORDER BY b.payment_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> billing = new HashMap<>();
                billing.put("billing_id", rs.getString("billing_id"));
                billing.put("appointment_id", rs.getString("appointment_id"));
                billing.put("patient_name", rs.getString("patient_name"));
                billing.put("doctor_name", rs.getString("doctor_name"));
                billing.put("amount", rs.getDouble("amount"));
                billing.put("payment_status", rs.getString("payment_status"));
                billing.put("payment_date", rs.getTimestamp("payment_date"));
                billings.add(billing);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting billings for export: " + e.getMessage());
        }
        
        return billings;
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