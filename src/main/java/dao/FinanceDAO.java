package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import utils.DBConnection;
import java.sql.SQLException;

public class FinanceDAO {
    
    // Get total revenue (all time)
    public double getTotalRevenue() {
        double total = 0;
        String query = "SELECT SUM(amount) as total FROM billings WHERE payment_status = 'paid'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) total = rs.getDouble("total");
        } catch (Exception e) {
            System.err.println("Error getting total revenue: " + e.getMessage());
        }
        return total;
    }
    
    // Get this month's revenue
    public double getMonthlyRevenue() {
        double total = 0;
        String query = "SELECT SUM(amount) as total FROM billings WHERE payment_status = 'paid' AND MONTH(payment_date) = MONTH(CURDATE()) AND YEAR(payment_date) = YEAR(CURDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) total = rs.getDouble("total");
        } catch (Exception e) {
            System.err.println("Error getting monthly revenue: " + e.getMessage());
        }
        return total;
    }
    
    // Get total completed appointments
    public int getTotalCompletedAppointments() {
        int total = 0;
        String query = "SELECT COUNT(*) as count FROM appointments WHERE status = 'completed'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) total = rs.getInt("count");
        } catch (Exception e) {
            System.err.println("Error getting completed appointments: " + e.getMessage());
        }
        return total;
    }
    
    // Get monthly revenue list (last 6 months)
    public List<Map<String, Object>> getMonthlyRevenueList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String query = "SELECT DATE_FORMAT(payment_date, '%b %Y') as month, SUM(amount) as revenue, COUNT(*) as count " +
                       "FROM billings WHERE payment_status = 'paid' " +
                       "GROUP BY DATE_FORMAT(payment_date, '%Y-%m') " +
                       "ORDER BY payment_date DESC LIMIT 6";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> month = new HashMap<>();
                month.put("month", rs.getString("month"));
                month.put("revenue", rs.getDouble("revenue"));
                month.put("count", rs.getInt("count"));
                list.add(month);
            }
        } catch (Exception e) {
            System.err.println("Error getting monthly revenue list: " + e.getMessage());
        }
        return list;
    }
    
 // Get finance data for export
    public List<Map<String, Object>> getFinanceDataForExport() {
        List<Map<String, Object>> list = new ArrayList<>();
        String query = "SELECT DATE_FORMAT(payment_date, '%b %Y') as month, SUM(amount) as revenue, COUNT(*) as count " +
                       "FROM billings WHERE payment_status = 'paid' " +
                       "GROUP BY DATE_FORMAT(payment_date, '%Y-%m') " +
                       "ORDER BY payment_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("month", rs.getString("month"));
                data.put("revenue", rs.getDouble("revenue"));
                data.put("count", rs.getInt("count"));
                list.add(data);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting finance data for export: " + e.getMessage());
        }
        
        return list;
    }
    
    // Get top 5 doctors by revenue
    public List<Map<String, Object>> getTopDoctors() {
        List<Map<String, Object>> list = new ArrayList<>();
        String query = "SELECT d.full_name, SUM(b.amount) as revenue, COUNT(b.id) as appointments " +
                       "FROM billings b " +
                       "JOIN users d ON b.doctor_id = d.id " +
                       "WHERE b.payment_status = 'paid' " +
                       "GROUP BY b.doctor_id " +
                       "ORDER BY revenue DESC LIMIT 5";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            int rank = 1;
            while (rs.next()) {
                Map<String, Object> doctor = new HashMap<>();
                doctor.put("rank", rank++);
                doctor.put("name", rs.getString("full_name"));
                doctor.put("revenue", rs.getDouble("revenue"));
                doctor.put("appointments", rs.getInt("appointments"));
                list.add(doctor);
            }
        } catch (Exception e) {
            System.err.println("Error getting top doctors: " + e.getMessage());
        }
        return list;
    }
    
    // Get recent billings (last 10)
    public List<Map<String, Object>> getRecentBillings() {
        List<Map<String, Object>> list = new ArrayList<>();
        String query = "SELECT b.billing_id, b.amount, b.payment_date, b.payment_status, " +
                       "p.full_name as patient_name, d.full_name as doctor_name " +
                       "FROM billings b " +
                       "JOIN users p ON b.patient_id = p.id " +
                       "JOIN users d ON b.doctor_id = d.id " +
                       "WHERE b.payment_status = 'paid' " +
                       "ORDER BY b.payment_date DESC LIMIT 10";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> billing = new HashMap<>();
                billing.put("billing_id", rs.getString("billing_id"));
                billing.put("patient_name", rs.getString("patient_name"));
                billing.put("doctor_name", rs.getString("doctor_name"));
                billing.put("amount", rs.getDouble("amount"));
                billing.put("payment_date", rs.getTimestamp("payment_date"));
                billing.put("status", rs.getString("payment_status"));
                list.add(billing);
            }
        } catch (Exception e) {
            System.err.println("Error getting recent billings: " + e.getMessage());
        }
        return list;
    }
    
    // Get max revenue for bar chart
    public double getMaxRevenue(List<Map<String, Object>> monthlyRevenueList) {
        double max = 0;
        for (Map<String, Object> month : monthlyRevenueList) {
            double revenue = (double) month.get("revenue");
            if (revenue > max) max = revenue;
        }
        return max;
    }
}