package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import utils.DBConnection;

@WebServlet("/admin/export-billings")
public class ExportBillingsServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"billings_" + System.currentTimeMillis() + ".csv\"");
        
        try (PrintWriter writer = response.getWriter();
             Connection conn = DBConnection.getConnection()) {
            
            // CSV Header
            writer.println("Billing ID,Appointment ID,Patient Name,Doctor Name,Amount,Payment Status,Payment Date");
            
            // Query with joins to get names
            String query = "SELECT b.billing_id, b.appointment_id, b.amount, b.payment_status, b.payment_date, " +
                           "p.full_name as patient_name, d.full_name as doctor_name " +
                           "FROM billings b " +
                           "JOIN users p ON b.patient_id = p.id " +
                           "JOIN users d ON b.doctor_id = d.id " +
                           "ORDER BY b.payment_date DESC";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                writer.println(String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%.2f\",\"%s\",\"%s\"",
                    rs.getString("billing_id"),
                    rs.getString("appointment_id"),
                    rs.getString("patient_name"),
                    rs.getString("doctor_name"),
                    rs.getDouble("amount"),
                    rs.getString("payment_status"),
                    rs.getTimestamp("payment_date")
                ));
            }
            
            writer.flush();
            
        } catch (Exception e) {
            System.err.println("Error exporting billings: " + e.getMessage());
            e.printStackTrace();
        }
    }
}