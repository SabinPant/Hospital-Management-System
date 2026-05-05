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
import utils.SessionUtil;

@WebServlet("/admin/departments")
public class AdminDepartmentServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private DepartmentDAO departmentDAO;
    
    @Override
    public void init() throws ServletException {
        departmentDAO = new DepartmentDAO();
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
        
        // Handle delete separately - redirect after completion
        if ("delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                boolean deleted = departmentDAO.deleteDepartment(id);
                if (deleted) {
                    session.setAttribute("success", "Department deleted successfully");
                } else {
                    session.setAttribute("error", "Cannot delete department with assigned doctors");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        // For edit - just set attribute and continue to show page
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
        
        if ("add".equals(action)) {
            String deptCode = request.getParameter("deptCode");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String headDoctorId = request.getParameter("headDoctorId");
            
            if (departmentDAO.isDeptCodeExists(deptCode)) {
                session.setAttribute("error", "Department code already exists");
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                return;
            }
            
            if (departmentDAO.isDeptNameExists(name)) {
                session.setAttribute("error", "Department name already exists");
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                return;
            }
            
            Department dept = new Department();
            dept.setDeptCode(deptCode.toUpperCase());
            dept.setName(name);
            dept.setDescription(description);
            dept.setHeadDoctorId(headDoctorId != null && !headDoctorId.isEmpty() ? Integer.parseInt(headDoctorId) : null);
            dept.setStatus("active");
            
            boolean added = departmentDAO.addDepartment(dept);
            
            if (added) {
                session.setAttribute("success", "Department added successfully");
            } else {
                session.setAttribute("error", "Failed to add department");
            }
            
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String deptCode = request.getParameter("deptCode");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String headDoctorId = request.getParameter("headDoctorId");
            String status = request.getParameter("status");
            
            Department dept = new Department();
            dept.setId(id);
            dept.setDeptCode(deptCode);
            dept.setName(name);
            dept.setDescription(description);
            dept.setHeadDoctorId(headDoctorId != null && !headDoctorId.isEmpty() ? Integer.parseInt(headDoctorId) : null);
            dept.setStatus(status);
            
            boolean updated = departmentDAO.updateDepartment(dept);
            
            if (updated) {
                session.setAttribute("success", "Department updated successfully");
            } else {
                session.setAttribute("error", "Failed to update department");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/departments");
    }
}