include <../module-dimensions.scad>
include <../../boards/8-ports-gigabit-switch-dimensions.scad>
include <BOSL2/std.scad>

eightPortsGigabitSwitchModuleWidth = eightPortsGigabitSwitchWidth * 1.2 > moduleWidth?ceil(eightPortsGigabitSwitchWidth
    * 1.2 /
    moduleWidth):moduleWidth;
eightPortsGigabitSwitchLengthCeil = ceil(eightPortsGigabitSwitchLength * 1.2 / moduleLength);
eightPortsGigabitSwitchLengthFloorTemp = floor(eightPortsGigabitSwitchLength * 1.2 / moduleLength);
eightPortsGigabitSwitchLengthFloor = eightPortsGigabitSwitchLengthFloorTemp == 0? 1:
        eightPortsGigabitSwitchLengthFloorTemp;
eightPortsGigabitSwitchModuleLengthRatio = (eightPortsGigabitSwitchLengthCeil + eightPortsGigabitSwitchLengthFloor) / 2;
echo("8PortsGigabitSwitchModuleLengthCeil is ", eightPortsGigabitSwitchLengthCeil);
echo("8PortsGigabitSwitchModuleLengthFloor is ", eightPortsGigabitSwitchLengthFloor);
echo("8PortsGigabitSwitchModuleLengthRatio is ", eightPortsGigabitSwitchModuleLengthRatio);
eightPortsGigabitSwitchModuleLength = eightPortsGigabitSwitchModuleLengthRatio * moduleLength;
echo("Module length is then ", eightPortsGigabitSwitchModuleLength);
eightPortsGigabitSwitchInvisibleFootX = - eightPortsGigabitSwitchDistanceFromEdgeY - (eightPortsGigabitSwitchModuleWidth
    - (eightPortsGigabitSwitchWidth - wallThickness * 2)) / 2;

firstInsidePoint = [wallThickness / 2, rodSurroundingDiameter + surroundingDiameter + holeSize, 0];
secondInsidePoint = [eightPortsGigabitSwitchModuleWidth - wallThickness / 2, rodSurroundingDiameter +
    surroundingDiameter + holeSize, 0];
thirdInsidePoint = [wallThickness / 2, eightPortsGigabitSwitchModuleLength - (rodSurroundingDiameter +
    surroundingDiameter + holeSize), 0];
fourthInsidePoint = [eightPortsGigabitSwitchModuleWidth - wallThickness / 2, eightPortsGigabitSwitchModuleLength - (
        rodSurroundingDiameter + surroundingDiameter + holeSize), 0];
fifthInsidePoint = [firstInsidePoint.x, (thirdInsidePoint.y + firstInsidePoint.y) / 2, firstInsidePoint.z];
sixthInsidePoint = [fourthInsidePoint.x, (thirdInsidePoint.y + firstInsidePoint.y) / 2, thirdInsidePoint.z];
rotatedPoints = rot(a = [0, 0, 90], p = [firstInsidePoint, secondInsidePoint, thirdInsidePoint, fourthInsidePoint,
    fifthInsidePoint, sixthInsidePoint],
reverse = false);

widthDifferenceBetweenSwitchAndModule = ((eightPortsGigabitSwitchModuleWidth - wallThickness) -
    eightPortsGigabitSwitchBetweenHoles.y) / 2;
lengthDifferenceBetweenSwitchAndModule = ((eightPortsGigabitSwitchModuleLength - (rodSurroundingDiameter +
    surroundingDiameter + holeSize) * 2) - eightPortsGigabitSwitchBetweenHoles.x) / 2;

translationVector = [(eightPortsGigabitSwitchModuleLength - (rodSurroundingDiameter + surroundingDiameter + holeSize)) -
    lengthDifferenceBetweenSwitchAndModule, - wallThickness / 2 - widthDifferenceBetweenSwitchAndModule, 0];
echo("Translation vector is ", translationVector);

translatedRotatedPoints = move(v = translationVector, p = rotatedPoints);
//(eightPortsGigabitSwitchModuleWidth, eightPortsGigabitSwitchModuleLength, moduleHeight, pinsPath =


// Description: Search target for the k points closest to point query. The input target is either a list of points to
// search or a search tree pre-computed by `vector_search_tree(). A list is returned containing the indices of the
// points found in sorted order, closest point first.

invisibleFeet = translatedRotatedPoints;
/*[insideWallSmallX, insideWallY, 0]*/
negativeInvisibleFeet = [/*
        [insideWallSmallX, insideWallSmallY, 0],
        [insideWallX, insideWallSmallY, 0]*/];
new_feet = concat(negativeInvisibleFeet, invisibleFeet, feet); // [1,2,3,4,5,6]
