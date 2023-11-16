# Start with offical base image
FROM apache/superset:3.0.1

## Install additional dependencies
USER root

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    git && \
    apt-get clean && \
    pip install -U pip

RUN pip install psycopg2 pyhive pymssql elasticsearch-dbapi duckdb
RUN git clone https://github.com/aadel/sqlalchemy-solr && cd sqlalchemy-solr && python3 setup.py install 

# Switch back to runtime user:
USER superset

