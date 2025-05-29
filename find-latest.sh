#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    # Return to original branch if possible
    if [ -n "$original_branch" ]; then
        echo "Returning to branch $original_branch..." >&2
        git checkout "$original_branch" 2>/dev/null || echo "Failed to return to original branch." >&2
    fi
    exit 1
}

# Check if a file name parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file_name>"
    exit 1
fi

file_name=$1

# Remember the current branch
original_branch=$(git branch --show-current) || handle_error "Failed to get current branch."

# Fetch all branches from the remote repository
echo "Fetching all branches..."
git fetch --all || handle_error "Failed to fetch branches."

# Get a list of all branches
branches=$(git branch -r | grep -v '\->') || handle_error "Failed to list branches."

latest_commit=""
latest_timestamp=0

# Loop through each branch to find the latest commit for the file
for branch in $branches; do
    branch_name=${branch#origin/}
    echo "Checking branch: $branch_name"
    
    # Checkout the branch
    git checkout "$branch_name" 2>/dev/null || {
        echo "Warning: Failed to checkout branch $branch_name, skipping."
        continue
    }

    # Get the latest commit for the file in the current branch
    commit=$(git log -1 --format="%H %cd" --date=iso -- "$file_name" 2>/dev/null)
    
    if [ -n "$commit" ]; then
        # Extract the date part from the commit info
        commit_date_str=$(echo "$commit" | awk '{print $2"T"$3}')
        
        # Convert ISO date to Unix timestamp for numeric comparison
        commit_timestamp=$(date -d "$commit_date_str" +%s 2>/dev/null)
        
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to parse date from commit: $commit_date_str"
            continue
        fi

        # Compare timestamps to find the latest one
        if [ "$commit_timestamp" -gt "$latest_timestamp" ]; then
            latest_commit=$commit
            latest_timestamp=$commit_timestamp
            echo "  Found newer commit: $(date -d @$commit_timestamp '+%Y-%m-%d %H:%M:%S')"
        fi
    fi
done

# Output the latest commit information
if [ -n "$latest_commit" ]; then
    echo "Latest commit for $file_name:"
    echo "$latest_commit"
    echo "Date: $(date -d @$latest_timestamp '+%Y-%m-%d %H:%M:%S')"
else
    echo "File $file_name not found in any branch."
fi

# Checkout back to the original branch
echo "Returning to original branch: $original_branch"
git checkout "$original_branch" || handle_error "Failed to return to original branch."

echo "Done."
