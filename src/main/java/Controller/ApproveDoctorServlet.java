package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import services.DoctorService;

@WebServlet("/admin/approve-doctor")
public class ApproveDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;
    
    @Override
    public void init() throws ServletException {
        doctorService = new DoctorService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=Invalid doctor ID");
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(idParam);
            int adminId = (int) session.getAttribute("admin_id");
            
            boolean updated = doctorService.approveDoctor(doctorId, adminId);
            
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=Doctor approved successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=Failed to approve doctor");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=Invalid doctor ID");
        }
    }
}