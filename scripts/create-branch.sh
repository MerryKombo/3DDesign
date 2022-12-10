#!/bin/bash -x

echo "$GITHUB_CREDENTIALS_PSW" | gh auth login --with-token
cp /tmp/sorted_jenkins_plugins.txt ./plugins.txt
git add .
# Get current branch name
branch_name=$GIT_BRANCH
echo "Working on branch $branch_name for repo $GIT_URL"
new_branch_name="binaries-for-$branch_name"
git config --global user.email "116569+gounthar@users.noreply.github.com"
git config --global user.name "$GITHUB_CREDENTIALS_USR"
git switch -c "${new_branch_name}" -m
git commit -m "chore(binaries) New binaries for $branch_name"
git push --set-upstream https://"$GITHUB_CREDENTIALS_USR":"$GITHUB_CREDENTIALS_PSW"@github.com/$GITHUB_REPOSITORY.git "${new_branch_name}"
# Now use gh to create a pull request from new_branch_name to branch_name
#gh pr create -B "$branch_name" -t "Update plugins.txt" -b "Update plugins.txt" --head "${new_branch_name}" --base "$branch_name"
#git switch "${branch_name}"
