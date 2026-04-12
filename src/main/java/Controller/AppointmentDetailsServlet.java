package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.AppointmentDAO;
import models.Appointment;

@WebServlet("/patient/appointment-details")
public class AppointmentDetailsServlet extends HttpServlet {
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
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            Appointment apt = appointmentDAO.getAppointmentById(appointmentId);
            
            if (apt == null) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Appointment not found");
                return;
            }
            
            // Get doctor name and specialization
            String doctorName = appointmentDAO.getDoctorNameByAppointmentId(appointmentId);
            String doctorSpecialization = appointmentDAO.getDoctorSpecializationByAppointmentId(appointmentId);
            
            apt.setDoctorName(doctorName);
            apt.setDoctorSpecialization(doctorSpecialization);
            
            request.setAttribute("appointment", apt);
            request.getRequestDispatcher("/WEB-INF/views/patient/appointment-details.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=Invalid ID");
        }
    }
}