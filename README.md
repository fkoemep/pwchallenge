# PWC ETL Process

A simple ETL process that extracts data from a medical data postgres DB, transforms it, and loads it into a Hydra Data Warehouse. A separate Jupyter Notebook running as an extra docker-compose service is also included to allow for data exploration.

This project uses the new Airflow 2.0 version that runs on docker-compose along with the new TaskFlow API. The LocalFilesystemBackend is used as a Secrets Engine to store the database credentials for security reasons.

The docker-compose file is based on the official Airflow docker-compose file with some modifications to include a Jupyter Notebook service.


## Usage
To start the services, run the following command from the root directory:

```bash
docker-compose up
```

And you will be able to run the two different DAGs from the Airflow UI, after the ETL process is finished you can explore the data using the Jupyter Notebook called data_consumer.

Airflow UI: http://localhost:8080

Juptyer Notebook: http://localhost:8888

You can also access the database and the data warehouse using the following connection urls:

```bash
Data Warehouse: postgresql://localhost:5434/
Medical DB: postgresql://localhost:5433/medicaldata

```

user and password for both databases are: admin