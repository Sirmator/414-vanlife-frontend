# ─────────────────────────────────────────
# Étape 1 : Build de l'application React
# ─────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Copier les fichiers de dépendances en premier (cache Docker)
COPY package*.json ./
RUN npm install

# Copier le reste du code source
COPY . .

# Build de production (génère /app/dist)
RUN npm run build

# ─────────────────────────────────────────
# Étape 2 : Servir avec nginx
# ─────────────────────────────────────────
FROM nginx:alpine

# Copier les fichiers buildés dans nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copier la configuration nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
