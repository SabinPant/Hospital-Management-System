package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import dao.ContactDAO;
import models.ContactMessage;

@WebServlet("/admin/messages")
public class AdminMessagesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ContactDAO contactDAO;
    
    @Override
    public void init() throws ServletException {
        contactDAO = new ContactDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        // Get all messages
        List<ContactMessage> messages = contactDAO.getAllMessages();
        request.setAttribute("messages", messages);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-messages.jsp")
               .forward(request, response);
    }
}