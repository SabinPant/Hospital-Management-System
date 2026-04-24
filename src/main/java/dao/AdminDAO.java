package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import models.Admin;
import utils.DBConnection;

/**
 * Data Access Object (DAO) class for managing Admin-related database operations.
 * Handles tasks such as retrieving admin details and updating login timestamps.
 */
public class AdminDAO {
    
    /**
     * Retrieves an Admin record from the database based on the provided username.
     * * @param username The username of the administrator to search for.
     * @return An Admin object populated with the user's data, or null if no match is found.
     */
    public Admin getAdminByUsername(String username) {
        // Define the SQL query to fetch the admin by exact username match
        String query = "SELECT * FROM admins WHERE username = ?";
        
        // Use try-with-resources to ensure database connections and statements are closed automatically
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            // Bind the username parameter to the query to prevent SQL injection
            pstmt.setString(1, username);
            
            // Execute the query and store the results
            ResultSet rs = pstmt.executeQuery();
            
            // If a record is found, map the database row to a new Admin model
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                admin.setFullName(rs.getString("full_name"));
                admin.setRole(rs.getString("role"));
                admin.setStatus(rs.getString("status"));
                admin.setLastLogin(rs.getTimestamp("last_login"));
                admin.setCreatedAt(rs.getTimestamp("created_at"));
                
                return admin;
            }
            
        } catch (SQLException e) {
            // Log the exception details for debugging purposes
            System.err.println("Error getting admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Return null if the admin was not found or an error occurred
        return null;
    }
    
    /**
     * Updates the last_login timestamp for a specific admin.
     * * @param adminId The unique identifier of the admin whose login time is being updated.
     */
    public void updateLastLogin(int adminId) {
        // Define the SQL query to update the last_login column
        String query = "UPDATE admins SET last_login = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            // Set the current system time as the new login timestamp
            pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            // Bind the target admin's ID
            pstmt.setInt(2, adminId);
            
            // Execute the update operation
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("Error updating last login: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Retrieves an Admin record from the database based on their unique ID.
     * Note: This method currently maps a subset of the Admin fields.
     * * @param id The unique identifier of the administrator to search for.
     * @return An Admin object populated with the user's data, or null if no match is found.
     */
    public Admin getAdminById(int id) {
        String query = "SELECT * FROM admins WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            // Bind the ID parameter to the query
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            // If the admin exists, map the basic profile information to the model
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setFullName(rs.getString("full_name"));
                admin.setRole(rs.getString("role"));
                admin.setStatus(rs.getString("status"));
                
                return admin;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting admin by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
}