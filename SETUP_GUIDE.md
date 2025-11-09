# 🚀 Complete Setup & Deployment Guide

## ✅ All Bugs Fixed!

Your project had the following issues which have been **FIXED**:

1. ✅ JWT deprecation warnings in `JwtUtil.java`
2. ✅ Unused import statement
3. ✅ API URL configuration mismatch
4. ✅ Missing deployment documentation

## 📋 Prerequisites Checklist

Before deploying, ensure you have:

- [ ] **Docker Desktop** installed and **RUNNING** (Windows)
  - Download from: https://www.docker.com/products/docker-desktop
  - Make sure the Docker Desktop app is started before deployment
  
- [ ] **At least 4GB RAM** available for containers

- [ ] **Ports Available**:
  - Port 3000 (Frontend)
  - Port 8080 (Backend)
  - Port 5432 (Database)

## 🎯 Deployment Steps

### Step 1: Start Docker Desktop
1. Open Docker Desktop application
2. Wait until you see "Docker Desktop is running" in the system tray
3. Verify with: `docker --version`

### Step 2: Navigate to Project
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"
```

### Step 3: Deploy Application

**Option A: Using PowerShell Script (Recommended)**
```powershell
.\deploy.ps1
```

**Option B: Manual Commands**
```powershell
# Stop any existing containers
docker compose down

# Build and start all services
docker compose up -d --build

# Wait 90 seconds for services to initialize
Start-Sleep -Seconds 90

# Check status
docker compose ps

# Check backend health
Invoke-WebRequest http://localhost:8080/actuator/health
```

### Step 4: Access Application

Once deployed, open your browser:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **Health Check**: http://localhost:8080/actuator/health

### Step 5: Login

Use these credentials:
- **Username**: `admin`
- **Password**: (any non-empty string)

## 🖥️ Deploying to VM

### For Production VM Deployment:

#### 1. Update Configuration Files

**A. Update docker-compose.yml** (line 39):
```yaml
REACT_APP_API_URL: http://YOUR_VM_IP:8080
# Replace YOUR_VM_IP with your actual VM IP
```

**B. Update WebConfig.java** (lines 11-15):
```java
.allowedOrigins(
    "http://YOUR_VM_IP:3000",
    "http://localhost:3000"
)
```

**C. Update JWT Secret** in `application.properties`:
```properties
jwt.secret=YOUR_SUPER_STRONG_SECRET_KEY_MINIMUM_256_BITS
```

#### 2. Copy to VM

```bash
# On your local machine
scp -r "d:\Devops Projects\devops intern\versions\local\my-task-app" user@YOUR_VM_IP:~/

# Or use Git
git push origin main

# On VM
git clone https://github.com/YourUsername/my-task-app.git
cd my-task-app
```

#### 3. Deploy on VM

```bash
# On the VM
cd my-task-app

# Start deployment
docker compose up -d --build

# Check status
docker compose ps

# View logs
docker compose logs -f
```

#### 4. Configure Firewall (VM)

```bash
# Allow necessary ports
sudo ufw allow 3000/tcp
sudo ufw allow 8080/tcp
sudo ufw enable
```

## 📊 Monitoring & Troubleshooting

### View Logs
```powershell
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f postgres
```

### Check Container Status
```powershell
docker compose ps
docker stats
```

### Restart Services
```powershell
# Restart all
docker compose restart

# Restart specific service
docker compose restart backend
```

### Common Issues

#### "Docker Desktop is not running"
**Solution**: Start Docker Desktop application and wait for it to fully start

#### "Port already in use"
**Solution**: 
```powershell
# Find process using the port
netstat -ano | findstr :8080

# Kill the process
taskkill /PID <PID> /F
```

#### "Backend health check failed"
**Solution**:
```powershell
# Check backend logs
docker compose logs backend

# Ensure database is ready
docker compose logs postgres | Select-String "ready"

# Restart if needed
docker compose restart backend
```

#### "Frontend shows connection error"
**Solution**:
1. Check if backend is running: `curl http://localhost:8080/actuator/health`
2. Check browser console for actual API URL
3. Verify REACT_APP_API_URL in docker-compose.yml

## 🛑 Stopping the Application

```powershell
# Stop containers (keeps data)
docker compose stop

# Stop and remove containers (keeps data in volumes)
docker compose down

# Remove everything including data (⚠️ careful!)
docker compose down -v
```

## 🔄 Updating the Application

```powershell
# Pull latest changes
git pull origin main

# Rebuild and restart
docker compose down
docker compose up -d --build
```

## 📚 Additional Documentation

- **README.md** - Project overview and features
- **DEPLOYMENT_GUIDE.md** - Detailed deployment guide
- **FIXES_APPLIED.md** - Bug fixes documentation

## ✅ Quick Test Commands

After deployment, test with these commands:

```powershell
# Test frontend
Invoke-WebRequest http://localhost:3000

# Test backend health
Invoke-WebRequest http://localhost:8080/actuator/health

# Test database
docker exec -it postgres psql -U admin -d taskdb -c "SELECT COUNT(*) FROM task;"

# Login test (returns JWT token)
Invoke-WebRequest -Uri http://localhost:8080/api/auth/login `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"username":"admin","password":"test"}'
```

## 🎉 Success Criteria

Your deployment is successful when:

- ✅ All 3 containers are "Up" (`docker compose ps`)
- ✅ Frontend loads at http://localhost:3000
- ✅ Backend health returns {"status":"UP"} 
- ✅ You can login and see the task list
- ✅ You can create, edit, and delete tasks

## 🆘 Need Help?

If you encounter issues:

1. **Check Docker Desktop is running**
2. **View logs**: `docker compose logs -f`
3. **Check ports**: `netstat -ano | findstr "3000 8080 5432"`
4. **Restart everything**: `docker compose down && docker compose up -d --build`

## 📝 Next Steps

1. ✅ **Start Docker Desktop**
2. ✅ **Run** `.\deploy.ps1`
3. ✅ **Access** http://localhost:3000
4. ✅ **Login** with username: admin
5. ✅ **Test** task management features

Your application is now ready to deploy! 🚀
