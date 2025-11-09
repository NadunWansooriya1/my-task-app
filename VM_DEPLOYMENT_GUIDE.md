# 🚀 VM Deployment Guide

## Complete Step-by-Step Deployment to VM

**VM IP**: `104.154.52.39`  
**Domain**: `task-vm.nadunwansooriya.online`  
**GitHub Repo**: `https://github.com/NadunWansooriya1/my-task-app.git`

---

## 📋 Prerequisites

### On Your Local Machine:
- [x] Git installed
- [x] GitHub account access
- [x] All code bugs fixed ✅

### On Your VM:
- [ ] SSH access
- [ ] Docker installed
- [ ] Docker Compose installed
- [ ] Git installed

---

## 🔧 Step 1: Prepare Your VM

### SSH into your VM:
```bash
ssh username@104.154.52.39
# Replace 'username' with your actual VM username
```

### Install Docker (if not already installed):
```bash
# Update system
sudo apt-get update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt-get install docker-compose-plugin

# Verify installation
docker --version
docker compose version

# Log out and log back in for group changes to take effect
exit
```

### Configure Firewall:
```bash
ssh username@104.154.52.39

# Allow necessary ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 3000/tcp  # Frontend
sudo ufw allow 8080/tcp  # Backend
sudo ufw enable

# Check firewall status
sudo ufw status
```

---

## 📦 Step 2: Push Your Code to GitHub

### On Your Local Machine (Windows PowerShell):

```powershell
# Navigate to your project
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"

# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit changes
git commit -m "Initial commit - Bug fixes and deployment setup"

# Add remote repository
git remote add origin https://github.com/NadunWansooriya1/my-task-app.git

# Push to GitHub
git branch -M main
git push -u origin main
```

If you get authentication errors:
```powershell
# Use GitHub Personal Access Token
# Go to: GitHub → Settings → Developer settings → Personal access tokens → Generate new token
# Then use: https://YOUR_TOKEN@github.com/NadunWansooriya1/my-task-app.git
```

---

## 🔐 Step 3: Set Up GitHub Secrets for Actions

1. Go to your GitHub repository: `https://github.com/NadunWansooriya1/my-task-app`
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add these secrets:

### Required Secrets:

| Secret Name | Value | Description |
|------------|-------|-------------|
| `VM_HOST` | `104.154.52.39` | Your VM IP address |
| `VM_USERNAME` | `your-username` | SSH username for VM |
| `VM_SSH_KEY` | `your-private-key` | SSH private key (see below) |

### Getting Your SSH Key:

**On your local machine:**
```powershell
# Generate SSH key if you don't have one
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# Display your public key (to add to VM)
cat ~/.ssh/id_rsa.pub

# Display your private key (to add to GitHub Secrets)
cat ~/.ssh/id_rsa
# Copy the ENTIRE content including -----BEGIN and -----END lines
```

**On your VM:**
```bash
# Add your public key to VM
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Paste your public key here, save and exit (Ctrl+X, Y, Enter)

# Set correct permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

**Test SSH connection from local machine:**
```powershell
ssh -i ~/.ssh/id_rsa username@104.154.52.39
```

---

## 🎯 Step 4: Clone Repository on VM

### SSH into your VM:
```bash
ssh username@104.154.52.39

# Clone your repository
cd ~
git clone https://github.com/NadunWansooriya1/my-task-app.git
cd my-task-app

# Verify files
ls -la
```

---

## 🚀 Step 5: First Deployment (Manual)

### On your VM:
```bash
cd ~/my-task-app

# Start deployment
docker compose up -d --build

# This will:
# - Download Docker images
# - Build backend (Spring Boot)
# - Build frontend (React)
# - Start PostgreSQL database
# - Start all services

# Check status
docker compose ps

# View logs
docker compose logs -f

# Check backend health
curl http://localhost:8080/actuator/health
```

### Monitor the deployment:
```bash
# Watch container status
watch docker compose ps

# Check specific service logs
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f postgres
```

---

## ✅ Step 6: Verify Deployment

### Test from VM:
```bash
# Test backend
curl http://localhost:8080/actuator/health

# Test frontend
curl http://localhost:3000

# Test database
docker exec -it postgres psql -U admin -d taskdb -c "\dt"
```

### Test from Your Browser:
- **Frontend**: `http://104.154.52.39:3000`
- **Backend API**: `http://104.154.52.39:8080/actuator/health`
- **Domain Frontend**: `http://task-vm.nadunwansooriya.online:3000`

