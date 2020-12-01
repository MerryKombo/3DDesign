include <PWM to V dimensions.scad>
use <../parts/feet.scad>
use <../parts/bracket.scad>
use <../parts/drilling templates.scad>
 
PWM_to_V_feet();
PWM_to_V_bracket();

module PWM_to_V_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module PWM_to_V_bracket() {
    translate(size) translate(size) bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    