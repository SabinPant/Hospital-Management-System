package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import dao.DepartmentDAO;
import models.Department;
import models.User;
import services.DepartmentService;
import utils.SessionUtil;

@WebServlet("/admin/departments")
public class AdminDepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DepartmentDAO departmentDAO;
    private DepartmentService departmentService;
    
    @Override
    public void init() throws ServletException {
        departmentDAO = new DepartmentDAO();
        departmentService = new DepartmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isAdminLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        // Handle delete
        if ("delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                String error = departmentService.deleteDepartment(id);
                if (error == null) {
                    session.setAttribute("success", "Department deleted successfully");
                } else {
                    session.setAttribute("error", error);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        // For edit - load department data
        if ("edit".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Department dept = departmentDAO.getDepartmentById(Integer.parseInt(idParam));
                request.setAttribute("editDepartment", dept);
            }
        }
        
        // Get all departments and doctors
        List<Department> departments = departmentDAO.getAllDepartments();
        List<User> doctors = departmentDAO.getAllApprovedDoctors();
        
        request.setAttribute("departments", departments);
        request.setAttribute("doctors", doctors);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/admin-departments.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!SessionUtil.isAdminLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String action = request.getParameter("action");
        String error = null;
        
        if ("add".equals(action)) {
            String deptCode = request.getParameter("deptCode");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String headDoctorId = request.getParameter("headDoctorId");
            
            error = departmentService.addDepartment(deptCode, name, description, headDoctorId);
            
            if (error == null) {
                session.setAttribute("success", "Department added successfully");
            } else {
                session.setAttribute("error", error);
            }
            
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String deptCode = request.getParameter("deptCode");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String headDoctorId = request.getParameter("headDoctorId");
            String status = request.getParameter("status");
            
            error = departmentService.updateDepartment(id, deptCode, name, description, headDoctorId, status);
            
            if (error == null) {
                session.setAttribute("success", "Department updated successfully");
            } else {
                session.setAttribute("error", error);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }
}