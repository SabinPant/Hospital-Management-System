package services;

import dao.AppointmentDAO;
import dao.BillingDAO;
import dao.NotificationDAO;
import models.Appointment;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

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
    
 // Business logic: Book a new appointment
    public boolean bookAppointment(int patientId, int doctorId, Date appointmentDate, Time appointmentTime, String symptoms) {
        // Business rule: Cannot book appointment in the past
        Date today = new Date(System.currentTimeMillis());
        if (appointmentDate.before(today)) {
            return false;
        }
        
        // Create appointment
        Appointment appointment = new Appointment(patientId, doctorId, appointmentDate, appointmentTime, symptoms);
        appointment.setAppointmentId(appointmentDAO.generateAppointmentId());
        
        boolean saved = appointmentDAO.saveAppointment(appointment);
        
        if (saved) {
            // Add notification
            String doctorName = appointmentDAO.getDoctorNameByAppointmentId(appointment.getId());
            notificationDAO.addNotification(patientId, "Appointment Booked", 
                "Your appointment with Dr. " + doctorName + " on " + appointmentDate + " at " + appointmentTime + " has been booked. Awaiting confirmation.", "info");
        }
        
        return saved;
    }
    
 // Get all approved doctors (for booking page)
    public List<Appointment> getAllDoctors() {
        return appointmentDAO.getAllDoctors();
    }
    
}