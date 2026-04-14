package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import dao.SystemLogDAO;
import models.SystemLog;

@WebServlet("/admin/logs")
public class AdminLogsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SystemLogDAO systemLogDAO;
    
    @Override
    public void init() throws ServletException {
        systemLogDAO = new SystemLogDAO();
        systemLogDAO.deleteOldLogs(0);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        // Get filter parameters
        String actionFilter = request.getParameter("action");
        String userTypeFilter = request.getParameter("userType");
        String search = request.getParameter("search");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        String pageParam = request.getParameter("page");
        
        // Handle "important" filter (hide VIEW_PAGE)
        if ("important".equals(actionFilter)) {
            actionFilter = "VIEW_PAGE_EXCLUDE";
        }
        
        int page = 1;
        int recordsPerPage = 30;
        
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }
        
        int offset = (page - 1) * recordsPerPage;
        
        // Get logs with filters
        List<SystemLog> logs = systemLogDAO.getLogs(actionFilter, userTypeFilter, search, dateFrom, dateTo, offset, recordsPerPage);
        int totalRecords = systemLogDAO.getLogsCount(actionFilter, userTypeFilter, search, dateFrom, dateTo);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        // Get distinct actions for filter dropdown (excluding VIEW_PAGE if needed)
        List<String> actions = systemLogDAO.getDistinctActions();
        
        request.setAttribute("logs", logs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("actions", actions);
        request.setAttribute("actionFilter", actionFilter);
        request.setAttribute("userTypeFilter", userTypeFilter);
        request.setAttribute("search", search);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-logs.jsp")
               .forward(request, response);
    }
}