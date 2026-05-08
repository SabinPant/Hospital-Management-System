<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcement | Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-announcement.css">
</head>
<body>

<div class="admin-container">

    <div class="admin-sidebar">
        <jsp:include page="/components/admin-sidebar.jsp">
            <jsp:param name="page" value="announcement" />
        </jsp:include>
    </div>

    <div class="admin-main">

        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1><i class="fas fa-bullhorn"></i> Announcements</h1>
            <div class="admin-user">
                <span><i class="fas fa-user-shield"></i> ${sessionScope.admin_name != null ? sessionScope.admin_name : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <!-- Success / Error alerts -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${sessionScope.success}
                <% session.removeAttribute("success"); %>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                <% session.removeAttribute("error"); %>
            </div>
        </c:if>

        <!-- ── Two-column layout ─────────────────────────── -->
        <div class="ann-layout">

            <!-- ============================================
                 LEFT — Compose Card
                 ============================================ -->
            <div class="ann-compose-card">

                <!-- Card header -->
                <div class="ann-card-header">
                    <div class="ann-header-icon">
                        <i class="fas fa-bullhorn"></i>
                    </div>
                    <div class="ann-header-text">
                        <h2>Compose Announcement</h2>
                        <p>Broadcast a message to your users instantly</p>
                    </div>
                </div>

                <!-- Form body -->
                <div class="ann-form-body">
                    <form action="${pageContext.request.contextPath}/admin/announcement" method="post" id="annForm">

                        <!-- Hidden radio inputs (synced by JS) -->
                        <input type="radio" name="sendTo" value="all"      id="radioAll"      class="ann-audience-radio" checked>
                        <input type="radio" name="sendTo" value="patients" id="radioPatients" class="ann-audience-radio">
                        <input type="radio" name="sendTo" value="doctors"  id="radioDoctors"  class="ann-audience-radio">

                        <!-- 1. Audience -->
                        <div class="ann-field">
                            <div class="ann-label">
                                <i class="fas fa-users"></i> Send To
                            </div>
                            <div class="ann-audience-group">
                                <div class="ann-audience-btn active" data-target="radioAll">
                                    <i class="fas fa-globe"></i> All Users
                                </div>
                                <div class="ann-audience-btn" data-target="radioPatients">
                                    <i class="fas fa-user-injured"></i> Patients Only
                                </div>
                                <div class="ann-audience-btn" data-target="radioDoctors">
                                    <i class="fas fa-user-md"></i> Doctors Only
                                </div>
                            </div>
                        </div>

                        <div class="ann-divider"></div>

                        <!-- 2. Type -->
                        <div class="ann-field">
                            <div class="ann-label">
                                <i class="fas fa-tag"></i> Announcement Type
                            </div>
                            <div class="ann-type-grid">

                                <div class="ann-type-card ann-type-info selected" data-type="info">
                                    <div class="ann-type-icon">
                                        <i class="fas fa-circle-info"></i>
                                    </div>
                                    <span class="ann-type-label">Info</span>
                                </div>

                                <div class="ann-type-card ann-type-success" data-type="success">
                                    <div class="ann-type-icon">
                                        <i class="fas fa-circle-check"></i>
                                    </div>
                                    <span class="ann-type-label">Success</span>
                                </div>

                                <div class="ann-type-card ann-type-warning" data-type="warning">
                                    <div class="ann-type-icon">
                                        <i class="fas fa-triangle-exclamation"></i>
                                    </div>
                                    <span class="ann-type-label">Warning</span>
                                </div>

                                <div class="ann-type-card ann-type-error" data-type="error">
                                    <div class="ann-type-icon">
                                        <i class="fas fa-circle-xmark"></i>
                                    </div>
                                    <span class="ann-type-label">Critical</span>
                                </div>

                            </div>
                            <input type="hidden" name="type" id="selectedType" value="info">
                        </div>

                        <div class="ann-divider"></div>

                        <!-- 3. Title with quick-fill presets -->
                        <div class="ann-field">
                            <div class="ann-label">
                                <i class="fas fa-heading"></i> Title
                            </div>

                            <!-- Quick-fill preset chips -->
                            <div class="ann-presets-wrap">
                                <span class="ann-preset-chip" data-fill="Scheduled Server Maintenance" data-type="warning">
                                    <i class="fas fa-server"></i> Server Maintenance
                                </span>
                                <span class="ann-preset-chip" data-fill="System Downtime Notice" data-type="error">
                                    <i class="fas fa-power-off"></i> System Downtime
                                </span>
                                <span class="ann-preset-chip" data-fill="Public Holiday Notice" data-type="info">
                                    <i class="fas fa-calendar-xmark"></i> Holiday Notice
                                </span>
                                <span class="ann-preset-chip" data-fill="New Feature Update" data-type="success">
                                    <i class="fas fa-star"></i> Feature Update
                                </span>
                                <span class="ann-preset-chip" data-fill="Emergency Alert" data-type="error">
                                    <i class="fas fa-triangle-exclamation"></i> Emergency Alert
                                </span>
                                <span class="ann-preset-chip" data-fill="Clinic Hours Change" data-type="warning">
                                    <i class="fas fa-clock"></i> Hours Change
                                </span>
                                <span class="ann-preset-chip" data-fill="Appointment Policy Update" data-type="info">
                                    <i class="fas fa-file-lines"></i> Policy Update
                                </span>
                                <span class="ann-preset-chip" data-fill="Service Restored" data-type="success">
                                    <i class="fas fa-circle-check"></i> Service Restored
                                </span>
                            </div>

                            <input type="text"
                                   name="title"
                                   id="annTitle"
                                   class="ann-input"
                                   placeholder="Enter announcement title…"
                                   required>
                        </div>

                        <!-- 4. Message -->
                        <div class="ann-field">
                            <div class="ann-label">
                                <i class="fas fa-comment-dots"></i> Message
                            </div>
                            <textarea name="message"
                                      id="annMessage"
                                      class="ann-textarea"
                                      placeholder="Write your announcement message here…"
                                      required></textarea>
                        </div>

                        <div class="ann-divider"></div>

                        <!-- Submit -->
                        <button type="submit" class="ann-submit-btn">
                            <i class="fas fa-paper-plane"></i>
                            Send Announcement
                            <span class="ann-submit-arrow"><i class="fas fa-arrow-right"></i></span>
                        </button>

                    </form>
                </div><!-- /.ann-form-body -->
            </div><!-- /.ann-compose-card -->


        </div><!-- /.ann-layout -->

    </div><!-- /.admin-main -->
</div><!-- /.admin-container -->

<script>
    /* ── Audience pill toggle ───────────────────────────── */
    const audienceBtns = document.querySelectorAll('.ann-audience-btn');
    audienceBtns.forEach(btn => {
        btn.addEventListener('click', function () {
            audienceBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            document.getElementById(this.dataset.target).checked = true;
        });
    });

    /* ── Type card selection ────────────────────────────── */
    const typeCards = document.querySelectorAll('.ann-type-card');
    const typeInput = document.getElementById('selectedType');

    typeCards.forEach(card => {
        card.addEventListener('click', function () {
            typeCards.forEach(c => c.classList.remove('selected'));
            this.classList.add('selected');
            typeInput.value = this.dataset.type;
        });
    });

    /* ── Quick-fill preset chips ────────────────────────── */
    // Maps preset type string → the matching ann-type-card element
    const typeCardMap = {};
    typeCards.forEach(card => { typeCardMap[card.dataset.type] = card; });

    document.querySelectorAll('.ann-preset-chip').forEach(chip => {
        chip.addEventListener('click', function () {
            // Fill title
            document.getElementById('annTitle').value = this.dataset.fill;

            // Switch type card to the preset's suggested type (if data-type set)
            const suggestedType = this.dataset.type;
            if (suggestedType && typeCardMap[suggestedType]) {
                typeCards.forEach(c => c.classList.remove('selected'));
                typeCardMap[suggestedType].classList.add('selected');
                typeInput.value = suggestedType;
            }

            // Focus message textarea so admin can keep typing
            document.getElementById('annMessage').focus();
        });
    });
</script>

</body>
</html>
