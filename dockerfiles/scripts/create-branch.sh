#!/bin/bash -x

# create a new branch (or check if exists) thanks to gh cli
echo "Starting the create-branch.sh script"

# Authenticate with GitHub using GITHUB_TOKEN
# Temporarily disable xtrace to prevent token from appearing in logs
set +x
echo "$GITHUB_TOKEN" | gh auth login --with-token
set -x

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

# Create a new branch for the binaries (or switch to it if it exists)
# Check if branch exists locally
if git show-ref --verify --quiet "refs/heads/${new_branch_name}"; then
    echo "Branch ${new_branch_name} exists locally, switching to it"
    git checkout "${new_branch_name}"
# Check if branch exists remotely
elif git ls-remote --exit-code --heads origin "${new_branch_name}" > /dev/null 2>&1; then
    echo "Branch ${new_branch_name} exists remotely, checking it out"
    git checkout -b "${new_branch_name}" "origin/${new_branch_name}"
else
    echo "Branch ${new_branch_name} does not exist, creating it"
    git checkout -b "${new_branch_name}"
fi

echo "Ending the create-branch.sh script"
