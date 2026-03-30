package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.ContactMessage;
import utils.DBConnection;

public class ContactDAO {
    
    // Save contact message to database
    public boolean saveMessage(ContactMessage message) {
        String query = "INSERT INTO contact_messages (name, email, phone, subject, message) VALUES (?, ?, ?, ?, ?)";
        
        System.out.println("Attempting to save message...");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn == null) {
                System.err.println("Connection is null! Cannot save message.");
                return false;
            }
            
            System.out.println("Connection obtained, preparing statement...");
            
            pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, message.getName());
            pstmt.setString(2, message.getEmail());
            pstmt.setString(3, message.getPhone());
            pstmt.setString(4, message.getSubject());
            pstmt.setString(5, message.getMessage());
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        message.setId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("Contact message saved successfully!");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("SQL Error saving contact message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    // Get all contact messages
    public List<ContactMessage> getAllMessages() {
        List<ContactMessage> messages = new ArrayList<>();
        String query = "SELECT * FROM contact_messages ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                ContactMessage message = new ContactMessage();
                message.setId(rs.getInt("id"));
                message.setName(rs.getString("name"));
                message.setEmail(rs.getString("email"));
                message.setPhone(rs.getString("phone"));
                message.setSubject(rs.getString("subject"));
                message.setMessage(rs.getString("message"));
                message.setCreatedAt(rs.getTimestamp("created_at"));
                messages.add(message);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting messages: " + e.getMessage());
            e.printStackTrace();
        }
        
        return messages;
    }
}