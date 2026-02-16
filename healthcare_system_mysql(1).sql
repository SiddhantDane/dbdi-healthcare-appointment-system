/* =====================================================
   Healthcare Appointment and Patient Records System
   Database Design and Implementation Assignment
   Student: Siddhant Sainath Dane
   ===================================================== */

DROP DATABASE IF EXISTS healthcare_db;
CREATE DATABASE healthcare_db;
USE healthcare_db;

-- =====================================================
-- 1. CORE ENTITY TABLES
-- =====================================================

CREATE TABLE patient (
    patient_id      VARCHAR(10) PRIMARY KEY,
    full_name       VARCHAR(120) NOT NULL,
    date_of_birth   DATE NOT NULL,
    gender          ENUM('Female','Male','Other') NOT NULL,
    contact_number  VARCHAR(30) NOT NULL,
    CONSTRAINT uq_patient_name UNIQUE (full_name)
);

CREATE TABLE doctor (
    doctor_id      VARCHAR(10) PRIMARY KEY,
    doctor_name    VARCHAR(120) NOT NULL,
    specialization VARCHAR(120) NOT NULL,
    phone_number   VARCHAR(30) NOT NULL,
    email_address  VARCHAR(150) NOT NULL,
    CONSTRAINT uq_doctor_email UNIQUE (email_address)
);

CREATE TABLE facility (
    facility_code  VARCHAR(10) PRIMARY KEY,
    facility_name  VARCHAR(150) NOT NULL,
    address        VARCHAR(220) NOT NULL,
    contact_number VARCHAR(30) NOT NULL
);

CREATE TABLE treatment (
    treatment_id   VARCHAR(10) PRIMARY KEY,
    treatment_name VARCHAR(150) NOT NULL,
    description    VARCHAR(400),
    cost           DECIMAL(10,2) NOT NULL CHECK (cost >= 0),
    CONSTRAINT uq_treatment_name UNIQUE (treatment_name)
);

-- =====================================================
-- 2. RELATIONSHIP TABLES (M:N)
-- =====================================================

