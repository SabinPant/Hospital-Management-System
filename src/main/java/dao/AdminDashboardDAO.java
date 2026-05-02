package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import models.AdminDashboardData;
import utils.DBConnection;

public class AdminDashboardDAO {
    
    public AdminDashboardData getDashboardData() {
        AdminDashboardData data = new AdminDashboardData();
        
        try (Connection conn = DBConnection.getConnection()) {
            
            // Total Users
            String totalUsersQuery = "SELECT COUNT(*) FROM users";
            try (PreparedStatement stmt = conn.prepareStatement(totalUsersQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) data.setTotalUsers(rs.getInt(1));
            }
            
            // Total Doctors
            String totalDoctorsQuery = "SELECT COUNT(*) FROM users WHERE user_type = 'doctor'";
            try (PreparedStatement stmt = conn.prepareStatement(totalDoctorsQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) data.setTotalDoctors(rs.getInt(1));
            }
            
            // Total Patients
            String totalPatientsQuery = "SELECT COUNT(*) FROM users WHERE user_type = 'patient'";
            try (PreparedStatement stmt = conn.prepareStatement(totalPatientsQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) data.setTotalPatients(rs.getInt(1));
            }
            
            // Pending Doctors
            String pendingDoctorsQuery = "SELECT COUNT(*) FROM doctor_profiles WHERE approval_status = 'pending'";
            try (PreparedStatement stmt = conn.prepareStatement(pendingDoctorsQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) data.setPendingDoctors(rs.getInt(1));
            }
            
            // Today's Appointments
            String todayAppointmentsQuery = "SELECT COUNT(*) FROM appointments WHERE appointment_date = CURDATE()";
            try (PreparedStatement stmt = conn.prepareStatement(todayAppointmentsQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) data.setTodayAppointments(rs.getInt(1));
            }
            
         // Total Revenue from billings
         // Total Revenue from billings - handle null
            String revenueQuery = "SELECT COALESCE(SUM(amount), 0) FROM billings WHERE payment_status = 'paid'";
            try (PreparedStatement stmt = conn.prepareStatement(revenueQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) data.setTotalRevenue(rs.getDouble(1));
            }
            
            // Total Completed Appointments
            String completedAppointmentsQuery = "SELECT COUNT(*) FROM appointments WHERE status = 'completed'";
            try (PreparedStatement stmt = conn.prepareStatement(completedAppointmentsQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) data.setTotalCompletedAppointments(rs.getInt(1));
            }
            
            // Average Revenue per Appointment
            if (data.getTotalCompletedAppointments() > 0) {
                data.setAvgRevenuePerAppointment(data.getTotalRevenue() / data.getTotalCompletedAppointments());
            }
            
            // Pending Doctors List
         // Pending Doctors List - Add more fields
            String pendingListQuery = "SELECT u.id, u.full_name, u.email, u.phone, u.address, u.created_at, " +
                                      "dp.specialization, dp.experience_years, dp.qualification, dp.license_number, dp.consultation_fee, dp.bio, dp.license_image " +
                                      "FROM users u JOIN doctor_profiles dp ON u.id = dp.user_id " +
                                      "WHERE dp.approval_status = 'pending'";
            List<Map<String, Object>> pendingDoctorsList = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(pendingListQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> doctor = new HashMap<>();
                    doctor.put("id", rs.getInt("id"));
                    doctor.put("full_name", rs.getString("full_name"));
                    doctor.put("email", rs.getString("email"));
                    doctor.put("phone", rs.getString("phone"));
                    doctor.put("address", rs.getString("address"));           
                    doctor.put("specialization", rs.getString("specialization"));
                    doctor.put("experience_years", rs.getInt("experience_years"));
                    doctor.put("qualification", rs.getString("qualification"));
                    doctor.put("license_number", rs.getString("license_number"));
                    doctor.put("consultation_fee", rs.getDouble("consultation_fee"));
                    doctor.put("bio", rs.getString("bio"));                  
                    doctor.put("license_image", rs.getString("license_image")); 
                    pendingDoctorsList.add(doctor);
                }
            }
            data.setPendingDoctorsList(pendingDoctorsList);
            
            // Today's Appointments List
            String todayAppointmentsListQuery = "SELECT a.appointment_id, a.appointment_time, a.status, " +
                                                "p.full_name as patient_name, d.full_name as doctor_name " +
                                                "FROM appointments a " +
                                                "JOIN users p ON a.patient_id = p.id " +
                                                "JOIN users d ON a.doctor_id = d.id " +
                                                "WHERE a.appointment_date = CURDATE() " +
                                                "ORDER BY a.appointment_time";
            List<Map<String, Object>> todayAppointmentsList = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(todayAppointmentsListQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    appointment.put("appointment_id", rs.getString("appointment_id"));
                    appointment.put("appointment_time", rs.getString("appointment_time"));
                    appointment.put("status", rs.getString("status"));
                    appointment.put("patient_name", rs.getString("patient_name"));
                    appointment.put("doctor_name", rs.getString("doctor_name"));
                    todayAppointmentsList.add(appointment);
                }
            }
            data.setTodayAppointmentsList(todayAppointmentsList);
            
            // Top Doctors (by completed appointments)
            String topDoctorsQuery = "SELECT d.full_name, COUNT(a.id) as appointment_count " +
                                     "FROM appointments a " +
                                     "JOIN users d ON a.doctor_id = d.id " +
                                     "WHERE a.status = 'completed' " +
                                     "GROUP BY a.doctor_id " +
                                     "ORDER BY appointment_count DESC " +
                                     "LIMIT 5";
            List<Map<String, Object>> topDoctorsList = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(topDoctorsQuery);
                 ResultSet rs = stmt.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    Map<String, Object> doctor = new HashMap<>();
                    doctor.put("rank", rank++);
                    doctor.put("full_name", rs.getString("full_name"));
                    doctor.put("appointment_count", rs.getInt("appointment_count"));
                    topDoctorsList.add(doctor);
                }
            }
            data.setTopDoctorsList(topDoctorsList);
            
            // Monthly Revenue (last 6 months)
            String monthlyRevenueQuery = "SELECT DATE_FORMAT(payment_date, '%b %Y') as month, SUM(amount) as revenue " +
                                         "FROM billings " +
                                         "WHERE payment_status = 'paid' " +
                                         "GROUP BY DATE_FORMAT(payment_date, '%Y-%m') " +
                                         "ORDER BY payment_date DESC " +
                                         "LIMIT 6";
            List<Map<String, Object>> monthlyRevenueList = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(monthlyRevenueQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> month = new HashMap<>();
                    month.put("month", rs.getString("month"));
                    month.put("revenue", rs.getDouble("revenue"));
                    monthlyRevenueList.add(month);
                }
            }
            data.setMonthlyRevenueList(monthlyRevenueList);
            
        } catch (Exception e) {
            System.err.println("Error fetching dashboard data: " + e.getMessage());
            e.printStackTrace();
        }
        
        return data;
    }
}