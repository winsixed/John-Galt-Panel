#!/bin/bash
set -o errexit -o pipefail

DIR="$(dirname "$0")/../dumps"
mkdir -p "$DIR"

# remove old backups older than 30 days
find "$DIR" -type f -mtime +30 -delete

timestamp=$(date +%F_%H%M%S)
pg_dump -U "${PGUSER:-postgres}" -d "${PGDATABASE:-john_galt}" -F c \
  | gpg --batch --yes --symmetric --cipher-algo AES256 --passphrase "$GPG_PASSPHRASE" \
  -o "$DIR/db_${timestamp}.dump.gpg"
