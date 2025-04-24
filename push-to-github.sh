#!/bin/bash

set -e

# Your GitHub username and repo name
GITHUB_USER="Madhavaraochalla"
REPO_NAME="shell-script"
GITHUB_TOKEN="${GITHUB_TOKEN}"

# Remote with token for HTTPS push
AUTH_REMOTE_URL="https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git"

# Files to commit
FILES=("create-users.sh" "deploy-grafana.sh" "push-to-github.sh")

# Git config to fix line ending warnings
git config --global core.autocrlf input

# Create GitHub repo if it doesn't exist
echo "Checking if repository $REPO_NAME exists on GitHub..."
repo_exists=$(curl -s -o /dev/null -w "%{http_code}" \
    -u "$GITHUB_USER:$GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME")

if [ "$repo_exists" -eq 404 ]; then
    echo "Repository not found. Creating repository on GitHub..."
    curl -s -X POST \
        -u "$GITHUB_USER:$GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -d "{\"name\": \"$REPO_NAME\"}" \
        "https://api.github.com/user/repos"
else
    echo "Repository $REPO_NAME already exists on GitHub."
fi

# Initialize git repo if not already initialized
if [ ! -d .git ]; then
    echo "Initializing Git repository..."
    git init
fi

# Set or reset remote origin
git remote remove origin 2>/dev/null || true
git remote add origin "$AUTH_REMOTE_URL"

# Add files
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        git add "$file"
        echo "Added $file"
    else
        echo "Warning: $file does not exist."
    fi
done

# Commit changes
git commit -m "Add deployment and user creation shell scripts" || echo "No changes to commit"

# Create and switch to a new branch
BRANCH="auto-deploy-branch"
git checkout -b $BRANCH || git checkout $BRANCH  # if branch already exists locally
echo "✅ Switched to branch: $BRANCH"

# Push to GitHub
echo "Pushing to GitHub repository $REPO_NAME..."
git branch -M main
git push -u origin main

echo "✅ Pushed scripts to GitHub repo: $REPO_NAME"
