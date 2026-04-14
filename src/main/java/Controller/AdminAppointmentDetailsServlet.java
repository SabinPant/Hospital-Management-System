package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;
import utils.DBConnection;

@WebServlet("/admin/appointment-details")
public class AdminAppointmentDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid appointment ID\"}");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(idParam);
            System.out.println("Fetching appointment details for ID: " + appointmentId);
            
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
                    Map<String, Object> data = new HashMap<>();
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
                    
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    Gson gson = new Gson();
                    String json = gson.toJson(data);
                    System.out.println("Sending JSON: " + json);
                    out.print(json);
                    out.flush();
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\": \"Appointment not found\"}");
                }
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid ID format\"}");
        } catch (Exception e) {
            System.err.println("Error in AdminAppointmentDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}