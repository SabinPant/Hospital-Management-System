package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import models.Appointment;
import utils.DBConnection;

public class AppointmentDAO {
    
	// Generate appointment ID (APT-2026-0001 format)
	public String generateAppointmentId() {
	    String query = "SELECT appointment_id FROM appointments ORDER BY id DESC LIMIT 1";
	    int currentYear = java.time.Year.now().getValue();
	    
	    try (Connection conn = DBConnection.getConnection();
	         Statement stmt = conn.createStatement();
	         ResultSet rs = stmt.executeQuery(query)) {
	        
	        int lastNumber = 0;
	        if (rs.next()) {
	            String lastId = rs.getString("appointment_id");
	            // Extract the number part (last 4 digits)
	            String numberPart = lastId.substring(lastId.length() - 4);
	            try {
	                lastNumber = Integer.parseInt(numberPart);
	            } catch (NumberFormatException e) {
	                lastNumber = 0;
	            }
	        }
	        
	        int nextNumber = lastNumber + 1;
	        String newId = String.format("APT-%d-%04d", currentYear, nextNumber);
	        System.out.println("Generated new appointment ID: " + newId);
	        return newId;
	        
	    } catch (SQLException e) {
	        System.err.println("Error generating appointment ID: " + e.getMessage());
	        return String.format("APT-%d-0001", currentYear);
	    }
	}
    
    // Save appointment
    public boolean saveAppointment(Appointment appointment) {
        String query = "INSERT INTO appointments (appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, symptoms) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, appointment.getAppointmentId());
            pstmt.setInt(2, appointment.getPatientId());
            pstmt.setInt(3, appointment.getDoctorId());
            pstmt.setDate(4, appointment.getAppointmentDate());
            pstmt.setTime(5, appointment.getAppointmentTime());
            pstmt.setString(6, appointment.getStatus());
            pstmt.setString(7, appointment.getSymptoms());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        appointment.setId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("Appointment saved: " + appointment.getAppointmentId());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error saving appointment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Get all doctors (for booking dropdown)
    public List<Appointment> getAllDoctors() {
        List<Appointment> doctors = new ArrayList<>();
        String query = "SELECT u.id, u.full_name, dp.specialization, dp.consultation_fee " +
                       "FROM users u " +
                       "JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "WHERE u.user_type = 'doctor' AND dp.approval_status = 'approved' " +
                       "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Appointment doctor = new Appointment();
                doctor.setDoctorId(rs.getInt("id"));
                doctor.setDoctorName(rs.getString("full_name"));
                doctor.setDoctorSpecialization(rs.getString("specialization"));
                doctor.setConsultationFee(rs.getDouble("consultation_fee"));
                doctors.add(doctor);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctors: " + e.getMessage());
            e.printStackTrace();
        }
        
        return doctors;
    }
    
    // Get appointments by patient ID
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, u.full_name as doctor_name, dp.specialization " +
                       "FROM appointments a " +
                       "JOIN users u ON a.doctor_id = u.id " +
                       "JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "WHERE a.patient_id = ? " +
                       "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, patientId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Appointment apt = extractAppointmentFromResultSet(rs);
                apt.setDoctorName(rs.getString("doctor_name"));
                apt.setDoctorSpecialization(rs.getString("specialization"));
                appointments.add(apt);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting patient appointments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    // Get upcoming appointments (for dashboard)
    public List<Appointment> getUpcomingAppointments(int patientId, int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, u.full_name as doctor_name, dp.specialization " +
                       "FROM appointments a " +
                       "JOIN users u ON a.doctor_id = u.id " +
                       "JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "WHERE a.patient_id = ? AND a.status IN ('pending', 'confirmed') " +
                       "AND a.appointment_date >= CURDATE() " +
                       "ORDER BY a.appointment_date ASC, a.appointment_time ASC " +
                       "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, patientId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Appointment apt = extractAppointmentFromResultSet(rs);
                apt.setDoctorName(rs.getString("doctor_name"));
                apt.setDoctorSpecialization(rs.getString("specialization"));
                appointments.add(apt);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting upcoming appointments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    // Cancel appointment
    public boolean cancelAppointment(int appointmentId, String reason) {
        String query = "UPDATE appointments SET status = 'cancelled', cancellation_reason = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, reason);
            pstmt.setInt(2, appointmentId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error cancelling appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Helper method to extract appointment from ResultSet
    private Appointment extractAppointmentFromResultSet(ResultSet rs) throws SQLException {
        Appointment apt = new Appointment();
        apt.setId(rs.getInt("id"));
        apt.setAppointmentId(rs.getString("appointment_id"));
        apt.setPatientId(rs.getInt("patient_id"));
        apt.setDoctorId(rs.getInt("doctor_id"));
        apt.setAppointmentDate(rs.getDate("appointment_date"));
        apt.setAppointmentTime(rs.getTime("appointment_time"));
        apt.setStatus(rs.getString("status"));
        apt.setSymptoms(rs.getString("symptoms"));
        apt.setDiagnosis(rs.getString("diagnosis"));
        apt.setPrescription(rs.getString("prescription"));
        apt.setNotes(rs.getString("notes"));
        apt.setCancellationReason(rs.getString("cancellation_reason"));
        apt.setCreatedAt(rs.getTimestamp("created_at"));
        apt.setUpdatedAt(rs.getTimestamp("updated_at"));
        return apt;
    }
}