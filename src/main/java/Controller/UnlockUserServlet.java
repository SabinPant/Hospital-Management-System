package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import services.UserService;

@WebServlet("/admin/unlock-user")
public class UnlockUserServlet extends HttpServlet {
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
        
        boolean unlocked = userService.unlockUser(userId, adminId);
        
        if (unlocked) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=User unlocked");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to unlock user");
        }
    }
}