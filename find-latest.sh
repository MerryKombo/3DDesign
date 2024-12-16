#!/bin/bash

# Fetch all branches from the remote repository
git fetch --all

# Get a list of all branches
branches=$(git branch -r | grep -v '\->')

latest_commit=""
latest_date=""

# Loop through each branch to find the latest commit for the file
for branch in $branches; do
    # Checkout the branch
    git checkout ${branch#origin/}

    # Get the latest commit for the file in the current branch
    commit=$(git log -1 --format="%H %cd" --date=iso -- assets/square.scad)

    if [ -n "$commit" ]; then
        commit_date=$(echo $commit | awk '{print $2" "$3}')

        # Compare commit dates to find the latest one
        if [ -z "$latest_date" ] || [ "$commit_date" \> "$latest_date" ]; then
            latest_commit=$commit
            latest_date=$commit_date
        fi
    fi
done

# Output the latest commit information
if [ -n "$latest_commit" ]; then
    echo "Latest commit for assets/square.scad:"
    echo $latest_commit
else
    echo "File assets/square.scad not found in any branch."
fi

# Checkout back to the original branch
git checkout -
