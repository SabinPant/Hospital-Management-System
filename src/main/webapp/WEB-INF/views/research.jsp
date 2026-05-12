<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Research | MediLife Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/global.css">
    <link rel="stylesheet" href="CSS/research.css">
</head>
<body>

    <jsp:include page="/components/header.jsp" />

    <!-- Hero -->
    <section class="res-hero">
        <div class="res-hero-overlay"></div>
        <div class="container res-hero-content">
            <span class="res-eyebrow"><i class="fas fa-flask"></i> Research &amp; Innovation</span>
            <h1>Research at <span class="res-hl">MediLife</span></h1>
            <p>Advancing medical science through rigorous clinical research, evidence-based practice,
               and partnerships with leading global institutions.</p>
        </div>
    </section>

    <!-- Intro -->
    <section class="res-intro">
        <div class="container res-intro-grid">
            <div class="res-intro-text">
                <h2>Our Research Mission</h2>
                <p>MediLife's Research &amp; Innovation Centre was established in 2010 with the goal
                   of bridging the gap between cutting-edge global medical science and the healthcare
                   needs of the people of Nepal. Our multidisciplinary teams collaborate with
                   universities across Asia, Europe, and North America.</p>
                <p>Every finding we publish is translated into tangible improvements in patient care,
                   clinical protocols, and public health policy across Bagmati Province.</p>
                <div class="res-stats">
                    <div class="res-stat"><span>120+</span><p>Published Papers</p></div>
                    <div class="res-stat"><span>18</span><p>Active Clinical Trials</p></div>
                    <div class="res-stat"><span>35+</span><p>Partner Universities</p></div>
                </div>
            </div>
            <div class="res-intro-img">
                <img src="Public/Hospital/Research.png" alt="Research"
                     onerror="this.src='https://placehold.co/500x380/e3f2fd/0a5c8e?text=Research+Centre'">
            </div>
        </div>
    </section>

    <!-- Latest Global Research Topics -->
    <section class="res-topics">
        <div class="container">
            <div class="res-topics-head">
                <span class="res-eyebrow"><i class="fas fa-globe"></i> Global Research Spotlight</span>
                <h2>Latest Research Topics</h2>
                <p>Key areas shaping the future of medicine — topics our team actively contributes to.</p>
            </div>

            <div class="res-grid">

                <div class="res-card">
                    <div class="res-card-icon" style="background:#e3f2fd;color:#0a5c8e;">
                        <i class="fas fa-dna"></i>
                    </div>
                    <div class="res-card-body">
                        <span class="res-card-cat">Oncology</span>
                        <h3>CAR-T Cell Therapy &amp; Personalised Cancer Treatment</h3>
                        <p>Chimeric antigen receptor T-cell therapy is revolutionising treatment for
                           blood cancers. Current global research focuses on expanding CAR-T to solid
                           tumours, reducing cytokine release syndrome, and lowering manufacturing costs
                           for wider access in low-income countries.</p>
                        <div class="res-card-tags">
                            <span>Immunotherapy</span><span>Oncology</span><span>Cell Biology</span>
                        </div>
                    </div>
                </div>

                <div class="res-card">
                    <div class="res-card-icon" style="background:#e8f5e9;color:#2e7d32;">
                        <i class="fas fa-heartbeat"></i>
                    </div>
                    <div class="res-card-body">
                        <span class="res-card-cat">Cardiology</span>
                        <h3>AI-Driven Early Detection of Heart Failure</h3>
                        <p>Deep learning models trained on ECG, echocardiogram, and wearable data
                           now predict heart failure readmission risk with over 85% accuracy. MediLife's
                           cardiology team is piloting an AI screening protocol in collaboration with
                           Tribhuvan University.</p>
                        <div class="res-card-tags">
                            <span>Artificial Intelligence</span><span>Cardiology</span><span>Wearables</span>
                        </div>
                    </div>
                </div>

                <div class="res-card">
                    <div class="res-card-icon" style="background:#fce4ec;color:#c62828;">
                        <i class="fas fa-brain"></i>
                    </div>
                    <div class="res-card-body">
                        <span class="res-card-cat">Neurology</span>
                        <h3>Blood Biomarkers for Early Alzheimer's Diagnosis</h3>
                        <p>Plasma phospho-tau 217 and amyloid-beta ratio tests can now identify
                           Alzheimer's pathology up to 20 years before symptoms appear. Research
                           is focused on large-scale population screening protocols and the ethical
                           implications of preclinical diagnosis.</p>
                        <div class="res-card-tags">
                            <span>Alzheimer's</span><span>Biomarkers</span><span>Neurology</span>
                        </div>
                    </div>
                </div>

                <div class="res-card">
                    <div class="res-card-icon" style="background:#fff3e0;color:#e65100;">
                        <i class="fas fa-virus"></i>
                    </div>
                    <div class="res-card-body">
                        <span class="res-card-cat">Infectious Disease</span>
                        <h3>mRNA Vaccine Platforms Beyond COVID-19</h3>
                        <p>Building on COVID-19 mRNA vaccine success, researchers are developing mRNA
                           candidates for TB, malaria, influenza, and HIV. Studies focus on thermostable
                           formulations critical for deployment in resource-limited settings like Nepal.</p>
                        <div class="res-card-tags">
                            <span>mRNA</span><span>Vaccines</span><span>Infectious Disease</span>
                        </div>
                    </div>
                </div>

                <div class="res-card">
                    <div class="res-card-icon" style="background:#f3e5f5;color:#6a1b9a;">
                        <i class="fas fa-baby"></i>
                    </div>
                    <div class="res-card-body">
                        <span class="res-card-cat">Maternal &amp; Child Health</span>
                        <h3>Point-of-Care Diagnostics for Neonatal Sepsis</h3>
                        <p>Neonatal sepsis remains a leading cause of newborn deaths in South Asia.
                           New lateral-flow assay and microfluidic chip technologies enable diagnosis
                           within 30 minutes at the bedside, enabling earlier antibiotic administration
                           in rural hospitals.</p>
                        <div class="res-card-tags">
                            <span>Neonatal</span><span>Diagnostics</span><span>Sepsis</span>
                        </div>
                    </div>
                </div>

                <div class="res-card">
                    <div class="res-card-icon" style="background:#e0f7fa;color:#00695c;">
                        <i class="fas fa-robot"></i>
                    </div>
                    <div class="res-card-body">
                        <span class="res-card-cat">Surgical Innovation</span>
                        <h3>Robotic-Assisted Surgery &amp; Haptic Feedback</h3>
                        <p>Next-generation surgical robots now incorporate tactile haptic feedback,
                           allowing surgeons to "feel" tissue resistance remotely. Research is evaluating
                           their use in low-resource settings via tele-surgery for orthopedic and
                           urological procedures.</p>
                        <div class="res-card-tags">
                            <span>Robotics</span><span>Surgery</span><span>Tele-Medicine</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="res-cta">
        <div class="container res-cta-inner">
            <h2>Collaborate with Our Research Team</h2>
            <p>We welcome partnerships with academic institutions, pharmaceutical companies, and
               global health organisations. Get in touch to explore joint research opportunities.</p>
            <a href="contact" class="res-cta-btn">Contact Us <i class="fas fa-arrow-right"></i></a>
        </div>
    </section>

    <jsp:include page="/components/footer.jsp" />

</body>
</html>
