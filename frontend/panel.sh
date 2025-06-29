#!/bin/bash

log_action() {
  mkdir -p logs
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> logs/panel.log
}

while true; do
  clear
  echo "=================================="
  echo "   🚀 DevOps Консоль управления"
  echo "=================================="

  echo "[ ОСНОВНОЕ ]"
  echo " 1. ❌ Выйти"
  echo " 2. 📦 Установить зависимости         (npm install)"
  echo " 3. ⚙️  Сборка фронтенда              (npm run build)"
  echo " 4. 🧹 Копирование ресурсов в out/    (public/* → out/)"
  echo " 5. 🔄 Перезапустить nginx"
  echo " 6. 🚀 Полный деплой вручную         (2 → 3 → 4 → 5)"
  echo " 7. 🧯 Откат из резервной копии       (out_backup/* → out/)"

  echo "[ GIT ОПЕРАЦИИ ]"
  echo " 8. 🔁 Git Pull                       (Обновление main)"
  echo " 9. 🧪 Zero Downtime Deploy          (build → temp → swap)"
  echo "10. 📤 Git Push                      (commit + push main)"
  echo "32. 🔖 Создать Git Tag"
  echo "33. ⬆️  Push всех тегов"
  echo "34. 🧹 Удалить все теги локально и в origin"

  echo "[ СЦЕНАРИИ И АРХИВАЦИЯ ]"
  echo "11. 🚀 DEPLOY-FULL (deploy-full.sh)  (автоматизация полной сборки)"
  echo "12. 🧯 ROLLBACK (rollback.sh)         (откат из последнего бэкапа)"
  echo "18. 🗂 Архивировать проект            (tar . → backups/)"
  echo "29. 🧹 Очистка логов"

  echo "[ BACKEND / API / БАЗА ]"
  echo "13. 🐍 Перезапустить backend         (systemctl restart web_panel)"
  echo "14. 📊 Статус backend и nginx"
  echo "15. 📄 Последние ошибки Gunicorn"
  echo "17. 🌐 Проверка API /api/inventory/"
  echo "36. 📤 Дамп PostgreSQL (pg_dump)"
  echo "37. 📥 Восстановление дампа PostgreSQL"

  echo "[ MONITORИНГ И СТАТИСТИКА ]"
  echo "16. 🚀 Pull + Build + Reload"
  echo "21. 💾 Диск и память (df, free)"
  echo "22. 📜 Просмотр лога панели"
  echo "23. ⚙️  Редактировать nginx config"
  echo "24. ✅ Проверка публичного сайта"
  echo "28. 🔍 Проверка портов (8000/nginx)"
  echo "31. 📊 Glances: загрузка, память и т.д."

  echo "[ ТЕСТЫ / ИНТЕГРАЦИИ ]"
  echo "25. 🔐 Проверка .env переменных"
  echo "26. 🧪 Тесты фронта (npm test)"
  echo "27. 🧪 Тесты бэка (pytest)"
  echo "35. 📅 Настроить cron-бэкап"
  echo "38. 🛠 Telegram Token из .env"
  echo "39. 📬 Лог уведомлений Telegram"
  echo "40. 🚀 GitHub Actions trigger"

  echo "=================================="
  read -p "Выберите действие: " choice

  case $choice in
    1) exit 0 ;;
    2) npm install ;;
    3) npm run build ;;
    4) rm -rf out/images out/*.jpg out/*.png out/*.svg out/*.ico; cp -r public/* out/ ;;
    5) sudo systemctl reload nginx ;;
    6) npm install && npm run build && cp -r public/* out/ && sudo systemctl reload nginx ;;
    7) cp -r out_backup/* out/ && sudo systemctl reload nginx ;;
    8) git pull origin main ;;
    9) rm -rf out_temp/ && mkdir -p out_temp/ && npm run build && cp -r public/* out_temp/ && mv out out_backup_$(date +%s) && mv out_temp out && sudo systemctl reload nginx ;;
    10) git add .; read -p "Комментарий: " msg; git commit -m "${msg:-autocommit $(date)}"; git push origin main ;;
    11) ./deploy-full.sh ;;
    12) ./rollback.sh ;;
    13) sudo systemctl restart web_panel ;;
    14) systemctl status web_panel --no-pager; systemctl status nginx --no-pager; read -p "Enter..." ;;
    15) journalctl -u web_panel.service -n 20 --no-pager; read -p "Enter..." ;;
    16) git pull origin main && npm run build && cp -r public/* out/ && sudo systemctl reload nginx ;;
    17) curl -s -o /dev/null -w "HTTP: %{http_code}\n" http://127.0.0.1:8000/api/inventory/; read -p "Enter..." ;;
    18) mkdir -p ../backups; tar czf ../backups/project_$(date +%Y%m%d_%H%M%S).tar.gz . ;;
    21) df -h | grep /$; free -h; read -p "Enter..." ;;
    22) less logs/panel.log ;;
    23) nano /etc/nginx/sites-available/default ;;
    24) curl -s -o /dev/null -w "HTTP: %{http_code}\n" https://johngaltbar.ru; read -p "Enter..." ;;
    25)
      echo "Проверка переменных .env:"
      test -f .env && source .env
      for var in POSTGRESQL_HOST POSTGRESQL_PORT POSTGRESQL_USER POSTGRESQL_DBNAME; do
        val=$(grep "^$var=" .env | cut -d= -f2)
        if [ -z "$val" ]; then echo "❌ $var не задан"; else echo "✅ $var = $val"; fi
      done
      read -p "Enter..." ;;
    26) npm test || echo "❌ npm test failed"; read -p "Enter..." ;;
    27) pytest || echo "❌ pytest not found or failed"; read -p "Enter..." ;;
    28) ss -tulnp | grep -E ":8000|:80"; read -p "Enter..." ;;
    29) rm -f logs/*.log; echo "✅ Логи очищены"; read -p "Enter..." ;;
  esac
  log_action "Выполнен пункт $choice"
done
