package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.AppointmentDAO;

@WebServlet("/patient/cancel-appointment")
public class CancelAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String idParam = request.getParameter("id");
        System.out.println("Cancel appointment - ID param: " + idParam); // Debug
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid appointment ID");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            String reason = request.getParameter("reason");
            if (reason == null || reason.isEmpty()) {
                reason = "Cancelled by patient";
            }
            
            boolean cancelled = appointmentDAO.cancelAppointment(appointmentId, reason);
            System.out.println("Cancellation result: " + cancelled); // Debug
            
            if (cancelled) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?success=Appointment cancelled successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Failed to cancel appointment");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("Number format error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid appointment ID format");
        }
    }
}