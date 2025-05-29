#!/bin/bash -x
echo "Starting the keep-only-binaries.sh script"

# Create binaries directory if it doesn't exist
mkdir -p binaries

# and move only the binary files while keeping the same directory structure
rsync -rv --include '*/' --include '*.png' --include '*.stl' --exclude '*' --prune-empty-dirs . binaries/

echo "Ending the keep-only-binaries.sh script"
