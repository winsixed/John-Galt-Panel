#!/bin/bash
set -o errexit -o pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
if ! "$DIR/db_backup.sh"; then
  if [ -n "$WEBHOOK_URL" ]; then
    curl -X POST -H 'Content-Type: application/json' -d '{"text":"db_backup failed"}' "$WEBHOOK_URL"
  fi
  exit 1
fi
