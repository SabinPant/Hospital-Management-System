package models;

import java.sql.Timestamp;

public class Department {
    private int id;
    private String deptCode;
    private String name;
    private String description;
    private Integer headDoctorId;
    private String headDoctorName;  // For display
    private int doctorCount;         // For display
    private String status;
    private Timestamp createdAt;
    
    // Constructors
    public Department() {}
    
    public Department(String deptCode, String name, String description, Integer headDoctorId) {
        this.deptCode = deptCode;
        this.name = name;
        this.description = description;
        this.headDoctorId = headDoctorId;
        this.status = "active";
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getDeptCode() { return deptCode; }
    public void setDeptCode(String deptCode) { this.deptCode = deptCode; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Integer getHeadDoctorId() { return headDoctorId; }
    public void setHeadDoctorId(Integer headDoctorId) { this.headDoctorId = headDoctorId; }
    
    public String getHeadDoctorName() { return headDoctorName; }
    public void setHeadDoctorName(String headDoctorName) { this.headDoctorName = headDoctorName; }
    
    public int getDoctorCount() { return doctorCount; }
    public void setDoctorCount(int doctorCount) { this.doctorCount = doctorCount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}