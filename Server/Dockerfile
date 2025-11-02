FROM node:20-alpine
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm install

COPY . .

# Детальная проверка
RUN echo "=== Содержимое корневой папки ===" && ls -la
RUN echo "=== Поиск папки migrations ===" && find . -name "migrations" -type d
RUN echo "=== Содержимое migrations ===" && find . -name "migrations" -exec ls -la {} \;
RUN echo "=== SQL файлы ===" && find . -name "*.sql"

EXPOSE 4200
CMD ["npm", "run", "migrate", "&&", "npm", "start"]