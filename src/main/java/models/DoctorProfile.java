package models;

import java.sql.Timestamp;

public class DoctorProfile {
    private int id;
    private int userId;
    private String specialization;
    private String qualification;
    private String licenseNumber;
    private int experienceYears;
    private double consultationFee;
    private String bio;
    private String approvalStatus;  // pending, approved, rejected
    private String rejectionReason;
    private Integer approvedBy;
    private Timestamp approvedAt;
    private String licenseImage;

    public DoctorProfile() {}
    
    public DoctorProfile(int userId, String specialization, String qualification, 
                         String licenseNumber, int experienceYears, double consultationFee) {
        this.userId = userId;
        this.specialization = specialization;
        this.qualification = qualification;
        this.licenseNumber = licenseNumber;
        this.experienceYears = experienceYears;
        this.consultationFee = consultationFee;
        this.approvalStatus = "pending";
    }
    
    // Getters
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getSpecialization() { return specialization; }
    public String getQualification() { return qualification; }
    public String getLicenseNumber() { return licenseNumber; }
    public int getExperienceYears() { return experienceYears; }
    public double getConsultationFee() { return consultationFee; }
    public String getBio() { return bio; }
    public String getApprovalStatus() { return approvalStatus; }
    public String getRejectionReason() { return rejectionReason; }
    public Integer getApprovedBy() { return approvedBy; }
    public Timestamp getApprovedAt() { return approvedAt; }
    public String getLicenseImage() { return licenseImage; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }
    public void setQualification(String qualification) { this.qualification = qualification; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }
    public void setConsultationFee(double consultationFee) { this.consultationFee = consultationFee; }
    public void setBio(String bio) { this.bio = bio; }
    public void setApprovalStatus(String approvalStatus) { this.approvalStatus = approvalStatus; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
    public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }
    public void setLicenseImage(String licenseImage) { this.licenseImage = licenseImage; }

}