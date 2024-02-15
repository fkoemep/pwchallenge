import pendulum
from airflow import AirflowException
from airflow.decorators import task
from airflow.models import Variable
from airflow.models import Connection


@task(retries=3, retry_delay=pendulum.duration(seconds=30))
def extract():
    from sqlalchemy import create_engine
    import pandas as pd

    select_admission_query = Variable.get('select_admission_query')
    select_test_admission_query = Variable.get('select_test_admission_query')
    connection = Connection.get_connection_from_secrets('medicaldata_connection')
    uri = connection.get_uri().replace('postgres://', 'postgresql://')
    engine = create_engine(uri)

    try:
        with engine.begin() as conn:

            data_stays = pd.read_sql_query(select_admission_query, conn)
            data_tests = pd.read_sql_query(select_test_admission_query, conn)

            print('Got the following stays data from Postgres...')
            print(data_stays.to_json(orient='records', lines=True))

            print('Got the following tests data from Postgres...')
            print(data_tests.to_json(orient='records', lines=True))

            return {'data_stays': data_stays, 'data_tests': data_tests}

    except Exception as e:
        raise AirflowException("Error while reading data from Postgres")
