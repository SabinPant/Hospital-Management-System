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

    // ===== YOUR ACTUAL PROJECT WEBAPP PATH =====
    private static final String PROJECT_WEBAPP_PATH = 
        "C:\\Users\\Acer\\eclipse-workspace\\Hospital-Management-System\\src\\main\\webapp";

    // Validate if file is a valid image
    public static boolean isValidImage(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("File is null or empty");
            return false;
        }
        if (filePart.getSize() > MAX_FILE_SIZE) {
            System.out.println("File too large: " + filePart.getSize());
            return false;
        }

        String contentType = filePart.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            System.out.println("Invalid content type: " + contentType);
            return false;
        }

        String extension = getFileExtension(filePart);
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            System.out.println("Invalid extension: " + extension);
            return false;
        }

        return true;
    }

    // Get file extension from Part
    public static String getFileExtension(Part filePart) {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        int dotIndex = fileName.lastIndexOf(".");
        return dotIndex > 0 ? fileName.substring(dotIndex).toLowerCase() : "";
    }

    // Get the project webapp path (used by FileServlet)
    public static String getProjectWebappPath(String appPath) {
        File webappDir = new File(PROJECT_WEBAPP_PATH);
        if (webappDir.exists() && webappDir.isDirectory()) {
            return PROJECT_WEBAPP_PATH;
        }
        // Fallback to deployed path
        return appPath;
    }

    // Save file to the REAL project webapp folder
    public static String saveFile(Part filePart, String uniqueName, String appPath) throws IOException {
        String uploadPath = PROJECT_WEBAPP_PATH + File.separator + UPLOAD_DIR.replace("/", File.separator);

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            System.out.println("Creating upload directory: " + uploadPath + " - Success: " + created);
        }

        String extension = getFileExtension(filePart);
        String fileName = uniqueName + extension;
        String fullFilePath = uploadPath + File.separator + fileName;

        System.out.println("Saving file to: " + fullFilePath);
        filePart.write(fullFilePath);

        // Return relative web path (used in <img src="...">)
        return UPLOAD_DIR + "/" + fileName;
    }
}