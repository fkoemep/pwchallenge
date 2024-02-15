from airflow.decorators import task
# from airflow.providers.apache.spark.decorators import pyspark
import typing

if typing.TYPE_CHECKING:
    from pyspark import SparkContext
    from pyspark.sql import SparkSession


@task()
def transform(data):
    import pandas as pd
    from datetime import datetime

    # selecting the columns we're interested in
    data_stays = data['data_stays']
    data_tests = data['data_tests']

    dim_doctor = data_tests[['npi_number', 'doctor_name', 'doctor_practice']].drop_duplicates()
    dim_patient = data_stays[['patient_code']].drop_duplicates()
    dim_test = data_tests[['test_code', 'test_name']].drop_duplicates()
    fact_hospital_events_stays = data_stays[['total_stay_cost', 'patient_code', 'admission_datetime', 'discharge_datetime']]
    fact_hospital_events_tests = data_tests[['test_cost', 'patient_code', 'npi_number', 'test_datetime', 'test_code']]

    fact_hospital_events_stays['event_type'] = 'stay'
    fact_hospital_events_tests['event_type'] = 'test'

    # renaming columns
    dim_doctor = dim_doctor.rename(columns={
        'npi_number': 'doctor_npi_number',
        'doctor_name': 'name',
        'doctor_practice': 'practice',
    })
    dim_patient = dim_patient.rename(columns={
        'patient_code': 'patient_id',
    })
    dim_test = dim_test.rename(columns={
        'test_name': 'name',
        'test_code': 'test_id',
    })
    fact_hospital_events_stays = fact_hospital_events_stays.rename(columns={
        'total_stay_cost': 'total_cost',
        'patient_code': 'patient_id',
        'admission_datetime': 'admission_test_date',
        'discharge_datetime': 'discharge_date',
    })
    fact_hospital_events_tests = fact_hospital_events_tests.rename(columns={
        'test_cost': 'total_cost',
        'patient_code': 'patient_id',
        'test_datetime': 'admission_test_date',
        'npi_number': 'doctor_npi_number',
        'test_code': 'test_id',
    })

    fact_hospital_events = pd.concat([fact_hospital_events_stays, fact_hospital_events_tests], ignore_index=True)

    return {'dim_doctor': dim_doctor, 'dim_patient': dim_patient, 'dim_test': dim_test, 'fact_hospital_events': fact_hospital_events}
