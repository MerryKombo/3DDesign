#!/bin/bash -x

# create a new branch (or check if exists) thanks to gh cli
echo "Starting the create-branch.sh script"

echo "$GH_CREDENTIALS_PSW" | gh auth login --with-token
# Get current branch name
branch_name=$GIT_BRANCH
echo "Working on branch $branch_name for repo $GIT_URL"
new_branch_name="binaries-for-$branch_name"
git config --global user.email "116569+gounthar@users.noreply.github.com"
git config --global user.name "$GH_CREDENTIALS_PSW"
git switch -c "${new_branch_name}" -m

echo "Ending the create-branch.sh script"
