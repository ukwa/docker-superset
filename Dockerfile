ARG PY_VER=3.7.9
FROM python:${PY_VER} AS lean

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    FLASK_ENV=production \
    FLASK_APP="superset.app:create_app()" \
    PYTHONPATH="/app/pythonpath" \
    SUPERSET_HOME="/app/superset_home" \
    SUPERSET_PORT=8080

RUN useradd --user-group --no-create-home --no-log-init --shell /bin/bash superset \
        && mkdir -p ${SUPERSET_HOME} ${PYTHONPATH} \
        && apt-get update -y \
        && apt-get install -y --no-install-recommends \
            build-essential \
            default-libmysqlclient-dev \
            libpq-dev \
        && rm -rf /var/lib/apt/lists/*

## Install
RUN cd /app \
        && chown -R superset:superset * \
        && pip install apache-superset Pillow redis psycopg2 pyhive pyldap pymssql elasticsearch-dbapi

RUN git clone https://github.com/aadel/sqlalchemy-solr && cd sqlalchemy-solr && python3 setup.py install 


COPY ./docker/docker-entrypoint.sh /usr/bin/

WORKDIR /app

USER superset

HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]

EXPOSE ${SUPERSET_PORT}

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

