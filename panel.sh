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
      rm -f patch.diff
    else
      echo "⚠️  patch.diff не найден"
    fi

    npm install
    npm run build

    echo "🧹 Перезапуск SSR-сервера через pm2..."
    pm2 delete john-galt-frontend || true
    pm2 start npm --name john-galt-frontend -- start

    exit 0
    ;;
esac

while true; do
  clear
  echo "============================================"
  echo "   🚀 ${bold}DevOps Панель управления проектом${normal}"
  echo "============================================"

  echo "${bold}[1-10] FRONTEND${normal}"
  echo " 1. ❌ Выйти"
  echo " 2. 📦 Установить зависимости (npm install)"
  echo " 3. ⚙️  Сборка фронтенда (npm run build)"
  echo " 4. 🔁 Перезапустить SSR (pm2 restart john-galt-frontend)"
  echo " 5. 📄 Логи SSR (pm2 logs john-galt-frontend)"
  echo " 6. 🚀 Полный деплой фронтенда (npm install + build + pm2 restart)"

  echo "${bold}[11-20] BACKEND${normal}"
  echo "11. 🐍 Перезапустить backend (systemctl restart web_panel)"
  echo "12. 📊 Статус backend и nginx"
  echo "13. 🧾 Последние ошибки Gunicorn"
  echo "14. 🌐 Проверка API /api/inventory/"
  echo "15. 📤 Дамп PostgreSQL (pg_dump → dumps/)"
  echo "16. 📥 Восстановление дампа (из последнего дампа)"
  echo "17. 🔐 Проверка .env переменных"
  echo "18. 💬 Telegram Token из .env"
  echo "19. 📬 Лог уведомлений Telegram"
  echo "20. 🚀 GitHub Actions Webhook Trigger"

  echo "${bold}[21-30] GIT И СЦЕНАРИИ${normal}"
  echo "21. 🔁 Git Pull (обновить main)"
  echo "22. 📤 Git Push (commit + push)"
  echo "23. 🔖 Создать Git Tag (ручной ввод)"
  echo "24. ⬆️ Отправить все теги (git push --tags)"
  echo "25. 🧹 Удалить все локальные теги (и с origin)"
  echo "26. 📄 Применить patch.diff (и перезапуск SSR)"
  echo "27. 🚀 DEPLOY-FULL (запуск deploy-full.sh)"
  echo "28. 🧯 ROLLBACK (откат rollback.sh)"
  echo "29. 📜 Просмотр лога панели"
  echo "30. 🧰 Архив проекта (tar.gz в backups/)"

  echo "${bold}[31-40] МОНИТОРИНГ И УТИЛИТЫ${normal}"
  echo "31. 🔁 pm2 list (процессы pm2)"
  echo "32. 🐍 ps aux | grep python (процессы Python)"
  echo "33. 🔍 ss -tulnp (прослушиваемые порты)"
  echo "34. 🛡️ Проверить статус web_panel.service"
  echo "35. 💾 Проверка диска и памяти"
  echo "36. ⚙️  Редактировать nginx config"
  echo "37. ✅ Проверка публичного сайта"
  echo "38. 🧼 Очистка логов панели"
  echo "39. 🕒 Настроить cron-бэкап"
  echo "40. ⏳ Выход"

  echo "============================================"
  read -p "Выберите действие: " choice

  case $choice in
    1) exit 0 ;;
    2) npm install ;;
    3) npm run build ;;
    4) pm2 restart john-galt-frontend ;;
    5) pm2 logs john-galt-frontend ;;
    6) npm install && npm run build && pm2 restart john-galt-frontend ;;
    11) sudo systemctl restart web_panel ;;
    12) systemctl status web_panel --no-pager; systemctl status nginx --no-pager; read -p "Нажмите Enter..." ;;
    13) journalctl -u web_panel.service -n 20 --no-pager; read -p "Нажмите Enter..." ;;
    14) curl -s -o /dev/null -w "HTTP: %{http_code}\n" http://127.0.0.1:8000/api/inventory/; read -p "Нажмите Enter..." ;;
    15) mkdir -p dumps && pg_dump -U postgres -d your_dbname > dumps/dump_$(date +%F_%T).sql && echo "✅ Дамп создан"; read -p "Нажмите Enter..." ;;
    16) latest_dump=$(ls -t dumps/*.sql | head -n 1); psql -U postgres -d your_dbname < "$latest_dump"; echo "✅ Дамп восстановлен: $latest_dump"; read -p "Нажмите Enter..." ;;
    17)
      echo "🧪 Проверка .env переменных:"
      test -f .env && source .env
      for var in POSTGRESQL_HOST POSTGRESQL_PORT POSTGRESQL_USER POSTGRESQL_DBNAME; do
        val=$(grep "^$var=" .env | cut -d= -f2)
        if [ -z "$val" ]; then echo "❌ $var не задан"; else echo "✅ $var = $val"; fi
      done
      read -p "Нажмите Enter..."
      ;;
    18) grep TELEGRAM_TOKEN .env; read -p "Нажмите Enter..." ;;
    19) tail -n 20 logs/telegram.log; read -p "Нажмите Enter..." ;;
    20) curl -X POST https://api.github.com/repos/YOUR_USER/YOUR_REPO/dispatches -H "Accept: application/vnd.github.v3+json" -H "Authorization: token YOUR_TOKEN" -d '{"event_type":"deploy"}'; read -p "Нажмите Enter..." ;;
    21) git pull origin main; read -p "Нажмите Enter..." ;;
    22)
      git add .
      read -p "Комментарий к коммиту: " msg
      git commit -m "${msg:-auto-commit $(date)}"
      git push origin main
      read -p "Нажмите Enter..."
      ;;
    23) read -p "Введите тег: " tag; git tag "$tag"; echo "✅ Тег создан: $tag"; read -p "Нажмите Enter..." ;;
    24) git push origin --tags; read -p "Нажмите Enter..." ;;
    25) git tag | xargs git tag -d; git push origin --delete $(git tag); read -p "Нажмите Enter..." ;;
    26)
      echo "▶️ Применение patch.diff..."
      git pull origin main
      if [ -f patch.diff ]; then
        git apply patch.diff && echo "✅ Патч применён"
        rm -f patch.diff
      else
        echo "⚠️  patch.diff не найден"
      fi
      npm install && npm run build
      pm2 restart john-galt-frontend
      read -p "Нажмите Enter..."
      ;;
    27) ./deploy-full.sh; read -p "Нажмите Enter..." ;;
    28) ./rollback.sh; read -p "Нажмите Enter..." ;;
    29) less logs/panel.log ;;
    30)
      mkdir -p ../backups
      tar czf ../backups/project_$(date +%F_%H%M%S).tar.gz .
      echo "✅ Архив создан"
      read -p "Нажмите Enter..."
      ;;
    31) pm2 list; read -p "Нажмите Enter..." ;;
    32) ps aux | grep python; read -p "Нажмите Enter..." ;;
    33) ss -tulnp; read -p "Нажмите Enter..." ;;
    34)
      status=$(systemctl is-active web_panel)
      if [ "$status" = "active" ]; then
        echo "✅ web_panel.service активен"
      else
        echo "❌ web_panel.service неактивен или упал"
      fi
      read -p "Нажмите Enter..."
      ;;
    35) df -h | grep /$; free -h; read -p "Нажмите Enter..." ;;
    36) sudo nano /etc/nginx/sites-available/default ;;
    37) curl -s -o /dev/null -w "HTTP: %{http_code}\n" http://localhost; read -p "Нажмите Enter..." ;;
    38) rm -f logs/*.log && echo "✅ Логи очищены"; read -p "Нажмите Enter..." ;;
    39) echo "⏱ Добавь cron-бэкап вручную: crontab -e"; read -p "Нажмите Enter..." ;;
    40) exit 0 ;;
    *) echo "❌ Неизвестная команда"; read -p "Нажмите Enter..." ;;
  esac

  log_action "Выполнено: $choice"
done
