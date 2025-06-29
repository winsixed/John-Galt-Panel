#!/bin/bash

set -e  # Если что-то падает — останавливаем скрипт

PROJECT_DIR="/var/www/John_Galt_Panel"
FRONT_DIR="$PROJECT_DIR/frontend"
API_URL="http://127.0.0.1:8000/api/inventory/"

echo "🔄 [1/6] Переход в проект и обновление кода из git..."
cd "$PROJECT_DIR"
git pull origin main

echo "📦 [2/6] Установка зависимостей frontend..."
cd "$FRONT_DIR"
npm install

echo "⚙️  [3/6] Сборка frontend (Next.js)..."
npm run build

echo "🧹 [4/6] Очистка старых ресурсов..."
rm -rf out/images out/*.jpg out/*.png out/*.svg out/*.ico

echo "📂 [5/6] Копирование public/ → out/"
cp -r public/* out/

echo "🔄 [6/6] Перезапуск nginx..."
sudo systemctl reload nginx

echo "🌐 Проверка доступности API-инвентаря..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL")
if [ "$STATUS" = "200" ]; then
  echo "✅ API-инвентарь работает: $API_URL"
else
  echo "❌ API ответил статусом: $STATUS"
fi
