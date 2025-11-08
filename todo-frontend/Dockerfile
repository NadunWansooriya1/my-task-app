# ==============================
# Stage 1: Build React
# ==============================
FROM node:20-alpine AS builder
WORKDIR /app

# Install build tools (only needed if you have native deps)
RUN apk add --no-cache python3 make g++

# Copy lockfiles
COPY package*.json ./

# Show real error if npm ci fails
RUN npm ci --loglevel=error || \
    (echo "=== NPM CI FAILED ===" && \
     find /root/.npm/_logs -name "*.log" -exec cat {} \; && \
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