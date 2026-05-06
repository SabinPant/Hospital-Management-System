package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import dao.AppointmentDAO;
import models.Appointment;
import utils.SessionUtil;

@WebServlet("/patient/medical-records")
public class MedicalRecordsServlet extends HttpServlet {
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
        if (!SessionUtil.isPatient(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int patientId = SessionUtil.getUserId(session);
        
        // Get all completed appointments (no limit)
        List<Appointment> records = appointmentDAO.getCompletedAppointmentsByPatientId(patientId, 100);
        request.setAttribute("medicalRecords", records);
        
        request.getRequestDispatcher("/WEB-INF/views/patient/medical-records.jsp")
               .forward(request, response);
    }
}