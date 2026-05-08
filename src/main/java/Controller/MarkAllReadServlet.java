package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import dao.NotificationDAO;
import utils.SessionUtil;

@WebServlet("/notification/read-all")
public class MarkAllReadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = SessionUtil.getUserId(session);
        notificationDAO.markAllAsRead(userId);
        
        response.sendRedirect(request.getContextPath() + "/notifications");
    }
}