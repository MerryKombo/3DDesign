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
fanVerticalReinforcementWidth = fanScrewHoleSize * 2 * fanEnclosureRatio;

fanHoles = [[fanScrewHolePad, fanWidth / 2, fanScrewHolePad], [fanWidth - fanScrewHolePad, fanWidth / 2, fanScrewHolePad
    ], [fanScrewHolePad, fanWidth / 2, fanWidth - fanScrewHolePad], [fanWidth - fanScrewHolePad, fanWidth / 2, fanWidth
    - fanScrewHolePad]];

centeredFanTranslation = [(fanEnclosureWidth - fanWidth) / 2, dovetailMaleToFemaleRatio * dovetailHeight, (moduleHeight
    - fanWidth) / 2];
centeredFanTranslationBehindTheEnclosure = [centeredFanTranslation.x, centeredFanTranslation.y +
        dovetailMaleToFemaleRatio * dovetailHeight, centeredFanTranslation.z];