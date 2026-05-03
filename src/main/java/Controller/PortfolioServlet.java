package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet("/portfolio/*")
public class PortfolioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Map<String, Map<String, Object>> doctors;

    @Override
    public void init() throws ServletException {
        doctors = new LinkedHashMap<>();
        loadDoctorData();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/about_us");
            return;
        }

        // Remove leading slash
        String slug = pathInfo.substring(1);

        Map<String, Object> doctor = doctors.get(slug);

        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/about_us");
            return;
        }

        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/WEB-INF/views/profile/doctor-portfolio.jsp")
               .forward(request, response);
    }

    private void loadDoctorData() {

        // ──────────── 1. DR. SABIN PANT ────────────
        Map<String, Object> sabin = new LinkedHashMap<>();
        sabin.put("name", "Dr. Sabin Pant");
        sabin.put("lastName", "Pant");
        sabin.put("specialization", "Chief Cardiologist");
        sabin.put("qualification", "MBBS, MD - Cardiology");
        sabin.put("experience", "15+ Years");
        sabin.put("department", "Cardiology Department");
        sabin.put("image", "Public/Doctors/SabinPant.jpg");
        sabin.put("email", "sabin.pant@medilife.com.np");
        sabin.put("biography", Arrays.asList(
            "Dr. Sabin Pant is a distinguished interventional cardiologist serving as the Chief of Cardiology at MediLife Hospital, Kathmandu. With over 15 years of clinical experience, he has established himself as one of the foremost cardiac specialists in Nepal, having performed more than 2,000 successful cardiac procedures including complex angioplasties, pacemaker implantations, and structural heart interventions.",
            "After completing his MBBS from Tribhuvan University with top honors, Dr. Pant pursued his MD in Cardiology from the prestigious All India Institute of Medical Sciences (AIIMS), New Delhi. He later completed a fellowship in Interventional Cardiology from the Asian Heart Institute, Mumbai, where he trained under world-renowned cardiologists.",
            "Dr. Pant is passionate about preventive cardiology and has led numerous community outreach programs across rural Nepal, conducting free heart health camps that have screened over 50,000 patients. His research on early detection of coronary artery disease in South Asian populations has been published in leading international journals including the Journal of the American College of Cardiology and the European Heart Journal.",
            "He serves as a visiting faculty member at Tribhuvan University Teaching Hospital and is an active member of the Nepal Heart Foundation, the American College of Cardiology, and the Asia Pacific Society of Cardiology. Dr. Pant believes in a holistic approach to heart health, combining cutting-edge medical technology with compassionate patient care."
        ));
        sabin.put("education", Arrays.asList(
            createMap("year", "2002", "degree", "MBBS", "institution", "Tribhuvan University, Institute of Medicine, Kathmandu"),
            createMap("year", "2007", "degree", "MD - Cardiology", "institution", "All India Institute of Medical Sciences (AIIMS), New Delhi"),
            createMap("year", "2009", "degree", "Fellowship - Interventional Cardiology", "institution", "Asian Heart Institute, Mumbai, India"),
            createMap("year", "2015", "degree", "Advanced Training - Structural Heart Interventions", "institution", "Mayo Clinic, Rochester, USA")
        ));
        sabin.put("experienceTimeline", Arrays.asList(
            createMap("period", "2020 - Present", "role", "Chief Cardiologist", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2015 - 2020", "role", "Senior Consultant Cardiologist", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2010 - 2015", "role", "Consultant Cardiologist", "organization", "Grande International Hospital, Kathmandu"),
            createMap("period", "2007 - 2010", "role", "Registrar - Cardiology", "organization", "AIIMS, New Delhi, India")
        ));
        sabin.put("expertise", Arrays.asList(
            "Interventional Cardiology", "Angioplasty & Stenting", "Pacemaker Implantation",
            "Heart Failure Management", "Preventive Cardiology", "Echocardiography",
            "Structural Heart Disease", "Cardiac Rehabilitation"
        ));
        sabin.put("certifications", Arrays.asList(
            createMap("title", "Fellow of the American College of Cardiology (FACC)", "issuer", "American College of Cardiology", "year", "2018"),
            createMap("title", "Best Cardiologist Award - Nepal Healthcare Excellence", "issuer", "Nepal Medical Association", "year", "2020"),
            createMap("title", "Fellow of the Asia Pacific Society of Cardiology", "issuer", "APSC", "year", "2017"),
            createMap("title", "Distinguished Service Award", "issuer", "Nepal Heart Foundation", "year", "2021")
        ));
        sabin.put("publications", Arrays.asList(
            createMap("title", "Early Detection of Coronary Artery Disease in South Asian Populations: A 10-Year Cohort Study", "journal", "Journal of the American College of Cardiology", "year", "2019"),
            createMap("title", "Outcomes of Primary PCI in ST-Elevation Myocardial Infarction: Experience from a Tertiary Care Center in Nepal", "journal", "European Heart Journal", "year", "2018"),
            createMap("title", "Prevalence of Cardiovascular Risk Factors Among Urban Population of Kathmandu Valley", "journal", "Nepal Medical College Journal", "year", "2020"),
            createMap("title", "Drug-Eluting Stents vs Bare-Metal Stents: Long-Term Outcomes in Diabetic Patients", "journal", "Asia Pacific Cardiology Review", "year", "2021")
        ));
        sabin.put("statProcedures", "2,000+");
        sabin.put("statPatients", "50,000+");
        doctors.put("sabin-pant", sabin);
        

        // ──────────── 2. DR. PRIYANSHU MAHAT ────────────
        Map<String, Object> priyanshu = new LinkedHashMap<>();
        priyanshu.put("name", "Dr. Priyanshu Mahat");
        priyanshu.put("lastName", "Mahat");
        priyanshu.put("specialization", "Senior Neurologist");
        priyanshu.put("qualification", "MBBS, DM - Neurology");
        priyanshu.put("experience", "12+ Years");
        priyanshu.put("department", "Neurology Department");
        priyanshu.put("image", "Public/Doctors/PriyanshuMahat.jpeg");
        priyanshu.put("email", "priyanshu.mahat@medilife.com.np");
        priyanshu.put("biography", Arrays.asList(
            "Dr. Priyanshu Mahat is a highly accomplished neurologist with over 12 years of experience in diagnosing and treating complex neurological disorders. As Senior Neurologist at MediLife Hospital, he leads the hospital's stroke management program and has pioneered the use of advanced neuroimaging techniques in the Kathmandu Valley.",
            "Dr. Mahat completed his MBBS from B.P. Koirala Institute of Health Sciences, Dharan, where he graduated with distinction. He then pursued his DM in Neurology from the National Institute of Mental Health and Neurosciences (NIMHANS), Bangalore, one of India's premier neuroscience institutions.",
            "His clinical expertise spans stroke management, epilepsy, movement disorders, multiple sclerosis, and neurodegenerative diseases. Dr. Mahat established MediLife's first dedicated Stroke Unit, which has significantly reduced mortality rates and improved patient outcomes through rapid thrombolysis protocols.",
            "Dr. Mahat has presented his research at international conferences including the World Congress of Neurology and has published extensively on stroke epidemiology in the Nepalese population. He is a member of the Nepal Neurological Society, Indian Academy of Neurology, and the World Stroke Organization."
        ));
        priyanshu.put("education", Arrays.asList(
            createMap("year", "2005", "degree", "MBBS", "institution", "B.P. Koirala Institute of Health Sciences, Dharan"),
            createMap("year", "2010", "degree", "MD - General Medicine", "institution", "Tribhuvan University Teaching Hospital, Kathmandu"),
            createMap("year", "2013", "degree", "DM - Neurology", "institution", "NIMHANS, Bangalore, India"),
            createMap("year", "2017", "degree", "Fellowship - Stroke & Cerebrovascular Diseases", "institution", "Royal Melbourne Hospital, Australia")
        ));
        priyanshu.put("experienceTimeline", Arrays.asList(
            createMap("period", "2019 - Present", "role", "Senior Neurologist & Stroke Unit Head", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2015 - 2019", "role", "Consultant Neurologist", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2013 - 2015", "role", "Assistant Professor - Neurology", "organization", "Kathmandu Medical College"),
            createMap("period", "2010 - 2011", "role", "Senior Resident - Neurology", "organization", "NIMHANS, Bangalore")
        ));
        priyanshu.put("expertise", Arrays.asList(
            "Stroke Management", "Epilepsy & Seizure Disorders", "Movement Disorders",
            "Multiple Sclerosis", "Neurodegenerative Diseases", "Neurophysiology",
            "Headache Medicine", "Neuromuscular Disorders"
        ));
        priyanshu.put("certifications", Arrays.asList(
            createMap("title", "Fellow of the World Stroke Organization", "issuer", "WSO", "year", "2020"),
            createMap("title", "Excellence in Stroke Care Award", "issuer", "Nepal Neurological Society", "year", "2021"),
            createMap("title", "Certified Neurosonologist", "issuer", "Neurosonology Research Group", "year", "2018")
        ));
        priyanshu.put("publications", Arrays.asList(
            createMap("title", "Epidemiology of Ischemic Stroke in Nepal: A Multicenter Prospective Study", "journal", "International Journal of Stroke", "year", "2020"),
            createMap("title", "Thrombolysis Outcomes in a Resource-Limited Setting: The MediLife Experience", "journal", "Journal of Stroke Medicine", "year", "2019"),
            createMap("title", "Clinical Profile of Epilepsy Patients in Central Nepal", "journal", "Nepal Journal of Neurosciences", "year", "2018")
        ));
        priyanshu.put("statProcedures","1,500+");
        priyanshu.put("statPatients", "25,000+");
        doctors.put("priyanshu-mahat", priyanshu);

        // ──────────── 3. DR. ARYAN SHAKYA ────────────
        Map<String, Object> aryan = new LinkedHashMap<>();
        aryan.put("name", "Dr. Aryan Shakya");
        aryan.put("lastName", "Shakya");
        aryan.put("specialization", "Orthopedic Surgeon");
        aryan.put("qualification", "MBBS, MS - Orthopedics");
        aryan.put("experience", "10+ Years");
        aryan.put("department", "Orthopedic Surgery Department");
        aryan.put("image", "Public/Doctors/AryanShakya.jpeg");
        aryan.put("email", "aryan.shakya@medilife.com.np");
        aryan.put("biography", Arrays.asList(
            "Dr. Aryan Shakya is a skilled orthopedic surgeon specializing in joint replacement, complex spine procedures, and sports injury rehabilitation. With over a decade of surgical experience, he has performed more than 1,500 successful joint replacement surgeries and is known for introducing minimally invasive orthopedic techniques to MediLife Hospital.",
            "Dr. Shakya earned his MBBS from Kathmandu University School of Medical Sciences and went on to complete his MS in Orthopedics from the esteemed All India Institute of Medical Sciences (AIIMS), New Delhi. He further honed his skills through a clinical fellowship in Joint Reconstruction at Singapore General Hospital.",
            "Trained in the latest arthroscopic and robotic-assisted surgical techniques, Dr. Shakya has transformed the orthopedic department at MediLife into a center of excellence. He specializes in total knee and hip replacements, ACL reconstruction, complex trauma surgery, and minimally invasive spine procedures.",
            "An avid sports enthusiast himself, Dr. Shakya serves as the official orthopedic consultant for several national sports teams and has developed comprehensive sports injury prevention programs for young athletes across Nepal."
        ));
        aryan.put("education", Arrays.asList(
            createMap("year", "2008", "degree", "MBBS", "institution", "Kathmandu University School of Medical Sciences"),
            createMap("year", "2013", "degree", "MS - Orthopedics", "institution", "AIIMS, New Delhi, India"),
            createMap("year", "2015", "degree", "Fellowship - Joint Reconstruction", "institution", "Singapore General Hospital, Singapore"),
            createMap("year", "2018", "degree", "Certification - Robotic-Assisted Orthopedic Surgery", "institution", "SICOT Training Center, Germany")
        ));
        aryan.put("experienceTimeline", Arrays.asList(
            createMap("period", "2020 - Present", "role", "Senior Orthopedic Surgeon", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2016 - 2020", "role", "Consultant Orthopedic Surgeon", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2013 - 2016", "role", "Junior Consultant - Orthopedics", "organization", "Nepal Mediciti Hospital, Lalitpur")
        ));
        aryan.put("expertise", Arrays.asList(
            "Total Knee Replacement", "Total Hip Replacement", "Arthroscopic Surgery",
            "Complex Trauma Surgery", "Spine Surgery", "Sports Injury Rehabilitation",
            "ACL Reconstruction", "Minimally Invasive Orthopedics"
        ));
        aryan.put("certifications", Arrays.asList(
            createMap("title", "AO Trauma Certified Surgeon", "issuer", "AO Foundation, Switzerland", "year", "2019"),
            createMap("title", "Best Young Orthopedic Surgeon Award", "issuer", "Nepal Orthopedic Association", "year", "2020"),
            createMap("title", "SICOT International Diploma", "issuer", "Societe Internationale de Chirurgie Orthopedique", "year", "2017")
        ));
        aryan.put("publications", Arrays.asList(
            createMap("title", "Outcomes of Total Knee Arthroplasty in Nepalese Population: A 5-Year Follow-Up Study", "journal", "Journal of Orthopedic Surgery", "year", "2020"),
            createMap("title", "Minimally Invasive Plate Osteosynthesis for Distal Tibia Fractures", "journal", "Nepal Orthopedic Association Journal", "year", "2019"),
            createMap("title", "Sports Injuries Among Young Athletes: Prevention and Management Strategies", "journal", "Asian Journal of Sports Medicine", "year", "2021")
        ));
        aryan.put("statProcedures","1,800+");
        aryan.put("statPatients", "26,000+");
        doctors.put("aryan-shakya", aryan);

        // ──────────── 4. DR. RABIN PANT ────────────
        Map<String, Object> rabin = new LinkedHashMap<>();
        rabin.put("name", "Dr. Rabin Pant");
        rabin.put("lastName", "Pant");
        rabin.put("specialization", "Senior Pediatrician");
        rabin.put("qualification", "MBBS, MD - Pediatrics");
        rabin.put("experience", "13+ Years");
        rabin.put("department", "Pediatrics Department");
        rabin.put("image", "Public/Doctors/RabinPant.jpeg");
        rabin.put("email", "rabin.pant@medilife.com.np");
        rabin.put("biography", Arrays.asList(
            "Dr. Rabin Pant is a compassionate and dedicated pediatrician with over 13 years of experience in child healthcare. As Senior Pediatrician at MediLife Hospital, he leads the hospital's child wellness initiative and has touched the lives of thousands of children through his commitment to accessible, high-quality pediatric care.",
            "After completing his MBBS from Tribhuvan University, Dr. Pant pursued his MD in Pediatrics from the Institute of Child Health, Kolkata, one of India's most prestigious pediatric training centers. His training included specialized rotations in neonatology, pediatric cardiology, and developmental pediatrics.",
            "Dr. Pant is deeply committed to improving child health outcomes across Nepal. He has conducted over 200 free health camps in rural communities across the Bagmati Province, providing vaccinations, nutritional assessments, and health education to underserved populations. His 'Healthy Child, Healthy Nepal' initiative has been recognized by the Ministry of Health.",
            "A strong advocate for preventive care, Dr. Pant regularly contributes to public health campaigns on childhood vaccination, nutrition, and early childhood development. He is an executive member of the Nepal Pediatric Society and a certified trainer for the Integrated Management of Childhood Illness (IMCI) program."
        ));
        rabin.put("education", Arrays.asList(
            createMap("year", "2004", "degree", "MBBS", "institution", "Tribhuvan University, Institute of Medicine, Kathmandu"),
            createMap("year", "2009", "degree", "MD - Pediatrics", "institution", "Institute of Child Health, Kolkata, India"),
            createMap("year", "2012", "degree", "Fellowship - Neonatology", "institution", "Christian Medical College, Vellore, India"),
            createMap("year", "2016", "degree", "Certificate - Pediatric Advanced Life Support (PALS)", "institution", "American Heart Association")
        ));
        rabin.put("experienceTimeline", Arrays.asList(
            createMap("period", "2018 - Present", "role", "Senior Pediatrician & Child Wellness Head", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2014 - 2018", "role", "Consultant Pediatrician", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2010 - 2014", "role", "Pediatric Registrar", "organization", "Kanti Children's Hospital, Kathmandu")
        ));
        rabin.put("expertise", Arrays.asList(
            "General Pediatrics", "Neonatology", "Vaccination & Immunization",
            "Pediatric Nutrition", "Growth & Development", "Childhood Asthma",
            "Pediatric Infectious Diseases", "Developmental Pediatrics"
        ));
        rabin.put("certifications", Arrays.asList(
            createMap("title", "Fellow of the Indian Academy of Pediatrics (FIAP)", "issuer", "Indian Academy of Pediatrics", "year", "2018"),
            createMap("title", "Community Health Champion Award", "issuer", "Ministry of Health, Nepal", "year", "2020"),
            createMap("title", "IMCI Master Trainer Certification", "issuer", "WHO/UNICEF", "year", "2017")
        ));
        rabin.put("publications", Arrays.asList(
            createMap("title", "Nutritional Status of Under-Five Children in Rural Bagmati: A Cross-Sectional Survey", "journal", "Nepal Journal of Pediatrics", "year", "2020"),
            createMap("title", "Vaccination Coverage and Barriers in Urban Slums of Kathmandu Valley", "journal", "WHO South-East Asia Journal of Public Health", "year", "2019"),
            createMap("title", "Clinical Profile of Acute Respiratory Infections in Hospitalized Children", "journal", "Journal of Nepal Paediatric Society", "year", "2018")
        ));
        rabin.put("statProcedures","1,700+");
        rabin.put("statPatients", "29,000+");
        doctors.put("rabin-pant", rabin);

        // ──────────── 5. DR. SHREYA POKHAREL ────────────
        Map<String, Object> shreya = new LinkedHashMap<>();
        shreya.put("name", "Dr. Shreya Pokharel");
        shreya.put("lastName", "Pokharel");
        shreya.put("specialization", "Dentist & Maxillofacial Surgeon");
        shreya.put("qualification", "BDS, MDS - Oral Surgery");
        shreya.put("experience", "9+ Years");
        shreya.put("department", "Dental Department");
        shreya.put("image", "Public/Doctors/ShreyaPokharel.jpeg");
        shreya.put("email", "shreya.pokharel@medilife.com.np");
        shreya.put("biography", Arrays.asList(
            "Dr. Shreya Pokharel is a talented dentist and maxillofacial surgeon who has transformed MediLife's Dental Department into the leading dental center in the Kathmandu Valley. With over 9 years of clinical experience, she specializes in cosmetic dentistry, dental implants, corrective jaw surgery, and complex oral and maxillofacial procedures.",
            "Dr. Pokharel completed her BDS from the College of Dental Surgery, B.P. Koirala Institute of Health Sciences, where she graduated at the top of her class. She then pursued her MDS in Oral and Maxillofacial Surgery from the prestigious Manipal College of Dental Sciences, Mangalore, India.",
            "Her advanced training in cosmetic dentistry includes certifications in smile design, veneers, and full-mouth rehabilitation. Dr. Pokharel is passionate about restoring not just dental function but also her patients' confidence through aesthetic dentistry. She has successfully placed over 1,000 dental implants and performed hundreds of complex maxillofacial surgeries.",
            "Dr. Pokharel regularly conducts dental awareness programs in schools and communities, educating children about oral hygiene. She is a lifetime member of the Nepal Dental Association and serves on the editorial board of the Nepal Journal of Dental Sciences."
        ));
        shreya.put("education", Arrays.asList(
            createMap("year", "2009", "degree", "BDS - Bachelor of Dental Surgery", "institution", "B.P. Koirala Institute of Health Sciences, Dharan"),
            createMap("year", "2014", "degree", "MDS - Oral & Maxillofacial Surgery", "institution", "Manipal College of Dental Sciences, Mangalore, India"),
            createMap("year", "2016", "degree", "Certificate - Advanced Cosmetic Dentistry", "institution", "UCLA School of Dentistry, USA"),
            createMap("year", "2018", "degree", "Fellowship - Dental Implantology", "institution", "International Congress of Oral Implantologists")
        ));
        shreya.put("experienceTimeline", Arrays.asList(
            createMap("period", "2020 - Present", "role", "Head - Dental & Maxillofacial Surgery", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2016 - 2020", "role", "Consultant Dental Surgeon", "organization", "MediLife Hospital, Kathmandu"),
            createMap("period", "2014 - 2016", "role", "Junior Consultant - Oral Surgery", "organization", "Dhulikhel Hospital, Kavre")
        ));
        shreya.put("expertise", Arrays.asList(
            "Cosmetic Dentistry", "Dental Implants", "Corrective Jaw Surgery",
            "Smile Design & Veneers", "Full Mouth Rehabilitation", "Wisdom Tooth Surgery",
            "TMJ Disorders", "Pediatric Dentistry"
        ));
        shreya.put("certifications", Arrays.asList(
            createMap("title", "Diplomate - International Congress of Oral Implantologists (DICOI)", "issuer", "ICOI", "year", "2019"),
            createMap("title", "Best Dental Practice Award", "issuer", "Nepal Dental Association", "year", "2021"),
            createMap("title", "Certified Invisalign Provider", "issuer", "Align Technology", "year", "2020")
        ));
        shreya.put("publications", Arrays.asList(
            createMap("title", "Success Rate of Dental Implants in Patients with Controlled Diabetes: A Prospective Study", "journal", "Journal of Oral Implantology", "year", "2020"),
            createMap("title", "Patterns of Maxillofacial Injuries in Road Traffic Accidents in Kathmandu Valley", "journal", "Nepal Journal of Dental Sciences", "year", "2019"),
            createMap("title", "Aesthetic Outcomes of Immediate Implant Placement in Anterior Maxilla", "journal", "International Journal of Esthetic Dentistry", "year", "2021")
        ));
        priyanshu.put("statProcedures","1,760+");
        priyanshu.put("statPatients", "28,700+");
        doctors.put("shreya-pokharel", shreya);
    }

    private Map<String, Object> createMap(String key1, Object val1, String key2, Object val2, String key3, Object val3) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put(key1, val1);
        map.put(key2, val2);
        map.put(key3, val3);
        return map;
    }
}
