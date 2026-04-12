package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.AppointmentDAO;
import dao.BillingDAO;

@WebServlet("/doctor/complete-appointment")
public class DoctorCompleteAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private BillingDAO billingDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        billingDAO = new BillingDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String idParam = request.getParameter("id");
        String diagnosis = request.getParameter("diagnosis");
        String prescription = request.getParameter("prescription");
        
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("error", "Invalid appointment ID");
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            int doctorId = (int) session.getAttribute("user_id");
            
            // Get patient ID
            int patientId = appointmentDAO.getPatientIdByAppointmentId(appointmentId);
            
            
            // Get consultation fee
            double consultationFee = billingDAO.getDoctorConsultationFee(doctorId);
           
            
            // Update appointment to completed
            boolean completed = appointmentDAO.completeAppointment(appointmentId, diagnosis, prescription);
            
            
            if (completed) {
                // Create billing record
                boolean billingCreated = billingDAO.createBilling(appointmentId, patientId, doctorId, consultationFee);
                System.out.println("Billing created: " + billingCreated);
                
                if (billingCreated) {
                    session.setAttribute("success", "Appointment completed and billing created");
                } else {
                    session.setAttribute("error", "Appointment completed but billing failed - check console");
                }
            } else {
                session.setAttribute("error", "Failed to complete appointment");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Number format error: " + e.getMessage());
            session.setAttribute("error", "Invalid ID format");
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
    }
}