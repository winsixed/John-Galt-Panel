#!/bin/bash

set -e

echo "♻️ Откат из резервной копии..."
cd frontend
git reset --hard HEAD~1 || true
pm2 delete john-galt-frontend || true
# Use npm start to run the built Next.js app after rollback
pm2 start npm --name john-galt-frontend -- start

echo "🔄 Перезапуск Nginx..."
sudo systemctl reload nginx

echo "✅ Откат завершён"
