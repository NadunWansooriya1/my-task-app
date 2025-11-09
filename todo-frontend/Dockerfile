# ==============================
# Stage 1: Build React (Node)
# ==============================
FROM node:20-alpine AS builder
WORKDIR /app

# Cache npm install
COPY package*.json ./
RUN npm ci --loglevel=error

# Copy source
COPY . .

# Build arg from docker-compose
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=${REACT_APP_API_URL}

# Build production bundle
RUN npm run build

# ==============================
# Stage 2: Serve with Nginx
# ==============================
FROM nginx:alpine

# Remove default config
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy secure config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build
COPY --from=builder /app/build /usr/share/nginx/html

# Security: non-root
USER nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]