#!/usr/bin/env bash

set -euo pipefail

DATABASE_NAME="online_store"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v psql >/dev/null 2>&1; then
  echo "Error: psql is not installed." >&2
  exit 1
fi

if [[ "${EUID}" -eq 0 ]] && id postgres >/dev/null 2>&1; then
  PSQL=(runuser -u postgres -- psql)
  CREATEDB=(runuser -u postgres -- createdb)
else
  PSQL=(psql)
  CREATEDB=(createdb)
fi

echo "Checking for database: $DATABASE_NAME"
database_exists="$("${PSQL[@]}" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$DATABASE_NAME'")"

if [[ "$database_exists" != "1" ]]; then
  echo "Creating database: $DATABASE_NAME"
  "${CREATEDB[@]}" "$DATABASE_NAME"
else
  echo "Database already exists."
fi

echo "Creating tables, constraints, and indexes..."
"${PSQL[@]}" -v ON_ERROR_STOP=1 -d "$DATABASE_NAME" -f "$PROJECT_DIR/sql/01_schema.sql"

echo "Loading sample data..."
"${PSQL[@]}" -v ON_ERROR_STOP=1 -d "$DATABASE_NAME" -f "$PROJECT_DIR/sql/02_seed.sql"

echo "Verifying database..."
"${PSQL[@]}" -v ON_ERROR_STOP=1 -d "$DATABASE_NAME" -f "$PROJECT_DIR/sql/04_verify.sql"

echo "Online store database setup completed."
