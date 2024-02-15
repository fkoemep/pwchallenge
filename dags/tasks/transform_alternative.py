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

    dim_patient = data[['patient_code']].drop_duplicates()
    fact_hospital_events = data[['total_stay_cost', 'admission_datetime', 'discharge_datetime', 'total_tests_cost', 'patient_code']]

    # renaming columns
    dim_patient = dim_patient.rename(columns={
        'patient_code': 'patient_id',
    })
    fact_hospital_events = fact_hospital_events.rename(columns={
        'patient_code': 'patient_id',
        'admission_datetime': 'admission_test_date',
        'discharge_datetime': 'discharge_date',
    })

    return {'dim_patient': dim_patient, 'fact_hospital_events': fact_hospital_events}
