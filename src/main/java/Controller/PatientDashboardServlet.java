package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import dao.AppointmentDAO;
import dao.NotificationDAO;
import models.Appointment;
import models.Notification;

@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private NotificationDAO notificationDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        notificationDAO = new NotificationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int patientId = (int) session.getAttribute("user_id");
        
        // Get upcoming appointments
        List<Appointment> upcomingAppointments = appointmentDAO.getUpcomingAppointments(patientId, 5);
        request.setAttribute("upcomingAppointments", upcomingAppointments);
        
        // Get total appointments count
        List<Appointment> allAppointments = appointmentDAO.getAppointmentsByPatientId(patientId);
        request.setAttribute("totalAppointments", allAppointments.size());
        
        // Get completed appointments for medical history
        List<Appointment> medicalHistory = appointmentDAO.getCompletedAppointmentsByPatientId(patientId, 5);
        request.setAttribute("medicalHistory", medicalHistory);
        
        // Get recent notifications for activity
        List<Notification> recentActivities = notificationDAO.getRecentNotifications(patientId, 5);
        request.setAttribute("recentActivities", recentActivities);
        
        request.getRequestDispatcher("/WEB-INF/views/patient/dashboard.jsp")
               .forward(request, response);
    }
}