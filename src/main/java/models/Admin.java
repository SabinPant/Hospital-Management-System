package models;

import java.sql.Timestamp;

public class Admin {
    private int id;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private String role;
    private String status;
    private Timestamp lastLogin;
    private Timestamp createdAt;
    
    public Admin() {}
    
    // Getters
    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getFullName() { return fullName; }
    public String getRole() { return role; }
    public String getStatus() { return status; }
    public Timestamp getLastLogin() { return lastLogin; }
    public Timestamp getCreatedAt() { return createdAt; }
    
    // Setters
    public void setId(int id) { this.id = id; }
    public void setUsername(String username) { this.username = username; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setRole(String role) { this.role = role; }
    public void setStatus(String status) { this.status = status; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}