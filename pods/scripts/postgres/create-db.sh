#!/bin/bash
set -e

echo "Creating databases for services:
    Database: $DB_NAME"

psql --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE $DB_NAME;
    GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $POSTGRES_USER;
EOSQL