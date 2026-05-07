package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

import services.AppointmentService;
import utils.SessionUtil;

@WebServlet("/patient/book-request")
public class BookAppointmentRequestServlet extends HttpServlet {
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
        if (!SessionUtil.isPatient(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int patientId = SessionUtil.getUserId(session);
        
        try {
            String dateStr = request.getParameter("appointmentDate");
            String timeStr = request.getParameter("appointmentTime");
            String problemDescription = request.getParameter("problemDescription");
            String symptoms = request.getParameter("symptoms");
            
            // Validate required fields
            if (dateStr == null || dateStr.trim().isEmpty()) {
                session.setAttribute("error", "Please select a preferred date.");
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
                return;
            }
            
            if (timeStr == null || timeStr.trim().isEmpty()) {
                session.setAttribute("error", "Please select a preferred time.");
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
                return;
            }
            
            if (problemDescription == null || problemDescription.trim().isEmpty()) {
                session.setAttribute("error", "Please describe your health problem.");
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
                return;
            }
            
            Date appointmentDate = Date.valueOf(dateStr);
            Time appointmentTime = Time.valueOf(timeStr + ":00");
            
            // Call service
            boolean saved = appointmentService.bookAppointmentRequest(
                patientId, appointmentDate, appointmentTime, problemDescription, symptoms
            );
           
            
            if (saved) {
                session.setAttribute("success", "Appointment request submitted! Admin will assign a doctor soon.");
            } else {
                session.setAttribute("error", "Failed to submit request. Please check the date and try again.");
            }
            
        } catch (IllegalArgumentException e) {
            System.err.println("Date/Time parse error: " + e.getMessage());
            session.setAttribute("error", "Invalid date or time format. Please check your entries.");
        } catch (Exception e) {
            System.err.println("Error in BookAppointmentRequestServlet: " + e.getMessage());
            session.setAttribute("error", "An error occurred. Please try again.");
        }
        
        response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
    }
}