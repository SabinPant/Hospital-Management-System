package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/Public/uploads/*")
public class FileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String PROJECT_WEBAPP_PATH = 
        "C:\\Users\\Acer\\eclipse-workspace\\Hospital-Management-System\\src\\main\\webapp";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String requestedFile = request.getPathInfo();
        
        if (requestedFile == null || requestedFile.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Build file path
        String filePath = PROJECT_WEBAPP_PATH + File.separator + "Public" 
                        + File.separator + "uploads" + File.separator + requestedFile;
        
        File file = new File(filePath);
        
        if (!file.exists()) {
            System.err.println("File not found: " + filePath);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Set content type
        String fileName = file.getName().toLowerCase();
        if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
            response.setContentType("image/jpeg");
        } else if (fileName.endsWith(".png")) {
            response.setContentType("image/png");
        } else if (fileName.endsWith(".gif")) {
            response.setContentType("image/gif");
        } else if (fileName.endsWith(".webp")) {
            response.setContentType("image/webp");
        } else {
            response.setContentType("application/octet-stream");
        }
        
        // Cache for 1 day
        response.setHeader("Cache-Control", "public, max-age=86400");
        
        // Stream the file
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
}