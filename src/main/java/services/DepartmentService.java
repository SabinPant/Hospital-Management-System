package services;

import dao.DepartmentDAO;
import models.Department;

public class DepartmentService {
    private DepartmentDAO departmentDAO;
    
    public DepartmentService() {
        this.departmentDAO = new DepartmentDAO();
    }
    
    /**
     * Validates and adds a new department.
     * Returns error message if validation fails, null if success.
     */
    public String addDepartment(String deptCode, String name, String description, String headDoctorId) {
        // Validate code
        if (deptCode == null || deptCode.trim().isEmpty()) {
            return "Department code is required";
        }
        
        // Validate name
        if (name == null || name.trim().isEmpty()) {
            return "Department name is required";
        }
        
        // Check uniqueness
        if (departmentDAO.isDeptCodeExists(deptCode)) {
            return "Department code already exists";
        }
        
        if (departmentDAO.isDeptNameExists(name)) {
            return "Department name already exists";
        }
        
        // Build department object
        Department dept = new Department();
        dept.setDeptCode(deptCode.toUpperCase());
        dept.setName(name);
        dept.setDescription(description);
        dept.setHeadDoctorId(headDoctorId != null && !headDoctorId.isEmpty() ? Integer.parseInt(headDoctorId) : null);
        dept.setStatus("active");
        
        // Save
        boolean added = departmentDAO.addDepartment(dept);
        
        if (!added) {
            return "Failed to add department";
        }
        
        return null; // Success
    }
    
    /**
     * Validates and updates an existing department.
     * Returns error message if validation fails, null if success.
     */
    public String updateDepartment(int id, String deptCode, String name, String description, 
                                    String headDoctorId, String status) {
        if (name == null || name.trim().isEmpty()) {
            return "Department name is required";
        }
        
        Department dept = new Department();
        dept.setId(id);
        dept.setDeptCode(deptCode);
        dept.setName(name);
        dept.setDescription(description);
        dept.setHeadDoctorId(headDoctorId != null && !headDoctorId.isEmpty() ? Integer.parseInt(headDoctorId) : null);
        dept.setStatus(status);
        
        boolean updated = departmentDAO.updateDepartment(dept);
        
        if (!updated) {
            return "Failed to update department";
        }
        
        return null; // Success
    }
    
    /**
     * Deletes a department.
     * Returns error message if it can't be deleted, null if success.
     */
    public String deleteDepartment(int id) {
        // Check if department has assigned doctors
        Department dept = departmentDAO.getDepartmentById(id);
        if (dept != null && dept.getDoctorCount() > 0) {
            return "Cannot delete department with assigned doctors";
        }
        
        boolean deleted = departmentDAO.deleteDepartment(id);
        
        if (!deleted) {
            return "Failed to delete department";
        }
        
        return null; // Success
    }
}