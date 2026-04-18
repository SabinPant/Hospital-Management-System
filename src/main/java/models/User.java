package models;

import java.sql.Timestamp;

public class User {
    private int id;
    private String userId;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private String gender;
    private String phone;
    private String address;
    private String userType;
    private String status;
    private String lockReason;
    private Timestamp lockedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public User() {}
    
    public User(String username, String email, String password, String fullName, String userType) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.userType = userType;
        this.status = "active";
    }
    
    // Getters
    public int getId() { return id; }
    public String getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getFullName() { return fullName; }
    public String getGender() { return gender; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public String getUserType() { return userType; }
    public String getStatus() { return status; }
    public String getLockReason() { return lockReason; }
    public Timestamp getLockedAt() { return lockedAt; }
    public Timestamp getCreatedAt() { return createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    
    // Setters
    public void setId(int id) { this.id = id; }
    public void setUserId(String userId) { this.userId = userId; }
    public void setUsername(String username) { this.username = username; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setGender(String gender) { this.gender = gender; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setAddress(String address) { this.address = address; }
    public void setUserType(String userType) { this.userType = userType; }
    public void setStatus(String status) { this.status = status; }
    public void setLockReason(String lockReason) { this.lockReason = lockReason; }
    public void setLockedAt(Timestamp lockedAt) { this.lockedAt = lockedAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}