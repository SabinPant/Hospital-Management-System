package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dao.SystemLogDAO;

@WebFilter("/*")
public class LoggingFilter implements Filter {
    private SystemLogDAO systemLogDAO;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        systemLogDAO = new SystemLogDAO();
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        String uri = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();
        String ipAddress = httpRequest.getRemoteAddr();
        
        // Don't log static resources
        if (uri.contains("/CSS/") || uri.contains("/js/") || uri.contains("/images/") || uri.contains("/Public/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Don't log the logs page itself
        if (uri.contains("/admin/logs") || uri.contains("/admin/export-logs")) {
            chain.doFilter(request, response);
            return;
        }
        
        // For login requests, capture email/username before processing
        String email = httpRequest.getParameter("email");
        String username = httpRequest.getParameter("username");
        
        // Determine action from URL
        String action = determineAction(uri, method);
        
        // Skip logging for IGNORE actions
        if ("IGNORE".equals(action)) {
            chain.doFilter(request, response);
            return;
        }
        
        String entityType = determineEntityType(uri);
        Integer entityId = extractEntityId(httpRequest);
        
        // For non-login actions, try to get user from session BEFORE processing
        Integer adminId = null;
        Integer userId = null;
        String actorName = "System";
        String actorType = "System";
        
        if (!action.equals("LOGIN") && !action.equals("ADMIN_LOGIN") && !action.equals("REGISTER")) {
            HttpSession session = httpRequest.getSession(false);
            if (session != null) {
                if (session.getAttribute("admin_id") != null) {
                    adminId = (Integer) session.getAttribute("admin_id");
                    actorName = (String) session.getAttribute("admin_name");
                    actorType = "Admin";
                } else if (session.getAttribute("user_id") != null) {
                    userId = (Integer) session.getAttribute("user_id");
                    actorName = (String) session.getAttribute("full_name");
                    actorType = (String) session.getAttribute("user_type");
                }
            }
        }
        
        // Process the request first
        chain.doFilter(request, response);
        
        // For login actions, get user from session AFTER processing
        if (action.equals("LOGIN") || action.equals("ADMIN_LOGIN") || action.equals("REGISTER")) {
            HttpSession session = httpRequest.getSession(false);
            if (session != null) {
                if (session.getAttribute("admin_id") != null) {
                    adminId = (Integer) session.getAttribute("admin_id");
                    actorName = (String) session.getAttribute("admin_name");
                    actorType = "Admin";
                } else if (session.getAttribute("user_id") != null) {
                    userId = (Integer) session.getAttribute("user_id");
                    actorName = (String) session.getAttribute("full_name");
                    actorType = (String) session.getAttribute("user_type");
                }
            }
        }
        
        String details = buildDetails(httpRequest, action, email, username);
        
        // Log the action
        systemLogDAO.addLog(adminId, userId, action, entityType, entityId, details, ipAddress);
        System.out.println("[LOG] " + action + " by " + actorType + " (" + actorName + ") from " + ipAddress);
    }
    
    private String determineAction(String uri, String method) {
        // Admin actions
        if (uri.contains("/admin/approve-doctor")) return "APPROVE_DOCTOR";
        if (uri.contains("/admin/reject-doctor")) return "REJECT_DOCTOR";
        if (uri.contains("/admin/lock-user")) return "LOCK_USER";
        if (uri.contains("/admin/unlock-user")) return "UNLOCK_USER";
        
        // Login/Logout actions
        if (uri.contains("/login") && !uri.contains("/admin")) return "LOGIN";
        if (uri.contains("/logout") && !uri.contains("/admin")) return "LOGOUT";
        if (uri.contains("/admin/login")) return "ADMIN_LOGIN";
        if (uri.contains("/admin/logout")) return "ADMIN_LOGOUT";
        
        // Registration
        if (uri.contains("/register")) return "REGISTER";
        
        // Appointment actions
        if (uri.contains("/patient/book-appointment") && "POST".equals(method)) return "BOOK_APPOINTMENT";
        if (uri.contains("/patient/cancel-appointment")) return "CANCEL_APPOINTMENT";
        if (uri.contains("/doctor/confirm-appointment")) return "CONFIRM_APPOINTMENT";
        if (uri.contains("/doctor/complete-appointment")) return "COMPLETE_APPOINTMENT";
        
        // Ignore all other page views (dashboard, finance, users, logs, etc.)
        return "IGNORE";
    }
    
    private String determineEntityType(String uri) {
        if (uri.contains("/doctor")) return "DOCTOR";
        if (uri.contains("/user")) return "USER";
        if (uri.contains("/appointment")) return "APPOINTMENT";
        if (uri.contains("/admin")) return "ADMIN";
        return "SYSTEM";
    }
    
    private Integer extractEntityId(HttpServletRequest request) {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                return Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
    
    private String buildDetails(HttpServletRequest request, String action, String email, String username) {
        StringBuilder details = new StringBuilder();
        
        switch (action) {
            case "APPROVE_DOCTOR":
            case "REJECT_DOCTOR":
                String doctorId = request.getParameter("id");
                String reason = request.getParameter("reason");
                details.append("Doctor ID: ").append(doctorId);
                if (reason != null) details.append(", Reason: ").append(reason);
                break;
                
            case "LOCK_USER":
            case "UNLOCK_USER":
                String userId = request.getParameter("id");
                String lockReason = request.getParameter("reason");
                details.append("User ID: ").append(userId);
                if (lockReason != null) details.append(", Reason: ").append(lockReason);
                break;
                
            case "LOGIN":
                details.append("Login: ").append(email != null ? email : "unknown");
                break;
                
            case "ADMIN_LOGIN":
                details.append("Admin Login: ").append(username != null ? username : "unknown");
                break;
                
            case "LOGOUT":
                details.append("User logged out");
                break;
                
            case "ADMIN_LOGOUT":
                details.append("Admin logged out");
                break;
                
            case "REGISTER":
                details.append("New user registered: ").append(email != null ? email : "unknown");
                break;
                
            case "BOOK_APPOINTMENT":
                String doctorIdParam = request.getParameter("doctorId");
                String appointmentDate = request.getParameter("appointmentDate");
                details.append("Doctor ID: ").append(doctorIdParam).append(", Date: ").append(appointmentDate);
                break;
                
            case "CANCEL_APPOINTMENT":
            case "CONFIRM_APPOINTMENT":
            case "COMPLETE_APPOINTMENT":
                String aptId = request.getParameter("id");
                details.append("Appointment ID: ").append(aptId);
                break;
                
            default:
                details.append("Action: ").append(action);
        }
        
        return details.toString();
    }
    
    @Override
    public void destroy() {
        // Cleanup
    }
}