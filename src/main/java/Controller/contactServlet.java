package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import dao.ContactDAO;
import models.ContactMessage;

@WebServlet("/contact")
public class contactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ContactDAO contactDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        contactDAO = new ContactDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/Contact.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/contact?error=1");
            return;
        }
        
        // Create ContactMessage object
        ContactMessage contactMessage = new ContactMessage(name, email, phone, subject, message);
        
        // Save to database
        boolean isSaved = contactDAO.saveMessage(contactMessage);
        
        if (isSaved) {
            System.out.println("Contact message saved from: " + name + " (" + email + ")");
            response.sendRedirect(request.getContextPath() + "/contact?success=1");
        } else {
            System.err.println("Failed to save contact message from: " + name);
            response.sendRedirect(request.getContextPath() + "/contact?error=1");
        }
    }
}