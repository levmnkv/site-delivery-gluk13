#!/bin/sh
set -e  # Останавливаться при ошибках

echo "🚀 ============ STARTING APPLICATION ============"
echo "📊 Current directory: $(pwd)"
echo "📊 PORT: $PORT"
echo "📊 NODE_ENV: $NODE_ENV"

# Покажем что есть в папке server
echo "📁 Server directory contents:"
ls -la /app/server/

# Проверим наличие основных файлов
echo "🔍 Checking required files:"
[ -f "/app/server/server.js" ] && echo "✅ server.js exists" || echo "❌ server.js missing"
[ -f "/app/server/app.js" ] && echo "✅ app.js exists" || echo "❌ app.js missing"
[ -f "/app/server/package.json" ] && echo "✅ package.json exists" || echo "❌ package.json missing"

# Переходим в папку сервера
cd /app/server

echo "📦 Checking Node.js version:"
node --version

echo "📦 Checking npm version:"
npm --version

echo "🔍 Checking if dependencies are installed:"
[ -d "node_modules" ] && echo "✅ node_modules exists" || echo "❌ node_modules missing"

# Пропускаем миграции для демо
echo "⏭️ Skipping migrations for demo..."

echo "🌐 ============ STARTING SERVER ============"
# Запускаем сервер с подробным логированием
exec node server.js