package services;

import dao.AppointmentDAO;
import dao.BillingDAO;
import dao.NotificationDAO;
import models.Appointment;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.time.LocalDate;

public class AppointmentService {
    private AppointmentDAO appointmentDAO;
    private NotificationDAO notificationDAO;
    private BillingDAO billingDAO;
    
    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
        this.notificationDAO = new NotificationDAO();
        this.billingDAO = new BillingDAO();
    }
    
    // Business logic: Cancel appointment (only if pending)
    public boolean cancelAppointment(int appointmentId, int userId, String reason) {
        Appointment apt = appointmentDAO.getAppointmentById(appointmentId);
        
        if (apt == null) {
            return false;
        }
        
        if (apt.getPatientId() != userId) {
            return false;
        }
        
        if (!"pending".equals(apt.getStatus())) {
            return false;
        }
        
        if (reason == null || reason.isEmpty()) {
            reason = "Cancelled by patient";
        }
        
        boolean cancelled = appointmentDAO.cancelAppointment(appointmentId, reason);
        
        if (cancelled) {
            String doctorName = appointmentDAO.getDoctorNameByAppointmentId(appointmentId);
            notificationDAO.addNotification(apt.getPatientId(), "Appointment Cancelled", 
                "Your appointment with Dr. " + doctorName + " has been cancelled. Reason: " + reason, "warning");
        }
        
        return cancelled;
    }
    
    // Business logic: Confirm appointment (only if pending)
    public boolean confirmAppointment(int appointmentId, int doctorId, String doctorName) {
        Appointment apt = appointmentDAO.getAppointmentById(appointmentId);
        
        if (apt == null) {
            return false;
        }
        
        if (apt.getDoctorId() != doctorId) {
            return false;
        }
        
        if (!"pending".equals(apt.getStatus())) {
            return false;
        }
        
        boolean confirmed = appointmentDAO.confirmAppointment(appointmentId);
        
        if (confirmed) {
            notificationDAO.addNotification(apt.getPatientId(), "Appointment Confirmed", 
                "Your appointment with Dr. " + doctorName + " has been confirmed.", "success");
        }
        
        return confirmed;
    }
    
    // Business logic: Complete appointment and generate billing
    public boolean completeAppointment(int appointmentId, int doctorId, String doctorName, String diagnosis, String prescription) {
        Appointment apt = appointmentDAO.getAppointmentById(appointmentId);
        
        if (apt == null) {
            return false;
        }
        
        // Business rule: Only assigned doctor can complete
        if (apt.getDoctorId() != doctorId) {
            return false;
        }
        
        // Business rule: Only confirmed appointments can be completed
        if (!"confirmed".equals(apt.getStatus())) {
            return false;
        }
        
        // Update appointment to completed
        boolean completed = appointmentDAO.completeAppointment(appointmentId, diagnosis, prescription);
        
        if (completed) {
            int patientId = apt.getPatientId();
            double consultationFee = billingDAO.getDoctorConsultationFee(doctorId);
            
            // Create billing record
            billingDAO.createBilling(appointmentId, patientId, doctorId, consultationFee);
            
            // Add notifications
            notificationDAO.addNotification(patientId, "Appointment Completed", 
                "Your appointment with Dr. " + doctorName + " has been completed. You can view your diagnosis and prescription in medical history.", "success");
            
            notificationDAO.addNotification(patientId, "Billing Generated", 
                "A bill of Rs " + consultationFee + " has been generated for your appointment with Dr. " + doctorName + ".", "info");
        }
        
        return completed;
    }
    
    public String bookAppointment(int patientId, int doctorId, Date appointmentDate, Time appointmentTime, String symptoms) {
        LocalDate today = LocalDate.now();
        LocalDate appointmentLocalDate = appointmentDate.toLocalDate();
        
        // Check 1: Past date
        if (appointmentLocalDate.isBefore(today)) {
            return "Cannot book appointment for past dates.";
        }
        
        // Check 2: Slot availability
        String dateStr = appointmentDate.toString();
        String timeStr = appointmentTime.toString();
        
        if (!appointmentDAO.isSlotAvailable(doctorId, dateStr, timeStr)) {
            return "This time slot is already booked. Please choose another time.";
        }
        
     // Create and save
        Appointment appointment = new Appointment(patientId, doctorId, appointmentDate, appointmentTime, symptoms);
        appointment.setRequestType("direct");
        appointment.setAppointmentId(appointmentDAO.generateAppointmentId());

        boolean saved = appointmentDAO.saveAppointment(appointment);
        
        if (saved) {
            String doctorName = appointmentDAO.getDoctorNameByAppointmentId(appointment.getId());
            notificationDAO.addNotification(patientId, "Appointment Booked", 
                "Your appointment with Dr. " + doctorName + " on " + appointmentDate + " at " + appointmentTime + " has been booked. Awaiting confirmation.", "info");
            return null; // Success — null means no error
        }
        
        return "Failed to save appointment. Please try again.";
    }
    
 // Business logic: Submit appointment request (admin-assigned flow)
    public boolean bookAppointmentRequest(int patientId, Date appointmentDate, Time appointmentTime, 
            String problemDescription, String symptoms) {

LocalDate today = LocalDate.now();
LocalDate appointmentLocalDate = appointmentDate.toLocalDate();

if (appointmentLocalDate.isBefore(today)) {
return false;
}


if (problemDescription == null || problemDescription.trim().isEmpty()) {
return false;
}


Appointment appointment = new Appointment();

appointment.setPatientId(patientId);
appointment.setDoctorId(0);
appointment.setAppointmentDate(appointmentDate);
appointment.setAppointmentTime(appointmentTime);
appointment.setStatus("admin_assigned");
appointment.setRequestType("admin_assigned");
appointment.setSymptoms(symptoms);
appointment.setProblemDescription(problemDescription);
appointment.setAppointmentId(appointmentDAO.generateAppointmentId());
boolean saved = appointmentDAO.saveAppointment(appointment);

if (saved) {
notificationDAO.addNotification(patientId, "Appointment Request Submitted", 
"Your appointment request has been submitted.", "info");
}

return saved;
}
    
    /**
     * Assigns a doctor to an admin-assigned appointment request.
     * Checks slot availability before assigning.
     * Returns error message if failed, null if success.
     */
    public String assignDoctorToRequest(int appointmentId, int doctorId, int adminId) {
        // Get appointment details for slot check
        Appointment apt = appointmentDAO.getAppointmentById(appointmentId);
        
        if (apt == null) {
            return "Appointment request not found.";
        }
        
        // Check slot availability
        String dateStr = apt.getAppointmentDate().toString();
        String timeStr = apt.getAppointmentTime().toString();
        
        if (!appointmentDAO.isSlotAvailable(doctorId, dateStr, timeStr)) {
            String doctorName = appointmentDAO.getDoctorNameById(doctorId);  
            return "Dr. " + doctorName + " is already booked at this time. Please choose another doctor.";
        }
        
        // Assign the doctor
        boolean assigned = appointmentDAO.assignDoctorToRequest(appointmentId, doctorId, adminId);
        
        if (!assigned) {
            return "Failed to assign doctor. Please try again.";
        }
        
        // Notify patient
        int patientId = apt.getPatientId();
        String doctorName = appointmentDAO.getDoctorNameById(doctorId);        notificationDAO.addNotification(patientId, "Doctor Assigned", 
            "Dr. " + doctorName + " has been assigned to your appointment request. Awaiting confirmation.", "info");
        
        // Notify doctor
        notificationDAO.addNotification(doctorId, "New Appointment Assigned", 
            "A new patient has been assigned to you by the admin. Please confirm the appointment.", "info");
        
        return null; // Success — no error
    }
    
    
 // Get all approved doctors (for booking page)
    public List<Appointment> getAllDoctors() {
        return appointmentDAO.getAllDoctors();
    }
    
}