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

import dao.FinanceDAO;

@WebServlet("/admin/finance")
public class AdminFinanceServlet extends HttpServlet {
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
        
        // Get data from DAO
        double totalRevenue = financeDAO.getTotalRevenue();
        double monthlyRevenue = financeDAO.getMonthlyRevenue();
        int totalAppointments = financeDAO.getTotalCompletedAppointments();
        double avgRevenue = totalAppointments > 0 ? totalRevenue / totalAppointments : 0;
        
        List<Map<String, Object>> monthlyRevenueList = financeDAO.getMonthlyRevenueList();
        List<Map<String, Object>> topDoctors = financeDAO.getTopDoctors();
        List<Map<String, Object>> recentBillings = financeDAO.getRecentBillings();
        double maxRevenue = financeDAO.getMaxRevenue(monthlyRevenueList);
        
        // Set attributes
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("avgRevenue", avgRevenue);
        request.setAttribute("monthlyRevenueList", monthlyRevenueList);
        request.setAttribute("topDoctors", topDoctors);
        request.setAttribute("recentBillings", recentBillings);
        request.setAttribute("maxRevenue", maxRevenue);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-finance.jsp")
               .forward(request, response);
    }
}