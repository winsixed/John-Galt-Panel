#!/bin/bash
set -e
DIR="$(dirname "$0")/../dumps"
mkdir -p "$DIR"
pg_dump -U "${PGUSER:-postgres}" -d "${PGDATABASE:-john_galt}" -F c -f "$DIR/db_$(date +%F_%H%M%S).dump"
