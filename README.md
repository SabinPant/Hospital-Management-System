🏥 MediLife Hospital Management System
A comprehensive hospital management web application built with Java Jakarta EE, following strict MVC architecture. The system handles patient registration, doctor approval workflows, appointment scheduling, billing, medical records, and administrative management with role-based access control.

📋 Table of Contents
Tech Stack

Features

Architecture

Project Structure

Setup Guide

Default Credentials

Notes for Developers

🛠 Tech Stack
Layer	Technology	Version
Language	Java	21
Server	Apache Tomcat	10.1.36
Database	MySQL (via XAMPP)	—
Build Tool	Maven	—
Frontend	JSP + JSTL + CSS + Vanilla JS	—
API Spec	Jakarta EE	5.0
Password Hashing	jBCrypt	0.4
JSON (Backend)	Gson	2.10.1
✨ Features
🔐 Authentication & Authorization
Three-role access control: Admin, Doctor, Patient

Secure password hashing with BCrypt

Session-based authentication with configurable timeout

Admin approval workflow for doctor registrations

Account lock/unlock with reason tracking

👨‍⚕️ Patient Portal
Registration with required medical details (blood group, DOB, emergency contact)

Profile image upload

Book appointments with available doctors

View upcoming and past appointments

Cancel pending appointments

Medical history with diagnoses and prescriptions

🩺 Doctor Portal
Registration with license document upload (pending admin approval)

Dashboard with today's appointments and statistics

Confirm or complete appointments

Add diagnosis and prescriptions

View patient medical history

Track earnings (total, monthly breakdown)

Profile and license image management

🛡️ Admin Panel
Dashboard with real-time statistics

Pending doctor approvals with license document review

User management with View Details modal and lock/unlock

View all appointments with filters and search

Department management (add, edit, delete)

Financial reports with CSV export

System logs with CSV export

Contact message viewer

Broadcast announcements to patients

📋 Appointments & Billing
Book appointments for future dates only

Status workflow: Pending → Confirmed → Completed

Automatic billing generation upon completion

Cancellation with reason tracking

🔔 Notifications
Real-time notification bell with unread count

Notifications for: booking, confirmation, completion, billing, account lock/unlock

Mark as read functionality

Notification history page

📄 Dynamic Doctor Portfolios
Individual profile pages for featured doctors

Education timeline, experience, expertise, certifications, publications

Book appointment CTA with login check

📁 File Uploads
Profile pictures for patients and doctors

License documents for doctor verification

Portable storage (works across machines)

🏗 Architecture
text
┌─────────────────────────────────────────────────────┐
│                   MVC ARCHITECTURE                   │
├──────────┬──────────────┬───────────────────────────┤
│  VIEW    │  CONTROLLER  │  MODEL                    │
│  (JSP)   │  (Servlet)   │  (Service → DAO → Entity) │
├──────────┼──────────────┼───────────────────────────┤
│  JSP     │  Routing &   │  services/                │
│  JSTL    │  Request     │  dao/                     │
│  CSS     │  Handling    │  models/                  │
│  JS(UI)  │              │  utils/                   │
└──────────┴──────────────┴───────────────────────────┘
Controllers — Handle HTTP requests/responses and routing only

Services — All business logic and validation

DAOs — Database access, SQL queries

Models — Entity classes (User, Doctor, Patient, Appointment, etc.)

Utils — Helper classes (PasswordUtil, SessionUtil, FileUploadUtil)

Filters — Authentication and authorization for each role

📁 Project Structure
text
src/
├── main/
│   ├── java/
│   │   ├── Controller/     # Servlets (routing only)
│   │   ├── dao/            # Data Access Objects (SQL queries)
│   │   ├── filter/         # Auth filters (Admin, Doctor, Patient)
│   │   ├── models/         # Entity classes (POJOs)
│   │   ├── services/       # Business logic layer
│   │   └── utils/          # Password, Session, FileUpload, DBConnection
│   └── webapp/
│       ├── CSS/            # Stylesheets
│       ├── Public/         # Static assets (images, uploads)
│       ├── WEB-INF/views/  # JSP pages (protected)
│       │   ├── admin/
│       │   ├── doctor/
│       │   ├── patient/
│       │   └── profile/
│       ├── components/     # Reusable JSP (header, footer, sidebar)
│       └── index.jsp       # Landing page
├── schema.sql              # Database schema + default data
└── pom.xml                 # Maven dependencies
🚀 Setup Guide
Prerequisites
Java 21 — Download JDK 21

Apache Tomcat 10.1.36 — Download Tomcat

XAMPP — Download XAMPP (for MySQL/phpMyAdmin)

Eclipse IDE for Enterprise Java — Download Eclipse

Maven — Bundled with Eclipse

Step 1: Database Setup
Open XAMPP Control Panel and start Apache and MySQL

Go to http://localhost/phpmyadmin

Click New to create a database named medilife_hms

Select the medilife_hms database

Click the Import tab

Choose the schema.sql file from the project root

Click Go — all tables and default data will be created

Step 2: Configure Tomcat in Eclipse
Open Eclipse

Go to Window → Preferences → Server → Runtime Environments

Click Add → Apache → Apache Tomcat 10.1

Browse to your Tomcat installation directory

Click Finish

Step 3: Import Project
File → Import → Existing Maven Projects

Browse to the project folder

Ensure pom.xml is selected

Click Finish

Wait for Maven to download dependencies

Step 4: Run the Application
Right-click the project → Run As → Run on Server

Select Tomcat 10.1 → Finish

The application will open at: http://localhost:8080/Hospital-Management-System/

🔑 Default Credentials
Role	Username	Password	Access
Admin	admin	admin123	/admin/login
Doctor	Register via form	—	/login
Patient	Register via form	—	/login
Doctor accounts require admin approval before login. Check the admin dashboard for pending approvals.

📝 Notes for Developers
MVC Pattern — Controllers handle routing only. All business logic lives in services/. Database access is exclusively through dao/.

Session Management — All session keys are centralized in SessionUtil.java. Use helper methods like isAdminLoggedIn(), isPatient(), getUserId() instead of raw session access.

JavaScript Policy — JavaScript is limited to UI operations (show/hide modals, form validation, DOM manipulation). No fetch()/AJAX calls for data handling. All data is rendered server-side via JSTL.

JSTL Over Scriptlets — All JSP files use JSTL/EL tags. Scriptlets are not permitted.

Password Security — Passwords are hashed using BCrypt (utils/PasswordUtil.java). Plain-text passwords never touch the database.

File Uploads — Uploaded files are stored in {user.home}/medilife_uploads/uploads/ for portability across machines.

Forms — All data submission uses POST method. Data retrieval uses GET.

Database — Run schema.sql to set up the complete database with tables and default data.

<p align="center">Made for better healthcare management</p>
