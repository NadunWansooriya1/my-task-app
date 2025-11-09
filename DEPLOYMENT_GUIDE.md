# 🚀 Deployment Guide for Task Management Application

## Prerequisites

Make sure your VM has:
- Docker installed
- Docker Compose installed
- Git installed (optional, for pulling updates)

## Quick Start (Local VM Deployment)

### 1. Navigate to Project Directory
```bash
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"
```

### 2. Stop Any Existing Containers
```bash
docker compose down
```

### 3. Clean Old Images (Optional but Recommended)
```bash
docker system prune -a -f
```

### 4. Build and Start All Services
```bash
docker compose up -d --build
```

This command will:
- Build the Spring Boot backend
- Build the React frontend
- Start PostgreSQL database
- Create the network between services

### 5. Check Container Status
```bash
docker compose ps
```

All containers should show "Up" status:
- `postgres` - Port 5432
- `backend` - Port 8080
- `frontend` - Port 3000

### 6. View Logs (If Needed)
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f postgres
```

## Access the Application

- **Frontend (Web UI)**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **API Health Check**: http://localhost:8080/actuator/health
- **PostgreSQL**: localhost:5432 (credentials in docker-compose.yml)

## Default Credentials

Use these credentials to login:
- Username: `admin`
- Password: Any non-empty string (JWT will be generated)

## Troubleshooting

### Backend Won't Start
```bash
# Check backend logs
docker compose logs backend

# Ensure database is ready
docker compose logs postgres | grep "ready"
```

### Frontend Shows Connection Error
1. Check if backend is running: `curl http://localhost:8080/actuator/health`
2. Check frontend environment: `docker compose logs frontend`
3. Verify API URL in browser console

### Database Connection Issues
```bash
# Restart database
docker compose restart postgres

# Check database connection
docker exec -it postgres psql -U admin -d taskdb
```

### Port Already in Use
If you get "port already allocated" errors:
```bash
# Find what's using the port (example for 8080)
netstat -ano | findstr :8080

# Kill the process (replace PID)
taskkill /PID <PID> /F

# Or use different ports in docker-compose.yml
```

## Stopping the Application

```bash
# Stop containers but keep data
docker compose stop

# Stop and remove containers (data persists in volumes)
docker compose down

# Remove everything including volumes (⚠️ deletes database)
docker compose down -v
```

## Updating the Application

```bash
# Pull latest code (if using Git)
git pull origin main

# Rebuild and restart
docker compose down
docker compose up -d --build
```

## Production Deployment (VM with Public IP)

### 1. Update Environment Variables

Edit `docker-compose.yml`:
```yaml
# Change REACT_APP_API_URL to your VM's public IP or domain
REACT_APP_API_URL: http://YOUR_VM_IP:8080
```

Edit `todo-api/src/main/resources/application.properties`:
```properties
# Update JWT secret to a strong random value
jwt.secret=YOUR_STRONG_SECRET_KEY_AT_LEAST_256_BITS
```

Edit `todo-api/src/main/java/com/example/todo_api/config/WebConfig.java`:
```java
// Add your VM's domain/IP
.allowedOrigins(
    "http://YOUR_VM_IP:3000",
    "http://localhost:3000"
)
```

### 2. Configure Firewall
```bash
# Allow necessary ports (example for Linux)
sudo ufw allow 3000/tcp  # Frontend
sudo ufw allow 8080/tcp  # Backend
sudo ufw allow 5432/tcp  # Database (only if external access needed)
```

### 3. Deploy
```bash
docker compose up -d --build
```

### 4. Setup SSL (Optional but Recommended)
For HTTPS support, consider using:
- Nginx reverse proxy with Let's Encrypt SSL
- Caddy server (automatic HTTPS)
- Cloud load balancer with SSL termination

## Health Checks

```bash
# Check all services
docker compose ps

# Check backend health
curl http://localhost:8080/actuator/health

# Check frontend
curl http://localhost:3000

# Check database
docker exec -it postgres pg_isready -U admin -d taskdb
```

## Monitoring

```bash
# Resource usage
docker stats

# Disk usage
docker system df

# Container details
docker compose ps -a
```

## Backup Database

```bash
# Backup
docker exec postgres pg_dump -U admin taskdb > backup.sql

# Restore
cat backup.sql | docker exec -i postgres psql -U admin -d taskdb
```

## Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| "Cannot connect to backend" | Check if backend is running: `docker compose logs backend` |
| "Port already in use" | Stop conflicting services or change ports in docker-compose.yml |
| "Database connection failed" | Wait 30s for DB to initialize, check logs: `docker compose logs postgres` |
| "Frontend shows blank page" | Check browser console, verify REACT_APP_API_URL is correct |
| "JWT token errors" | Ensure jwt.secret is set and at least 256 bits |

## Performance Optimization

### For Production:
1. Set proper resource limits in docker-compose.yml
2. Use production-ready PostgreSQL configuration
3. Enable compression in Nginx
4. Set up database connection pooling
5. Configure logging levels appropriately

## Security Checklist

- [ ] Change default database password
- [ ] Use strong JWT secret (256+ bits)
- [ ] Enable HTTPS in production
- [ ] Configure proper CORS origins
- [ ] Set up firewall rules
- [ ] Regular security updates
- [ ] Implement rate limiting
- [ ] Enable PostgreSQL SSL connections

## Need Help?

1. Check logs: `docker compose logs`
2. Verify network: `docker network ls`
3. Inspect containers: `docker compose ps`
4. Check resources: `docker stats`

