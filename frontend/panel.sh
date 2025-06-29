#!/bin/bash

while true; do
  clear
  echo "============================"
  echo "  Панель управления проектом"
  echo "============================"
  echo "1. ❌ Выйти"
  echo "2. 📦 Установить зависимости"
  echo "3. ⚙️  Собрать фронтенд"
  echo "4. 🧹 Копировать public/* в out/"
  echo "5. 🔄 Перезапустить nginx"
  echo "6. 🚀 Полный деплой (2-3-5)"
  echo "7. 🧯 Откат (из out_backup)"
  echo "8. 🔁 Git Pull"
  echo "9. 🧪 Zero Downtime Deploy"
  echo "10. 📤 Git Push (commit + push)"
  echo "============================"
  read -p "Выберите действие: " choice

  case $choice in
    1)
      echo "Выход..."
      exit 0
      ;;
    2)
      npm install
      read -p "Нажмите Enter для возврата..."
      ;;
    3)
      npm run build
      read -p "Нажмите Enter для возврата..."
      ;;
    4)
      rm -rf out/images out/*.jpg out/*.png out/*.svg out/*.ico
      cp -r public/* out/
      read -p "Готово. Нажмите Enter..."
      ;;
    5)
      sudo systemctl reload nginx
      read -p "nginx перезапущен. Нажмите Enter..."
      ;;
    6)
      npm install && npm run build
      cp -r public/* out/
      sudo systemctl reload nginx
      read -p "Полный деплой завершён. Нажмите Enter..."
      ;;
    7)
      cp -r out_backup/* out/
      sudo systemctl reload nginx
      read -p "Откат выполнен. Нажмите Enter..."
      ;;
    8)
      git pull origin main
      read -p "Git Pull завершён. Нажмите Enter..."
      ;;
    9)
      echo "🧪 Zero Downtime Deploy..."
      rm -rf out_temp/
      mkdir -p out_temp/
      npm run build && cp -r public/* out_temp/
      if [ $? -eq 0 ]; then
        mv out out_backup_$(date +%s)
        mv out_temp out
        sudo systemctl reload nginx
        echo "✅ Успешный zero-downtime деплой"
      else
        echo "❌ Ошибка сборки. Zero deploy отменён."
      fi
      read -p "Нажмите Enter для возврата..."
      ;;
    10)
      echo "📤 Git Push: коммит и отправка в origin/main"
      git add .
      read -p "Введите комментарий к коммиту: " msg
      git commit -m "${msg:-autocommit $(date)}"
      git push origin main
      read -p "✅ Изменения запушены. Нажмите Enter..."
      ;;
    *)
      echo "Неверный выбор. Попробуйте снова."
      sleep 1
      ;;
  esac
done
