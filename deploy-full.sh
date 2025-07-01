#!/bin/bash

set -e

echo "🔁 Git Pull..."
git pull origin main || { echo "❌ Git Pull failed"; exit 1; }

echo "📦 Установка зависимостей..."
cd frontend
npm install || { echo "❌ npm install завершился с ошибкой"; exit 1; }

echo "⚙️  Сборка проекта..."
npm run build || { echo "❌ Ошибка сборки"; exit 1; }

echo "📂 Копирование в out/"
rm -rf out/images out/*.jpg out/*.png out/*.svg out/*.ico
cp -r public/* out/

echo "🔄 Перезапуск Nginx..."
sudo systemctl reload nginx

echo "✅ DEPLOY-FULL завершён"
