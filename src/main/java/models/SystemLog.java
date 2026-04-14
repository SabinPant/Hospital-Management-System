package models;

import java.sql.Timestamp;

public class SystemLog {
    private int id;
    private Integer adminId;
    private Integer userId;
    private String action;
    private String entityType;
    private Integer entityId;
    private String details;
    private String ipAddress;
    private Timestamp createdAt;
    
    // Additional fields for display
    private String actorName;
    private String actorType;
    
    public SystemLog() {}
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Integer getAdminId() { return adminId; }
    public void setAdminId(Integer adminId) { this.adminId = adminId; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    
    public String getEntityType() { return entityType; }
    public void setEntityType(String entityType) { this.entityType = entityType; }
    
    public Integer getEntityId() { return entityId; }
    public void setEntityId(Integer entityId) { this.entityId = entityId; }
    
    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
    
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getActorName() { return actorName; }
    public void setActorName(String actorName) { this.actorName = actorName; }
    
    public String getActorType() { return actorType; }
    public void setActorType(String actorType) { this.actorType = actorType; }
}