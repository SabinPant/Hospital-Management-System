package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import models.Notification;
import utils.DBConnection;
import java.util.HashMap;
import java.util.Map;

public class NotificationDAO {
    
    // Add notification for a user
    public boolean addNotification(int userId, String title, String message, String type) {
        String query = "INSERT INTO notifications (user_id, title, message, type, created_at) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setString(2, title);
            pstmt.setString(3, message);
            pstmt.setString(4, type);
            pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding notification: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get recent notifications for a user
    public List<Notification> getRecentNotifications(int userId, int limit) {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Notification notif = new Notification();
                notif.setId(rs.getInt("id"));
                notif.setUserId(rs.getInt("user_id"));
                notif.setTitle(rs.getString("title"));
                notif.setMessage(rs.getString("message"));
                notif.setType(rs.getString("type"));
                notif.setRead(rs.getBoolean("is_read"));
                notif.setCreatedAt(rs.getTimestamp("created_at"));
                notifications.add(notif);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting notifications: " + e.getMessage());
            e.printStackTrace();
        }
        
        return notifications;
    }
    
 // Get previous announcements (admin sent, user_id IS NULL means sent to all)
    public List<Map<String, Object>> getPreviousAnnouncements() {
        List<Map<String, Object>> announcements = new ArrayList<>();
        String query = "SELECT n.*, a.full_name as admin_name " +
                       "FROM notifications n " +
                       "JOIN admins a ON n.admin_id = a.id " +
                       "WHERE n.user_id IS NULL " +
                       "ORDER BY n.created_at DESC LIMIT 20";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> announcement = new HashMap<>();
                announcement.put("id", rs.getInt("id"));
                announcement.put("title", rs.getString("title"));
                announcement.put("message", rs.getString("message"));
                announcement.put("type", rs.getString("type"));
                announcement.put("admin_name", rs.getString("admin_name"));
                announcement.put("created_at", rs.getTimestamp("created_at"));
                announcements.add(announcement);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting announcements: " + e.getMessage());
            e.printStackTrace();
        }
        
        return announcements;
    }
    
 // Get user IDs by type (all, patients, doctors)
    public List<Integer> getUserIdsByType(String type) {
        List<Integer> userIds = new ArrayList<>();
        String query;
        
        if ("patients".equals(type)) {
            query = "SELECT id FROM users WHERE user_type = 'patient'";
        } else if ("doctors".equals(type)) {
            query = "SELECT id FROM users WHERE user_type = 'doctor'";
        } else {
            query = "SELECT id FROM users WHERE user_type IN ('patient', 'doctor')";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                userIds.add(rs.getInt("id"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user IDs: " + e.getMessage());
            e.printStackTrace();
        }
        
        return userIds;
    }
    
 // Mark notification as read
    public boolean markAsRead(int notificationId) {
        String query = "UPDATE notifications SET is_read = TRUE WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, notificationId);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error marking notification as read: " + e.getMessage());
            return false;
        }
    }
    
 // Get all notifications for a user
    public List<Map<String, Object>> getUserNotifications(int userId) {
        List<Map<String, Object>> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> notif = new HashMap<>();
                notif.put("id", rs.getInt("id"));
                notif.put("title", rs.getString("title"));
                notif.put("message", rs.getString("message"));
                notif.put("type", rs.getString("type"));
                notif.put("is_read", rs.getBoolean("is_read"));
                notif.put("created_at", rs.getTimestamp("created_at"));
                notifications.add(notif);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user notifications: " + e.getMessage());
        }
        
        return notifications;
    }

    // Get unread count for a user
    public int getUnreadCount(int userId) {
        String query = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting unread count: " + e.getMessage());
        }
        
        return 0;
    }
    
 // Mark all notifications as read for a user
    public boolean markAllAsRead(int userId) {
        String query = "UPDATE notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            int rows = pstmt.executeUpdate();
            System.out.println("Marked " + rows + " notifications as read for user " + userId);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("Error marking all as read: " + e.getMessage());
            return false;
        }
    }
}