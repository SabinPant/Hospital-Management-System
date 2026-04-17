package utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

public class FileUploadUtil {
    
    private static final String UPLOAD_DIR = "Public/uploads";
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp");
    private static final List<String> ALLOWED_MIME_TYPES = Arrays.asList("image/jpeg", "image/png", "image/gif", "image/webp");
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    // Validate if file is an image
    public static boolean isValidImage(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("File is null or empty");
            return false;
        }
        
        // Check file size
        if (filePart.getSize() > MAX_FILE_SIZE) {
            System.out.println("File too large: " + filePart.getSize());
            return false;
        }
        
        // Check content type
        String contentType = filePart.getContentType();
        System.out.println("Content Type: " + contentType);
        
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            System.out.println("Invalid content type: " + contentType);
            return false;
        }
        
        // Check file extension
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        int dotIndex = fileName.lastIndexOf(".");
        if (dotIndex > 0) {
            extension = fileName.substring(dotIndex).toLowerCase();
        }
        
        System.out.println("File extension: " + extension);
        
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            System.out.println("Invalid extension: " + extension);
            return false;
        }
        
        return true;
    }
    
    // Get file extension
    public static String getFileExtension(Part filePart) {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        int dotIndex = fileName.lastIndexOf(".");
        if (dotIndex > 0) {
            return fileName.substring(dotIndex).toLowerCase();
        }
        return "";
    }
    
 // Save file and return path - Using absolute path
    public static String saveFile(Part filePart, String uniqueName, String appPath) throws IOException {
        // Use your actual Eclipse workspace path
        String uploadPath = "C:\\Users\\Acer\\eclipse-workspace\\Hospital-Management-System\\src\\main\\webapp\\Public\\uploads";
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        String extension = getFileExtension(filePart);
        String fileName = uniqueName + extension;
        String filePath = uploadPath + File.separator + fileName;
        
        System.out.println("Full file path: " + filePath);
        
        filePart.write(filePath);
        
        return "Public/uploads/" + fileName;
    }
}