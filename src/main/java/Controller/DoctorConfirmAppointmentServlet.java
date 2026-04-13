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
@WebServlet("/doctor/confirm-appointment")
public class DoctorConfirmAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("error", "Invalid appointment ID");
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            boolean confirmed = appointmentDAO.confirmAppointment(appointmentId);
            
            if (confirmed) {
                // Get patient ID and doctor name
                int patientId = appointmentDAO.getPatientIdByAppointmentId(appointmentId);
                String doctorName = (String) session.getAttribute("full_name");
                
                // Add notification
                NotificationDAO notifDAO = new NotificationDAO();
                notifDAO.addNotification(patientId, "Appointment Confirmed", 
                    "Your appointment with Dr. " + doctorName + " has been confirmed.", "success");
                
                session.setAttribute("success", "Appointment confirmed");
            } else {
                session.setAttribute("error", "Failed to confirm");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid ID");
        }
        
        response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
    }
}