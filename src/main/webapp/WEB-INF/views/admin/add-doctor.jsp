<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Doctor | Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    
    <style>
        /* Form Specific Styles */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 32px;
        }
        
        .form-section {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            padding: 24px;
        }

        .form-section-title {
            font-size: 1.1rem;
            color: #0ea5e9;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 6px;
        }

        .form-group input, 
        .form-group select, 
        .form-group textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            color: #1e293b;
            transition: all 0.2s;
            box-sizing: border-box;
        }

        .form-group input:focus, 
        .form-group select:focus, 
        .form-group textarea:focus {
            outline: none;
            border-color: #0ea5e9;
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .file-upload-wrapper {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }

        .form-actions {
            grid-column: 1 / -1;
            display: flex;
            justify-content: flex-end;
            gap: 16px;
            margin-top: 10px;
        }

        .btn-cancel {
            background: #f1f5f9;
            color: #64748b;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.2s;
            border: none;
            cursor: pointer;
        }

        .btn-cancel:hover {
            background: #e2e8f0;
            color: #1e293b;
        }

        .btn-submit {
            background: #10b981;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: 0.2s;
            box-shadow: 0 4px 6px rgba(16, 185, 129, 0.2);
            font-size: 1rem;
        }

        .btn-submit:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(16, 185, 129, 0.3);
        }

        /* Responsive */
        @media (max-width: 900px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="admin-container">
  <!-- Sidebar - Using component -->
    <div class="admin-sidebar">
      
<jsp:include page="/components/admin-sidebar.jsp">
    <jsp:param name="page" value="" />
</jsp:include>
    </div>

    <div class="admin-main">
        <div class="admin-topbar" style="margin-bottom: 32px;">
            <div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #64748b; text-decoration: none; font-size: 0.9rem; margin-bottom: 8px; display: inline-block;"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
                <h1 style="color: #1e293b; font-size: 1.8rem; font-weight: 700; margin: 0;">Register New Doctor</h1>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/admin/add-doctor-process" method="POST" enctype="multipart/form-data">
            
            <div class="form-grid">
                
                <div class="form-section">
                    <h3 class="form-section-title"><i class="fas fa-user"></i> Personal & Account Details</h3>
                    
                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="full_name" required placeholder="e.g. Dr. John Doe">
                    </div>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Gender *</label>
                            <select name="gender" required>
                                <option value="" disabled selected>Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Phone Number *</label>
                            <input type="text" name="phone" required placeholder="e.g. 9800000000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Email Address *</label>
                        <input type="email" name="email" required placeholder="e.g. doctor@medilife.com">
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Username *</label>
                            <input type="text" name="username" required placeholder="Unique username">
                        </div>
                        <div class="form-group">
                            <label>Temporary Password *</label>
                            <input type="password" name="password" required placeholder="Enter password">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Clinic/Home Address</label>
                        <textarea name="address" placeholder="Enter full address" style="min-height: 80px;"></textarea>
                    </div>
                </div>

                <div class="form-section">
                    <h3 class="form-section-title"><i class="fas fa-briefcase-medical"></i> Professional Profile</h3>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>Specialization *</label>
                            <input type="text" name="specialization" required placeholder="e.g. Cardiologist">
                        </div>
                        <div class="form-group">
                            <label>Experience (Years)</label>
                            <input type="number" name="experience_years" min="0" value="0" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Qualifications *</label>
                        <input type="text" name="qualification" required placeholder="e.g. MBBS, MD (Cardiology)">
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label>License Number *</label>
                            <input type="text" name="license_number" required placeholder="Medical board license #">
                        </div>
                        <div class="form-group">
                            <label>Consultation Fee (Rs)</label>
                            <input type="number" step="0.01" name="consultation_fee" min="0" value="500.00" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>License Image/Document Upload</label>
                        <div class="file-upload-wrapper">
                            <input type="file" name="license_image" accept="image/*,.pdf" style="border: none; padding: 0; cursor: pointer;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Professional Biography</label>
                        <textarea name="bio" placeholder="Write a short bio about the doctor's expertise..."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-submit"><i class="fas fa-check-circle"></i> Create Doctor Profile</button>
                </div>

            </div>
        </form>
    </div>
</div>

</body>
</html>