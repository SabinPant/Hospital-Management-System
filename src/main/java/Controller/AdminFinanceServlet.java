package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import utils.DBConnection;

@WebServlet("/admin/finance")
public class AdminFinanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            
            // Total Revenue (All Time)
            double totalRevenue = 0;
            String totalQuery = "SELECT SUM(amount) as total FROM billings WHERE payment_status = 'paid'";
            try (PreparedStatement stmt = conn.prepareStatement(totalQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) totalRevenue = rs.getDouble("total");
            }
            request.setAttribute("totalRevenue", totalRevenue);
            
            // This Month Revenue
            double monthlyRevenue = 0;
            String monthQuery = "SELECT SUM(amount) as total FROM billings WHERE payment_status = 'paid' AND MONTH(payment_date) = MONTH(CURDATE()) AND YEAR(payment_date) = YEAR(CURDATE())";
            try (PreparedStatement stmt = conn.prepareStatement(monthQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) monthlyRevenue = rs.getDouble("total");
            }
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            
            // Total Completed Appointments
            int totalAppointments = 0;
            String apptQuery = "SELECT COUNT(*) as count FROM appointments WHERE status = 'completed'";
            try (PreparedStatement stmt = conn.prepareStatement(apptQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) totalAppointments = rs.getInt("count");
            }
            request.setAttribute("totalAppointments", totalAppointments);
            
            // Average Revenue Per Appointment
            double avgRevenue = totalAppointments > 0 ? totalRevenue / totalAppointments : 0;
            request.setAttribute("avgRevenue", avgRevenue);
            
            // Monthly Revenue for Chart and Table (Last 6 months)
            List<Map<String, Object>> monthlyRevenueList = new ArrayList<>();
            String monthlyListQuery = "SELECT DATE_FORMAT(payment_date, '%b %Y') as month, DATE_FORMAT(payment_date, '%Y-%m') as sort_date, SUM(amount) as revenue, COUNT(*) as count " +
                                      "FROM billings WHERE payment_status = 'paid' " +
                                      "GROUP BY DATE_FORMAT(payment_date, '%Y-%m') " +
                                      "ORDER BY payment_date DESC LIMIT 6";
            try (PreparedStatement stmt = conn.prepareStatement(monthlyListQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> month = new HashMap<>();
                    month.put("month", rs.getString("month"));
                    month.put("revenue", rs.getDouble("revenue"));
                    month.put("count", rs.getInt("count"));
                    monthlyRevenueList.add(month);
                }
            }
            request.setAttribute("monthlyRevenueList", monthlyRevenueList);
            
            // Top 5 Doctors by Revenue
            List<Map<String, Object>> topDoctors = new ArrayList<>();
            String doctorQuery = "SELECT d.full_name, SUM(b.amount) as revenue, COUNT(b.id) as appointments " +
                                 "FROM billings b " +
                                 "JOIN users d ON b.doctor_id = d.id " +
                                 "WHERE b.payment_status = 'paid' " +
                                 "GROUP BY b.doctor_id " +
                                 "ORDER BY revenue DESC LIMIT 5";
            try (PreparedStatement stmt = conn.prepareStatement(doctorQuery);
                 ResultSet rs = stmt.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    Map<String, Object> doctor = new HashMap<>();
                    doctor.put("rank", rank++);
                    doctor.put("name", rs.getString("full_name"));
                    doctor.put("revenue", rs.getDouble("revenue"));
                    doctor.put("appointments", rs.getInt("appointments"));
                    topDoctors.add(doctor);
                }
            }
            request.setAttribute("topDoctors", topDoctors);
            
            // Recent Billings (Last 10)
            List<Map<String, Object>> recentBillings = new ArrayList<>();
            String billingQuery = "SELECT b.billing_id, b.amount, b.payment_date, b.payment_status, " +
                                  "p.full_name as patient_name, d.full_name as doctor_name " +
                                  "FROM billings b " +
                                  "JOIN users p ON b.patient_id = p.id " +
                                  "JOIN users d ON b.doctor_id = d.id " +
                                  "WHERE b.payment_status = 'paid' " +
                                  "ORDER BY b.payment_date DESC LIMIT 10";
            try (PreparedStatement stmt = conn.prepareStatement(billingQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> billing = new HashMap<>();
                    billing.put("billing_id", rs.getString("billing_id"));
                    billing.put("patient_name", rs.getString("patient_name"));
                    billing.put("doctor_name", rs.getString("doctor_name"));
                    billing.put("amount", rs.getDouble("amount"));
                    billing.put("payment_date", rs.getTimestamp("payment_date"));
                    billing.put("status", rs.getString("payment_status"));
                    recentBillings.add(billing);
                }
            }
            request.setAttribute("recentBillings", recentBillings);
            
            // Calculate max revenue for bar chart width (CSS only)
            double maxRevenue = 0;
            for (Map<String, Object> month : monthlyRevenueList) {
                double revenue = (double) month.get("revenue");
                if (revenue > maxRevenue) maxRevenue = revenue;
            }
            request.setAttribute("maxRevenue", maxRevenue);
            
        } catch (Exception e) {
            System.err.println("Error in AdminFinanceServlet: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-finance.jsp")
               .forward(request, response);
    }
}