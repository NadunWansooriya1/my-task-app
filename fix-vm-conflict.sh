#!/bin/bash

# Script to fix merge conflicts on VM
# Run this on your VM if deployment fails due to merge conflicts

echo "========================================"
echo "🔧 Fixing Merge Conflicts on VM"
echo "========================================"
echo ""

cd ~/my-task-app || exit 1

echo "📍 Current status:"
git status
echo ""

echo "🔄 Resetting to clean state..."

# Abort any ongoing merge
git merge --abort 2>/dev/null || true

# Stash any local changes
git stash 2>/dev/null || true

# Switch to main branch
git checkout main

# Force pull from origin
echo "📥 Force pulling latest code from GitHub..."
git fetch --all
git reset --hard origin/main
git clean -fd

echo ""
echo "✅ Repository reset to match GitHub"
echo ""

# Show current committ
echo "📍 Current commit:"
git log -1 --oneline
echo ""

echo "🏗️  Ready to deploy. Run:"
echo "   docker compose down"
echo "   docker compose up -d --build"
echo ""
echo "Or run: ./vm-setup.sh"
