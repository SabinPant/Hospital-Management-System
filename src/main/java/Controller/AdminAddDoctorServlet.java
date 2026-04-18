package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;

import services.DoctorService;

@WebServlet("/admin/add-doctor-process")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class AdminAddDoctorServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private DoctorService doctorService;
    
    @Override
    public void init() throws ServletException {
        doctorService = new DoctorService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/add-doctor");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        // Get form data
        String fullName = request.getParameter("full_name");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String address = request.getParameter("address");
        String specialization = request.getParameter("specialization");
        String experienceYears = request.getParameter("experience_years");
        String qualification = request.getParameter("qualification");
        String licenseNumber = request.getParameter("license_number");
        String consultationFee = request.getParameter("consultation_fee");
        String bio = request.getParameter("bio");
        Part licenseImage = request.getPart("license_image");
        String appPath = getServletContext().getRealPath("");
        
        // Validate required fields
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            session.setAttribute("error", "Please fill all required fields");
            response.sendRedirect(request.getContextPath() + "/admin/add-doctor");
            return;
        }
        
        // Create doctor via service
        boolean created = doctorService.createDoctorByAdmin(
            fullName, gender, phone, email, username, password, address,
            specialization, experienceYears, qualification, licenseNumber,
            consultationFee, bio, licenseImage, appPath
        );
        
        if (created) {
            session.setAttribute("success", "Doctor registered successfully! They can now login.");
        } else {
            session.setAttribute("error", "Failed to register doctor. Email or username may already exist.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}