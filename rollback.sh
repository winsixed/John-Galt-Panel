#!/bin/bash

set -e

echo "♻️ Откат из резервной копии..."
cd frontend
cp -r out_backup/* out/ || { echo "❌ Не удалось скопировать бэкап"; exit 1; }

echo "🔄 Перезапуск Nginx..."
sudo systemctl reload nginx

echo "✅ Откат завершён"
