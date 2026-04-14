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

import utils.DBConnection;

@WebServlet("/notification/read")
public class MarkNotificationReadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            int notificationId = Integer.parseInt(idParam);
            
            String query = "UPDATE notifications SET is_read = TRUE WHERE id = ?";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(query)) {
                
                pstmt.setInt(1, notificationId);
                pstmt.executeUpdate();
                
            } catch (Exception e) {
                System.err.println("Error marking notification as read: " + e.getMessage());
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/notifications");
    }
}