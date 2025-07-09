#!/bin/bash
set -o errexit -o pipefail

BASE_DIR="/var/www/John_Galt_Panel"
RELEASES="$BASE_DIR/releases"
CURRENT="$BASE_DIR/current"

prev_release=$(ls -dt "$RELEASES"/* | sed -n '2p' || true)
if [ -z "$prev_release" ]; then
  echo "No previous release found" >&2
  exit 1
fi

ln -sfn "$prev_release" "$CURRENT"

latest_dump=$(ls -t dumps/*.dump.gpg 2>/dev/null | head -n 1 || true)
if [ -n "$latest_dump" ]; then
  echo "Restoring database from $latest_dump"
  gpg --batch --yes --decrypt "$latest_dump" | pg_restore --clean --if-exists -U "${PGUSER:-postgres}" -d "${PGDATABASE:-john_galt}"
fi

cd "$CURRENT/frontend"
pm2 delete john-galt-frontend || true
pm2 start npm --name john-galt-frontend -- start

systemctl reload nginx
systemctl restart web_panel

echo "✅ Откат завершён"
