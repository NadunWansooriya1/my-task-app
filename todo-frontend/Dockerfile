# ==============================
# Stage 1: Build React (Alpine = tiny)
# ==============================
FROM node:20-alpine AS builder
WORKDIR /app

# ---- Cache npm install -------------------------------------------------
COPY package*.json ./
# Install *everything* (dev + prod) – needed for `npm run build`
RUN npm ci --loglevel=error

# ---- Copy source (after npm ci → cache reuse) -------------------------
COPY . .

# ---- Build argument (set in docker‑compose) ---------------------------
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=${REACT_APP_API_URL}

# ---- Build production bundle -------------------------------------------
RUN npm run build

# ==============================
# Stage 2: Serve with Nginx (Alpine)
# ==============================
FROM nginx:alpine

# Remove default config
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy secure Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy only the built static files
COPY --from=builder /app/build /usr/share/nginx/html

# Run as non‑root
USER nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]