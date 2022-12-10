#!/bin/bash -x

echo "Starting the push-to-repo.sh script"

git add .

# Get current branch name
branch_name=$GIT_BRANCH

git commit -m "chore(binaries) New binaries for $branch_name"
git push --set-upstream https://"$GITHUB_CREDENTIALS_USR":"$GITHUB_CREDENTIALS_PSW"@github.com/$GITHUB_REPOSITORY.git "${new_branch_name}"
# Now use gh to create a pull request from new_branch_name to branch_name
#gh pr create -B "$branch_name" -t "Update plugins.txt" -b "Update plugins.txt" --head "${new_branch_name}" --base "$branch_name"
#git switch "${branch_name}"

echo "Starting the push-to-repo.sh script"
