FROM node:18-alpine

WORKDIR /app

# Копируем файлы зависимостей
COPY Server/package*.json ./server/
COPY Client/package*.json ./client/

# Устанавливаем зависимости клиента и собираем
WORKDIR /app/client
RUN npm ci
COPY Client/ ./
RUN npm run build

# Устанавливаем зависимости сервера
WORKDIR /app/server
RUN npm ci --only=production
COPY Server/ ./

# Копируем скрипт запуска
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Открываем порт сервера
EXPOSE 4200

CMD ["/app/start.sh"]