# 🚀 Quick Start Commands

## ✅ What's Been Updated:

1. ✅ Configuration updated for VM IP: `104.154.52.39`
2. ✅ CORS configured for domain: `task-vm.nadunwansooriya.online`
3. ✅ GitHub Actions workflow ready
4. ✅ All deployment scripts created

---

## 📦 STEP 1: Push to GitHub (Run on Windows)

### Option A: Use the Script (Easiest)
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"
.\push-to-github.ps1
```

### Option B: Manual Commands
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"

# Initialize and add all files
git init
git add .
git commit -m "Deploy: VM deployment with GitHub Actions"

# Add remote and push
git remote add origin https://github.com/NadunWansooriya1/my-task-app.git
git branch -M main
git push -u origin main
```

**Note**: You may need to authenticate with GitHub. If asked, use a Personal Access Token:
1. Go to: https://github.com/settings/tokens
2. Generate new token (classic)
3. Select scopes: `repo`, `workflow`
4. Use token as password when pushing

---

## 🔐 STEP 2: Set Up GitHub Secrets

1. Go to: **https://github.com/NadunWansooriya1/my-task-app/settings/secrets/actions**
2. Click "New repository secret"
3. Add this secret:

| Name | Value |
|------|-------|
| `SSH_PRIVATE_KEY` | Your VM's SSH private key (entire content) |

**To get your SSH private key:**
```powershell
# On Windows
cat ~/.ssh/id_rsa
# Copy everything including -----BEGIN and -----END lines
```

---

## 🖥️ STEP 3: Set Up Your VM

### A. SSH into VM:
```bash
ssh nadun_wansooriya@104.154.52.39
```

### B. Clone Repository:
```bash
cd ~
git clone https://github.com/NadunWansooriya1/my-task-app.git
cd my-task-app
```

### C. Run Setup Script (Easiest):
```bash
chmod +x vm-setup.sh
./vm-setup.sh
```

### OR Manual Setup:
```bash
# Install Docker (if needed)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt-get update
sudo apt-get install -y docker-compose-plugin

# Configure firewall
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 3000/tcp
sudo ufw allow 8080/tcp
sudo ufw enable

# Log out and log back in
exit
```

### D. First Deployment:
```bash
ssh nadun_wansooriya@104.154.52.39
cd ~/my-task-app

# Deploy
docker compose up -d --build

# Wait for services to start (2-5 minutes)
sleep 120

# Check status
docker compose ps

# Check health
curl http://localhost:8080/actuator/health
```

---

## ✅ STEP 4: Verify Deployment

### From Your VM:
```bash
# Check containers
docker compose ps

# Check logs
docker compose logs -f backend

# Test backend
curl http://localhost:8080/actuator/health

# Test frontend
curl http://localhost:3000
```

### From Your Browser:
Open these URLs:
- **Frontend**: http://104.154.52.39:3000
- **Backend API**: http://104.154.52.39:8080/actuator/health
- **Domain** (if DNS configured): http://task-vm.nadunwansooriya.online:3000

### Test Login:
1. Go to: http://104.154.52.39:3000
2. Username: `admin`
3. Password: `test` (any text works)
4. You should see the task list

---

## 🔄 STEP 5: Test GitHub Actions Auto-Deploy

### Make a test change on your local machine:
```powershell
cd "d:\Devops Projects\devops intern\versions\local\my-task-app"

# Make a small change
echo "# Test" >> README.md

# Commit and push
git add .
git commit -m "Test: GitHub Actions auto-deployment"
git push origin main
```

### Monitor the deployment:
1. Go to: **https://github.com/NadunWansooriya1/my-task-app/actions**
2. Click on the latest workflow run
3. Watch it deploy automatically!

### On your VM, you can watch:
```bash
watch docker compose ps
# Or
docker compose logs -f
```

---

## 📊 Monitoring Commands

### On VM:
```bash
# Check status
docker compose ps

# View all logs
docker compose logs -f

# View specific service logs
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f postgres

# Check resource usage
docker stats

# Restart services
docker compose restart

# Full rebuild
docker compose down
docker compose up -d --build
```

---

## 🐛 Troubleshooting

### GitHub Actions fails:
```bash
# Check if SSH key is correct in GitHub Secrets
# Make sure SSH_PRIVATE_KEY secret is set correctly
```

### Container won't start:
```bash
# Check logs
docker compose logs backend

# Restart
docker compose restart backend

# Rebuild
docker compose down
docker compose up -d --build backend
```

### Can't access from browser:
```bash
# Check firewall
sudo ufw status

# Check if ports are listening
sudo netstat -tulpn | grep -E '3000|8080'

# Check container status
docker compose ps
```

### Database issues:
```bash
# Access database
docker exec -it postgres psql -U admin -d taskdb

# Inside PostgreSQL:
\dt          # List tables
\q           # Quit

# Restart database
docker compose restart postgres
```

---

## 🎯 Complete Workflow Summary

```
┌─────────────────────┐
│  1. Local Machine   │  →  Push code to GitHub
│     (Windows)       │      .\push-to-github.ps1
└─────────────────────┘
          ↓
┌─────────────────────┐
│  2. GitHub          │  →  Workflow triggers automatically
│     Actions         │      Runs on: push to main
└─────────────────────┘
          ↓
┌─────────────────────┐
│  3. Your VM         │  →  GitHub Actions SSHs in
│     (GCP/Linux)     │      Pulls code & rebuilds
└─────────────────────┘
          ↓
┌─────────────────────┐
│  4. Docker          │  →  Builds & starts containers
│     Containers      │      postgres + backend + frontend
└─────────────────────┘
          ↓
┌─────────────────────┐
│  5. Live App! 🎉    │  →  http://104.154.52.39:3000
└─────────────────────┘
```

---

## ✨ Success Checklist

- [ ] Code pushed to GitHub
- [ ] GitHub secrets configured (SSH_PRIVATE_KEY)
- [ ] Repository cloned on VM
- [ ] First deployment completed on VM
- [ ] All containers running (docker compose ps shows "Up")
- [ ] Backend health check passes
- [ ] Frontend accessible in browser
- [ ] Can login and use the app
- [ ] GitHub Actions workflow runs successfully
- [ ] Auto-deployment works on push

---

## 📞 Quick Reference

| What | Where | How |
|------|-------|-----|
| **Push code** | Local Windows | `git push origin main` |
| **Monitor deployment** | GitHub | [Actions tab](https://github.com/NadunWansooriya1/my-task-app/actions) |
| **Check VM** | SSH | `ssh nadun_wansooriya@104.154.52.39` |
| **View logs** | VM | `docker compose logs -f` |
| **Restart app** | VM | `docker compose restart` |
| **Access app** | Browser | http://104.154.52.39:3000 |

---

Your deployment pipeline is ready! Every push to `main` branch will automatically deploy to your VM. 🚀
