package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.AppointmentDAO;
import utils.SessionUtil;

@WebServlet("/admin/appointments")
public class AdminAppointmentsServlet extends HttpServlet {
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
        if (!SessionUtil.isAdminLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        
        // Handle appointment requests tab
        if ("requests".equals(status)) {
            List<Map<String, Object>> requests = appointmentDAO.getAdminAssignedRequests();
            List<Map<String, Object>> approvedDoctors = getApprovedDoctorsForDropdown();
            request.setAttribute("appointmentRequests", requests);
            request.setAttribute("approvedDoctors", approvedDoctors);
        } else {
            // Normal appointments
            List<Map<String, Object>> appointments = appointmentDAO.getAllAppointments(status, search);
            request.setAttribute("appointments", appointments);
        }
        
        request.setAttribute("currentStatus", status);
        request.setAttribute("currentSearch", search);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-appointments.jsp")
               .forward(request, response);
    }
    
    // Get approved doctors for the assign dropdown
    private List<Map<String, Object>> getApprovedDoctorsForDropdown() {
    	
    	
    	return appointmentDAO.getApprovedDoctorsForDropdown();
    }
}