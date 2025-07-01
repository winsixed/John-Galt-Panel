#!/bin/bash

echo "📦 [1/4] Установка зависимостей..."
npm install

echo "⚙️  [2/4] Сборка проекта..."
npm run build

echo "🧹 [3/4] Очистка старых статичных данных..."
rm -rf out/images out/*.jpg out/*.png out/*.svg out/*.ico

echo "📂 [4/4] Копирование public/ в out/..."
cp -r public/* out/

echo "✅ Готово! Static frontend собран и ресурсы скопированы."

	
