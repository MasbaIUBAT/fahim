#!/bin/bash

# Check if GITHUB_PAT is set
if [ -z "$GITHUB_PAT" ]; then
    echo "Error: GITHUB_PAT environment variable is not set."
    exit 1
fi

# Define the remote URL (update with your actual remote URL)
REPO_URL="https://$GITHUB_PAT@github.com/MasbaIUBAT/fahim.git"

# Initialize a new Git repository
echo "Initializing Git repository..."
git init

# Create and switch to the 'main' branch (only if 'main' branch does not already exist)
if ! git show-ref --verify --quiet refs/heads/main; then
    echo "Creating and switching to branch 'main'..."
    git checkout -b main
else
    echo "Branch 'main' already exists. Switching to it..."
    git checkout main
fi

# Add all changes to the staging area
echo "Adding changes to staging area..."
git add .

# Commit the changes
echo "Committing changes..."
git commit -m 'Initial commit'

# Add the remote URL
echo "Adding remote repository..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

# Fetch and merge changes from the remote (if any)
echo "Fetching changes from remote..."
git fetch origin

echo "Merging remote changes..."
git merge origin/main --allow-unrelated-histories

# Push changes to the remote repository
echo "Pushing changes to remote repository..."
git push -u origin main

echo "Script completed successfully!"
