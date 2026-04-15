package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import services.UserService;

@WebServlet("/admin/lock-user")
public class LockUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
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
        int userId = Integer.parseInt(request.getParameter("id"));
        String reason = request.getParameter("reason");
        
        boolean locked = userService.lockUser(userId, reason, adminId);
        
        if (locked) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=User locked");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to lock user");
        }
    }
}