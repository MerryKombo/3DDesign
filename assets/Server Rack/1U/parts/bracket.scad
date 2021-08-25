include <../boards/orangepi zero dimensions.scad>


bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);

module bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight) {
    union() {
        bracket_feet(feet,holeSize, baseSize, baseHeight, totalHeight);
        bracket_link(feet, linkThickness, linkHeight);
    }
}

module bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight) {
    difference() {
      union()  {
            hull() {
                cylinder(r=baseSize/2, h=baseHeight, $fn=100);
                translate([0,0,(totalHeight - baseHeight)/2]) cylinder(r=footSize/2, h=baseHeight, $fn=100);
            }
            translate([0,0,totalHeight - baseHeight]) cylinder(r=footSize/2, h=baseHeight, $fn=100);
        }
        color("red") translate([0,0,-0.5]) cylinder(r=holeSize/2, h=totalHeight+1, $fn=100);
    }
 }
 
 module bracket_feet(points,holeSize, baseSize, baseHeight, totalHeight) {
     for (point = points) {
         translate (point) bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight);
     }
 }
 
 module bracket_link(points, thickness, height) {
     firstSide = points[1][0] - points[0][0];
     secondSide = points[3][1] - points[0][0];
     length = sqrt(pow(firstSide,2) + pow(secondSide,2)) - holeSize;
     atan = atan(firstSide/secondSide);
     union() {
        color("blue") translate([0,0,height*2]) rotate([270,0,-atan]) translate([0,0, holeSize/2]) cylinder(h=length, r=thickness/2, center=false, $fn=100);
        color("green") translate([firstSide,0,height*2]) rotate([270,0,atan]) translate([0,0, holeSize/2]) cylinder(h=length, r=thickness/2, center=false, $fn=100);
     }
 }
 
