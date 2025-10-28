#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Check if a file name parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file_name>"
    exit 1
fi

file_name="$1"

# Fetch all branches from the remote repository
echo "Fetching all branches..."
git fetch --all || handle_error "Failed to fetch branches."

# Get a list of all remote branches
branches=$(git branch -r | grep -v '\->' | grep -v 'HEAD') || handle_error "Failed to list branches."

latest_commit=""
latest_timestamp=0
latest_branch=""

echo "Searching for latest commit of '$file_name' across all branches..."

# Loop through each branch to find the latest commit for the file
for branch in $branches; do
    branch_name="${branch#origin/}"
    
    # Get the latest commit for the file directly from the remote branch (no checkout needed)
    commit=$(git log -1 --format="%H %ct" "$branch" -- "$file_name" 2>/dev/null)
    
    if [ -n "$commit" ]; then
        # Extract commit hash and timestamp
        commit_hash=$(echo "$commit" | awk '{print $1}')
        commit_timestamp=$(echo "$commit" | awk '{print $2}')
        
        echo "  Branch $branch_name: found commit $commit_hash at $(date -d "@$commit_timestamp" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "timestamp $commit_timestamp")"
        
        # Compare timestamps to find the latest one
        if [ "$commit_timestamp" -gt "$latest_timestamp" ]; then
            latest_commit=$commit_hash
            latest_timestamp=$commit_timestamp
            latest_branch=$branch_name
            echo "    -> New latest commit found!"
        fi
    fi
done

# Output the latest commit information
echo ""
if [ -n "$latest_commit" ]; then
    echo "Latest commit for '$file_name':"
    echo "  Commit: $latest_commit"
    echo "  Branch: $latest_branch"
    echo "  Date: $(date -d "@$latest_timestamp" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "timestamp $latest_timestamp")"
    echo ""
    echo "Full details:"
    git log -1 --format="%H %ai %an <%ae>%n%B" "$latest_commit" -- "$file_name"
else
    echo "File '$file_name' not found in any branch."
    exit 1
fi

echo "Done."
