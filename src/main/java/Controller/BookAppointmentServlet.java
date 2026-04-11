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

import dao.AppointmentDAO;
import models.Appointment;

@WebServlet("/patient/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }
    
    // Show booking page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get list of approved doctors
        request.setAttribute("doctors", appointmentDAO.getAllDoctors());
        request.getRequestDispatcher("/WEB-INF/views/patient/book-appointment.jsp")
               .forward(request, response);
    }
    
    // Process booking
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int patientId = (int) session.getAttribute("user_id");
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            Date appointmentDate = Date.valueOf(request.getParameter("appointmentDate"));
            Time appointmentTime = Time.valueOf(request.getParameter("appointmentTime") + ":00");
            String symptoms = request.getParameter("symptoms");
            
            // Validate inputs
            if (doctorId == 0 || appointmentDate == null || symptoms == null || symptoms.trim().isEmpty()) {
                request.setAttribute("error", "Please fill all required fields");
                request.setAttribute("doctors", appointmentDAO.getAllDoctors());
                request.getRequestDispatcher("/WEB-INF/views/patient/book-appointment.jsp")
                       .forward(request, response);
                return;
            }
            
            // Create appointment
            Appointment appointment = new Appointment(patientId, doctorId, appointmentDate, appointmentTime, symptoms);
            appointment.setAppointmentId(appointmentDAO.generateAppointmentId());
            
            boolean saved = appointmentDAO.saveAppointment(appointment);
            
            if (saved) {
            	response.sendRedirect(request.getContextPath() + "/patient/appointments?success=Appointment booked successfully! ID: " + appointment.getAppointmentId());
            } else {
            	 request.setAttribute("error", "Failed to book appointment. Please try again.");
            	    request.setAttribute("doctors", appointmentDAO.getAllDoctors());
            	    request.getRequestDispatcher("/WEB-INF/views/patient/book-appointment.jsp")
            	           .forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error booking appointment: " + e.getMessage());
            request.setAttribute("error", "Invalid input. Please check your entries.");
            request.setAttribute("doctors", appointmentDAO.getAllDoctors());
            request.getRequestDispatcher("/WEB-INF/views/patient/book-appointment.jsp")
                   .forward(request, response);
        }
    }
}