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

import utils.DBConnection;

public class BillingDAO {
    
	// Generate billing ID - now accepts connection parameter
	private String generateBillingId(Connection conn) {
	    String query = "SELECT billing_id FROM billings ORDER BY id DESC LIMIT 1";
	    int currentYear = java.time.Year.now().getValue();
	    
	    try (Statement stmt = conn.createStatement();
	         ResultSet rs = stmt.executeQuery(query)) {
	        
	        int lastNumber = 0;
	        if (rs.next()) {
	            String lastId = rs.getString("billing_id");
	            String numberPart = lastId.substring(lastId.length() - 4);
	            try {
	                lastNumber = Integer.parseInt(numberPart);
	            } catch (NumberFormatException e) {
	                lastNumber = 0;
	            }
	        }
	        
	        int nextNumber = lastNumber + 1;
	        String newId = String.format("BIL-%d-%04d", currentYear, nextNumber);
	       
	        return newId;
	        
	    } catch (SQLException e) {
	        System.err.println("Error generating billing ID: " + e.getMessage());
	        return String.format("BIL-%d-0001", currentYear);
	    }
	}

	// Create billing record - FIXED
	public boolean createBilling(int appointmentId, int patientId, int doctorId, double amount) {
	    String query = "INSERT INTO billings (billing_id, appointment_id, patient_id, doctor_id, amount, payment_status, payment_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(query)) {
	        
	        // Generate billing ID using the SAME connection
	        String billingId = generateBillingId(conn);
	        
	        pstmt.setString(1, billingId);
	        pstmt.setInt(2, appointmentId);
	        pstmt.setInt(3, patientId);
	        pstmt.setInt(4, doctorId);
	        pstmt.setDouble(5, amount);
	        pstmt.setString(6, "paid");
	        pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
	        
	        int rowsAffected = pstmt.executeUpdate();
	       
	        return rowsAffected > 0;
	        
	    } catch (SQLException e) {
	        System.err.println("Error creating billing: " + e.getMessage());
	        e.printStackTrace();
	        return false;
	    }
	}
    
    
    
    // Get billing by appointment ID
    public Map<String, Object> getBillingByAppointmentId(int appointmentId) {
        Map<String, Object> billing = new HashMap<>();
        String query = "SELECT b.*, p.full_name as patient_name, d.full_name as doctor_name " +
                       "FROM billings b " +
                       "JOIN users p ON b.patient_id = p.id " +
                       "JOIN users d ON b.doctor_id = d.id " +
                       "WHERE b.appointment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                billing.put("billing_id", rs.getString("billing_id"));
                billing.put("appointment_id", rs.getInt("appointment_id"));
                billing.put("patient_name", rs.getString("patient_name"));
                billing.put("doctor_name", rs.getString("doctor_name"));
                billing.put("amount", rs.getDouble("amount"));
                billing.put("payment_status", rs.getString("payment_status"));
                billing.put("payment_method", rs.getString("payment_method"));
                billing.put("payment_date", rs.getTimestamp("payment_date"));
                billing.put("created_at", rs.getTimestamp("created_at"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting billing by appointment ID: " + e.getMessage());
        }
        
        return billing;
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
               
                return fee;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting consultation fee: " + e.getMessage());
        }
        
        return 500.00; // Default fee
    }
    
    // Update payment status
    public boolean updatePaymentStatus(int billingId, String status, String paymentMethod) {
        String query = "UPDATE billings SET payment_status = ?, payment_method = ?, payment_date = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, status);
            pstmt.setString(2, paymentMethod);
            pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(4, billingId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating payment status: " + e.getMessage());
            return false;
        }
    }
}