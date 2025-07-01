#!/bin/bash

FRONT_DIR="/var/www/John_Galt_Panel/frontend"
BACK_API="http://127.0.0.1:8000/api/inventory/"

echo "📦 [1/5] Установка зависимостей..."
cd "$FRONT_DIR"
npm install

echo "⚙️  [2/5] Сборка проекта..."
npm run build

echo "🚀 [3/5] Перезапуск SSR через pm2..."
pm2 delete john-galt-frontend || true
# Next.js 15 no longer generates a standalone server.js by default.
# Use `next start` via npm to serve the built app on port 3000.
pm2 start npm --name john-galt-frontend -- start

echo "🔄 [4/5] Перезапуск nginx..."
sudo systemctl reload nginx

echo ""
echo "🌐 Проверка API-инвентаря..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BACK_API")

if [ "$STATUS" = "200" ]; then
  echo "✅ Backend API работает: $BACK_API"
else
  echo "❌ Ошибка: backend вернул статус $STATUS"
fi

	

