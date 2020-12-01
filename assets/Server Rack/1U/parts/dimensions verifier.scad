use <../utils/fillet.scad>
use <drilling templates.scad>

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

points = [ [0,0,0], [42.11,0,0], [0,40.11,0], [42.11,40.11,0] ];

verifier_checkDimensions(points, 3, 0.4, 20);

module verifier_checkDimensions(points, holeSize, thickness, height) {
    firstBar = [ points[0], points[3]];
    secondBar = [points[2], points[1]];
    middlePoint = [points[3][0]/2, points[3][1]/2, 0];
    middlePointHigh = [middlePoint[0], middlePoint[1], height];
    plate(firstBar, holeSize+2, thickness, holeSize);
    plate(secondBar, holeSize+2, thickness, holeSize);
}


