# ==============================
# Stage 1: Build React
# ==============================
FROM node:20-alpine AS builder
WORKDIR /app

# Install build tools (only if you have native deps like sharp)
RUN apk add --no-cache python3 make g++

# Copy lockfiles
COPY package*.json ./

# Install + show full log on failure
RUN npm ci --loglevel=error || \
    (echo "=== NPM CI FAILED ===" && \
     echo "=== FULL NPM LOG ===" && \
     cat /root/.npm/_logs/*-debug-*.log 2>/dev/null || echo "No log found" && \
     exit 1)

# Copy source
COPY . .

# Build
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=${REACT_APP_API_URL}
RUN npm run build

# ==============================
# Stage 2: Nginx
# ==============================
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
USER nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]