include <BOSL2/std.scad>

eightPortsFastEthernetSwitchWidth = 44.81088;
yDistanceBetweenHoles = 30.06881;
eightPortsFastEthernetSwitchLength = 59.34054;
distanceBetweenSmallHoles = 14.15939;
distanceBetweenSmallHolesAndBigHoles = 12.38066;
eightPortsFastEthernetSwitchBetweenHoles = [distanceBetweenSmallHoles, distanceBetweenSmallHolesAndBigHoles];
distanceBetweenBigHoles = eightPortsFastEthernetSwitchLength - distanceBetweenSmallHoles - 2 *
    distanceBetweenSmallHolesAndBigHoles;
holeSize = 3.56;
topHoleDistanceFromEdgeX = 8.55 + holeSize / 2;
topHoleDistanceFromEdgeX2 = 8.89 + holeSize / 2;
topHoleDistanceFromEdgeY = 3.26 + holeSize / 2;
bottomHoleDistanceFromEdgeX = 19.22 + holeSize / 2;
bottomHoleDistanceFromEdgeX2 = 19.53 + holeSize / 2;
bottomHoleDistanceFromEdgeY = 8.45 + holeSize / 2;
// Let's hope they are centered, we'll see when we get the board if the holes are centered...
eightPortsFastEthernetSwitchDistanceFromEdgeX = topHoleDistanceFromEdgeX;
eightPortsFastEthernetSwitchDistanceFromEdgeX2 = bottomHoleDistanceFromEdgeX2;
//(eightPortsFastEthernetSwitchLength - distanceBetweenSmallHoles) / 2;
eightPortsFastEthernetSwitchDistanceFromEdgeY = topHoleDistanceFromEdgeY;
eightPortsFastEthernetSwitchDistanceFromEdgeY2 = bottomHoleDistanceFromEdgeY;
//(eightPortsFastEthernetSwitchWidth -    eightPortsFastEthernetSwitchBetweenHoles.y) / 2;

/*eightPortsFastEthernetSwitchHoles = [[eightPortsFastEthernetSwitchDistanceFromEdgeX,
    eightPortsFastEthernetSwitchDistanceFromEdgeY], [
        eightPortsFastEthernetSwitchLength - eightPortsFastEthernetSwitchDistanceFromEdgeX2,
    eightPortsFastEthernetSwitchDistanceFromEdgeY2], [eightPortsFastEthernetSwitchLength -
    eightPortsFastEthernetSwitchDistanceFromEdgeX2
    , eightPortsFastEthernetSwitchWidth - eightPortsFastEthernetSwitchDistanceFromEdgeY2],
        [eightPortsFastEthernetSwitchDistanceFromEdgeX, eightPortsFastEthernetSwitchWidth -
        eightPortsFastEthernetSwitchDistanceFromEdgeY]];
*/

eightPortsFastEthernetSwitchHolesDiameter = holeSize;//     3;

// Feet must be
// 2-       4
// ^\       ^
// | \      |
// 1  \____>3
translationVector = [distanceBetweenSmallHolesAndBigHoles + distanceBetweenSmallHoles, yDistanceBetweenHoles, 0];
echo("Translation vector is ", translationVector);
feetBeforeRotation = [[0, 0, 0],
        [- distanceBetweenSmallHolesAndBigHoles, yDistanceBetweenHoles, 0],
        [distanceBetweenSmallHoles, 0, 0],
        [distanceBetweenSmallHoles + distanceBetweenSmallHolesAndBigHoles, yDistanceBetweenHoles, 0]
    ];

rotatedPoints = rot(a = [0, 0, 180], p = feetBeforeRotation, reverse = true);

feet = move(v = translationVector, p = rotatedPoints);

oldfeet = [/*[-10,0],*/[0, 0, 0],
        [eightPortsFastEthernetSwitchLength - eightPortsFastEthernetSwitchDistanceFromEdgeX * 2,
        0, 0],
        [0, eightPortsFastEthernetSwitchWidth -
            eightPortsFastEthernetSwitchDistanceFromEdgeY * 2, 0],
        [eightPortsFastEthernetSwitchLength - eightPortsFastEthernetSwitchDistanceFromEdgeX * 2
        , eightPortsFastEthernetSwitchWidth - eightPortsFastEthernetSwitchDistanceFromEdgeY * 2, 0]
    ];

//size = [48, 46, 2];
size = [eightPortsFastEthernetSwitchLength, eightPortsFastEthernetSwitchWidth, 11.5];
//holeSize = 3;
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
