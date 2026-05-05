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


@WebServlet("/doctor/patient-details")
public class DoctorPatientDetailsServlet extends HttpServlet {
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
        int patientId = Integer.parseInt(request.getParameter("id"));
        String patientName = request.getParameter("name");
        
        List<Map<String, Object>> medicalHistory = appointmentDAO.getPatientMedicalHistory(doctorId, patientId);
        
        request.setAttribute("medicalHistory", medicalHistory);
        request.setAttribute("patientName", patientName);
        request.setAttribute("patientId", patientId);
        
        request.getRequestDispatcher("/WEB-INF/views/doctor/patient-details.jsp")
               .forward(request, response);
    }
}