package utils;

import java.util.regex.Pattern;

/*
 * A centralized validation facade that codifies the domain's input integrity
 * rules into a single, stateless utility surface. Every public contract is a
 * pure function; null and blank values are rejected early, while domain-specific
 * constraints (Nepali 10‑digit phones, canonical blood groups, tiered password
 * strength) are enforced declaratively through compiled regex and scoring
 * heuristics. The nested {@link PasswordStrength} record-style type elevates
 * password evaluation from a binary gate to a diagnostic feedback channel,
 * enabling richer client-side experiences without coupling business logic to
 * any particular presentation framework. Designed to serve as both an inline
 * guard layer in service commands and a backing delegate for annotation-driven
 * validation adapters.
 */
public class ValidationUtil {
    
    // Email validation
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return Pattern.matches(emailRegex, email);
    }
    
    // Phone validation (Nepali: 10 digits)
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return false; // Now required
        String phoneRegex = "^[0-9]{10}$";
        return Pattern.matches(phoneRegex, phone);
    }
    
    // Username validation (alphanumeric + underscore, 3-20 chars)
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) return false;
        String usernameRegex = "^[a-zA-Z0-9_]{3,20}$";
        return Pattern.matches(usernameRegex, username);
    }
    
    // Full name validation (letters, spaces, min 2 chars)
    public static boolean isValidFullName(String name) {
        if (name == null || name.trim().isEmpty()) return false;
        String nameRegex = "^[a-zA-Z\\s]{2,50}$";
        return Pattern.matches(nameRegex, name);
    }
    
    // Password strength check
    public static PasswordStrength checkPasswordStrength(String password) {
        if (password == null || password.isEmpty()) {
            return new PasswordStrength("Weak", 0, "Password cannot be empty");
        }
        
        int score = 0;
        StringBuilder feedback = new StringBuilder();
        
        // Length check
        if (password.length() >= 8) {
            score++;
        } else {
            feedback.append("Password must be at least 8 characters. ");
        }
        
        // Uppercase check
        if (Pattern.matches(".*[A-Z].*", password)) {
            score++;
        } else {
            feedback.append("Add uppercase letter. ");
        }
        
        // Lowercase check
        if (Pattern.matches(".*[a-z].*", password)) {
            score++;
        } else {
            feedback.append("Add lowercase letter. ");
        }
        
        // Number check
        if (Pattern.matches(".*[0-9].*", password)) {
            score++;
        } else {
            feedback.append("Add a number. ");
        }
        
        // Special character check
        if (Pattern.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?].*", password)) {
            score++;
        } else {
            feedback.append("Add a special character (!@#$%^&*)");
        }
        
        // Determine strength
        String strength;
        if (score >= 5) {
            strength = "Strong";
        } else if (score >= 3) {
            strength = "Medium";
        } else {
            strength = "Weak";
        }
        
        return new PasswordStrength(strength, score, feedback.toString().trim());
    }
    
    // Password strength class
    public static class PasswordStrength {
        private String strength;
        private int score;
        private String feedback;
        
        public PasswordStrength(String strength, int score, String feedback) {
            this.strength = strength;
            this.score = score;
            this.feedback = feedback;
        }
        
        public String getStrength() { return strength; }
        public int getScore() { return score; }
        public String getFeedback() { return feedback; }
    }
    
    // License number validation
    public static boolean isValidLicenseNumber(String license) {
        return license != null && !license.trim().isEmpty() && license.length() >= 3;
    }
    
    // Experience years validation
    public static boolean isValidExperience(int years) {
        return years >= 0 && years <= 60;
    }
    
    // Consultation fee validation
    public static boolean isValidFee(double fee) {
        return fee >= 0 && fee <= 100000;
    }
    
    // Blood group validation
    public static boolean isValidBloodGroup(String bloodGroup) {
        if (bloodGroup == null || bloodGroup.isEmpty()) return true; // Optional
        String[] validGroups = {"A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"};
        for (String group : validGroups) {
            if (group.equals(bloodGroup)) return true;
        }
        return false;
    }
}