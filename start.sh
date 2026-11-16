#!/bin/sh
# Small wrapper for Railway: listen on $PORT and cap the native heap.
set -e

# Railway routes the public domain to $PORT. CommaFeed's default is 8082.
export QUARKUS_HTTP_PORT="${PORT:-8082}"

# If no JDBC URL is given but Railway Postgres variables are, build it from them.
if [ -z "${QUARKUS_DATASOURCE_JDBC_URL:-}" ] && [ -n "${PGHOST:-}" ]; then
  export QUARKUS_DATASOURCE_JDBC_URL="jdbc:postgresql://${PGHOST}:${PGPORT:-5432}/${PGDATABASE:-railway}"
  export QUARKUS_DATASOURCE_USERNAME="${QUARKUS_DATASOURCE_USERNAME:-${PGUSER:-postgres}}"
  export QUARKUS_DATASOURCE_PASSWORD="${QUARKUS_DATASOURCE_PASSWORD:-${PGPASSWORD:-}}"
fi

if [ -z "${QUARKUS_DATASOURCE_JDBC_URL:-}" ]; then
  echo "CommaFeed: QUARKUS_DATASOURCE_JDBC_URL is not set (this image needs PostgreSQL)." >&2
  exit 1
fi

# Native-image heap cap. Override with COMMAFEED_MAX_HEAP (for example 1g).
exec ./commafeed "-Xmx${COMMAFEED_MAX_HEAP:-512m}"
