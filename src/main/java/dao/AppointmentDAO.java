package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.Appointment;
import utils.DBConnection;
import java.util.Map;
import java.util.HashMap;

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
    
 // Get all appointments with optional status filter and search
    public List<Map<String, Object>> getAllAppointments(String status, String search) {
        List<Map<String, Object>> appointments = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT a.id, a.appointment_id, a.appointment_date, a.appointment_time, a.status, " +
            "a.symptoms, a.diagnosis, a.prescription, a.cancellation_reason, " +
            "p.full_name as patient_name, p.email as patient_email, p.phone as patient_phone, " +
            "d.full_name as doctor_name, dp.specialization " +
            "FROM appointments a " +
            "JOIN users p ON a.patient_id = p.id " +
            "JOIN users d ON a.doctor_id = d.id " +
            "LEFT JOIN doctor_profiles dp ON d.id = dp.user_id " +
            "WHERE 1=1"
        );
        
        if (status != null && !status.trim().isEmpty() && !"all".equals(status)) {
            query.append(" AND a.status = ?");
        }
        
        if (search != null && !search.trim().isEmpty()) {
            query.append(" AND (p.full_name LIKE ? OR d.full_name LIKE ? OR a.appointment_id LIKE ?)");
        }
        
        query.append(" ORDER BY a.appointment_date DESC, a.appointment_time DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
            
            int paramIndex = 1;
            if (status != null && !status.trim().isEmpty() && !"all".equals(status)) {
                pstmt.setString(paramIndex++, status);
            }
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
            }
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> apt = new HashMap<>();
                apt.put("id", rs.getInt("id"));
                apt.put("appointment_id", rs.getString("appointment_id"));
                apt.put("appointment_date", rs.getDate("appointment_date"));
                apt.put("appointment_time", rs.getString("appointment_time"));
                apt.put("status", rs.getString("status"));
                apt.put("symptoms", rs.getString("symptoms"));
                apt.put("diagnosis", rs.getString("diagnosis"));
                apt.put("prescription", rs.getString("prescription"));
                apt.put("cancellation_reason", rs.getString("cancellation_reason"));
                apt.put("patient_name", rs.getString("patient_name"));
                apt.put("patient_email", rs.getString("patient_email"));
                apt.put("patient_phone", rs.getString("patient_phone"));
                apt.put("doctor_name", rs.getString("doctor_name"));
                apt.put("specialization", rs.getString("specialization"));
                appointments.add(apt);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting appointments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return appointments;
    }
    
 // Get appointment details by ID for admin
    public Map<String, Object> getAppointmentDetailsForAdmin(int appointmentId) {
        Map<String, Object> data = new HashMap<>();
        String query = "SELECT a.*, " +
                       "p.full_name as patient_name, p.email as patient_email, p.phone as patient_phone, " +
                       "d.full_name as doctor_name, " +
                       "dp.specialization " +
                       "FROM appointments a " +
                       "JOIN users p ON a.patient_id = p.id " +
                       "JOIN users d ON a.doctor_id = d.id " +
                       "LEFT JOIN doctor_profiles dp ON d.id = dp.user_id " +
                       "WHERE a.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                data.put("appointment_id", rs.getString("appointment_id"));
                data.put("appointment_date", rs.getDate("appointment_date").toString());
                data.put("appointment_time", rs.getString("appointment_time"));
                data.put("status", rs.getString("status"));
                data.put("symptoms", rs.getString("symptoms"));
                data.put("diagnosis", rs.getString("diagnosis"));
                data.put("prescription", rs.getString("prescription"));
                data.put("cancellation_reason", rs.getString("cancellation_reason"));
                data.put("patient_name", rs.getString("patient_name"));
                data.put("patient_email", rs.getString("patient_email"));
                data.put("patient_phone", rs.getString("patient_phone"));
                data.put("doctor_name", rs.getString("doctor_name"));
                data.put("specialization", rs.getString("specialization"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting appointment details: " + e.getMessage());
        }
        
        return data;
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
 // Get doctor's appointments by specific date (exclude completed and cancelled)
    public List<Appointment> getDoctorAppointmentsByDate(int doctorId, String date) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, u.full_name as patient_name " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
                       "WHERE a.doctor_id = ? AND a.appointment_date = ? " +
                       "AND a.status NOT IN ('completed', 'cancelled') " +
                       "ORDER BY a.appointment_time ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            pstmt.setDate(2, Date.valueOf(date));
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Appointment apt = extractAppointmentFromResultSet(rs);
                apt.setPatientName(rs.getString("patient_name"));
                appointments.add(apt);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor appointments by date: " + e.getMessage());
            e.printStackTrace();
        }
        
        return appointments;
    }
    
 // Get patient ID by appointment ID
    public int getPatientIdByAppointmentId(int appointmentId) {
        String query = "SELECT patient_id FROM appointments WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("patient_id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting patient ID: " + e.getMessage());
        }
        
        return 0;
    }

 // Get doctor's upcoming appointments (future dates) - exclude completed and cancelled
    public List<Appointment> getDoctorUpcomingAppointments(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, u.full_name as patient_name " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
                       "WHERE a.doctor_id = ? AND a.appointment_date > CURDATE() " +
                       "AND a.status NOT IN ('completed', 'cancelled') " +
                       "ORDER BY a.appointment_date ASC, a.appointment_time ASC " +
                       "LIMIT 10";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Appointment apt = extractAppointmentFromResultSet(rs);
                apt.setPatientName(rs.getString("patient_name"));
                appointments.add(apt);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor upcoming appointments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return appointments;
    }

 // Get doctor's recent completed appointments (for history)
    public List<Appointment> getDoctorRecentAppointments(int doctorId, int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, u.full_name as patient_name " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
                       "WHERE a.doctor_id = ? AND a.status = 'completed' " +
                       "ORDER BY a.appointment_date DESC, a.appointment_time DESC " +
                       "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Appointment apt = extractAppointmentFromResultSet(rs);
                apt.setPatientName(rs.getString("patient_name"));
                appointments.add(apt);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor recent appointments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return appointments;
    }

 // Get doctor's total unique patients count
    public int getDoctorTotalPatients(int doctorId) {
        String query = "SELECT COUNT(DISTINCT patient_id) as total FROM appointments WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor total patients: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
 // Get doctor's today's appointment count
    public int getDoctorTodayAppointmentCount(int doctorId) {
        String query = "SELECT COUNT(*) as count FROM appointments WHERE doctor_id = ? AND appointment_date = CURDATE()";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor today count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

 // Get doctor's pending appointments count (only pending, not confirmed)
    public int getDoctorPendingCount(int doctorId) {
        String query = "SELECT COUNT(*) as count FROM appointments WHERE doctor_id = ? AND status = 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor pending count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    // Get doctor's completed appointments count
    public int getDoctorCompletedCount(int doctorId) {
        String query = "SELECT COUNT(*) as count FROM appointments WHERE doctor_id = ? AND status = 'completed'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor completed count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

 // Get doctor name by appointment ID
    public String getDoctorNameByAppointmentId(int appointmentId) {
        String query = "SELECT u.full_name FROM appointments a " +
                       "JOIN users u ON a.doctor_id = u.id " +
                       "WHERE a.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("full_name");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor name: " + e.getMessage());
        }
        
        return "Unknown";
    }

    // Get doctor specialization by appointment ID
    public String getDoctorSpecializationByAppointmentId(int appointmentId) {
        String query = "SELECT dp.specialization FROM appointments a " +
                       "JOIN users u ON a.doctor_id = u.id " +
                       "JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "WHERE a.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("specialization");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor specialization: " + e.getMessage());
        }
        
        return "General Medicine";
    }
    
    // Get appointment by ID with patient details
    public Appointment getAppointmentById(int appointmentId) {
        String query = "SELECT a.*, u.full_name as patient_name, u.email as patient_email, u.phone as patient_phone " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
                       "WHERE a.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Appointment apt = extractAppointmentFromResultSet(rs);
                apt.setPatientName(rs.getString("patient_name"));
                apt.setPatientEmail(rs.getString("patient_email"));
                apt.setPatientPhone(rs.getString("patient_phone"));
                return apt;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting appointment by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Confirm appointment (pending -> confirmed)
    public boolean confirmAppointment(int appointmentId) {
        String query = "UPDATE appointments SET status = 'confirmed' WHERE id = ? AND status = 'pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appointmentId);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Confirm appointment - Rows affected: " + rowsAffected);
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error confirming appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

 // Complete appointment with diagnosis and prescription
    public boolean completeAppointment(int appointmentId, String diagnosis, String prescription) {
        String query = "UPDATE appointments SET status = 'completed', diagnosis = ?, prescription = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, diagnosis);
            pstmt.setString(2, prescription);
            pstmt.setInt(3, appointmentId);
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Complete appointment - Rows affected: " + rowsAffected);
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error completing appointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
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
 // Get completed appointments for patient (medical history)
    public List<Appointment> getCompletedAppointmentsByPatientId(int patientId, int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT a.*, u.full_name as doctor_name, dp.specialization " +
                       "FROM appointments a " +
                       "JOIN users u ON a.doctor_id = u.id " +
                       "JOIN doctor_profiles dp ON u.id = dp.user_id " +
                       "WHERE a.patient_id = ? AND a.status = 'completed' " +
                       "ORDER BY a.appointment_date DESC " +
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
            System.err.println("Error getting completed appointments: " + e.getMessage());
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