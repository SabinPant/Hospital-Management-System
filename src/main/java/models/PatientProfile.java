package models;

import java.sql.Date;

public class PatientProfile {
    private int id;
    private int userId;
    private Date dateOfBirth;
    private String bloodGroup;
    private String emergencyContact;
    private String medicalHistory;
    private String allergies;
    
    public PatientProfile() {}
    
    public PatientProfile(int userId) {
        this.userId = userId;
    }
    
    // Getters
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public Date getDateOfBirth() { return dateOfBirth; }
    public String getBloodGroup() { return bloodGroup; }
    public String getEmergencyContact() { return emergencyContact; }
    public String getMedicalHistory() { return medicalHistory; }
    public String getAllergies() { return allergies; }
    
    // Setters
    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public void setEmergencyContact(String emergencyContact) { this.emergencyContact = emergencyContact; }
    public void setMedicalHistory(String medicalHistory) { this.medicalHistory = medicalHistory; }
    public void setAllergies(String allergies) { this.allergies = allergies; }
}