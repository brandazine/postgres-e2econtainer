ARG POSTGRES_VERSION
ARG ALPINE_VERSION=3.20
ARG HLL_VERSION=2.18

FROM hbontempo/postgres-hll:${POSTGRES_VERSION}-alpine${ALPINE_VERSION}-v${HLL_VERSION} as base

COPY ./configs/postgresql.conf /usr/local/share/postgresql/postgresql.conf

CMD ["postgres", "-c", "config_file=/usr/local/share/postgresql/postgresql.conf"]
