# Start with offical base image
FROM apache/superset:1.0.0rc4

## Install additional dependencies
USER root
RUN pip install psycopg2 pyhive pymssql elasticsearch-dbapi
RUN git clone https://github.com/aadel/sqlalchemy-solr && cd sqlalchemy-solr && python3 setup.py install 

# Switch back to runtime user:
USER superset

