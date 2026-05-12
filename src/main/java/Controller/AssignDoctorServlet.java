package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import services.AppointmentService;
import utils.SessionUtil;

@WebServlet("/admin/assign-doctor")
public class AssignDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentService appointmentService;
    
    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
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
        	String newDate = request.getParameter("newDate");
        	String newTime = request.getParameter("newTime");
        	
        	
        	if (doctorId <= 0) {
        	    response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&error=Please select a doctor");
        	    return;
        	}

        	String error = appointmentService.assignDoctorToRequest(appointmentId, doctorId, adminId, newDate, newTime);
            
            if (error == null) {
                response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&success=Doctor assigned successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&error=" + java.net.URLEncoder.encode(error, "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&error=Invalid data");
        } catch (Exception e) {
            System.err.println("Error in AssignDoctorServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/appointments?status=requests&error=An error occurred");
        }
    }
}