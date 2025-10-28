#!/bin/bash -x

echo "Starting the push-to-repo.sh script"

git add .

# Get current branch name
branch_name=$BRANCH_NAME
new_branch_name="binaries-for-$branch_name"

git commit -m "chore(binaries) New binaries for $branch_name"

# Temporarily disable xtrace to prevent GITHUB_TOKEN from appearing in logs
set +x
git push --set-upstream https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git "${new_branch_name}"
set -x

# Now use gh to create a pull request from new_branch_name to branch_name
gh pr create -B "$branch_name" -t "Update binaries for $branch_name" -b "Update generated binaries for $branch_name" --head "${new_branch_name}" --base "$branch_name"

echo "Ending the push-to-repo.sh script"
