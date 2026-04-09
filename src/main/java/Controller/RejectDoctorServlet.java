package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.DoctorDAO;

@WebServlet("/admin/reject-doctor")
public class RejectDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
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
            
            // Get rejection reason from request (optional)
            String rejectionReason = request.getParameter("reason");
            if (rejectionReason == null || rejectionReason.isEmpty()) {
                rejectionReason = "Application does not meet our requirements";
            }
            
            // Update doctor rejection status
            boolean updated = doctorDAO.rejectDoctor(doctorId, adminId, rejectionReason);
            
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=Doctor rejected");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=Failed to reject doctor");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=Invalid doctor ID");
        }
    }
}