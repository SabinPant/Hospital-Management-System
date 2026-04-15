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

import dao.FinanceDAO;

@WebServlet("/admin/export-finance")
public class ExportFinanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FinanceDAO financeDAO;
    
    @Override
    public void init() throws ServletException {
        financeDAO = new FinanceDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"finance_report_" + System.currentTimeMillis() + ".csv\"");
        
        try (PrintWriter writer = response.getWriter()) {
            
            // CSV Header
            writer.println("Month,Revenue,Appointments,Average per Appointment");
            
            // Get data from DAO
            List<Map<String, Object>> financeData = financeDAO.getFinanceDataForExport();
            
            for (Map<String, Object> data : financeData) {
                String month = (String) data.get("month");
                double revenue = (double) data.get("revenue");
                int count = (int) data.get("count");
                double avg = count > 0 ? revenue / count : 0;
                
                writer.println(String.format("\"%s\",\"%.2f\",\"%d\",\"%.2f\"",
                    month, revenue, count, avg));
            }
            
            writer.flush();
            
        } catch (Exception e) {
            System.err.println("Error exporting finance: " + e.getMessage());
            e.printStackTrace();
        }
    }
}