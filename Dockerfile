# syntax=docker/dockerfile:1
# --- deps ---
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# --- build ---
FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Si el proyecto requiere herramientas nativas, descomenta las siguientes líneas
# RUN apk add --no-cache python3 make g++
RUN npm run build

# --- runner ---
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=9000
COPY --from=build /app .
EXPOSE 9000
CMD ["npm", "run", "start"]
