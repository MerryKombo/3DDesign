#!/bin/bash -x

echo "Starting the generate-binaries.sh script"
create-branch.sh
find . -type f -name "*scad" -print0 | xargs -I{} --null xvfb-run -a openscad --imgsize=4096,2160 {} -o {}.png
find . -type f -name "*scad" -print0 | xargs -I{} --null openscad {} -o {}.stl
keep-only-binaries.sh
push-to-repo.sh

echo "Ending the generate-binaries.sh script"