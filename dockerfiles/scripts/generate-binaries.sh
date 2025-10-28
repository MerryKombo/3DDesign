#!/bin/bash -ex
# NOTE: Token-sensitive commands in helper scripts are now wrapped
# with set +x / set -x guards to prevent exposure in logs.
# See issue #50 for details.

echo "Starting the generate-binaries.sh script"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Helper function to format file size
format_size() {
    local size=$1
    if [ $size -lt 1024 ]; then
        echo "${size}B"
    elif [ $size -lt 1048576 ]; then
        echo "$(( size / 1024 ))KB"
    else
        echo "$(( size / 1048576 ))MB"
    fi
}

# Call helper scripts with full paths
# set -e ensures the script exits on any error
log "Creating branch..."
"${SCRIPT_DIR}/create-branch.sh"

# Count total SCAD files
log "Counting SCAD files..."
TOTAL_FILES=$(find . -type f -name "*scad" | wc -l)
log "Found $TOTAL_FILES SCAD files to process"

# Process PNG files with progress tracking
log "Starting PNG generation (4096x2160 resolution)..."
CURRENT=0
find . -type f -name "*scad" -print0 | while IFS= read -r -d '' file; do
    CURRENT=$((CURRENT + 1))
    START_TIME=$(date +%s)
    FILE_SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")

    log "[$CURRENT/$TOTAL_FILES] Processing PNG: $file ($(format_size $FILE_SIZE))"

    if xvfb-run -a openscad --imgsize=4096,2160 "$file" -o "${file}.png"; then
        END_TIME=$(date +%s)
        ELAPSED=$((END_TIME - START_TIME))
        OUTPUT_SIZE=$(stat -f%z "${file}.png" 2>/dev/null || stat -c%s "${file}.png" 2>/dev/null || echo "0")
        log "[$CURRENT/$TOTAL_FILES] ✓ PNG completed in ${ELAPSED}s (output: $(format_size $OUTPUT_SIZE))"
    else
        END_TIME=$(date +%s)
        ELAPSED=$((END_TIME - START_TIME))
        log "[$CURRENT/$TOTAL_FILES] ✗ PNG failed after ${ELAPSED}s for: $file"
    fi
done

# Process STL files with progress tracking
log "Starting STL generation..."
CURRENT=0
find . -type f -name "*scad" -print0 | while IFS= read -r -d '' file; do
    CURRENT=$((CURRENT + 1))
    START_TIME=$(date +%s)
    FILE_SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")

    log "[$CURRENT/$TOTAL_FILES] Processing STL: $file ($(format_size $FILE_SIZE))"

    if openscad "$file" -o "${file}.stl"; then
        END_TIME=$(date +%s)
        ELAPSED=$((END_TIME - START_TIME))
        OUTPUT_SIZE=$(stat -f%z "${file}.stl" 2>/dev/null || stat -c%s "${file}.stl" 2>/dev/null || echo "0")
        log "[$CURRENT/$TOTAL_FILES] ✓ STL completed in ${ELAPSED}s (output: $(format_size $OUTPUT_SIZE))"
    else
        END_TIME=$(date +%s)
        ELAPSED=$((END_TIME - START_TIME))
        log "[$CURRENT/$TOTAL_FILES] ✗ STL failed after ${ELAPSED}s for: $file"
    fi
done

log "Filtering binaries..."
"${SCRIPT_DIR}/keep-only-binaries.sh"

log "Pushing to repository..."
"${SCRIPT_DIR}/push-to-repo.sh"

log "Ending the generate-binaries.sh script"