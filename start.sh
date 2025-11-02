#!/bin/sh
echo "🚀 Starting application on Railway..."

# Запускаем миграции и сервер
cd /app/server
echo "🗄️ Running database migrations..."
npm run migrate

echo "🌐 Starting server..."
npm start