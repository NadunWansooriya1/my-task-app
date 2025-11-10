#!/bin/bash

echo "=========================================="
echo "VM Database & Services Diagnostic Script"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "1. Checking Docker containers..."
echo "----------------------------------------"
docker ps -a
echo ""

echo "2. Checking Docker container logs (last 20 lines each)..."
echo "----------------------------------------"
echo -e "${YELLOW}PostgreSQL logs:${NC}"
docker logs postgres --tail 20
echo ""

echo -e "${YELLOW}Backend logs:${NC}"
docker logs backend --tail 20
echo ""

echo -e "${YELLOW}Frontend logs:${NC}"
docker logs frontend --tail 20
echo ""

echo "3. Testing PostgreSQL connection..."
echo "----------------------------------------"
docker exec -it postgres psql -U admin -d taskdb -c "\dt" 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database tables:${NC}"
    docker exec postgres psql -U admin -d taskdb -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';"
    echo ""
    echo -e "${GREEN}✓ Task count:${NC}"
    docker exec postgres psql -U admin -d taskdb -c "SELECT COUNT(*) as total_tasks FROM task;"
else
    echo -e "${RED}✗ Failed to connect to database${NC}"
fi
echo ""

echo "4. Checking database connectivity from backend..."
echo "----------------------------------------"
docker exec backend curl -s http://localhost:8080/actuator/health 2>&1
echo ""

echo "5. Testing backend API..."
echo "----------------------------------------"
echo -e "${YELLOW}Health check:${NC}"
curl -s http://localhost:8080/health
echo ""
echo -e "${YELLOW}Root endpoint:${NC}"
curl -s http://localhost:8080/
echo ""

echo "6. Checking network connectivity..."
echo "----------------------------------------"
docker network inspect my-task-app_app-network --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{println}}{{end}}' 2>&1
echo ""

echo "7. Database connection test from host..."
echo "----------------------------------------"
docker exec postgres pg_isready -U admin -d taskdb
echo ""

echo "8. Environment variables in backend..."
echo "----------------------------------------"
docker exec backend env | grep -E "SPRING_DATASOURCE|JWT_SECRET"
echo ""

echo "9. Port bindings..."
echo "----------------------------------------"
echo -e "${YELLOW}PostgreSQL (should be 5432):${NC}"
docker port postgres 2>&1
echo -e "${YELLOW}Backend (should be 8080):${NC}"
docker port backend 2>&1
echo -e "${YELLOW}Frontend (should be 80):${NC}"
docker port frontend 2>&1
echo ""

echo "10. Disk space check..."
echo "----------------------------------------"
df -h | grep -E "Filesystem|/dev/"
echo ""

echo "=========================================="
echo "Diagnostic Complete!"
echo "=========================================="
echo ""
echo "To fix common issues, run these commands:"
echo ""
echo "# Restart all containers:"
echo "  cd ~/my-task-app && docker compose restart"
echo ""
echo "# Rebuild and restart:"
echo "  cd ~/my-task-app && docker compose down && docker compose up -d --build"
echo ""
echo "# Access PostgreSQL directly:"
echo "  docker exec -it postgres psql -U admin -d taskdb"
echo ""
echo "# View real-time logs:"
echo "  docker logs -f backend"
echo "  docker logs -f postgres"
echo ""
