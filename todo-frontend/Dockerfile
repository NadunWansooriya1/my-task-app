# ==============================
# Stage 1: Build the React app
# ==============================
FROM node:20-alpine AS builder
WORKDIR /app

# 1. Copy only the lockfiles first → cache layer
COPY package*.json ./
# Install **all** dependencies (dev + prod) – required for `npm run build`
RUN npm ci

# 2. Copy source code
COPY . .

# 3. Pass the API base URL from docker‑compose (optional but handy)
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=${REACT_APP_API_URL}

# 4. Build the production bundle
RUN npm run build

# ==============================
# Stage 2: Serve with Nginx
# ==============================
FROM nginx:alpine

# Remove default config
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy our secure Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built static files
COPY --from=builder /app/build /usr/share/nginx/html

# Run as non‑root
USER nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]