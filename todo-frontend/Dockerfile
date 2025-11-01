# Build stage
FROM node:18-alpine as build
WORKDIR /app
COPY todo-frontend/package*.json ./
RUN npm ci
COPY todo-frontend/ .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY todo-frontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80