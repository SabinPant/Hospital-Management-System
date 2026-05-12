package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.Department;
import utils.DBConnection;

public class DepartmentDAO {
    
    // Get all departments with doctor count and head doctor name
	
	public List<Department> getAllDepartments() {
	    List<Department> departments = new ArrayList<>();
	    String query = "SELECT d.*, " +
	                   "u.full_name as head_doctor_name, " +
	                   "(SELECT COUNT(*) FROM doctor_profiles dp WHERE dp.specialization = d.name) as doctor_count " +
	                   "FROM departments d " +
	                   "LEFT JOIN users u ON d.head_doctor_id = u.id " +
	                   "ORDER BY d.name";
	    
	    try (Connection conn = DBConnection.getConnection();
	         Statement stmt = conn.createStatement();
	         ResultSet rs = stmt.executeQuery(query)) {
	        
	        while (rs.next()) {
	            Department dept = new Department();
	            dept.setId(rs.getInt("id"));
	            dept.setDeptCode(rs.getString("dept_code"));
	            dept.setName(rs.getString("name"));
	            dept.setDescription(rs.getString("description"));
	            dept.setHeadDoctorId(rs.getInt("head_doctor_id") == 0 ? null : rs.getInt("head_doctor_id"));
	            dept.setHeadDoctorName(rs.getString("head_doctor_name"));
	            dept.setDoctorCount(rs.getInt("doctor_count"));
	            dept.setStatus(rs.getString("status"));
	            dept.setCreatedAt(rs.getTimestamp("created_at"));
	            departments.add(dept);
	        }
	        
	    } catch (SQLException e) {
	        System.err.println("Error getting departments: " + e.getMessage());
	        e.printStackTrace();
	    }
	    
	    return departments;
	}
    
    // Get department by ID
    public Department getDepartmentById(int id) {
        String query = "SELECT d.*, u.full_name as head_doctor_name " +
                       "FROM departments d " +
                       "LEFT JOIN users u ON d.head_doctor_id = u.id " +
                       "WHERE d.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setDeptCode(rs.getString("dept_code"));
                dept.setName(rs.getString("name"));
                dept.setDescription(rs.getString("description"));
                dept.setHeadDoctorId(rs.getInt("head_doctor_id") == 0 ? null : rs.getInt("head_doctor_id"));
                dept.setHeadDoctorName(rs.getString("head_doctor_name"));
                dept.setStatus(rs.getString("status"));
                dept.setCreatedAt(rs.getTimestamp("created_at"));
                return dept;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting department: " + e.getMessage());
        }
        
        return null;
    }
    
    // Check if department code exists
    public boolean isDeptCodeExists(String deptCode) {
        String query = "SELECT id FROM departments WHERE dept_code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, deptCode);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.err.println("Error checking dept code: " + e.getMessage());
        }
        
        return false;
    }
    
    // Check if department name exists
    public boolean isDeptNameExists(String name) {
        String query = "SELECT id FROM departments WHERE name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, name);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.err.println("Error checking dept name: " + e.getMessage());
        }
        
        return false;
    }
    
    // Add new department
    public boolean addDepartment(Department department) {
        String query = "INSERT INTO departments (dept_code, name, description, head_doctor_id, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, department.getDeptCode());
            pstmt.setString(2, department.getName());
            pstmt.setString(3, department.getDescription());
            pstmt.setObject(4, department.getHeadDoctorId());
            pstmt.setString(5, department.getStatus());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        department.setId(rs.getInt(1));
                    }
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error adding department: " + e.getMessage());
        }
        
        return false;
    }
    
    
    
    // Delete department (only if no doctors assigned)
    public boolean deleteDepartment(int id) {
        String query = "DELETE FROM departments WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting department: " + e.getMessage());
            return false;
        }
    }
    
    // Get all approved doctors (for head doctor dropdown)
    public List<models.User> getAllApprovedDoctors() {
        List<models.User> doctors = new ArrayList<>();
        String query = "SELECT u.id, u.full_name FROM users u " +
                       "JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "WHERE u.user_type = 'doctor' AND dp.approval_status = 'approved' " +
                       "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                models.User doctor = new models.User();
                doctor.setId(rs.getInt("id"));
                doctor.setFullName(rs.getString("full_name"));
                doctors.add(doctor);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctors: " + e.getMessage());
        }
        
        return doctors;
    }
}