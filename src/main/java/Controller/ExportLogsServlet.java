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

@WebServlet("/admin/export-logs")
public class ExportLogsServlet extends HttpServlet {
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
        response.setHeader("Content-Disposition", "attachment; filename=\"system_logs_" + System.currentTimeMillis() + ".csv\"");
        
        try (PrintWriter writer = response.getWriter();
             Connection conn = DBConnection.getConnection()) {
            
            // CSV Header
            writer.println("Timestamp,User,Type,Action,Details,IP Address");
            
            String query = "SELECT l.*, " +
                           "CASE WHEN l.admin_id IS NOT NULL THEN a.full_name " +
                           "     WHEN l.user_id IS NOT NULL THEN u.full_name " +
                           "     ELSE 'System' END as actor_name, " +
                           "CASE WHEN l.admin_id IS NOT NULL THEN 'Admin' " +
                           "     WHEN l.user_id IS NOT NULL THEN u.user_type " +
                           "     ELSE 'System' END as actor_type " +
                           "FROM system_logs l " +
                           "LEFT JOIN admins a ON l.admin_id = a.id " +
                           "LEFT JOIN users u ON l.user_id = u.id " +
                           "ORDER BY l.created_at DESC";
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    String timestamp = rs.getTimestamp("created_at").toString();
                    String actor = rs.getString("actor_name");
                    String type = rs.getString("actor_type");
                    String action = rs.getString("action");
                    String details = rs.getString("details") != null ? rs.getString("details").replace(",", ";") : "";
                    String ip = rs.getString("ip_address") != null ? rs.getString("ip_address") : "";
                    
                    writer.println(String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",
                        timestamp, actor, type, action, details, ip));
                }
            }
            
            writer.flush();
            
        } catch (Exception e) {
            System.err.println("Error exporting logs: " + e.getMessage());
            e.printStackTrace();
        }
    }
}