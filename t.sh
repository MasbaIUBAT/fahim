#!/bin/bash

# Repositories to push to
REPOS=("https://github.com/MasbaIUBAT/fahim.git" "https://github.com/MasbaIUBAT/new-job.git" "https://github.com/MasbaIUBAT/Docker-networking-.git" "https://github.com/MasbaIUBAT/fahim.git" "https://github.com/MasbaIUBAT/new-repository.git")
# File to be pushed
FILE_NAME="rumi.txt"
COMMIT_MESSAGE="Adding $FILE_NAME to the repository"

# GitHub Token for authentication
GITHUB_TOKEN="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"

# Loop through each repository
for REPO_URL in "${REPOS[@]}"; do
    # Extract repository name and directory
    REPO_DIR=$(basename "$REPO_URL" .git)
    
    echo "Processing repository: $REPO_URL"
    
    # Check if directory for repo already exists
    if [ ! -d "$REPO_DIR" ]; then
        echo "Cloning repository from $REPO_URL..."
        git clone "$REPO_URL" || { echo "Failed to clone repository $REPO_URL"; continue; }
    fi

    # Navigate into the repository directory
    cd "$REPO_DIR" || { echo "Failed to navigate to $REPO_DIR"; continue; }

    # Initialize the repository if it is not already initialized
    if [ ! -d ".git" ]; then
        echo "Initializing new Git repository..."
        git init || { echo "Failed to initialize Git repository in $REPO_DIR"; cd ..; continue; }
    fi

    # Check the current branch
    CURRENT_BRANCH=$(git branch --show-current)
    if [ -z "$CURRENT_BRANCH" ]; then
        echo "No branch detected. Checking out main branch..."
        git checkout -b main || { echo "Failed to checkout main branch in $REPO_DIR"; cd ..; continue; }
        CURRENT_BRANCH="main"
    fi
    
    echo "Current branch is $CURRENT_BRANCH"

    # Check if the file exists in the parent directory
    if [ -f "../$FILE_NAME" ]; then
        echo "Adding and committing '$FILE_NAME' file to $REPO_DIR..."
        cp "../$FILE_NAME" . || { echo "Failed to copy $FILE_NAME to $REPO_DIR"; cd ..; continue; }

        git add "$FILE_NAME" || { echo "Failed to add $FILE_NAME to staging"; cd ..; continue; }

        # Commit the changes
        git commit -m "$COMMIT_MESSAGE" || { echo "Failed to commit changes in $REPO_DIR"; cd ..; continue; }

        # Push the changes
        echo "Pushing changes to $REPO_URL..."
        git remote set-url origin https://$GITHUB_TOKEN@${REPO_URL#https://} || { echo "Failed to set remote URL for $REPO_DIR"; cd ..; continue; }
        git push origin "$CURRENT_BRANCH" || { echo "Failed to push changes to $REPO_URL"; cd ..; continue; }
    else
        echo "File '$FILE_NAME' does not exist in the parent directory. Skipping..."
    fi

    # Navigate back to parent directory
    cd ..
done

echo "Script execution completed."
