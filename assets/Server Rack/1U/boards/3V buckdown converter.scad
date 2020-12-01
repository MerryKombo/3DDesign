include <3V buckdown converter dimensions.scad>
use <../parts/feet.scad>
use <../parts/bracket.scad>
use <../parts/drilling templates.scad>

3V_buckdown_converter_feet();
3V_buckdown_converter_bracket();

module 3V_buckdown_converter_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module 3V_buckdown_converter_bracket() {
    translate(size) translate(size) bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    