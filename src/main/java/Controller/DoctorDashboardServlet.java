package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import models.Appointment;
import utils.SessionUtil;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (!SessionUtil.isDoctor(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            int doctorId = SessionUtil.getUserId(session);
            
            // Get doctor's department/specialization
            String department = doctorDAO.getDoctorDepartment(doctorId);
            request.setAttribute("department", department != null ? department : "General Medicine");
            
            // Get today's appointments (ensure not null)
            List<Appointment> todayAppointments = appointmentDAO.getDoctorAppointmentsByDate(doctorId, java.time.LocalDate.now().toString());
            request.setAttribute("todayAppointments", todayAppointments != null ? todayAppointments : new ArrayList<>());
            
            // Get upcoming appointments
            List<Appointment> upcomingAppointments = appointmentDAO.getDoctorUpcomingAppointments(doctorId);
            request.setAttribute("upcomingAppointments", upcomingAppointments != null ? upcomingAppointments : new ArrayList<>());
            
            // Get recent appointments
            List<Appointment> recentAppointments = appointmentDAO.getDoctorRecentAppointments(doctorId, 10);
            request.setAttribute("recentAppointments", recentAppointments != null ? recentAppointments : new ArrayList<>());
            
            // Get stats
            request.setAttribute("totalPatients", appointmentDAO.getDoctorTotalPatients(doctorId));
            request.setAttribute("todayCount", appointmentDAO.getDoctorTodayAppointmentCount(doctorId));
            request.setAttribute("pendingCount", appointmentDAO.getDoctorPendingCount(doctorId));
            request.setAttribute("completedCount", appointmentDAO.getDoctorCompletedCount(doctorId));
            
            request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            System.err.println("Error in DoctorDashboardServlet: " + e.getMessage());
            e.printStackTrace();
           
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=1");
        }
    }
}