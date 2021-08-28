include <../module-dimensions.scad>

sliderScaleRatio = 1.0;
sliderThickness = 1.5;
usableSize = [sliderScaleRatio * (moduleWidth - 2 * wallThickness), moduleLength - 2 * (rodSurroundingDiameter +
    surroundingDiameter*2) , sliderThickness];
wireFrameHoleSize = 3;
wireFrameHoleSpace = 71.34;
DIN41612HoleSize = 2;
DIN41612SizeSpace = 58.34;
DIN41612YDistance = 4.15;
sliderSize = [2.5, 2.5];
dovetailHeight = 3;
dovetailAngle = 15;
plateThickness = 1.5;
baseDovetailBottomHeight = tan(dovetailAngle) * dovetailHeight;
baseDovetailTopHeight = dovetailHeight - baseDovetailBottomHeight;
pinSize = [5, 5];
pinDepth = 3;
frontPinsShift = 10;
rearPinsShift = 20;