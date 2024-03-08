#!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
  echo >&2 "Error: psql is not installed."
  exit 1
fi

if ! [ -x "$(command -v sqlx)" ]; then
  echo >&2 "Error: sqlx is not installed."
  echo >&2 "Use:"
  echo >&2 "    cargo install --version=0.7.1 sqlx-cli --no-default-features --features postgres"
  echo >&2 "to install it."
  exit 1
fi

export POSTGRES_DB=newsletter
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=password

if [[ -z "${SKIP_DOCKER}" ]]; then
  docker compose up -d db
fi

export PGPASSWORD=${POSTGRES_PASSWORD}
until psql -h "localhost" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

export DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:5432/${POSTGRES_DB}
sqlx database create
sqlx migrate run
