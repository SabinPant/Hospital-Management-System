package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import dao.BillingDAO;

@WebServlet("/admin/export-billings")
public class ExportBillingsServlet extends HttpServlet {
    private BillingDAO billingDAO;
    
    @Override
    public void init() throws ServletException {
        billingDAO = new BillingDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"billings_" + System.currentTimeMillis() + ".csv\"");
        
        try (PrintWriter writer = response.getWriter()) {
            
            // CSV Header
            writer.println("Billing ID,Appointment ID,Patient Name,Doctor Name,Amount,Payment Status,Payment Date");
            
            // Get data from DAO
            List<Map<String, Object>> billings = billingDAO.getAllBillingsForExport();
            
            for (Map<String, Object> billing : billings) {
                writer.println(String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%.2f\",\"%s\",\"%s\"",
                    billing.get("billing_id"),
                    billing.get("appointment_id"),
                    billing.get("patient_name"),
                    billing.get("doctor_name"),
                    (double) billing.get("amount"),
                    billing.get("payment_status"),
                    billing.get("payment_date")
                ));
            }
            
            writer.flush();
            
        } catch (Exception e) {
            System.err.println("Error exporting billings: " + e.getMessage());
            e.printStackTrace();
        }
    }
}