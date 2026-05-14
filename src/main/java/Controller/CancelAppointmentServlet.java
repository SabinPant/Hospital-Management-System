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

@WebServlet("/patient/cancel-appointment")
public class CancelAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;
    
    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = SessionUtil.getUserId(session);
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid appointment ID");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            String reason = request.getParameter("reason");
            
            // Call Service (business logic is in Service, not Servlet)
            boolean cancelled = appointmentService.cancelAppointment(appointmentId, userId, reason);
            
            if (cancelled) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?success=Appointment cancelled successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Cannot cancel this appointment");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid appointment ID");
        }
    }
}