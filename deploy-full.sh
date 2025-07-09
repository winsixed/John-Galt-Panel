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
# ensure the static files are present in standalone
mkdir -p .next/standalone/.next
cp -R .next/static .next/standalone/.next/
cd .next/standalone
pm2 delete john-galt-frontend || true
pm2 start server.js --name john-galt-frontend
cd "$NEW_RELEASE"

ln -sfn "$NEW_RELEASE" "$CURRENT"

systemctl reload nginx
systemctl restart web_panel

echo "✅ DEPLOY-FULL завершён"
