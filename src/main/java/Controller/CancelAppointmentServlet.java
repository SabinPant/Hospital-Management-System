package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.AppointmentDAO;
import models.Appointment;
import dao.NotificationDAO;
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
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid appointment ID");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            
            // Get appointment to check status
            Appointment apt = appointmentDAO.getAppointmentById(appointmentId);
            
            if (apt == null) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Appointment not found");
                return;
            }
            
            // ONLY allow cancellation for pending appointments
            if (!"pending".equals(apt.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Cannot cancel " + apt.getStatus() + " appointment");
                return;
            }
            
            String reason = request.getParameter("reason");
            if (reason == null || reason.isEmpty()) {
                reason = "Cancelled by patient";
            }
            
            boolean cancelled = appointmentDAO.cancelAppointment(appointmentId, reason);
            
            if (cancelled) {
                // Get doctor name
                String doctorName = appointmentDAO.getDoctorNameByAppointmentId(appointmentId);
                
                // Add notification
                NotificationDAO notifDAO = new NotificationDAO();
                notifDAO.addNotification(apt.getPatientId(), "Appointment Cancelled", 
                    "Your appointment with Dr. " + doctorName + " has been cancelled. Reason: " + reason, "warning");
                
                response.sendRedirect(request.getContextPath() + "/patient/appointments?success=Appointment cancelled successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Failed to cancel appointment");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid appointment ID");
        }
    }
}