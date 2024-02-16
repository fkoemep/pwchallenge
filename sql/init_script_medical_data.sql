-- noinspection SqlNoDataSourceInspectionForFile
CREATE TABLE IF NOT EXISTS dim_patient (
    patient_id VARCHAR(400) PRIMARY KEY -- no other patient fields because of privacy concerns, for example HIPAA
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
    admission_test_date DATE NOT NULL, --REFERENCES dim_date(date_value),
    discharge_date DATE, --REFERENCES dim_date(date_value),
    event_type VARCHAR(100) NOT NULL, -- stay or test for now
    total_cost DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS fact_hospital_events_alternative (
    event_id SERIAL PRIMARY KEY,
    patient_id VARCHAR(400) NOT NULL, --REFERENCES dim_patient(patient_id),
    admission_test_date DATE NOT NULL, --REFERENCES dim_date(date_value),
    discharge_date DATE, --REFERENCES dim_date(date_value),
    total_stay_cost DECIMAL(10, 2) NOT NULL,
    total_tests_cost DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS dim_date (
  date_value DATE PRIMARY KEY,
  epoch BIGINT NOT NULL,
  day_suffix TEXT NOT NULL,
  day_name TEXT NOT NULL,
  day_of_week INT NOT NULL,
  day_of_month INT NOT NULL,
  day_of_year INT NOT NULL,
  month INT NOT NULL,
  month_name TEXT NOT NULL,
  month_name_abbreviated TEXT NOT NULL,
  year_value INT NOT NULL,
  first_day_of_week DATE NOT NULL,
  last_day_of_week DATE NOT NULL
);
WITH dates_table AS (SELECT
  date::date
FROM generate_series (
  '2022-01-01'::date,
  '2025-01-01'::date,
  '1 day'::interval
) date)
INSERT INTO dim_date
SELECT
date as date_value,
EXTRACT(EPOCH FROM date) AS epoch,
TO_CHAR(date, 'fmDDth') AS day_suffix,
TO_CHAR(date, 'TMDay') AS day_name,
EXTRACT(ISODOW FROM date) AS day_of_week,
EXTRACT(DAY FROM date) AS day_of_month,
EXTRACT(DOY FROM date) AS day_of_year,
EXTRACT(MONTH FROM date) AS month,
TO_CHAR(date, 'TMMonth') AS month_name,
TO_CHAR(date, 'Mon') AS month_name_abbreviated,
EXTRACT(YEAR FROM date) AS year_value,
date + (1 - EXTRACT(ISODOW FROM date))::INT AS first_day_of_week, date + (7 - EXTRACT(ISODOW FROM date))::INT AS last_day_of_week
FROM dates_table
ORDER BY date ASC;
