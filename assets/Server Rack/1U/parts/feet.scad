use <bracket.scad>
include <../boards/orangepi zero dimensions.scad>

feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;


module feet_foot(point, holeSize, baseSize, baseHeight, totalHeight) {
    difference() {
                  cylinder(r=footSize/2, h=baseHeight, $fn=100);
                color("red") translate([0,0,-0.5]) cylinder(r=holeSize/2, h=totalHeight+1, $fn=100);
    }
 }
 
 module feet_feet(points,holeSize, baseSize, baseHeight, totalHeight) {
     for (point = points) {
         translate (point) feet_foot(point, holeSize, baseSize, baseHeight, totalHeight);
     }
 }