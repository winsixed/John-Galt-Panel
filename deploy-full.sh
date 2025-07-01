#!/bin/bash

set -e

echo "🔁 Git Pull..."
git pull origin main || { echo "❌ Git Pull failed"; exit 1; }

echo "📦 Установка зависимостей (frontend)..."
cd frontend
npm install || { echo "❌ npm install завершился с ошибкой"; exit 1; }

echo "⚙️  Сборка проекта (Next.js)..."
npm run build || { echo "❌ Ошибка сборки"; exit 1; }

echo "🚀 Перезапуск SSR через pm2..."
pm2 delete john-galt-frontend || true
# Start the built Next.js app using `next start` instead of standalone server.js
pm2 start npm --name john-galt-frontend -- start

cd ..

echo "🔄 Перезапуск Nginx..."
sudo systemctl reload nginx

echo "🚀 Перезапуск backend (FastAPI)..."
sudo systemctl restart web_panel

echo "✅ DEPLOY-FULL завершён"
