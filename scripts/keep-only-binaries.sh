#!/bin/bash -x
# and move only the binary files while keeping the same directory structure
rsync -rv --include '*/' --include '*.png' --include '*.stl' --exclude '*' --prune-empty-dirs . binaries/