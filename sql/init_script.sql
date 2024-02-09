CREATE TABLE IF NOT EXISTS patient (
patient_code VARCHAR(400),
patient_name VARCHAR(200),
phone_number VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS admission (
patient_code VARCHAR(400),
admission_datetime timestamp,
admission_reason VARCHAR(1000),
bed_code VARCHAR(400),
discharge_datetime timestamp
);
CREATE TABLE IF NOT EXISTS test_admission (
patient_code VARCHAR(400),
admission_datetime timestamp,
test_datetime timestamp,
test_code int,
npi_number VARCHAR(400)
);
CREATE TABLE IF NOT EXISTS doctor (
npi_number VARCHAR(400),
doctor_name VARCHAR(200),
practice VARCHAR(200)
);
CREATE TABLE IF NOT EXISTS test (
test_code int,
test_name VARCHAR(40)
);
CREATE TABLE IF NOT EXISTS stay_daily_cost (
price_date_from date,
price int
);
CREATE TABLE IF NOT EXISTS test_cost (
test_code int,
price_date_from date,
price int
);
INSERT INTO patient(patient_code, patient_name, phone_number) VALUES ('1111', 'Jane Doe', '(555) 585-1234');
INSERT INTO patient(patient_code, patient_name, phone_number) VALUES ('2222', 'John Smith', '(341) 657-1104');
INSERT INTO patient(patient_code, patient_name, phone_number) VALUES ('3333', 'Elizabeth Green', '(530) 555-9230');
INSERT INTO admission(patient_code, admission_datetime, admission_reason, bed_code, discharge_datetime) VALUES ('1111', '2023-01-01', 'abdominal pain', 'B31', '2023-01-10');
INSERT INTO admission(patient_code, admission_datetime, admission_reason, bed_code,discharge_datetime) VALUES ('2222', '2023-01-01', 'difficulty to breath', 'C40', '2023-01-01');
INSERT INTO admission(patient_code, admission_datetime, admission_reason, bed_code,discharge_datetime) VALUES ('3333', '2023-01-02', 'headache and dizziness', 'F300', '2023-01-06');
INSERT INTO stay_daily_cost(price_date_from, price) VALUES ( '2022-12-30', 10);
INSERT INTO stay_daily_cost(price_date_from, price) VALUES ( '2022-01-06', 12);
INSERT INTO test_admission(patient_code, admission_datetime, test_datetime, test_code, npi_number) VALUES ('1111', '2023-01-01', '2023-01-02', '2', '1245319599');
INSERT INTO test_admission(patient_code, admission_datetime, test_datetime, test_code, npi_number) VALUES ('1111', '2023-01-01', '2023-01-02', '3', '1245319599');
INSERT INTO test_admission(patient_code, admission_datetime, test_datetime, test_code, npi_number) VALUES ('2222', '2023-01-01', '2023-01-01', '1', '0265319599');
INSERT INTO test_admission(patient_code, admission_datetime, test_datetime, test_code, npi_number) VALUES ('3333', '2023-01-02', '2023-01-02', '3', '1245319599');
INSERT INTO test(test_code, test_name) VALUES ( 1, 'chest x-ray');
INSERT INTO test(test_code, test_name) VALUES ( 2, 'Complete Blood Count');
INSERT INTO test(test_code, test_name) VALUES ( 3, 'Urinalysis');
INSERT INTO test_cost(test_code, price_date_from, price) VALUES ( 1, '2022-12-30', 5);
INSERT INTO test_cost(test_code, price_date_from, price) VALUES ( 2, '2023-01-01', 2);
INSERT INTO test_cost(test_code, price_date_from, price) VALUES ( 3, '2022-12-30', 3);
INSERT INTO test_cost(test_code, price_date_from, price) VALUES ( 2, '2023-01-06', 5);
INSERT INTO doctor(npi_number, doctor_name, practice) VALUES ('1245319599', 'Julia Styles', 'radiology');
INSERT INTO doctor(npi_number, doctor_name, practice) VALUES ('0265319599', 'Greg Brown','biochemistry');