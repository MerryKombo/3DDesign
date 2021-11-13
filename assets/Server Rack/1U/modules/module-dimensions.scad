include <dovetails/dovetails-dimensions.scad>

oneU = 43.66;
numberOfU = 1;
totalWidth = 450.85;
numberOfUnits = 6;
wallThickness = 5;
thicknessOfEars = wallThickness;
earsBetweenHolesDistance = 15.875;
earsWidth = 15.875;
holesPerU = 3;
earsHoleDiameter = 6;

// For the Sliding Plate
sizeOfEars = 5;

m5NutScalingRatio = 1.05;
m5NutWidthAcrossFlats = 8;
m5NutWidthAcrossSpikes = 9.3;
m5FinishedJamNut = 4;

// Need to leave room for the end nuts and the ear walls
moduleWidth = (totalWidth - (thicknessOfEars * 2 + m5FinishedJamNut * m5NutScalingRatio * 2)) / numberOfUnits;
moduleLength = 150;
moduleHeight = numberOfU * oneU;

threadedRodDiameter = 5;
threadedRodDiameterHole = 5.15;

surroundingDiameter = 2;
rodSurroundingDiameter = threadedRodDiameter + surroundingDiameter;
rodEarHeight = 5;
rodEarDistanceFromSide = rodSurroundingDiameter / 2 + surroundingDiameter;

points = [[0, 0, 0], [10, 0, 0], [0, 10, 0], [10, 10, 0]];

echo("rodSurroundingDiameter is", rodSurroundingDiameter);
