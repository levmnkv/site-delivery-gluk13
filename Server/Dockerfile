FROM node:22-alpine3.21 AS build
WORKDIR /app

COPY package.json package-lock.json* .npmrc* ./
RUN if [ -f package-lock.json ]; then npm ci --include=dev; else npm install; fi

COPY . .

ARG BASE=/
ENV VITE_BASE=${BASE}
RUN npm run build


FROM node:22-alpine3.21 AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=4200
ENV HOST=0.0.0.0
ENV STATIC_DIR=/app/dist

# Детальная проверка
RUN echo "=== Содержимое корневой папки ===" && ls -la
RUN echo "=== Поиск папки migrations ===" && find . -name "migrations" -type d
RUN echo "=== Содержимое migrations ===" && find . -name "migrations" -exec ls -la {} \;
RUN echo "=== SQL файлы ===" && find . -name "*.sql"
RUN npm init -y \
 && npm install --omit=dev express@4 compression@1
 
EXPOSE 4200
COPY server.cjs ./server.cjs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://127.0.0.1:3000/ >/dev/null 2>&1 || exit 1
CMD ["node", "server.cjs"]

