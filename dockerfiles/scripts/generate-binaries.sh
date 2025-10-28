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

# Helper function to format file size with decimal precision
format_size() {
    local size=$1
    if [ "$size" = "unknown" ]; then
        echo "unknown"
    elif [ $size -lt 1024 ]; then
        echo "${size}B"
    elif [ $size -lt 1048576 ]; then
        # Use awk for floating point division
        awk -v s="$size" 'BEGIN {printf "%.1fKB", s/1024}'
    else
        awk -v s="$size" 'BEGIN {printf "%.1fMB", s/1048576}'
    fi
}

# Helper function to get file size with error handling
get_file_size() {
    local file=$1
    local size

    # Try macOS stat first, then Linux stat
    size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$size" ]; then
        log "Warning: Failed to get size for: $file"
        echo "unknown"
    else
        echo "$size"
    fi
}

# Helper function to process SCAD files (consolidates PNG and STL processing)
process_files() {
    local file_type=$1      # "PNG" or "STL"
    local output_ext=$2     # ".png" or ".stl"
    local img_size=$3       # Image size for PNG (empty for STL)

    log "Starting $file_type generation${img_size:+ ($img_size resolution)}..."

    local current=0
    find . -type f -name "*scad" -print0 | while IFS= read -r -d '' file; do
        current=$((current + 1))
        START_TIME=$(date +%s)
        FILE_SIZE=$(get_file_size "$file")

        log "[$current/$TOTAL_FILES] Processing $file_type: $file ($(format_size $FILE_SIZE))"

        # Build the command based on file type
        local cmd
        if [ "$file_type" = "PNG" ]; then
            cmd="xvfb-run -a openscad --imgsize=$img_size \"$file\" -o \"${file}${output_ext}\""
        else
            cmd="openscad \"$file\" -o \"${file}${output_ext}\""
        fi

        if eval "$cmd"; then
            END_TIME=$(date +%s)
            ELAPSED=$((END_TIME - START_TIME))
            OUTPUT_SIZE=$(get_file_size "${file}${output_ext}")
            log "[$current/$TOTAL_FILES] ✓ $file_type completed in ${ELAPSED}s (output: $(format_size $OUTPUT_SIZE))"
        else
            END_TIME=$(date +%s)
            ELAPSED=$((END_TIME - START_TIME))
            log "[$current/$TOTAL_FILES] ✗ $file_type failed after ${ELAPSED}s for: $file"
        fi
    done
}

# Call helper scripts with full paths
# set -e ensures the script exits on any error
log "Creating branch..."
"${SCRIPT_DIR}/create-branch.sh"

# Count total SCAD files
log "Counting SCAD files..."
TOTAL_FILES=$(find . -type f -name "*scad" | wc -l)
log "Found $TOTAL_FILES SCAD files to process"

# Process PNG and STL files using consolidated function
process_files "PNG" ".png" "4096,2160"
process_files "STL" ".stl"

log "Filtering binaries..."
"${SCRIPT_DIR}/keep-only-binaries.sh"

log "Pushing to repository..."
"${SCRIPT_DIR}/push-to-repo.sh"

log "Ending the generate-binaries.sh script"