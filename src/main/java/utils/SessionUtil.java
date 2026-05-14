package utils;

import jakarta.servlet.http.HttpSession;
import models.Admin;
import models.User;

public class SessionUtil {

    
    // SESSION KEY CONSTANTS 
    
    // Admin session keys
    public static final String ADMIN_ID       = "admin_id";
    public static final String ADMIN_USERNAME = "admin_username";
    public static final String ADMIN_NAME     = "admin_name";
    public static final String ADMIN_ROLE     = "admin_role";
    public static final String IS_ADMIN       = "isAdmin";
    
    // User session keys
    public static final String USER_ID         = "user_id";
    public static final String USER_ID_DISPLAY = "user_id_display";
    public static final String EMAIL           = "email";
    public static final String FULL_NAME       = "full_name";
    public static final String PHONE           = "phone";
    public static final String USER_TYPE       = "user_type";
    public static final String STATUS          = "status";
    public static final String JOINED_DATE     = "joined_date";
    public static final String PROFILE_IMAGE   = "profile_image";
    public static final String BLOOD_GROUP     = "blood_group";

    // 
    // ADMIN SESSION HELPERS
    // 

    /**
     * Creates an admin session with all required attributes.
     */
    public static void createAdminSession(HttpSession session, Admin admin) {
        if (session == null || admin == null) return;
        session.setAttribute(ADMIN_ID, admin.getId());
        session.setAttribute(ADMIN_USERNAME, admin.getUsername());
        session.setAttribute(ADMIN_NAME, admin.getFullName());
        session.setAttribute(ADMIN_ROLE, admin.getRole());
        session.setAttribute(IS_ADMIN, true);
    }

    /**
     * Checks if an admin is currently logged in.
     */
    public static boolean isAdminLoggedIn(HttpSession session) {
        return session != null && session.getAttribute(ADMIN_ID) != null;
    }

    /**
     * Gets the logged-in admin's ID, or null if not logged in.
     */
    public static Integer getAdminId(HttpSession session) {
        if (!isAdminLoggedIn(session)) return null;
        return (Integer) session.getAttribute(ADMIN_ID);
    }

    /**
     * Gets the logged-in admin's name, or null if not logged in.
     */
    public static String getAdminName(HttpSession session) {
        if (!isAdminLoggedIn(session)) return null;
        return (String) session.getAttribute(ADMIN_NAME);
    }

    /**
     * Destroys the admin session.
     */
    public static void destroyAdminSession(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }

    // USER (PATIENT / DOCTOR) SESSION HELPERS

    /**
     * Creates a user session with all required attributes.
     */
    public static void createUserSession(HttpSession session, User user, 
                                          String profileImage, String bloodGroup) {
        if (session == null || user == null) return;
        session.setAttribute(USER_ID, user.getId());
        session.setAttribute(USER_ID_DISPLAY, user.getUserId());
        session.setAttribute(EMAIL, user.getEmail());
        session.setAttribute(FULL_NAME, user.getFullName());
        session.setAttribute(PHONE, user.getPhone());
        session.setAttribute(USER_TYPE, user.getUserType());
        session.setAttribute(STATUS, user.getStatus());
        session.setAttribute(JOINED_DATE, user.getCreatedAt());
        
        if (profileImage != null && !profileImage.isEmpty()) {
            session.setAttribute(PROFILE_IMAGE, profileImage);
        }
        
        if (bloodGroup != null && !bloodGroup.isEmpty()) {
            session.setAttribute(BLOOD_GROUP, bloodGroup);
        }
    }

    /**
     * Checks if a user (patient or doctor) is logged in.
     */
    public static boolean isUserLoggedIn(HttpSession session) {
        return session != null && session.getAttribute(USER_ID) != null;
    }

    /**
     * Gets the logged-in user's ID, or null.
     */
    public static Integer getUserId(HttpSession session) {
        if (!isUserLoggedIn(session)) return null;
        return (Integer) session.getAttribute(USER_ID);
    }

    /**
     * Gets the logged-in user's type (patient/doctor), or null.
     */
    public static String getUserType(HttpSession session) {
        if (!isUserLoggedIn(session)) return null;
        return (String) session.getAttribute(USER_TYPE);
    }

    /**
     * Checks if the logged-in user is a patient.
     */
    public static boolean isPatient(HttpSession session) {
        return "patient".equals(getUserType(session));
    }

    /**
     * Checks if the logged-in user is a doctor.
     */
    public static boolean isDoctor(HttpSession session) {
        return "doctor".equals(getUserType(session));
    }

    /**
     * Gets the logged-in user's full name, or null.
     */
    public static String getFullName(HttpSession session) {
        if (!isUserLoggedIn(session)) return null;
        return (String) session.getAttribute(FULL_NAME);
    }

    /**
     * Gets the logged-in user's status, or null.
     */
    public static String getStatus(HttpSession session) {
        if (!isUserLoggedIn(session)) return null;
        return (String) session.getAttribute(STATUS);
    }

    /**
     * Updates the profile image path in the session.
     */
    public static void updateProfileImage(HttpSession session, String imagePath) {
        if (session != null && imagePath != null) {
            session.setAttribute(PROFILE_IMAGE, imagePath);
        }
    }

    /**
     * Destroys the user session.
     */
    public static void destroyUserSession(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }
}