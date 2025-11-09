# Quick Test Guide - Local Development

## Current Status ✅
- Database (PostgreSQL) is RUNNING!

## Testing with Slow Network

Since you're experiencing slow Docker image downloads, here are alternative ways to test:

### Option 1: Test Database First (WORKING NOW!)
```powershell
# Check database status
docker compose ps

# Access database
docker exec -it postgres psql -U admin -d taskdb

# Inside PostgreSQL, check tables
\dt

# Exit
\q
```

### Option 2: Build Services Separately (Recommended for Slow Network)

#### Build Backend Only:
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"
docker compose build backend
docker compose up -d backend
```

#### Build Frontend Only:
```powershell
docker compose build frontend
docker compose up -d frontend
```

### Option 3: Run Without Docker (Fast Testing)

#### Backend (Spring Boot):
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app\todo-api"

# Update application.properties to use localhost:5432 instead of postgres:5432
# Then run:
.\mvnw.cmd spring-boot:run
```

#### Frontend (React):
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app\todo-frontend"
npm install
npm start
```

### Option 4: Use Pre-built JAR (If Available)

If you have the JAR file already built:
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app\todo-api"
java -jar target\todo-api-0.0.1-SNAPSHOT.jar
```

## Current Container Status

Run this to see what's running:
```powershell
docker compose ps
```

## Network Troubleshooting

If Docker downloads are slow:

1. **Check Docker Desktop Settings**:
   - Go to Settings → Docker Engine
   - Add faster DNS servers

2. **Use Docker Hub Mirror** (if available in your region)

3. **Wait and Retry**: The images are large (Maven ~200MB, Node ~150MB)
   ```powershell
   docker compose up -d --build --timeout 300
   ```

4. **Download Images Separately** (do this first):
   ```powershell
   docker pull maven:3.9-eclipse-temurin-17-alpine
   docker pull eclipse-temurin:17-jre-alpine
   docker pull node:18-alpine
   docker pull nginx:alpine
   
   # Then build
   docker compose build
   docker compose up -d
   ```

## What's Working Now:

✅ **PostgreSQL Database** - Running on port 5432
- Connect with: `docker exec -it postgres psql -U admin -d taskdb`

## Next Steps:

Choose one of these:
1. **Wait for network and build** (can take 10-30 mins with slow connection)
2. **Run backend/frontend locally** without Docker (fastest)
3. **Build one service at a time** (moderate speed)

Let me know which option you prefer!
