#!/bin/bash

FRONT_DIR="/var/www/John_Galt_Panel/frontend"
BACK_API="http://127.0.0.1:8000/api/inventory/"

echo "📦 [1/5] Установка зависимостей..."
cd "$FRONT_DIR"
npm install

echo "⚙️  [2/5] Сборка проекта..."
npm run build

echo "🧹 [3/5] Очистка старых ресурсов..."
rm -rf out/images out/*.jpg out/*.png out/*.svg out/*.ico

echo "📂 [4/5] Копирование public/ → out/"
cp -r public/* out/

echo "🔄 [5/5] Перезапуск nginx..."
sudo systemctl reload nginx

echo ""
echo "🌐 Проверка API-инвентаря..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BACK_API")

if [ "$STATUS" = "200" ]; then
  echo "✅ Backend API работает: $BACK_API"
else
  echo "❌ Ошибка: backend вернул статус $STATUS"
fi

	

