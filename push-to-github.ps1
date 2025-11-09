# Quick GitHub Push and VM Setup Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 GitHub Push & VM Deployment Setup" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "d:\Devops Projects\devops intern\versions\local\my-task-app"
cd $projectPath

Write-Host "📁 Project: my-task-app" -ForegroundColor Yellow
Write-Host "🌐 GitHub: https://github.com/NadunWansooriya1/my-task-app.git" -ForegroundColor Yellow
Write-Host "🖥️  VM IP: 104.154.52.39" -ForegroundColor Yellow
Write-Host "🌍 Domain: task-vm.nadunwansooriya.online" -ForegroundColor Yellow
Write-Host ""

# Check if git is initialized
if (-not (Test-Path ".git")) {
    Write-Host "📦 Initializing Git repository..." -ForegroundColor Yellow
    git init
    Write-Host ""
}

# Check current git status
Write-Host "📊 Current Git Status:" -ForegroundColor Yellow
git status --short
Write-Host ""

# Add all files
Write-Host "➕ Adding all files to git..." -ForegroundColor Yellow
git add .
Write-Host ""

# Show what will be committed
Write-Host "📝 Files to be committed:" -ForegroundColor Yellow
git status --short
Write-Host ""

# Commit
$commitMessage = Read-Host "Enter commit message (or press Enter for default)"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Deploy: Updated configuration for VM deployment with GitHub Actions"
}

Write-Host ""
Write-Host "💾 Committing changes..." -ForegroundColor Yellow
git commit -m "$commitMessage"
Write-Host ""

# Check if remote exists
$remoteExists = git remote | Select-String "origin"
if (-not $remoteExists) {
    Write-Host "🔗 Adding GitHub remote..." -ForegroundColor Yellow
    git remote add origin https://github.com/NadunWansooriya1/my-task-app.git
    Write-Host ""
}

# Set main branch
Write-Host "🌿 Setting main branch..." -ForegroundColor Yellow
git branch -M main
Write-Host ""

# Push to GitHub
Write-Host "⬆️  Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "   (You may need to authenticate)" -ForegroundColor Gray
Write-Host ""

$pushResult = git push -u origin main 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Push failed. You may need to:" -ForegroundColor Yellow
    Write-Host "   1. Authenticate with GitHub" -ForegroundColor White
    Write-Host "   2. Create a Personal Access Token" -ForegroundColor White
    Write-Host "   3. Use: git push -u origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "   Get token at: https://github.com/settings/tokens" -ForegroundColor Cyan
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "📋 Next Steps:" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1️⃣  Set up GitHub Secrets:" -ForegroundColor Yellow
Write-Host "   Go to: https://github.com/NadunWansooriya1/my-task-app/settings/secrets/actions" -ForegroundColor White
Write-Host "   Add these secrets:" -ForegroundColor White
Write-Host "   - SSH_PRIVATE_KEY: Your VM SSH private key" -ForegroundColor Gray
Write-Host ""
Write-Host "2️⃣  SSH into your VM:" -ForegroundColor Yellow
Write-Host "   ssh nadun_wansooriya@104.154.52.39" -ForegroundColor White
Write-Host ""
Write-Host "3️⃣  Clone repository on VM:" -ForegroundColor Yellow
Write-Host "   cd ~" -ForegroundColor White
Write-Host "   git clone https://github.com/NadunWansooriya1/my-task-app.git" -ForegroundColor White
Write-Host "   cd my-task-app" -ForegroundColor White
Write-Host ""
Write-Host "4️⃣  First deployment on VM:" -ForegroundColor Yellow
Write-Host "   docker compose up -d --build" -ForegroundColor White
Write-Host ""
Write-Host "5️⃣  Check deployment:" -ForegroundColor Yellow
Write-Host "   docker compose ps" -ForegroundColor White
Write-Host "   curl http://localhost:8080/actuator/health" -ForegroundColor White
Write-Host ""
Write-Host "6️⃣  Test in browser:" -ForegroundColor Yellow
Write-Host "   Frontend: http://104.154.52.39:3000" -ForegroundColor Cyan
Write-Host "   Backend:  http://104.154.52.39:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✨ Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📖 See VM_DEPLOYMENT_GUIDE.md for detailed instructions" -ForegroundColor Yellow
