import pendulum
from airflow import AirflowException
from airflow.decorators import task
from airflow.models import Variable
from airflow.models import Connection


@task(retries=3, retry_delay=pendulum.duration(seconds=30))
def extract():
    from sqlalchemy import create_engine
    import pandas as pd

    select_alternative_query = Variable.get('select_alternative_query')
    connection = Connection.get_connection_from_secrets('medicaldata_connection')
    uri = connection.get_uri().replace('postgres://', 'postgresql://')
    engine = create_engine(uri)

    try:
        with engine.begin() as conn:

            data = pd.read_sql_query(select_alternative_query, conn)

            print('Got the following data from Postgres...')
            print(data.to_json(orient='records', lines=True))

            return data

    except Exception as e:
        raise AirflowException("Error while reading data from Postgres")
