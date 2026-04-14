package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.NotificationDAO;

@WebServlet("/admin/announcement")
public class AdminAnnouncementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        // Get previous announcements from DAO
        List<Map<String, Object>> announcements = notificationDAO.getPreviousAnnouncements();
        request.setAttribute("announcements", announcements);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-announcement.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        int adminId = (int) session.getAttribute("admin_id");
        
        String sendTo = request.getParameter("sendTo");
        String type = request.getParameter("type");
        String title = request.getParameter("title");
        String message = request.getParameter("message");
        
        // Validation
        if (title == null || title.trim().isEmpty()) {
            session.setAttribute("error", "Title is required");
            response.sendRedirect(request.getContextPath() + "/admin/announcement");
            return;
        }
        
        if (message == null || message.trim().isEmpty()) {
            session.setAttribute("error", "Message is required");
            response.sendRedirect(request.getContextPath() + "/admin/announcement");
            return;
        }
        
        // Get user IDs from DAO
        List<Integer> userIds = notificationDAO.getUserIdsByType(sendTo);
        
        int sentCount = 0;
        for (int userId : userIds) {
            boolean sent = notificationDAO.addNotification(userId, title, message, type);
            if (sent) sentCount++;
        }
        
        session.setAttribute("success", "Announcement sent to " + sentCount + " users");
        response.sendRedirect(request.getContextPath() + "/admin/announcement");
    }
}