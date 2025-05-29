#!/bin/bash -x

# create a new branch (or check if exists) thanks to gh cli
echo "Starting the create-branch.sh script"

# Authenticate with GitHub using GITHUB_TOKEN
echo "$GITHUB_TOKEN" | gh auth login --with-token

# Get current branch name
branch_name=$BRANCH_NAME
echo "Working on branch $branch_name for repo $GIT_URL"
echo "$(pwd) is the current directory"
echo "Checking if branch $branch_name exists"

# Create a new branch name for the binaries
new_branch_name="binaries-for-$branch_name"

# Configure Git with a temporary config file to avoid permission issues
git config --local user.email "github-actions@github.com"
git config --local user.name "GitHub Actions"

# Create a new branch for the binaries
git checkout -b "${new_branch_name}"

echo "Ending the create-branch.sh script"
