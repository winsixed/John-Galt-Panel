#!/bin/bash
set -o errexit -o pipefail

BASE_DIR="/var/www/John_Galt_Panel"
RELEASES="$BASE_DIR/releases"
CURRENT="$BASE_DIR/current"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
NEW_RELEASE="$RELEASES/$TIMESTAMP"

mkdir -p "$RELEASES"
REPO_URL=${REPO_URL:-$(git config --get remote.origin.url)}
git clone "$REPO_URL" "$NEW_RELEASE"

cd "$NEW_RELEASE/frontend"
npm ci
npm run build
pm2 delete john-galt-frontend || true
pm2 start npm --name john-galt-frontend -- start

ln -sfn "$NEW_RELEASE" "$CURRENT"

systemctl reload nginx
systemctl restart web_panel

echo "✅ DEPLOY-FULL завершён"
