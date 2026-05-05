package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import services.AppointmentService;
import utils.SessionUtil;

@WebServlet("/doctor/complete-appointment")
public class DoctorCompleteAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;
    
    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (!SessionUtil.isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int doctorId = SessionUtil.getUserId(session);
        String doctorName = SessionUtil.getFullName(session);
        String idParam = request.getParameter("id");
        String diagnosis = request.getParameter("diagnosis");
        String prescription = request.getParameter("prescription");
        
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("error", "Invalid appointment ID");
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            
            // Call Service (business logic is in Service)
            boolean completed = appointmentService.completeAppointment(appointmentId, doctorId, doctorName, diagnosis, prescription);
            
            if (completed) {
                session.setAttribute("success", "Appointment completed and billing created");
            } else {
                session.setAttribute("error", "Failed to complete appointment - Appointment must be confirmed first");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid ID format");
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            session.setAttribute("error", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
    }
}