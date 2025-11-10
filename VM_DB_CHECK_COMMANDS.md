# VM Database Check - Manual Commands
# Run these commands on your VM to diagnose database issues

## Step 1: Check if containers are running
docker ps

# Expected output: You should see 3 containers running:
# - postgres
# - backend
# - frontend

## Step 2: Check container health
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

## Step 3: Check PostgreSQL logs
docker logs postgres --tail 50

## Step 4: Test database connection
docker exec -it postgres psql -U admin -d taskdb

# Once connected, run these SQL commands:
# \dt                          -- List all tables
# SELECT * FROM task LIMIT 5;  -- View tasks
# \q                           -- Exit

## Step 5: Check if backend can connect to database
docker exec backend curl -s http://localhost:8080/actuator/health

## Step 6: Test database from backend container
docker exec -it backend bash
# Then run:
# apt-get update && apt-get install -y postgresql-client
# psql -h postgres -U admin -d taskdb
# (password: admin)

## Step 7: Check environment variables
docker exec backend env | grep SPRING_DATASOURCE

## Step 8: View backend logs for errors
docker logs backend --tail 100

## Step 9: Restart services if needed
cd ~/my-task-app
docker compose restart

## Step 10: Full rebuild if issues persist
cd ~/my-task-app
docker compose down
docker compose up -d --build

## Step 11: Check network connectivity
docker network inspect my-task-app_app-network

## Step 12: Test API endpoints
curl http://localhost:8080/health
curl http://localhost:8080/actuator/health
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"pass"}'

## Quick Database Queries
# Connect to database:
docker exec -it postgres psql -U admin -d taskdb

# Inside PostgreSQL, run:
SELECT COUNT(*) FROM task;                                    -- Total tasks
SELECT * FROM task WHERE completed = false;                   -- Pending tasks
SELECT task_date, COUNT(*) FROM task GROUP BY task_date;     -- Tasks by date
\d task                                                       -- Table structure

## Common Issues & Fixes

### Issue 1: Database not accepting connections
docker compose restart postgres
docker logs postgres

### Issue 2: Backend can't connect to database
docker compose down
docker compose up -d

### Issue 3: Tables not created
docker exec -it postgres psql -U admin -d taskdb -c "DROP TABLE IF EXISTS task CASCADE;"
docker compose restart backend

### Issue 4: Port already in use
docker compose down
sudo lsof -i :5432  # Check what's using the port
sudo lsof -i :8080
docker compose up -d

### Issue 5: Out of disk space
df -h
docker system prune -a  # WARNING: This removes unused containers/images

## Monitoring Commands
# Watch logs in real-time:
docker logs -f backend
docker logs -f postgres

# Check resource usage:
docker stats

# Check all containers (including stopped):
docker ps -a
