-- noinspection SqlNoDataSourceInspectionForFile
CREATE TABLE IF NOT EXISTS dim_patient (
    patient_id VARCHAR(400) PRIMARY KEY,
    name VARCHAR(200),
    phone_number VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS dim_doctor (
    doctor_npi_number VARCHAR(400) PRIMARY KEY,
    name VARCHAR(200),
    practice VARCHAR(200)
);
CREATE TABLE IF NOT EXISTS dim_test (
    test_id INT PRIMARY KEY,
    name VARCHAR(40)
);

-- had to remove foreign keys due to hydra not supporting them for columnar tables
CREATE TABLE IF NOT EXISTS fact_hospital_events (
    event_id SERIAL PRIMARY KEY,
    patient_id VARCHAR(400) NOT NULL, --REFERENCES dim_patient(patient_id),
    test_id INT, --REFERENCES dim_test(test_id),
    doctor_npi_number VARCHAR(400), --REFERENCES dim_doctor(doctor_npi_number),
    admission_test_date TIMESTAMP NOT NULL,
    discharge_date TIMESTAMP,
    event_type VARCHAR(100) NOT NULL, -- stay or test for now
    total_cost DECIMAL(10, 2) NOT NULL
);
