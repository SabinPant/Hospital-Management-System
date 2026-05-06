package utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    // Hash password using BCrypt
    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(10));
    }
    
    // Verify password
    public static boolean verifyPassword(String inputPassword, String storedHash) {
        if (storedHash == null || !storedHash.startsWith("$2a$")) {
            return false;
        }
        try {
            return BCrypt.checkpw(inputPassword, storedHash);
        } catch (Exception e) {
            return false;
        }
    }
}