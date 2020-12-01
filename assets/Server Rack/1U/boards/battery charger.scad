include <battery charger dimensions.scad>
use <../parts/feet.scad>
use <../parts/bracket.scad>
use <../parts/drilling templates.scad>

battery_charger_feet();
battery_charger_bracket();

module battery_charger_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module battery_charger_bracket() {
    translate(size) translate(size) bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    
