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

import services.UserService;

@WebServlet("/upload-image")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB threshold
    maxFileSize = 1024 * 1024 * 5,        // 5MB max file size
    maxRequestSize = 1024 * 1024 * 10     // 10MB max request size
)
public class ImageUploadServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = (int) session.getAttribute("user_id");
        String userType = (String) session.getAttribute("user_type");
        String imageType = request.getParameter("imageType");
        Part filePart = request.getPart("image");
        
        // Check file size
        if (filePart.getSize() > 5 * 1024 * 1024) { // 5MB limit
            session.setAttribute("error", "File size exceeds 5MB limit");
            redirectBack(request, response, userType);
            return;
        }
        
        String appPath = getServletContext().getRealPath("");
        
        String result = userService.handleImageUpload(userId, userType, imageType, filePart, appPath);
        
        if (result != null) {
            session.setAttribute("profile_image", result);  // ← ADD THIS LINE
            session.setAttribute("success", "Image uploaded successfully");
        } else {
            session.setAttribute("error", "Failed to upload image. Only JPG, PNG, GIF allowed");
        }
        
        redirectBack(request, response, userType);
    }
    
    private void redirectBack(HttpServletRequest request, HttpServletResponse response, String userType) 
            throws IOException {
        if ("patient".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/patient/profile");
        } else if ("doctor".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/doctor/profile");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}