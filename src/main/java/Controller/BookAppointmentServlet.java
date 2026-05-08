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
import dao.AppointmentDAO;
import utils.SessionUtil;

@WebServlet("/patient/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
        appointmentDAO = new AppointmentDAO();
    }
    
    // Show booking page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get list of approved doctors (using DAO directly - this is fine as it's just data retrieval)
        request.setAttribute("doctors", appointmentDAO.getAllDoctors());
        request.getRequestDispatcher("/WEB-INF/views/patient/book-appointment.jsp")
               .forward(request, response);
    }
    
    // Process booking
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int patientId = SessionUtil.getUserId(session);
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            Date appointmentDate = Date.valueOf(request.getParameter("appointmentDate"));
            Time appointmentTime = Time.valueOf(request.getParameter("appointmentTime") + ":00");
            String symptoms = request.getParameter("symptoms");
            
            // Validate inputs
            if (doctorId == 0 || appointmentDate == null || symptoms == null || symptoms.trim().isEmpty()) {
                session.setAttribute("bookingError", "Please fill all required fields");
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
                return;
            }
            
            String result = appointmentService.bookAppointment(patientId, doctorId, appointmentDate, appointmentTime, symptoms);

            if (result == null) {
                session.setAttribute("bookingSuccess", "Appointment booked successfully!");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
            } else {
                session.setAttribute("bookingError", result);
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
            }
            
        } catch (Exception e) {
            System.err.println("Error booking appointment: " + e.getMessage());
            session.setAttribute("bookingError", "Invalid input. Please check your entries.");
            response.sendRedirect(request.getContextPath() + "/patient/book-appointment");
        }
    }
}