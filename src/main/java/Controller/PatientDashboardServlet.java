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
import models.Appointment;

@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int patientId = (int) session.getAttribute("user_id");
        
        // Get upcoming appointments (limit 5)
        List<Appointment> upcomingAppointments = appointmentDAO.getUpcomingAppointments(patientId, 5);
        request.setAttribute("upcomingAppointments", upcomingAppointments);
        
        // Get total appointments count
        List<Appointment> allAppointments = appointmentDAO.getAppointmentsByPatientId(patientId);
        request.setAttribute("totalAppointments", allAppointments.size());
        
        request.getRequestDispatcher("/WEB-INF/views/patient/dashboard.jsp")
               .forward(request, response);
    }
}