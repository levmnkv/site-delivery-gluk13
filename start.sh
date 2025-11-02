#!/bin/sh
echo "🚀 Starting application on Railway..."

# Запускаем nginx в фоне
echo "📦 Starting nginx..."
nginx

# Переходим в папку сервера и запускаем миграции + сервер
cd /app/server
echo "🗄️ Running database migrations..."
npm run migrate

echo "🌐 Starting server..."
npm start