package utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

/**
 * Utility class for validating and storing user-uploaded image files.
 * Files are saved to an external directory outside the application deployment path.
 */
public class FileUploadUtil {

    private static final String UPLOAD_DIR = "uploads";
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp");
    private static final List<String> ALLOWED_MIME_TYPES = Arrays.asList("image/jpeg", "image/png", "image/gif", "image/webp");
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    /**
     * Returns the base directory path for storing uploaded files.
     * Defaults to ~/medilife_uploads/ and creates the directory if it doesn't exist.
     */
    public static String getUploadBasePath(String appPath) {
        String defaultPath = System.getProperty("user.home") + File.separator + "medilife_uploads";
        
        File dir = new File(defaultPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        
        return defaultPath;
    }

    /**
     * Validates the uploaded file against size, MIME type, and extension rules.
     * Returns false if the file is null, empty, too large, or not an allowed image format.
     */
    public static boolean isValidImage(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) {
            
            return false;
        }
        if (filePart.getSize() > MAX_FILE_SIZE) {
           
            return false;
        }

        String contentType = filePart.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
           
            return false;
        }

        String extension = getFileExtension(filePart);
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
           
            return false;
        }

        return true;
    }

    /**
     * Extracts the lowercase file extension from the submitted file name.
     * Returns an empty string if no extension is found.
     */
    public static String getFileExtension(Part filePart) {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        int dotIndex = fileName.lastIndexOf(".");
        return dotIndex > 0 ? fileName.substring(dotIndex).toLowerCase() : "";
    }

    /**
     * Saves the uploaded file to the uploads directory using the provided unique name.
     * Returns the saved file name (without path) for later retrieval via FileServlet.
     */
    public static String saveFile(Part filePart, String uniqueName, String appPath) throws IOException {
        String uploadPath = getUploadBasePath(appPath) + File.separator + UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            System.out.println("Creating upload directory: " + uploadPath + " - Success: " + created);
        }

        String extension = getFileExtension(filePart);
        String fileName = uniqueName + extension;
        String fullFilePath = uploadPath + File.separator + fileName;

       
        filePart.write(fullFilePath);

        return fileName;
    }
}