CREATE TABLE patient_doctor (
    patient_id VARCHAR(10),
    doctor_id  VARCHAR(10),
    start_date DATE,
    PRIMARY KEY (patient_id, doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE patient_treatment (
    patient_id   VARCHAR(10),
    treatment_id VARCHAR(10),
    first_given  DATE,
    PRIMARY KEY (patient_id, treatment_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatment(treatment_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =====================================================
-- 3. APPOINTMENT TABLE (1:N relationships)
-- =====================================================

CREATE TABLE appointment (
    appointment_id VARCHAR(12) PRIMARY KEY,
    appt_date      DATE NOT NULL,
    appt_time      TIME NOT NULL,
    patient_id     VARCHAR(10) NOT NULL,
    doctor_id      VARCHAR(10) NOT NULL,
    facility_code  VARCHAR(10) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (facility_code) REFERENCES facility(facility_code)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE appointment_treatment (
    appointment_id VARCHAR(12),
    treatment_id   VARCHAR(10),
    quantity       INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    notes          VARCHAR(300),
    PRIMARY KEY (appointment_id, treatment_id),
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatment(treatment_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- =====================================================
-- 4. INDEXING REQUIREMENT
-- =====================================================

CREATE INDEX idx_doctor_name ON doctor(doctor_name);

-- =====================================================
-- 5. SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO patient VALUES
('P001','Alice Green','1998-04-12','Female','+49 151 1111111'),
('P002','Mark Lee','1995-09-05','Male','+49 152 2222222'),
('P003','Sara Khan','2001-01-22','Female','+49 153 3333333'),
('P004','Jonas Meyer','1988-07-19','Male','+49 154 4444444');

INSERT INTO doctor VALUES
('D001','Dr. Asad','Physiotherapy','+49 30 100100','asad@clinic.example'),
('D002','Dr. Adams','Radiology','+49 30 200200','adams@clinic.example'),
('D003','Dr. Chen','General Practice','+49 30 300300','chen@clinic.example'),
('D004','Dr. Novak','Orthopedics','+49 30 400400','novak@clinic.example');

INSERT INTO facility VALUES
('F001','BSBI Health Centre','Handjerystraße 3, 12489 Berlin','+49 30 555000'),
('F002','GigaCare Diagnostics','Grünheide (Mark), Brandenburg','+49 30 555111'),
('F003','City Ortho Clinic','Alexanderplatz, Berlin','+49 30 555222');

INSERT INTO treatment VALUES
('T001','Physiotherapy Session','45-minute physiotherapy session',50.00),
('T002','X-Ray','Standard X-Ray imaging',100.00),
('T003','Blood Test','Basic blood panel',35.00),
('T004','MRI Scan','Magnetic resonance imaging',750.00),
('T005','Vaccination','Seasonal vaccination',25.00);

INSERT INTO patient_doctor VALUES
('P001','D003','2025-01-10'),
('P001','D001','2025-02-15'),
('P002','D003','2025-01-12'),
('P002','D002','2025-03-01'),
('P003','D003','2025-02-20'),
('P003','D004','2025-04-05'),
('P004','D004','2025-03-18');

INSERT INTO patient_treatment VALUES
('P001','T001','2025-02-15'),
('P001','T005','2025-01-10'),
('P002','T002','2025-03-01'),
('P002','T003','2025-03-01'),
('P003','T004','2025-04-05'),
('P004','T001','2025-03-18'),
('P004','T003','2025-03-18');

INSERT INTO appointment VALUES
('A1001','2025-02-15','09:30:00','P001','D001','F001'),
('A1002','2025-03-01','14:00:00','P002','D002','F002'),
('A1003','2025-03-18','11:15:00','P004','D004','F003'),
('A1004','2025-04-05','10:00:00','P003','D004','F003'),
('A1005','2025-05-20','16:30:00','P001','D003','F002');

INSERT INTO appointment_treatment VALUES
('A1001','T001',1,'Initial physio assessment'),
('A1001','T005',1,'Seasonal vaccination'),
('A1002','T002',1,'X-Ray for suspected fracture'),
('A1002','T003',1,'Blood panel before imaging'),
('A1003','T001',2,'Two sessions scheduled'),
('A1004','T004',1,'MRI for knee'),
('A1005','T003',1,'Follow-up blood test');

-- =====================================================
-- 6. BUSINESS QUERIES
-- =====================================================

-- (a) Appointments for Alice Green
SELECT a.appointment_id, a.appt_date, a.appt_time,
       d.doctor_name, f.facility_name
FROM appointment a
JOIN patient p ON p.patient_id = a.patient_id
JOIN doctor d ON d.doctor_id = a.doctor_id
JOIN facility f ON f.facility_code = a.facility_code
WHERE p.full_name = 'Alice Green'
ORDER BY a.appt_date;

-- (b) Total treatments administered by each doctor
SELECT d.doctor_id, d.doctor_name,
       COUNT(at.treatment_id) AS total_treatments_administered
FROM doctor d
JOIN appointment a ON a.doctor_id = d.doctor_id
JOIN appointment_treatment at ON at.appointment_id = a.appointment_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY total_treatments_administered DESC;

-- (c) Doctors who treated more than 5 patients
SELECT d.doctor_id, d.doctor_name,
       COUNT(DISTINCT pd.patient_id) AS patients_treated
FROM doctor d
JOIN patient_doctor pd ON pd.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(DISTINCT pd.patient_id) > 5;

-- (d) Facilities where Mark Lee received treatment
SELECT DISTINCT f.facility_name
FROM facility f
JOIN appointment a ON a.facility_code = f.facility_code
JOIN patient p ON p.patient_id = a.patient_id
JOIN appointment_treatment at ON at.appointment_id = a.appointment_id
WHERE p.full_name = 'Mark Lee';

-- (e) Patients with assigned doctors and treatments
SELECT p.full_name, d.doctor_name, t.treatment_name
FROM patient p
JOIN patient_doctor pd ON pd.patient_id = p.patient_id
JOIN doctor d ON d.doctor_id = pd.doctor_id
LEFT JOIN patient_treatment pt ON pt.patient_id = p.patient_id
LEFT JOIN treatment t ON t.treatment_id = pt.treatment_id
ORDER BY p.full_name;

-- (f) Most expensive treatment and doctor who administered it
SELECT t.treatment_name, t.cost, d.doctor_name
FROM treatment t
JOIN appointment_treatment at ON at.treatment_id = t.treatment_id
JOIN appointment a ON a.appointment_id = at.appointment_id
JOIN doctor d ON d.doctor_id = a.doctor_id
WHERE t.cost = (SELECT MAX(cost) FROM treatment);

-- (g) Patients with appointments in more than one facility
SELECT p.patient_id, p.full_name,
       COUNT(DISTINCT a.facility_code) AS facilities_used
FROM patient p
JOIN appointment a ON a.patient_id = p.patient_id
GROUP BY p.patient_id, p.full_name
HAVING COUNT(DISTINCT a.facility_code) > 1;

-- (CASE + GROUP BY) Facility activity classification
SELECT f.facility_name,
       COUNT(at.treatment_id) AS total_treatments,
       AVG(t.cost) AS avg_treatment_cost,
       CASE
         WHEN COUNT(at.treatment_id) > 10 THEN 'High Activity'
         ELSE 'Low Activity'
       END AS activity_label
FROM facility f
LEFT JOIN appointment a ON a.facility_code = f.facility_code
LEFT JOIN appointment_treatment at ON at.appointment_id = a.appointment_id
LEFT JOIN treatment t ON t.treatment_id = at.treatment_id
GROUP BY f.facility_name
ORDER BY total_treatments DESC;
