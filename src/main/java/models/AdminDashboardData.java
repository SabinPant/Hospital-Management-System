package models;

import java.util.List;
import java.util.Map;

public class AdminDashboardData {
    private int totalUsers;
    private int totalDoctors;
    private int totalPatients;
    private int pendingDoctors;
    private int todayAppointments;
    private double totalRevenue;
    private int totalCompletedAppointments;
    private double avgRevenuePerAppointment;
    private List<Map<String, Object>> pendingDoctorsList;
    private List<Map<String, Object>> todayAppointmentsList;
    private List<Map<String, Object>> topDoctorsList;
    private List<Map<String, Object>> monthlyRevenueList;
    
    // Getters and Setters
    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
    
    public int getTotalDoctors() { return totalDoctors; }
    public void setTotalDoctors(int totalDoctors) { this.totalDoctors = totalDoctors; }
    
    public int getTotalPatients() { return totalPatients; }
    public void setTotalPatients(int totalPatients) { this.totalPatients = totalPatients; }
    
    public int getPendingDoctors() { return pendingDoctors; }
    public void setPendingDoctors(int pendingDoctors) { this.pendingDoctors = pendingDoctors; }
    
    public int getTodayAppointments() { return todayAppointments; }
    public void setTodayAppointments(int todayAppointments) { this.todayAppointments = todayAppointments; }
    
    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
    
    public int getTotalCompletedAppointments() { return totalCompletedAppointments; }
    public void setTotalCompletedAppointments(int totalCompletedAppointments) { this.totalCompletedAppointments = totalCompletedAppointments; }
    
    public double getAvgRevenuePerAppointment() { return avgRevenuePerAppointment; }
    public void setAvgRevenuePerAppointment(double avgRevenuePerAppointment) { this.avgRevenuePerAppointment = avgRevenuePerAppointment; }
    
    public List<Map<String, Object>> getPendingDoctorsList() { return pendingDoctorsList; }
    public void setPendingDoctorsList(List<Map<String, Object>> pendingDoctorsList) { this.pendingDoctorsList = pendingDoctorsList; }
    
    public List<Map<String, Object>> getTodayAppointmentsList() { return todayAppointmentsList; }
    public void setTodayAppointmentsList(List<Map<String, Object>> todayAppointmentsList) { this.todayAppointmentsList = todayAppointmentsList; }
    
    public List<Map<String, Object>> getTopDoctorsList() { return topDoctorsList; }
    public void setTopDoctorsList(List<Map<String, Object>> topDoctorsList) { this.topDoctorsList = topDoctorsList; }
    
    public List<Map<String, Object>> getMonthlyRevenueList() { return monthlyRevenueList; }
    public void setMonthlyRevenueList(List<Map<String, Object>> monthlyRevenueList) { this.monthlyRevenueList = monthlyRevenueList; }
}