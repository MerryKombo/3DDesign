#!/bin/bash -ex
# NOTE: The -x flag (xtrace) can expose sensitive tokens in logs.
# TODO: Wrap token-sensitive commands with set +x / set -x guards
# See issue #50 for comprehensive fix across all scripts.

echo "Starting the generate-binaries.sh script"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Call helper scripts with full paths
# set -e ensures the script exits on any error
"${SCRIPT_DIR}/create-branch.sh"
find . -type f -name "*scad" -print0 | xargs -I{} --null xvfb-run -a openscad --imgsize=4096,2160 {} -o {}.png
find . -type f -name "*scad" -print0 | xargs -I{} --null openscad {} -o {}.stl
"${SCRIPT_DIR}/keep-only-binaries.sh"
"${SCRIPT_DIR}/push-to-repo.sh"

echo "Ending the generate-binaries.sh script"