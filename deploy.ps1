# PowerShell Deployment Script for Task Management Application
# Run this script from PowerShell in the project directory

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "🚀 Starting Deployment" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Get current location
$projectPath = Get-Location
Write-Host "📍 Project Path: $projectPath" -ForegroundColor Yellow
Write-Host ""

# Check if Docker is running
Write-Host "🔍 Checking Docker..." -ForegroundColor Yellow
try {
    docker version | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}
Write-Host ""

# Stop existing containers
Write-Host "⏸️  Stopping existing containers..." -ForegroundColor Yellow
docker compose down
Write-Host ""

# Optional: Clean old images
$cleanImages = Read-Host "Do you want to clean old Docker images? (y/N)"
if ($cleanImages -eq 'y' -or $cleanImages -eq 'Y') {
    Write-Host "🧹 Cleaning old images..." -ForegroundColor Yellow
    docker image prune -af
    Write-Host ""
}

# Build and start containers
Write-Host "🏗️  Building and starting containers..." -ForegroundColor Yellow
Write-Host "⏳ This may take 2-5 minutes on first run..." -ForegroundColor Yellow
docker compose up -d --build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Wait for services to be ready
Write-Host "⏳ Waiting for services to start (90 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 90
Write-Host ""

# Check container status
Write-Host "📊 Container Status:" -ForegroundColor Yellow
docker compose ps
Write-Host ""

# Check backend health
Write-Host "🏥 Checking backend health..." -ForegroundColor Yellow
$maxRetries = 15
$retryCount = 0
$backendHealthy = $false

while ($retryCount -lt $maxRetries) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Backend is healthy!" -ForegroundColor Green
            $backendHealthy = $true
            break
        }
    } catch {
        $retryCount++
        Write-Host "   Waiting for backend... ($retryCount/$maxRetries)" -ForegroundColor Gray
        Start-Sleep -Seconds 10
    }
}

if (-not $backendHealthy) {
    Write-Host "⚠️  Backend health check failed. Check logs with: docker compose logs backend" -ForegroundColor Yellow
}
Write-Host ""

# Display access information
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ Deployment Completed!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📱 Access your application:" -ForegroundColor Yellow
Write-Host "   Frontend:     http://localhost:3000" -ForegroundColor White
Write-Host "   Backend API:  http://localhost:8080" -ForegroundColor White
Write-Host "   Health Check: http://localhost:8080/actuator/health" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Default Login:" -ForegroundColor Yellow
Write-Host "   Username: admin" -ForegroundColor White
Write-Host "   Password: (any non-empty string)" -ForegroundColor White
Write-Host ""
Write-Host "📋 Useful Commands:" -ForegroundColor Yellow
Write-Host "   View logs:    docker compose logs -f" -ForegroundColor White
Write-Host "   Stop all:     docker compose down" -ForegroundColor White
Write-Host "   Restart:      docker compose restart" -ForegroundColor White
Write-Host "==========================================" -ForegroundColor Cyan
