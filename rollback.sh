#!/bin/bash

set -e

echo "♻️ Откат из резервной копии..."

# Restore latest database dump if available
latest_dump=$(ls -t dumps/*.dump dumps/*.sql 2>/dev/null | head -n 1 || true)
if [ -n "$latest_dump" ]; then
  echo "💾 Восстановление базы данных из $latest_dump"
  if [[ "$latest_dump" == *.dump ]]; then
    pg_restore --clean --if-exists -U "${PGUSER:-postgres}" -d "${PGDATABASE:-john_galt}" "$latest_dump"
  else
    psql -U "${PGUSER:-postgres}" -d "${PGDATABASE:-john_galt}" < "$latest_dump"
  fi
else
  echo "⚠️  Файл дампа не найден"
fi

cd frontend
git reset --hard HEAD~1 || true
pm2 delete john-galt-frontend || true
# Use npm start to run the built Next.js app after rollback
pm2 start npm --name john-galt-frontend -- start

echo "🔄 Перезапуск Nginx..."
sudo systemctl reload nginx

echo "✅ Откат завершён"
