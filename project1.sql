-- Create the database
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- Table: Patients
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    dob DATE,
    gender VARCHAR(10),
    contact VARCHAR(15),
    address TEXT
);

-- Table: Doctors
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100),
    contact VARCHAR(15)
);

-- Table: Visits
CREATE TABLE Visits (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    symptoms TEXT,
    diagnosis TEXT,
    status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Table: Bills
CREATE TABLE Bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_id INT,
    consultation_fee DECIMAL(10,2),
    medicine_charge DECIMAL(10,2),
    other_charge DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);
-- Insert sample records.
INSERT INTO Patients (name, dob, gender, contact, address) VALUES
('John Doe', '1990-05-10', 'Male', '9876543210', '123 Park Street, City A'),
('Jane Smith', '1985-09-23', 'Female', '9876501234', '456 Lake Road, City B'),
('Ravi Kumar', '1978-12-01', 'Male', '7890123456', '789 Hill Street, City C'),
('Anita Roy', '2000-03-15', 'Female', '8123456789', '321 Garden Lane, City D');


INSERT INTO Doctors (name, specialization, contact) VALUES
('Dr. Amit Sharma', 'Cardiology', '9123456780'),
('Dr. Meera Kapoor', 'Neurology', '9988776655'),
('Dr. Rakesh Rao', 'Orthopedics', '8877665544'),
('Dr. Sunita Sen', 'Pediatrics', '9765432109');

INSERT INTO Visits (patient_id, doctor_id, visit_date, symptoms, diagnosis, status) VALUES
(1, 1, '2025-07-07', 'Chest pain', 'Mild heartburn', 'Admitted'),
(2, 2, '2025-07-06', 'Headache and nausea', 'Migraine', 'Discharged'),
(3, 3, '2025-07-05', 'Knee pain after fall', 'Ligament strain', 'Admitted'),
(4, 4, '2025-07-04', 'Fever and cough', 'Seasonal flu', 'Discharged');

INSERT INTO Bills (visit_id, consultation_fee, medicine_charge, other_charge, total_amount, payment_status) VALUES
(1, 600.00, 250.00, 400.00, 1250.00, 'Pending'),
(2, 500.00, 150.00, 200.00, 850.00, 'Paid'),
(3, 700.00, 300.00, 500.00, 1500.00, 'Pending'),
(4, 400.00, 100.00, 150.00, 650.00, 'Paid');

--  Queries for Appointments and Payments
	--  Get all appointments for a patient:
	SELECT v.visit_id, p.name AS patient, d.name AS doctor, v.visit_date, v.status
	FROM Visits v
	JOIN Patients p ON v.patient_id = p.patient_id
	JOIN Doctors d ON v.doctor_id = d.doctor_id
	WHERE p.name = 'John Doe';
	-- b. List all unpaid bills:
	SELECT b.bill_id, p.name AS patient, b.total_amount
	FROM Bills b
	JOIN Visits v ON b.visit_id = v.visit_id
	JOIN Patients p ON v.patient_id = p.patient_id
	WHERE b.payment_status = 'Pending';

