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
import utils.SessionUtil;

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
        if (!SessionUtil.isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = SessionUtil.getUserId(session);
        String userType = SessionUtil.getUserType(session);
        String imageType = request.getParameter("imageType");
        Part filePart = request.getPart("image");
        
        // Check file size
        if (filePart.getSize() > 5 * 1024 * 1024) { // 5MB limit
            session.setAttribute("error", "File size exceeds 5MB limit");
            redirectBack(request, response, session);
            return;
        }
        
        String appPath = getServletContext().getRealPath("");
        
        String result = userService.handleImageUpload(userId, userType, imageType, filePart, appPath);
        
        if (result != null) {
        	SessionUtil.updateProfileImage(session, result);
            session.setAttribute("success", "Image uploaded successfully");
        } else {
            session.setAttribute("error", "Failed to upload image. Only JPG, PNG, GIF allowed");
        }
        
        redirectBack(request, response, session);
    }
    
    private void redirectBack(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        if (SessionUtil.isPatient(session)) {
            response.sendRedirect(request.getContextPath() + "/patient/profile");
        } else if (SessionUtil.isDoctor(session)) {
            response.sendRedirect(request.getContextPath() + "/doctor/profile");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}