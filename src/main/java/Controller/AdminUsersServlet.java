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

import java.sql.Timestamp;
import dao.AdminDAO;
import dao.UserDAO;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String filter = request.getParameter("filter");
        String search = request.getParameter("search");
        
        List<Map<String, Object>> users = userDAO.getAllUsers(filter, search);
        request.setAttribute("users", users);
        request.setAttribute("currentFilter", filter);
        request.setAttribute("currentSearch", search);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-users.jsp")
               .forward(request, response);
    }
    
    
}