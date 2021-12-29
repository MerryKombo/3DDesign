include <../module-dimensions.scad>

fanWidth = 40;
fanDepth = 10;
fanScrewHoleSize = 5;
fanScrewHolePad = 4;
fanBladesDiameter = 39;

// Enclosure
enclosureToFanRatio = 1.5;

// The fan should fit the enclosure without too much struggling
fanEnclosureRatio = 0.95;
fanEnclosureWidth = fanWidth * enclosureToFanRatio;
fanVerticalReinforcementWidth = fanScrewHoleSize * 1.5 * fanEnclosureRatio;
fanVerticalReinforcementDepth = fanScrewHoleSize;
fanEnclosureLength = fanDepth + 2 * (rodSurroundingDiameter + surroundingDiameter) + fanVerticalReinforcementDepth * 2;
fanAndHarnessWidth = fanWidth + fanVerticalReinforcementWidth;
fanAndHarnessDepth = fanVerticalReinforcementDepth * 1.5;

fanHoles = [[fanScrewHolePad, fanVerticalReinforcementDepth, fanScrewHolePad], [fanWidth - fanScrewHolePad,
    fanVerticalReinforcementDepth, fanScrewHolePad
    ], [fanScrewHolePad, fanVerticalReinforcementDepth, fanWidth - fanScrewHolePad], [fanWidth - fanScrewHolePad,
    fanVerticalReinforcementDepth, fanWidth
        - fanScrewHolePad]];

centeredFanTranslation = [(moduleWidth - fanWidth) / 2, dovetailHeight + fanVerticalReinforcementDepth +
    fanVerticalReinforcementWidth, (moduleHeight
    - fanWidth) / 2];
centeredFanTranslationBehindTheEnclosure = [centeredFanTranslation.x, centeredFanTranslation.y +
    fanVerticalReinforcementDepth, centeredFanTranslation.z];