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
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        // Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            
            request.setAttribute("error", "Please fill all required fields");
            request.getRequestDispatcher("/WEB-INF/views/Contact.jsp")
                   .forward(request, response);
            return;
        }
        
        // Create and save message
        ContactMessage contactMessage = new ContactMessage(name, email, phone, subject, message);
        boolean saved = contactDAO.saveMessage(contactMessage);
        
        if (saved) {
            request.setAttribute("success", "Thank you! Your message has been sent. We'll get back to you within 24 hours.");
        } else {
            request.setAttribute("error", "Unable to send message. Please try again or call us directly.");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/Contact.jsp")
               .forward(request, response);
    }
}