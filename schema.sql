-- ============================================
-- CREATE DATABASE
-- ============================================
CREATE DATABASE IF NOT EXISTS medilife_hms;
USE medilife_hms;

-- ============================================
-- 1. ADMINS TABLE
-- ============================================
DROP TABLE IF EXISTS admins;
CREATE TABLE admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('super_admin', 'admin') DEFAULT 'admin',
    status ENUM('active', 'inactive') DEFAULT 'active',
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2. USERS TABLE
-- ============================================
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(20) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') DEFAULT NULL,
    phone VARCHAR(20) NOT NULL,
    profile_image VARCHAR(255) DEFAULT NULL,
    address TEXT,
    user_type ENUM('patient', 'doctor') NOT NULL,
    status ENUM('active', 'locked', 'inactive') DEFAULT 'active',
    lock_reason TEXT,
    locked_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================
-- 3. DOCTOR PROFILES TABLE
-- ============================================
DROP TABLE IF EXISTS doctor_profiles;
CREATE TABLE doctor_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    specialization VARCHAR(100) NOT NULL,
    qualification VARCHAR(200) NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    license_image VARCHAR(255) DEFAULT NULL,
    experience_years INT DEFAULT 0,
    consultation_fee DECIMAL(10,2) DEFAULT 0.00,
    bio TEXT,
    approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    rejection_reason TEXT,
    approved_by INT NULL,
    approved_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES admins(id)
);

-- ============================================
-- 4. PATIENT PROFILES TABLE
-- ============================================
DROP TABLE IF EXISTS patient_profiles;
CREATE TABLE patient_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    date_of_birth DATE,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'),
    emergency_contact VARCHAR(20),
    medical_history TEXT,
    allergies TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- 5. DEPARTMENTS TABLE
-- ============================================
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dept_code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    head_doctor_id INT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (head_doctor_id) REFERENCES users(id)
);

-- ============================================
-- 6. APPOINTMENTS TABLE
-- ============================================
DROP TABLE IF EXISTS appointments;
CREATE TABLE appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id VARCHAR(20) NOT NULL UNIQUE,
    patient_id INT NOT NULL,
    doctor_id INT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('pending', 'confirmed', 'completed', 'cancelled', 'rescheduled', 'admin_assigned') DEFAULT 'pending',
    request_type ENUM('direct', 'admin_assigned') DEFAULT 'direct',
    symptoms TEXT,
    problem_description TEXT,
    diagnosis TEXT,
    prescription TEXT,
    doctor_notes TEXT,
    notes TEXT,
    cancellation_reason TEXT,
    assigned_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id),
    FOREIGN KEY (doctor_id) REFERENCES users(id),
    FOREIGN KEY (assigned_by) REFERENCES admins(id)
);

-- ============================================
-- 7. CONTACT MESSAGES TABLE
-- ============================================
DROP TABLE IF EXISTS contact_messages;
CREATE TABLE contact_messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 8. NOTIFICATIONS TABLE
-- ============================================
DROP TABLE IF EXISTS notifications;
CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    admin_id INT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('info', 'success', 'warning', 'error') DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (admin_id) REFERENCES admins(id)
);

-- ============================================
-- 9. BILLINGS TABLE
-- ============================================
DROP TABLE IF EXISTS billings;
CREATE TABLE billings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    billing_id VARCHAR(20) NOT NULL UNIQUE,
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    payment_method ENUM('cash', 'card', 'insurance', 'online') NULL,
    payment_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    FOREIGN KEY (patient_id) REFERENCES users(id),
    FOREIGN KEY (doctor_id) REFERENCES users(id)
);

-- ============================================
-- 10. SYSTEM LOGS TABLE
-- ============================================
DROP TABLE IF EXISTS system_logs;
CREATE TABLE system_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT NULL,
    user_id INT NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    details TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admins(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ============================================
-- INSERT DEFAULT DATA
-- ============================================

-- Default Super Admin (login with username: admin, password: admin123)
-- Password is stored as BCrypt hash for security
INSERT INTO admins (username, email, password, full_name, role, status) 
VALUES ('admin', 'admin@medilife.com', '$2a$10$aTwWCaUGFb5XFs.j9SQfn.nHQs1tw3ZONQjIyI2z0Ts1c0.6SymS2', 'Super Administrator', 'super_admin', 'active');
-- Departments
INSERT INTO departments (dept_code, name, description) VALUES
('CARD', 'Cardiology', 'Heart and cardiovascular diseases treatment'),
('NEUR', 'Neurology', 'Brain, spine, and nervous system disorders'),
('ORTH', 'Orthopedics', 'Bone, joint, and muscle conditions'),
('PED', 'Pediatrics', 'Child and adolescent healthcare'),
('DERM', 'Dermatology', 'Skin, hair, and nail conditions'),
('GYN', 'Gynecology', 'Women''s reproductive health'),
('OPH', 'Ophthalmology', 'Eye care and vision services'),
('DENT', 'Dentistry', 'Dental and oral healthcare');
