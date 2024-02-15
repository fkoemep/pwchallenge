FROM python:3.12-slim

RUN mkdir /app
COPY jupyter /app
WORKDIR /app
RUN pip install jupyterlab
RUN pip install psycopg[binary]
RUN pip install pandas
RUN pip install SQLAlchemy
RUN pip install pyarrow

ADD jupyter/overrides.json /usr/local/share/jupyter/lab/settings/overrides.json