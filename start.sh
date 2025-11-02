#!/bin/sh
set -e

echo "🚀 Starting application on Railway..."
echo "📊 PORT: $PORT"
echo "📊 NODE_ENV: $NODE_ENV"

# Переходим в папку сервера
cd /app/server

echo "🗄️ Running database migrations..."
# Запускаем миграции с обработкой ошибок
if npm run migrate; then
    echo "✅ Migrations completed successfully"
else
    echo "⚠️ Migrations failed, but continuing startup..."
fi

echo "🌐 Starting server on port $PORT..."
# Запускаем сервер
exec node server.js