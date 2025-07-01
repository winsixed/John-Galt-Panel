#!/bin/bash

# Цвета
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

log_action() {
  mkdir -p logs
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> logs/panel.log
}

case "$1" in
  frontend:build)
    echo "🔧 Сборка фронтенда (SSR)..."
    cd frontend

    echo "▶️ Применение patch.diff..."
    git pull origin main
    if [ -f patch.diff ]; then
      git apply patch.diff && echo "✅ Патч применён"
    else
      echo "⚠️  patch.diff не найден"
    fi

    npm install
    npm run build

    echo "🧹 Перезапуск SSR-сервера через pm2..."
    pm2 delete john-galt-frontend || true
    pm2 start .next/standalone/server.js --name john-galt-frontend

    exit 0
    ;;
esac

while true; do
  clear
  echo "============================================"
  echo "   🚀 ${bold}DevOps Панель управления проектом${normal}"
  echo "============================================"

  echo "${bold}[1-10] ОСНОВНОЕ УПРАВЛЕНИЕ${normal}"
  echo " 1. ❌ Выйти"
  echo " 2. 📦 Установить зависимости       (npm install)"
  echo " 3. ⚙️  Сборка фронтенда            (npm run build)"
  echo " 4. 🧹 Копировать public/ в out/    (очистка и копирование ресурсов)"
  echo " 5. 🔄 Перезапуск nginx             (systemctl reload nginx)"
  echo " 6. 🚀 Полный деплой                (2 → 3 → 4 → 5)"
  echo " 7. 🧯 Откат из резервной копии     (out_backup/* → out/)"
  echo " 8. 🔁 Git Pull                     (обновить main)"
  echo " 9. 🧪 Zero Downtime Deploy         (временная out → swap)"
  echo "10. 📤 Git Push                     (commit + push)"

  echo "${bold}[11-20] GIT И СЦЕНАРИИ${normal}"
  echo "11. 🚀 DEPLOY-FULL                  (запуск deploy-full.sh)"
  echo "12. 🧯 ROLLBACK                     (откат rollback.sh)"
  echo "13. 📄 Применить patch.diff         (если файл существует)"
  echo "14. 🔖 Создать Git Tag              (ручной ввод)"
  echo "15. ⬆️  Отправить все теги          (git push --tags)"
  echo "16. 🧹 Удалить все локальные теги   (и с origin)"

  echo "${bold}[21-30] BACKEND И API${normal}"
  echo "21. 🐍 Перезапустить backend        (Gunicorn systemctl)"
  echo "22. 📊 Статус backend и nginx"
  echo "23. 🧾 Последние ошибки Gunicorn"
  echo "24. 🌐 Проверка API /api/inventory/"
  echo "25. 📤 Дамп PostgreSQL              (pg_dump → dumps/)"
  echo "26. 📥 Восстановление дампа         (из последнего дампа)"
  echo "27. 🔐 Проверка .env переменных"
  echo "28. 💬 Telegram Token из .env"
  echo "29. 📬 Лог уведомлений Telegram"
  echo "30. 🚀 GitHub Actions Webhook Trigger"

  echo "${bold}[31-40] МОНИТОРИНГ И УТИЛИТЫ${normal}"
  echo "31. 📦 Pull + Build + Reload        (обновление + перезапуск)"
  echo "32. 💾 Проверка диска и памяти"
  echo "33. 📜 Просмотр лога панели"
  echo "34. ⚙️  Редактировать nginx config"
  echo "35. ✅ Проверка публичного сайта"
  echo "36. 🔍 Проверка портов 80/8000"
  echo "37. 📊 Glances (нагрузка, процессы)"
  echo "38. 🧼 Очистка логов панели"
  echo "39. 🧰 Архив проекта                (tar.gz в backups/)"
  echo "40. 🕒 Настроить cron-бэкап"

  echo "============================================"
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
    10) git add .; read -p "Комментарий к коммиту: " msg; git commit -m "${msg:-auto-commit $(date)}"; git push origin main ;;
    11) ./deploy-full.sh ;;
    12) ./rollback.sh ;;
    13)
      echo "▶️ Применение patch.diff..."
      git pull origin main
      if [ -f patch.diff ]; then
        git apply patch.diff && echo "✅ Патч применён"
      else
        echo "⚠️  patch.diff не найден"
      fi
      npm install && npm run build && cp -r public/* out/ && sudo systemctl reload nginx
      ;;
    14) read -p "Введите тег: " tag; git tag "$tag"; echo "✅ Тег создан: $tag" ;;
    15) git push origin --tags ;;
    16) git tag | xargs git tag -d; git push origin --delete $(git tag) ;;
    21) sudo systemctl restart web_panel ;;
    22) systemctl status web_panel --no-pager; systemctl status nginx --no-pager; read -p "Enter..." ;;
    23) journalctl -u web_panel.service -n 20 --no-pager; read -p "Enter..." ;;
    24) curl -s -o /dev/null -w "HTTP: %{http_code}\n" http://127.0.0.1:8000/api/inventory/; read -p "Enter..." ;;
    25) mkdir -p dumps && pg_dump -U postgres -d your_dbname > dumps/dump_$(date +%F_%T).sql && echo "✅ Дамп создан" ;;
    26) latest_dump=$(ls -t dumps/*.sql | head -n 1); psql -U postgres -d your_dbname < "$latest_dump"; echo "✅ Дамп восстановлен: $latest_dump" ;;
    27)
      echo "🧪 Проверка .env переменных:"
      test -f .env && source .env
      for var in POSTGRESQL_HOST POSTGRESQL_PORT POSTGRESQL_USER POSTGRESQL_DBNAME; do
        val=$(grep "^$var=" .env | cut -d= -f2)
        if [ -z "$val" ]; then echo "❌ $var не задан"; else echo "✅ $var = $val"; fi
      done
      read -p "Enter..." ;;
    28) grep TELEGRAM_TOKEN .env ;;
    29) cat logs/telegram.log | tail -n 20; read -p "Enter..." ;;
    30) curl -X POST https://api.github.com/repos/YOUR_USER/YOUR_REPO/dispatches -H "Accept: application/vnd.github.v3+json" -H "Authorization: token YOUR_TOKEN" -d '{"event_type":"deploy"}' ;;
    31) git pull origin main && npm run build && cp -r public/* out/ && sudo systemctl reload nginx ;;
    32) df -h | grep /$; free -h; read -p "Enter..." ;;
    33) less logs/panel.log ;;
    34) sudo nano /etc/nginx/sites-available/default ;;
    35) curl -s -o /dev/null -w "HTTP: %{http_code}\n" http://localhost; read -p "Enter..." ;;
    36) ss -tulnp | grep -E ":8000|:80"; read -p "Enter..." ;;
    37) command -v glances >/dev/null && glances || echo "❌ Glances не установлен"; read -p "Enter..." ;;
    38) rm -f logs/*.log && echo "✅ Логи очищены" ;;
    39) mkdir -p ../backups; tar czf ../backups/project_$(date +%F_%H%M%S).tar.gz . && echo "✅ Архив создан" ;;
    40) echo "⏱ Добавь cron-бэкап вручную: crontab -e" ;;
    *) echo "❌ Неизвестная команда" ;;
  esac

  log_action "Выполнено: $choice"
done
