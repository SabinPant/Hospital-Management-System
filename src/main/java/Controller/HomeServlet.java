package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dao.UserDAO;
import dao.AppointmentDAO;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        appointmentDAO = new AppointmentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int doctorCount = userDAO.getApprovedDoctorCount();
        int patientCount = userDAO.getPatientCount();
        int completedCount = appointmentDAO.getCompletedAppointmentCount();
        
        request.setAttribute("doctorCount", doctorCount);
        request.setAttribute("patientCount", patientCount);
        request.setAttribute("completedCount", completedCount);
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}