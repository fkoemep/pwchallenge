import pendulum
from airflow import AirflowException
from airflow.decorators import task
from airflow.models import Connection


@task(retries=1, retry_delay=pendulum.duration(seconds=30))
def load(data):
    from sqlalchemy import create_engine
    import pandas as pd
    from sqlalchemy.dialects.postgresql import insert

    connection = Connection.get_connection_from_secrets("hydra_connection")
    uri = connection.get_uri().replace('postgres://', 'postgresql://')
    engine = create_engine(uri)

    def insert_on_conflict_nothing(table, conn, keys, data_iter):
        data = [dict(zip(keys, row)) for row in data_iter]
        stmt = insert(table.table).values(data).on_conflict_do_nothing()
        result = conn.execute(stmt)
        return result.rowcount

    try:
        with engine.begin() as conn:

            # dim_patient
            print('Loading the following dim_patient records to Hydra...')
            print(data['dim_patient'].to_json(orient='records', lines=True))

            data['dim_patient'].to_sql('dim_patient', conn, if_exists="append", index=False, method=insert_on_conflict_nothing)

            # fact_hospital_events
            print('Loading the following fact_hospital_events_alternative records to Hydra...')
            print(data['fact_hospital_events'].to_json(orient='records', lines=True))

            data['fact_hospital_events'].to_sql('fact_hospital_events_alternative', conn, if_exists="append", index=False)

    except Exception as e:
        raise AirflowException("Error while loading data to Hydra")




