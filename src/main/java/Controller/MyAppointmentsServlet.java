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

@WebServlet("/patient/appointments")
public class MyAppointmentsServlet extends HttpServlet {
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
        
        try {
            int patientId = (int) session.getAttribute("user_id");
            
            // Get all appointments for this patient
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(patientId);
            request.setAttribute("appointments", appointments);
            
            System.out.println("Found " + appointments.size() + " appointments for patient: " + patientId);
            
            request.getRequestDispatcher("/WEB-INF/views/patient/my-appointments.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            System.err.println("Error in MyAppointmentsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/dashboard?error=Unable to load appointments");
        }
    }
}