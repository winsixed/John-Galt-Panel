#!/bin/bash
set -o errexit -o pipefail
if ! pm2 resurrect; then
  if [ -n "$WEBHOOK_URL" ]; then
    curl -X POST -H 'Content-Type: application/json' -d '{"text":"pm2_resurrect failed"}' "$WEBHOOK_URL"
  fi
  exit 1
fi
