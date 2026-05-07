package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.AppointmentDAO;
import dao.NotificationDAO;
import utils.SessionUtil;

@WebServlet("/doctor/reject-appointment")
public class DoctorRejectAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isDoctor(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int doctorId = SessionUtil.getUserId(session);
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("id"));
            String reason = request.getParameter("reason");
            
            if (reason == null || reason.trim().isEmpty()) {
                reason = "No reason provided";
            }
            
            boolean rejected = appointmentDAO.rejectAssignedAppointment(appointmentId, doctorId, reason);
            
            if (rejected) {
                // Notify admin that assignment needs attention
                int patientId = appointmentDAO.getPatientIdByAppointmentId(appointmentId);
                notificationDAO.addNotification(patientId, "Appointment Reassigned", 
                    "Your appointment request is being reviewed again. A new doctor will be assigned shortly.", "warning");
                
                session.setAttribute("success", "Appointment rejected and sent back to admin.");
            } else {
                session.setAttribute("error", "Failed to reject appointment.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid appointment ID.");
        } catch (Exception e) {
            System.err.println("Error in DoctorRejectAppointmentServlet: " + e.getMessage());
            session.setAttribute("error", "An error occurred.");
        }
        
        response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
    }
}