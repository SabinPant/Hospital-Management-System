package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import models.SystemLog;
import utils.DBConnection;

public class SystemLogDAO {
    
	public boolean addLog(Integer adminId, Integer userId, String action, 
            String entityType, Integer entityId, String details, String ipAddress) {
String query = "INSERT INTO system_logs (admin_id, user_id, action, entity_type, entity_id, details, ip_address, created_at) " +
         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

try (Connection conn = DBConnection.getConnection();
PreparedStatement pstmt = conn.prepareStatement(query)) {

// Handle null values properly
if (adminId != null) {
  pstmt.setInt(1, adminId);
} else {
  pstmt.setNull(1, java.sql.Types.INTEGER);
}

if (userId != null) {
  pstmt.setInt(2, userId);
} else {
  pstmt.setNull(2, java.sql.Types.INTEGER);
}

pstmt.setString(3, action);
pstmt.setString(4, entityType);

if (entityId != null) {
  pstmt.setInt(5, entityId);
} else {
  pstmt.setNull(5, java.sql.Types.INTEGER);
}

pstmt.setString(6, details);
pstmt.setString(7, ipAddress);
pstmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));

int rowsAffected = pstmt.executeUpdate();
return rowsAffected > 0;

} catch (SQLException e) {
System.err.println("Error adding system log: " + e.getMessage());
e.printStackTrace();
return false;
}
}
    
    // Get logs with filters (7 parameters version)
    public List<SystemLog> getLogs(String actionFilter, String userTypeFilter, String search, 
                                    String dateFrom, String dateTo, int offset, int limit) {
        List<SystemLog> logs = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT l.*, " +
            "CASE " +
            "  WHEN l.admin_id IS NOT NULL THEN a.full_name " +
            "  WHEN l.user_id IS NOT NULL THEN u.full_name " +
            "  ELSE 'System' " +
            "END as actor_name, " +
            "CASE " +
            "  WHEN l.admin_id IS NOT NULL THEN 'Admin' " +
            "  WHEN l.user_id IS NOT NULL THEN u.user_type " +
            "  ELSE 'System' " +
            "END as actor_type " +
            "FROM system_logs l " +
            "LEFT JOIN admins a ON l.admin_id = a.id " +
            "LEFT JOIN users u ON l.user_id = u.id " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Handle action filter
        if (actionFilter != null && !actionFilter.isEmpty() && !"all".equals(actionFilter)) {
            if ("VIEW_PAGE_EXCLUDE".equals(actionFilter)) {
                query.append(" AND l.action NOT IN ('VIEW_PAGE', 'VIEW_DASHBOARD')");
            } else {
                query.append(" AND l.action = ?");
                params.add(actionFilter);
            }
        }
        
        // Handle user type filter
        if (userTypeFilter != null && !userTypeFilter.isEmpty() && !"all".equals(userTypeFilter)) {
            if ("System".equals(userTypeFilter)) {
                query.append(" AND l.admin_id IS NULL AND l.user_id IS NULL");
            } else if ("Admin".equals(userTypeFilter)) {
                query.append(" AND l.admin_id IS NOT NULL");
            } else {
                query.append(" AND u.user_type = ?");
                params.add(userTypeFilter);
            }
        }
        
        // Handle search
        if (search != null && !search.trim().isEmpty()) {
            query.append(" AND (l.details LIKE ? OR a.full_name LIKE ? OR u.full_name LIKE ? OR l.action LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Handle date range
        if (dateFrom != null && !dateFrom.isEmpty()) {
            query.append(" AND DATE(l.created_at) >= ?");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.isEmpty()) {
            query.append(" AND DATE(l.created_at) <= ?");
            params.add(dateTo);
        }
        
        query.append(" ORDER BY l.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                SystemLog log = new SystemLog();
                log.setId(rs.getInt("id"));
                log.setAdminId(rs.getInt("admin_id") == 0 ? null : rs.getInt("admin_id"));
                log.setUserId(rs.getInt("user_id") == 0 ? null : rs.getInt("user_id"));
                log.setAction(rs.getString("action"));
                log.setEntityType(rs.getString("entity_type"));
                log.setEntityId(rs.getInt("entity_id") == 0 ? null : rs.getInt("entity_id"));
                log.setDetails(rs.getString("details"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                log.setActorName(rs.getString("actor_name"));
                log.setActorType(rs.getString("actor_type"));
                logs.add(log);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting logs: " + e.getMessage());
            e.printStackTrace();
        }
        
        return logs;
    }
    
    // Get total count for pagination (5 parameters version)
    public int getLogsCount(String actionFilter, String userTypeFilter, String search, String dateFrom, String dateTo) {
        StringBuilder query = new StringBuilder(
            "SELECT COUNT(*) as count FROM system_logs l " +
            "LEFT JOIN admins a ON l.admin_id = a.id " +
            "LEFT JOIN users u ON l.user_id = u.id " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Handle action filter
        if (actionFilter != null && !actionFilter.isEmpty() && !"all".equals(actionFilter)) {
            if ("VIEW_PAGE_EXCLUDE".equals(actionFilter)) {
                query.append(" AND l.action NOT IN ('VIEW_PAGE', 'VIEW_DASHBOARD')");
            } else {
                query.append(" AND l.action = ?");
                params.add(actionFilter);
            }
        }
        
        // Handle user type filter
        if (userTypeFilter != null && !userTypeFilter.isEmpty() && !"all".equals(userTypeFilter)) {
            if ("System".equals(userTypeFilter)) {
                query.append(" AND l.admin_id IS NULL AND l.user_id IS NULL");
            } else if ("Admin".equals(userTypeFilter)) {
                query.append(" AND l.admin_id IS NOT NULL");
            } else {
                query.append(" AND u.user_type = ?");
                params.add(userTypeFilter);
            }
        }
        
        // Handle search
        if (search != null && !search.trim().isEmpty()) {
            query.append(" AND (l.details LIKE ? OR a.full_name LIKE ? OR u.full_name LIKE ? OR l.action LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Handle date range
        if (dateFrom != null && !dateFrom.isEmpty()) {
            query.append(" AND DATE(l.created_at) >= ?");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.isEmpty()) {
            query.append(" AND DATE(l.created_at) <= ?");
            params.add(dateTo);
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting logs count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Delete old logs (older than given days)
    public int deleteOldLogs(int days) {
        String query = "DELETE FROM system_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL 20 SECOND)";        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
 
            int deleted = pstmt.executeUpdate();
            System.out.println("Deleted " + deleted + " old log entries");
            return deleted;
            
        } catch (SQLException e) {
            System.err.println("Error deleting old logs: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
    
    // Get distinct action types for filter dropdown
    public List<String> getDistinctActions() {
        List<String> actions = new ArrayList<>();
        String query = "SELECT DISTINCT action FROM system_logs ORDER BY action";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                actions.add(rs.getString("action"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting distinct actions: " + e.getMessage());
            e.printStackTrace();
        }
        
        return actions;
    }
}