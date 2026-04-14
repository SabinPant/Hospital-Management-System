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

@WebServlet("/notifications")
public class NotificationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = (int) session.getAttribute("user_id");
        
        List<Map<String, Object>> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> notif = new HashMap<>();
                notif.put("id", rs.getInt("id"));
                notif.put("title", rs.getString("title"));
                notif.put("message", rs.getString("message"));
                notif.put("type", rs.getString("type"));
                notif.put("is_read", rs.getBoolean("is_read"));
                notif.put("created_at", rs.getTimestamp("created_at"));
                notifications.add(notif);
            }
            
        } catch (Exception e) {
            System.err.println("Error getting notifications: " + e.getMessage());
        }
        
        int unreadCount = 0;
        for (Map<String, Object> n : notifications) {
            if (!(Boolean) n.get("is_read")) unreadCount++;
        }
        
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        
        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp")
               .forward(request, response);
    }
}