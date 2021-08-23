use <../utils/fillet.scad>
use <../utils/intersection.scad>

totalWidth = 450;
numberOfUnits = 5;
sizeOfEars = 5;
moduleWidth = (totalWidth - (sizeOfEars * 2)) / numberOfUnits;
moduleLength = 150;
oneU = 43.66;
numberOfU = 1;
moduleHeight = numberOfU * oneU;

wallThickness = 5;
threadedRodDiameter = 3;
surroundingDiameter = 2;
rodSurroundingDiameter = threadedRodDiameter + surroundingDiameter;
rodEarHeight = 5;
rodEarDistanceFromSide = rodSurroundingDiameter + surroundingDiameter;
drillTemplateThickness = 1;
drillTemplateGuideHeight = 20;

points = [ [0,0,0], [42.11,0,0], [0,40.11,0], [42.11,40.11,0] ];

/*rounded_box(points, 3, 10);
color("red") plate(points, 5, 2, 3);
color("blue") bar(20, 5, 2, 3);*/

drillTemplate(points, 3, drillTemplateThickness, drillTemplateGuideHeight);


module rounded_box(points, radius, height){
    hull(){
        for (p = points){
            translate(p) cylinder(r=radius, h=height, $fn=100);
        }
    }
}

module cylinders(points, diameter, thickness){
    for (p=points){
        translate(p) color("red") cylinder(d=diameter, h=thickness, center=false, $fn=100);
    }
}
 
module plate(points, diameter, thickness, hole_diameter){
    difference(){
        hull() cylinders(points, diameter, thickness);
        cylinders(points, hole_diameter, thickness+1);
    }
}
 
module bar(length, width, thickness, hole_diameter){
    plate([[0,0,0], [length,0,0]], width, thickness, hole_diameter);
}

module drillTemplate(points, holeSize, thickness, height) {
    firstBar = [ points[0], points[3]];
    secondBar = [points[2], points[1]];
    middlePoint = IntersectionOfLines(points[0], points[3], points[1], points[2]);
    middlePointHigh = [middlePoint[0], middlePoint[1], height];
    plate(firstBar, holeSize+2, thickness, holeSize);
    plate(secondBar, holeSize+2, thickness, holeSize);
    //cylinders([middlePoint, middlePointHigh], 3, height);
    translate(middlePoint) color("blue") cylinder(d=3, h=height, center=false, $fn=100);
/*
    hull() {
        translate(middlePoint) color("green") cylinder(d=3, h=3, center=false, $fn=100);
        translate(middlePoint) color("red") cylinder(d=5, h=1, center=false, $fn=100);
    }*/
    fillet(r=2, steps=15) {
        translate(middlePoint) color("green") cylinder(d=holeSize, h=thickness+2, center=false, $fn=100);
        translate(middlePoint) color("red") cylinder(d=holeSize+2, h=thickness, center=false, $fn=100);
}
}


