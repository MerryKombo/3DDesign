include <dovetails/dovetails-dimensions.scad>

oneU = 43.66;
numberOfU = 1;
totalWidth = 450;
numberOfUnits = 5;
sizeOfEars = 5;
moduleWidth = (totalWidth - (sizeOfEars * 2)) / numberOfUnits;
moduleLength = 150;
moduleHeight = numberOfU * oneU;

wallThickness = 5;
threadedRodDiameter = 5;
threadedRodDiameterHole = 5.15;
surroundingDiameter = 2;
rodSurroundingDiameter = threadedRodDiameter + surroundingDiameter;
rodEarHeight = 5;
rodEarDistanceFromSide = rodSurroundingDiameter / 2 + surroundingDiameter;

m5NutScalingRatio = 1.05;

points = [[0, 0, 0], [10, 0, 0], [0, 10, 0], [10, 10, 0]];

echo("rodSurroundingDiameter is", rodSurroundingDiameter);