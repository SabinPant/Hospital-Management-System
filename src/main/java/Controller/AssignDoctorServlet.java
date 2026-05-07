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

@WebServlet("/admin/assign-doctor")
public class AssignDoctorServlet extends HttpServlet {
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
        if (!SessionUtil.isAdminLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        int adminId = SessionUtil.getAdminId(session);
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            
            if (doctorId <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&error=Please select a doctor");
                return;
            }
            
            boolean assigned = appointmentDAO.assignDoctorToRequest(appointmentId, doctorId, adminId);
            
            if (assigned) {
                // Notify the patient
                int patientId = appointmentDAO.getPatientIdByAppointmentId(appointmentId);
                String doctorName = appointmentDAO.getDoctorNameByAppointmentId(appointmentId);
                notificationDAO.addNotification(patientId, "Doctor Assigned", 
                    "Dr. " + doctorName + " has been assigned to your appointment request. Awaiting confirmation.", "info");
                
                // Notify the doctor
                notificationDAO.addNotification(doctorId, "New Appointment Assigned", 
                    "A new patient has been assigned to you by the admin. Please confirm the appointment.", "info");
                
                response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&success=Doctor assigned successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&error=Failed to assign doctor");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&error=Invalid data");
        } catch (Exception e) {
            System.err.println("Error in AssignDoctorServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&error=An error occurred");
        }
    }
}