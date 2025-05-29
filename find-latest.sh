#!/bin/bash

# Check if a file name parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file_name>"
    exit 1
fi

file_name=$1

# Remember the current branch
original_branch=$(git branch --show-current)

# Fetch all branches from the remote repository
git fetch --all

# Get a list of all branches
branches=$(git branch -r | grep -v '\->')

latest_commit=""
latest_date=""

# Loop through each branch to find the latest commit for the file
for branch in $branches; do
    # Get the latest commit for the file in the remote branch
    commit=$(git log -1 --format="%H %cd" --date=iso origin/${branch#origin/} -- $file_name)
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
    echo "Latest commit for $file_name:"
    echo $latest_commit
else
    echo "File $file_name not found in any branch."
fi

# Checkout back to the original branch
git checkout $original_branch
