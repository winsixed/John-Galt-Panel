#!/bin/bash

set -e

FRONT_DIR="/var/www/John_Galt_Panel/frontend"
BUILD_DIR="$FRONT_DIR/out-temp"
FINAL_DIR="$FRONT_DIR/out"
BACKUP_DIR="$FRONT_DIR/out-backup-$(date +%s)"
PUBLIC_DIR="$FRONT_DIR/public"

echo "📦 [1/6] Установка зависимостей..."
cd "$FRONT_DIR"
npm install

echo "⚙️  [2/6] Сборка проекта во временную папку..."
rm -rf "$BUILD_DIR"
npm run build
cp -r "$PUBLIC_DIR"/* "$BUILD_DIR/"

echo "🧪 [3/6] Проверка nginx конфига..."
sudo nginx -t || { echo "❌ Ошибка nginx конфигурации"; exit 1; }

echo "🛡 [4/6] Бэкап текущей версии в: $BACKUP_DIR"
mv "$FINAL_DIR" "$BACKUP_DIR"

echo "🚀 [5/6] Переключение на новую версию"
mv "$BUILD_DIR" "$FINAL_DIR"

echo "🔄 [6/6] Перезапуск nginx..."
sudo systemctl reload nginx

echo "✅ Готово! Панель обновлена без простоев."
