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

@WebServlet("/admin/export-finance")
public class ExportFinanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"finance_report_" + System.currentTimeMillis() + ".csv\"");
        
        try (PrintWriter writer = response.getWriter();
             Connection conn = DBConnection.getConnection()) {
            
            // CSV Header
            writer.println("Month,Revenue,Appointments,Average per Appointment");
            
            String query = "SELECT DATE_FORMAT(payment_date, '%b %Y') as month, SUM(amount) as revenue, COUNT(*) as count " +
                           "FROM billings WHERE payment_status = 'paid' " +
                           "GROUP BY DATE_FORMAT(payment_date, '%Y-%m') " +
                           "ORDER BY payment_date DESC";
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    String month = rs.getString("month");
                    double revenue = rs.getDouble("revenue");
                    int count = rs.getInt("count");
                    double avg = count > 0 ? revenue / count : 0;
                    
                    writer.println(String.format("\"%s\",\"%.2f\",\"%d\",\"%.2f\"",
                        month, revenue, count, avg));
                }
            }
            
            writer.flush();
            
        } catch (Exception e) {
            System.err.println("Error exporting finance: " + e.getMessage());
            e.printStackTrace();
        }
    }
}