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
verifierPlateThickness = 0.4;

wallThickness = 5;
threadedRodDiameter = 3;
surroundingDiameter = 2;
rodSurroundingDiameter = threadedRodDiameter + surroundingDiameter;
rodEarHeight = 5;
rodEarDistanceFromSide = rodSurroundingDiameter + surroundingDiameter;

points = [ [0,0,0], [42.11,0,0], [0,40.11,0], [42.11,40.11,0] ];

verifier_checkDimensions(points, 3, verifierPlateThickness);

module verifier_checkDimensions(points, holeSize, thickness) {
    firstBar = [ points[0], points[3]];
    secondBar = [points[2], points[1]];
    plate(firstBar, holeSize+2, thickness, holeSize);
    plate(secondBar, holeSize+2, thickness, holeSize);
}


