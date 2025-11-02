# Мульти-стадийная сборка
FROM node:18-alpine as client-builder
WORKDIR /app/client
COPY Client/package*.json ./
RUN npm ci
COPY Client/ ./
RUN npm run build

FROM node:18-alpine as server-builder
WORKDIR /app/server
COPY Server/package*.json ./
RUN npm ci
COPY Server/ ./
RUN npm run build

# Финальный образ
FROM node:18-alpine
WORKDIR /app

# Копируем бэкенд
COPY --from=server-builder /app/server /app/server

# Копируем фронтенд
COPY --from=client-builder /app/client/dist /app/client

# Устанавливаем зависимости для продакшена
WORKDIR /app/server
RUN npm ci --only=production

# Устанавливаем nginx
RUN apk add --no-cache nginx

# Копируем конфиг nginx
COPY nginx/nginx.conf /etc/nginx/http.d/default.conf

# Создаем скрипт запуска
WORKDIR /app
COPY start.sh ./
RUN chmod +x ./start.sh

EXPOSE 8000

CMD ["./start.sh"]