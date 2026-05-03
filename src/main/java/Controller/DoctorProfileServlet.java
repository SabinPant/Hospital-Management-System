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

import dao.DoctorDAO;
import dao.UserDAO;

@WebServlet("/doctor/profile")
public class DoctorProfileServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userType = (String) session.getAttribute("user_type");
        if (!"doctor".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int doctorId = (int) session.getAttribute("user_id");
        
        // Fetch profile image from database and update session
        String profileImage = userDAO.getProfileImage(doctorId);
        if (profileImage != null) {
            session.setAttribute("profile_image", profileImage);
        }
        
        Map<String, Object> profile = doctorDAO.getDoctorProfile(doctorId);
        Map<String, Object> earnings = doctorDAO.getDoctorEarnings(doctorId);
        List<Map<String, Object>> monthlyEarnings = doctorDAO.getMonthlyEarnings(doctorId);
        
        request.setAttribute("profile", profile);
        request.setAttribute("earnings", earnings);
        request.setAttribute("monthlyEarnings", monthlyEarnings);
        
        request.getRequestDispatcher("/WEB-INF/views/doctor/profile.jsp")
               .forward(request, response);
    }
}