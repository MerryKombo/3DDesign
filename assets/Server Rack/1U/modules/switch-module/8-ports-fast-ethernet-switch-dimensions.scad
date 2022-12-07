include <../module-dimensions.scad>
include <../../boards/8-ports-fast-ethernet-switch-dimensions.scad>
include <BOSL2/std.scad>

eightPortsFastEthernetSwitchModuleWidth = eightPortsFastEthernetSwitchWidth * 1.2 > moduleWidth?ceil(
        eightPortsFastEthernetSwitchWidth
        * 1.2 /
    moduleWidth):moduleWidth;
eightPortsFastEthernetSwitchLengthCeil = ceil(eightPortsFastEthernetSwitchLength * 1.2 / moduleLength);
eightPortsFastEthernetSwitchLengthFloorTemp = floor(eightPortsFastEthernetSwitchLength * 1.2 / moduleLength);
eightPortsFastEthernetSwitchLengthFloor = eightPortsFastEthernetSwitchLengthFloorTemp == 0? 1:
        eightPortsFastEthernetSwitchLengthFloorTemp;
eightPortsFastEthernetSwitchModuleLengthRatio = (eightPortsFastEthernetSwitchLengthCeil +
    eightPortsFastEthernetSwitchLengthFloor) / 2;
echo("8PortsFastEthernetSwitchModuleLengthCeil is ", eightPortsFastEthernetSwitchLengthCeil);
echo("8PortsFastEthernetSwitchModuleLengthFloor is ", eightPortsFastEthernetSwitchLengthFloor);
echo("8PortsFastEthernetSwitchModuleLengthRatio is ", eightPortsFastEthernetSwitchModuleLengthRatio);
eightPortsFastEthernetSwitchModuleLength = eightPortsFastEthernetSwitchModuleLengthRatio * moduleLength;
echo("Module length is then ", eightPortsFastEthernetSwitchModuleLength);
eightPortsFastEthernetSwitchInvisibleFootX = - eightPortsFastEthernetSwitchDistanceFromEdgeY - (
    eightPortsFastEthernetSwitchModuleWidth
    - (eightPortsFastEthernetSwitchWidth - wallThickness * 2)) / 2;

firstInsidePoint = [wallThickness / 2, rodSurroundingDiameter + surroundingDiameter + holeSize, 0];
secondInsidePoint = [eightPortsFastEthernetSwitchModuleWidth - wallThickness / 2, rodSurroundingDiameter +
    surroundingDiameter + holeSize, 0];
thirdInsidePoint = [wallThickness / 2, eightPortsFastEthernetSwitchModuleLength - (rodSurroundingDiameter +
    surroundingDiameter + holeSize), 0];
fourthInsidePoint = [eightPortsFastEthernetSwitchModuleWidth - wallThickness / 2,
        eightPortsFastEthernetSwitchModuleLength - (
            rodSurroundingDiameter + surroundingDiameter + holeSize), 0];
fifthInsidePoint = [firstInsidePoint.x, (thirdInsidePoint.y + firstInsidePoint.y) / 3, firstInsidePoint.z];
sixthInsidePoint = [fourthInsidePoint.x, (thirdInsidePoint.y + firstInsidePoint.y) / 3, thirdInsidePoint.z];
seventhInsidePoint = [firstInsidePoint.x, eightPortsFastEthernetSwitchModuleLength - (thirdInsidePoint.y +
    firstInsidePoint.y) / 3, firstInsidePoint.z];
eighthInsidePoint = [fourthInsidePoint.x, eightPortsFastEthernetSwitchModuleLength - (thirdInsidePoint.y +
    firstInsidePoint.y) / 3, thirdInsidePoint.z];
allInsidePoints = [firstInsidePoint, secondInsidePoint, thirdInsidePoint, fourthInsidePoint, fifthInsidePoint,
    sixthInsidePoint, seventhInsidePoint, eighthInsidePoint];
echo("Inside points are ", allInsidePoints);

insideRotatedPoints = rot(a = [0, 0, 90], p = allInsidePoints, reverse = false);
echo("Rotated points are ", insideRotatedPoints);

widthDifferenceBetweenSwitchAndModule = ((eightPortsFastEthernetSwitchModuleWidth - wallThickness) -
    eightPortsFastEthernetSwitchBetweenHoles.y) / 2;
lengthDifferenceBetweenSwitchAndModule = ((eightPortsFastEthernetSwitchModuleLength - (rodSurroundingDiameter +
    surroundingDiameter + holeSize) * 2) - eightPortsFastEthernetSwitchBetweenHoles.x) / 2;

echo("eightPortsFastEthernetSwitchModuleLength is ", eightPortsFastEthernetSwitchModuleLength);
echo("widthDifferenceBetweenSwitchAndModule is ", widthDifferenceBetweenSwitchAndModule);

harnessTranslationVector = [(eightPortsFastEthernetSwitchModuleLength)
    - lengthDifferenceBetweenSwitchAndModule, - eightPortsFastEthernetSwitchWidth / 2 + wallThickness / 2 + 0.5
    /*- wallThickness / 2 /*- eightPortsFastEthernetSwitchWidth*/, 0];
echo("Translation vector is ", harnessTranslationVector);

translatedInsideRotatedPoints = move(v = harnessTranslationVector, p = insideRotatedPoints);

echo("Translated points are ", translatedInsideRotatedPoints);

eightPortsFastEthernetSwitchHoles = translatedInsideRotatedPoints;

echo("eightPortsFastEthernetSwitchHoles is ", eightPortsFastEthernetSwitchHoles);

//(eightPortsFastEthernetSwitchModuleWidth, eightPortsFastEthernetSwitchModuleLength, moduleHeight, pinsPath =


// Description: Search target for the k points closest to point query. The input target is either a list of points to
// search or a search tree pre-computed by `vector_search_tree(). A list is returned containing the indices of the
// points found in sorted order, closest point first.

invisibleFeet = translatedInsideRotatedPoints;
/*[insideWallSmallX, insideWallY, 0]*/
negativeInvisibleFeet = [/*
        [insideWallSmallX, insideWallSmallY, 0],
        [insideWallX, insideWallSmallY, 0]*/];
new_feet = /*removeDuplicates(*/concat(/*negativeInvisibleFeet,*/ invisibleFeet, feet)/*)*/; // [1,2,3,4,5,6]
echo("invisible feet are ", invisibleFeet);
echo("feet are ", feet);
echo("new feet are ", new_feet);

//echo("De-duplicated points are ", removeDuplicates(new_feet));