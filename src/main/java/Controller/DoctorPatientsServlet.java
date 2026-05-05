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
@WebServlet("/doctor/patients")
public class DoctorPatientsServlet extends HttpServlet {
    /**
	 * 
	 */
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
        if (!SessionUtil.isDoctor(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int doctorId = SessionUtil.getUserId(session);
        
        // Get search parameter
        String search = request.getParameter("search");
        
        List<Map<String, Object>> patients = appointmentDAO.getDoctorPatients(doctorId);
        
        // Filter by search if provided
        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.toLowerCase().trim();
            patients.removeIf(p -> !((String) p.get("full_name")).toLowerCase().contains(searchLower) &&
                                   !((String) p.get("email")).toLowerCase().contains(searchLower) &&
                                   !((String) p.get("phone")).toLowerCase().contains(searchLower));
        }
        
        request.setAttribute("patients", patients);
        request.setAttribute("search", search);
        
        request.getRequestDispatcher("/WEB-INF/views/doctor/patients.jsp")
               .forward(request, response);
    }
}