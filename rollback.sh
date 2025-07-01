#!/bin/bash

set -e

echo "♻️ Откат из резервной копии..."
cd frontend
git reset --hard HEAD~1 || true
pm2 delete john-galt-frontend || true
pm2 start .next/standalone/server.js --name john-galt-frontend

echo "🔄 Перезапуск Nginx..."
sudo systemctl reload nginx

echo "✅ Откат завершён"
