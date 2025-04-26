#!/bin/bash

set -e

# Dry-run option
DRYRUN=false
if [ "$1" == "--dry-run" ]; then
  DRYRUN=true
  echo "⚡ Running in dry-run mode: No changes will be made."
fi

# Your GitHub username and repo name
GITHUB_USER="Madhavaraochalla"
REPO_NAME="shell-script-repo"

# Use the exported token (make sure it's exported before running the script)
AUTH_REMOTE_URL="https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"

# Files to commit
#FILES=("delete-repo.sh" "create-users.sh" "deploy-grafana.sh" "Push-code.sh" "delete.sh" "deploy.sh" "Readme.md")

# Files to remove (if needed)
FILES_TO_REMOVE=("") 

# Git config
$DRYRUN || git config --global core.autocrlf input

# Check if repo exists
echo "Checking if repository $REPO_NAME exists on GitHub..."
if ! $DRYRUN; then
    repo_exists=$(curl -s -o /dev/null -w "%{http_code}" \
        -u "$GITHUB_USER:$GITHUB_TOKEN" \
        "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME")
else
    repo_exists=200
    echo "(dry-run) Assuming repo exists."
fi

if [ "$repo_exists" -eq 404 ]; then
    echo "Repository not found. Creating repository on GitHub..."
    if ! $DRYRUN; then
        curl -s -X POST \
            -u "$GITHUB_USER:$GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -d "{\"name\": \"$REPO_NAME\"}" \
            "https://api.github.com/user/repos"
    else
        echo "(dry-run) Would create repository $REPO_NAME."
    fi
else
    echo "Repository $REPO_NAME already exists on GitHub."
fi

# Initialize git repo
if [ ! -d .git ]; then
    echo "Initializing Git repository..."
    $DRYRUN || git init
    $DRYRUN || git commit --allow-empty -m "Initial commit"
fi

# Set or reset remote origin
$DRYRUN || git remote remove origin 2>/dev/null || true
if ! $DRYRUN; then
    git remote add origin "$AUTH_REMOTE_URL"
else
    echo "(dry-run) Would set remote to $AUTH_REMOTE_URL."
fi

# Pull latest changes
echo "Pulling latest changes from GitHub..."
if ! $DRYRUN; then
    git pull origin master || echo "No changes to pull or already up-to-date."
else
    echo "(dry-run) Would pull latest changes."
fi

### Optional: Stage all local changes (Uncomment the below line if you want to add all files)
$DRYRUN || git add .

# Add files
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        if ! $DRYRUN; then
            git add "$file"
        fi
        echo "Added $file"
    else
        echo "Warning: $file does not exist."
    fi
done

# Remove files
for file in "${FILES_TO_REMOVE[@]}"; do
    if [ -f "$file" ]; then
        if ! $DRYRUN; then
            git rm --cached "$file" || git rm -f "$file"
        fi
        echo "Removed $file from repository."
    else
        echo "Warning: $file does not exist."
    fi
done

# Get commit count and create message
commit_count=$(git rev-list --count HEAD || echo "0")
commit_message="Commit $commit_count: $(git diff --cached --name-only | tr '\n' ' ')" 

# Commit changes
if ! $DRYRUN; then
    git commit -m "$commit_message" || echo "No changes to commit"
else
    echo "(dry-run) Would commit with message: '$commit_message'"
fi

# Show added/removed files and commit ID
echo "Files added and committed:"
git diff --cached --name-only
commit_id=$(git log -1 --format=%H || echo "dry-run-commit-id")
echo "Commit ID: $commit_id"

# Create and switch to branch
BRANCH="auto-deploy-branch"
if ! $DRYRUN; then
    git checkout -b $BRANCH || git checkout $BRANCH
else
    echo "(dry-run) Would checkout/create branch: $BRANCH"
fi
echo "✅ Switched to branch: $BRANCH"

# Push to GitHub
echo "Pushing to GitHub repository $REPO_NAME..."
if ! $DRYRUN; then
    git branch -M main
    git push -u origin main
else
    echo "(dry-run) Would push branch main to remote."
fi

# Final output
echo "✅ Scripts ready in GitHub repo: $REPO_NAME"
echo "Commit ID of pushed changes: $commit_id"
