#!/bin/bash

# VM Setup Script - Run this on your VM after cloning the repository

set -e

echo "========================================"
echo "🚀 VM Setup Script"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📍 Current directory:${NC} $(pwd)"
echo ""

# Check if running on VM
if [ ! -d "~/my-task-app" ]; then
    echo -e "${YELLOW}⚠️  This script should be run after cloning the repository${NC}"
    echo ""
    echo "First, clone the repository:"
    echo "  cd ~"
    echo "  git clone https://github.com/NadunWansooriya1/my-task-app.git"
    echo "  cd my-task-app"
    echo "  ./vm-setup.sh"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if Docker is installed
echo -e "${YELLOW}🔍 Checking Docker installation...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}📦 Docker not found. Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo -e "${GREEN}✅ Docker installed${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Please log out and log back in for Docker permissions to take effect${NC}"
    echo "Then run this script again."
    exit 0
else
    echo -e "${GREEN}✅ Docker is installed${NC}"
    docker --version
fi
echo ""

# Check if Docker Compose is installed
echo -e "${YELLOW}🔍 Checking Docker Compose...${NC}"
if ! docker compose version &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Docker Compose plugin...${NC}"
    sudo apt-get update
    sudo apt-get install -y docker-compose-plugin
    echo -e "${GREEN}✅ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✅ Docker Compose is installed${NC}"
    docker compose version
fi
echo ""

# Configure firewall
echo -e "${YELLOW}🔥 Configuring firewall...${NC}"
if command -v ufw &> /dev/null; then
    sudo ufw allow 22/tcp   # SSH
    sudo ufw allow 80/tcp   # HTTP
    sudo ufw allow 443/tcp  # HTTPS
    sudo ufw allow 3000/tcp # Frontend
    sudo ufw allow 8080/tcp # Backend
    sudo ufw --force enable
    echo -e "${GREEN}✅ Firewall configured${NC}"
    sudo ufw status
else
    echo -e "${YELLOW}⚠️  UFW not installed, skipping firewall configuration${NC}"
fi
echo ""

# Pull latest code
echo -e "${YELLOW}📥 Pulling latest code from GitHub...${NC}"
git pull origin main
echo -e "${GREEN}✅ Code updated${NC}"
echo ""

# Build and start containers
echo -e "${YELLOW}🏗️  Building and starting containers...${NC}"
echo "This may take 5-15 minutes on first run..."
echo ""
docker compose down
docker compose up -d --build

echo ""
echo -e "${YELLOW}⏳ Waiting for services to start (90 seconds)...${NC}"
sleep 90

# Check container status
echo ""
echo -e "${YELLOW}📊 Container Status:${NC}"
docker compose ps
echo ""

# Check backend health
echo -e "${YELLOW}🏥 Checking backend health...${NC}"
for i in {1..15}; do
    if curl -f http://localhost:8080/actuator/health 2>/dev/null | grep -q "UP"; then
        echo -e "${GREEN}✅ Backend is healthy!${NC}"
        break
    fi
    echo "   Waiting for backend... ($i/15)"
    sleep 10
done
echo ""

# Display URLs
echo "========================================"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo "========================================"
echo ""
echo "Access your application:"
echo "  Frontend: http://104.154.52.39:3000"
echo "  Backend:  http://104.154.52.39:8080"
echo "  Health:   http://104.154.52.39:8080/actuator/health"
echo ""
echo "Login credentials:"
echo "  Username: admin"
echo "  Password: (any non-empty string)"
echo ""
echo "Useful commands:"
echo "  docker compose ps              # Check status"
echo "  docker compose logs -f         # View logs"
echo "  docker compose restart         # Restart services"
echo "  docker compose down            # Stop all"
echo "  docker compose up -d --build   # Rebuild and start"
echo ""
echo "========================================"
