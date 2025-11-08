# ──────────────────────
# Stage 1: Build React
# ──────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

# Install only production deps
COPY package*.json ./
RUN npm ci --only=production

# Copy source + build
COPY . .
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=${REACT_APP_API_URL}
RUN npm run build

# ──────────────────────
# Stage 2: Serve with Nginx
# ──────────────────────
FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom secure config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build files
COPY --from=builder /app/build /usr/share/nginx/html

# Security: non-root user
USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]