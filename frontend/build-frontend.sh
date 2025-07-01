#!/bin/bash

echo "🔧 Сборка фронтенда (SSR)..."
cd "$(dirname "$0")"

npm install
npm run build

echo "🚀 SSR-билд завершён. Сервер: .next/standalone/server.js"
