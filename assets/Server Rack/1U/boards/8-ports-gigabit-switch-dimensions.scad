eightPortsGigabitSwitchWidth = 58.1966;
eightPortsGigabitSwitchLength = 111.83627;
eightPortsGigabitSwitchBetweenHoles = [100.19338, 45.32884];
// Let's hope they are centered, we'll see when we get the board if the holes are centered...
eightPortsGigabitSwitchDistanceFromEdgeX = (eightPortsGigabitSwitchLength - eightPortsGigabitSwitchBetweenHoles.x) / 2;
eightPortsGigabitSwitchDistanceFromEdgeY = (eightPortsGigabitSwitchWidth - eightPortsGigabitSwitchBetweenHoles.y) / 2;

eightPortsGigabitSwitchHoles = [[eightPortsGigabitSwitchDistanceFromEdgeX, eightPortsGigabitSwitchDistanceFromEdgeY], [
        eightPortsGigabitSwitchLength - eightPortsGigabitSwitchDistanceFromEdgeX,
    eightPortsGigabitSwitchDistanceFromEdgeY], [eightPortsGigabitSwitchLength - eightPortsGigabitSwitchDistanceFromEdgeX
    , eightPortsGigabitSwitchWidth - eightPortsGigabitSwitchDistanceFromEdgeY],
        [eightPortsGigabitSwitchDistanceFromEdgeX, eightPortsGigabitSwitchWidth -
        eightPortsGigabitSwitchDistanceFromEdgeY]];

eightPortsGigabitSwitchHolesDiameter = 3;

// Feet must be
// 2-       4
// ^\       ^
// | \      |
// 1  \____>3
feet = [[0, 0, 0],
        [eightPortsGigabitSwitchLength - eightPortsGigabitSwitchDistanceFromEdgeX * 2,
        0, 0],
        [0, eightPortsGigabitSwitchWidth -
            eightPortsGigabitSwitchDistanceFromEdgeY * 2, 0],
        [eightPortsGigabitSwitchLength - eightPortsGigabitSwitchDistanceFromEdgeX * 2
        , eightPortsGigabitSwitchWidth - eightPortsGigabitSwitchDistanceFromEdgeY * 2, 0]
    ];

//size = [48, 46, 2];
size = [eightPortsGigabitSwitchLength, eightPortsGigabitSwitchWidth, 11.5];
holeSize = 3;
baseSize = 9;
footSize = 5;
baseHeight = 3;
totalHeight = 7;
linkThickness = 3;
linkHeight = 2;
verifierPlateThickness = 0.4;
drillTemplateThickness = 1;
drillTemplateGuideHeight = 20;
hotShoeHeightClearance = 5;