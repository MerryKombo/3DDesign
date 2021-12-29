include <../module-dimensions.scad>

fanWidth = 40;
fanDepth = 28;
fanHeight = fanWidth;
fanScrewHoleSize = 3;
fanScrewHoleMeasuredSize = 3.45;
fanScrewHolePad = 2.44;
fanBladesDiameter = 38.03;

// Enclosure
enclosureToFanRatio = 1.5;

// The fan should fit the enclosure without too much struggling
fanEnclosureRatio = 0.95;
fanEnclosureWidth = fanWidth * enclosureToFanRatio;
fanVerticalReinforcementWidth = fanScrewHoleSize * 1.5 * fanEnclosureRatio;
//fanVerticalReinforcementDepth = fanScrewHoleSize;
fanEnclosureLength = fanDepth + 2 * (rodSurroundingDiameter + surroundingDiameter) + wallThickness;
fanCradleSize = [fanWidth / fanEnclosureRatio + wallThickness, fanDepth / fanEnclosureRatio + wallThickness, fanWidth /
    fanEnclosureRatio];
firstFanScrewHole = [fanScrewHolePad, 0, fanHeight - fanScrewHolePad - fanScrewHoleSize];
secondFanScrewHole = [fanScrewHolePad, 0, fanScrewHolePad];
thirdFanScrewHole = [fanWidth - fanScrewHolePad - fanScrewHoleSize, 0, fanScrewHolePad];
fourthFanScrewHole = [fanWidth - fanScrewHolePad - fanScrewHoleSize, 0, fanHeight - fanScrewHolePad - fanScrewHoleSize];
fanScrewHoles = [firstFanScrewHole, secondFanScrewHole, thirdFanScrewHole, fourthFanScrewHole];
fanTranslationVector = [((fanWidth / fanEnclosureRatio + wallThickness) - fanWidth) / 2, ((fanDepth / fanEnclosureRatio
    + wallThickness) - fanDepth) / 2, wallThickness / 2 - fanScrewHolePad];