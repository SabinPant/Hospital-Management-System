package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import services.AppointmentService;

@WebServlet("/doctor/confirm-appointment")
public class DoctorConfirmAppointmentServlet extends HttpServlet {
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
        
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int doctorId = (int) session.getAttribute("user_id");
        String doctorName = (String) session.getAttribute("full_name");
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("error", "Invalid appointment ID");
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            
            // Call Service (business logic is in Service)
            boolean confirmed = appointmentService.confirmAppointment(appointmentId, doctorId, doctorName);
            
            if (confirmed) {
                session.setAttribute("success", "Appointment confirmed");
            } else {
                session.setAttribute("error", "Failed to confirm - Appointment may not be pending");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid ID");
        }
        
        response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
    }
}