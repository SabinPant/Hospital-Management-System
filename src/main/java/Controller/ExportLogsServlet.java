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

import dao.SystemLogDAO;

@WebServlet("/admin/export-logs")
public class ExportLogsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SystemLogDAO systemLogDAO;
    
    @Override
    public void init() throws ServletException {
        systemLogDAO = new SystemLogDAO();
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
        response.setHeader("Content-Disposition", "attachment; filename=\"system_logs_" + System.currentTimeMillis() + ".csv\"");
        
        try (PrintWriter writer = response.getWriter()) {
            
            // CSV Header
            writer.println("Timestamp,User,Type,Action,Details,IP Address");
            
            // Get data from DAO
            List<Map<String, Object>> logs = systemLogDAO.getAllLogsForExport();
            
            for (Map<String, Object> log : logs) {
                String timestamp = log.get("created_at").toString();
                String actor = (String) log.get("actor_name");
                String type = (String) log.get("actor_type");
                String action = (String) log.get("action");
                String details = log.get("details") != null ? ((String) log.get("details")).replace(",", ";") : "";
                String ip = log.get("ip_address") != null ? (String) log.get("ip_address") : "";
                
                writer.println(String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",
                    timestamp, actor, type, action, details, ip));
            }
            
            writer.flush();
            
        } catch (Exception e) {
            System.err.println("Error exporting logs: " + e.getMessage());
            e.printStackTrace();
        }
    }
}