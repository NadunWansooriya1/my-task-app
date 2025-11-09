cd ~/my-task-app

# Create the deployment script
cat > deploy.sh << 'EOF'
#!/bin/bash
set -e

echo "=========================================="
echo "🚀 Starting Deployment"
echo "=========================================="

# Navigate to app directory
cd ~/my-task-app || exit 1

echo ""
echo "📍 Current commit BEFORE update:"
git log -1 --oneline

# Ensure we're on main branch
echo ""
echo "🔀 Switching to main branch..."
git checkout main

# Fetch all changes from GitHub
echo ""
echo "📥 Fetching latest code from GitHub..."
git fetch --all --prune

# Force update to latest code
echo ""
echo "⬇️ Pulling latest code..."
git reset --hard origin/main
git clean -fd

# Show what we updated to
echo ""
echo "✅ Updated to commit:"
git log -1 --oneline
echo ""

# Stop all containers
echo "⏸️ Stopping containers..."
docker compose down

# Remove old images to force rebuild
echo ""
echo "🧹 Cleaning old images..."
docker image prune -af

# Build and start with new code
echo ""
echo "🏗️ Building and starting containers (this takes 2-3 minutes)..."
docker compose up -d --build

# Wait for containers to start
echo ""
echo "⏳ Waiting 90 seconds for services to start..."
sleep 90

# Show container status
echo ""
echo "📊 Container status:"
docker compose ps

# Check backend health
echo ""
echo "🏥 Checking backend health..."
for i in {1..15}; do
  if curl -f http://localhost:8080/actuator/health 2>/dev/null | grep -q "UP"; then
    echo "✅ Backend is healthy!"
    break
  fi
  echo "   Waiting for backend... ($i/15)"
  sleep 10
done

echo ""
echo "=========================================="
echo "✅ Deployment Completed Successfully!"
echo "=========================================="
EOF

# Make it executable
chmod +x deploy.sh

# Test it works
ls -la deploy.sh