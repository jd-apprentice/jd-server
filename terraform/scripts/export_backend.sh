#!/bin/bash

PG_USER="${1:-postgres_user}"
PG_PASSWORD="${2:-postgres_password}"
PG_HOST="${3:-localhost}"
PG_PORT="${4:-5432}"
PG_DATABASE="${5:-postgres}"

export PG_CONN_STR="postgres://${PG_USER}:${PG_PASSWORD}@${PG_HOST}:${PG_PORT}/${PG_DATABASE}?sslmode=disable"
