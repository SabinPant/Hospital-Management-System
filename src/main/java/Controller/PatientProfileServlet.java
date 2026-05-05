package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

import dao.PatientDAO;
import dao.UserDAO;
import utils.SessionUtil;

@WebServlet("/patient/profile")
public class PatientProfileServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        patientDAO = new PatientDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isPatient(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = SessionUtil.getUserId(session);
        
        // Load profile image into session
        String profileImage = userDAO.getProfileImage(userId);
        if (profileImage != null) {
            session.setAttribute("profile_image", profileImage);
        }
        
        // Load patient profile details into session
        Map<String, Object> patientProfile = patientDAO.getPatientProfileDetails(userId);
        if (patientProfile != null) {
            session.setAttribute("emergency_contact", patientProfile.get("emergency_contact"));
            session.setAttribute("medical_history", patientProfile.get("medical_history"));
            session.setAttribute("allergies", patientProfile.get("allergies"));
            session.setAttribute("address", patientProfile.get("address"));
        }
        
        request.getRequestDispatcher("/WEB-INF/views/patient/profile.jsp")
               .forward(request, response);
    }
}