### Test Login:
1. Open `http://104.154.52.39:3000`
2. Username: `admin`
3. Password: `test` (any non-empty string)
4. Should see task list

---

## 🔄 Step 7: Enable GitHub Actions Auto-Deployment

### How it works:
1. You push code to GitHub
2. GitHub Actions automatically:
   - SSHs into your VM
   - Pulls latest code
   - Rebuilds containers
   - Restarts services

### Test the workflow:

**On your local machine:**
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"

# Make a small change (test)
echo "# Test deployment" >> README.md

# Commit and push
git add .
git commit -m "Test: GitHub Actions deployment"
git push origin main
```

### Monitor GitHub Actions:
1. Go to: `https://github.com/NadunWansooriya1/my-task-app/actions`
2. Click on the latest workflow run
3. Watch the deployment progress

---

## 🔍 Step 8: Troubleshooting

### Check GitHub Actions logs:
- Go to: GitHub → Your Repo → Actions → Latest run
- Click on "Deploy to VM via SSH"
- Check each step's output

### Check VM logs:
```bash
ssh username@104.154.52.39
cd ~/my-task-app

# Check container status
docker compose ps

# Check logs
docker compose logs --tail=100

# Check specific service
docker compose logs backend --tail=50

# Restart if needed
docker compose restart

# Full rebuild
docker compose down
docker compose up -d --build
```

### Common Issues:

| Issue | Solution |
|-------|----------|
| SSH connection failed | Check VM_SSH_KEY secret, verify firewall allows port 22 |
| Docker build timeout | VM might have slow network, increase timeout or pull images first |
| Port already in use | Check with `sudo lsof -i :8080`, kill process if needed |
| Container unhealthy | Check logs: `docker compose logs backend` |
| Database connection failed | Ensure postgres container is running and healthy |

---

## 📊 Step 9: Monitoring

### Set up monitoring commands on VM:
```bash
# Create monitoring script
cat > ~/monitor.sh << 'EOF'
#!/bin/bash
echo "=== Container Status ==="
docker compose ps

echo ""
echo "=== Resource Usage ==="
docker stats --no-stream

echo ""
echo "=== Backend Health ==="
curl -s http://localhost:8080/actuator/health | jq '.'

echo ""
echo "=== Recent Logs ==="
docker compose logs --tail=20
EOF

chmod +x ~/monitor.sh

# Run monitoring
~/monitor.sh
```

---

## 🎉 Success Checklist

Verify everything is working:

- [ ] Code pushed to GitHub successfully
- [ ] GitHub Actions workflow runs without errors
- [ ] VM containers are all "Up" and "healthy"
- [ ] Backend health check returns: `{"status":"UP"}`
- [ ] Frontend loads in browser: `http://104.154.52.39:3000`
- [ ] Can login with username: `admin`
- [ ] Can create, edit, and delete tasks
- [ ] Changes pushed to GitHub auto-deploy to VM

---

## 🔄 Daily Workflow

### Making changes and deploying:

```powershell
# On your local machine
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"

# Make your changes
# Edit files...

# Test locally (optional)
docker compose up -d

# Commit and push (auto-deploys!)
git add .
git commit -m "Description of changes"
git push origin main

# GitHub Actions will automatically deploy to VM!
```

---

## 📝 Quick Commands Reference

### Local Machine (PowerShell):
```powershell
# Push changes
git add .
git commit -m "message"
git push origin main

# Check git status
git status
```

### VM (SSH):
```bash
# Check deployment
docker compose ps
docker compose logs -f

# Restart services
docker compose restart

# Full rebuild
docker compose down && docker compose up -d --build

# Check health
curl http://localhost:8080/actuator/health
```

---

## 🆘 Support

If you encounter issues:
1. Check GitHub Actions logs
2. SSH into VM and check: `docker compose logs`
3. Verify firewall rules: `sudo ufw status`
4. Check if ports are listening: `sudo netstat -tulpn`
5. Restart Docker: `sudo systemctl restart docker`

---

## 🎯 Next Steps (Optional)

1. **Set up HTTPS** with Let's Encrypt SSL
2. **Configure domain** (task-vm.nadunwansooriya.online) with proper DNS
3. **Add monitoring** (Prometheus + Grafana)
4. **Set up backups** for PostgreSQL database
5. **Configure logging** (ELK stack or similar)

Your deployment is ready! 🚀
