package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.NotificationDAO;
import utils.SessionUtil;

@WebFilter("/doctor/*")
public class DoctorAuthFilter implements Filter {
    
    private NotificationDAO notificationDAO;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        if (!SessionUtil.isDoctor(session)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        String status = SessionUtil.getStatus(session);
        if (status != null && "locked".equals(status)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=Account locked");
            return;
        }
        
        // Set unread notification count for header
        try {
            int userId = SessionUtil.getUserId(session);
            int unreadCount = notificationDAO.getUnreadCount(userId);
            session.setAttribute("unreadCount", unreadCount);
        } catch (Exception e) {
            session.setAttribute("unreadCount", 0);
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {}
}