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
import utils.SessionUtil;

@WebServlet("/notifications")
public class NotificationsServlet extends HttpServlet {
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
        if (!SessionUtil.isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = SessionUtil.getUserId(session);
        
        // Get data from DAO
        List<Map<String, Object>> notifications = notificationDAO.getUserNotifications(userId);
        int unreadCount = notificationDAO.getUnreadCount(userId);
        
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        
        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp")
               .forward(request, response);
    }
}