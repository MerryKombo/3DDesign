#!/bin/bash -x
find . -type f -name "*scad" -print0 | xargs -I{} --null xvfb-run -a openscad --imgsize=4096,2160 {} -o {}.png
find . -type f -name "*scad" -print0 | xargs -I{} --null openscad {} -o {}.stl