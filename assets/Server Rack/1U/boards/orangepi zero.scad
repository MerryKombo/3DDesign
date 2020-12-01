include <orangepi zero dimensions.scad>
use <../parts/feet.scad>
use <../parts/bracket.scad>
use <../parts/drilling templates.scad>

orangepi_zero_feet();
orangepi_zero_bracket();

module orangepi_zero_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module orangepi_zero_bracket() {
    translate(size) translate(size) bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    