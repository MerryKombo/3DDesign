include <BOSL2/std.scad>

powerDistributionWidth = 44.81088;
yDistanceBetweenHoles = 30.06881;
powerDistributionLength = 59.34054;
distanceBetweenSmallHoles = 14.15939;
distanceBetweenSmallHolesAndBigHoles = 12.38066;
powerDistributionBetweenHoles = [distanceBetweenSmallHoles, distanceBetweenSmallHolesAndBigHoles];
distanceBetweenBigHoles = powerDistributionLength - distanceBetweenSmallHoles - 2 *
    distanceBetweenSmallHolesAndBigHoles;
holeSize = 3.56;
topHoleDistanceFromEdgeX = 8.55 + holeSize / 2;
topHoleDistanceFromEdgeX2 = 8.89 + holeSize / 2;
topHoleDistanceFromEdgeY = 3.26 + holeSize / 2;
bottomHoleDistanceFromEdgeX = 19.22 + holeSize / 2;
bottomHoleDistanceFromEdgeX2 = 19.53 + holeSize / 2;
bottomHoleDistanceFromEdgeY = 8.45 + holeSize / 2;
// Let's hope they are centered, we'll see when we get the board if the holes are centered...
powerDistributionDistanceFromEdgeX = topHoleDistanceFromEdgeX;
powerDistributionDistanceFromEdgeX2 = bottomHoleDistanceFromEdgeX2;
//(powerDistributionLength - distanceBetweenSmallHoles) / 2;
powerDistributionDistanceFromEdgeY = topHoleDistanceFromEdgeY;
powerDistributionDistanceFromEdgeY2 = bottomHoleDistanceFromEdgeY;
//(powerDistributionWidth -    powerDistributionBetweenHoles.y) / 2;

/*powerDistributionHoles = [[powerDistributionDistanceFromEdgeX,
    powerDistributionDistanceFromEdgeY], [
        powerDistributionLength - powerDistributionDistanceFromEdgeX2,
    powerDistributionDistanceFromEdgeY2], [powerDistributionLength -
    powerDistributionDistanceFromEdgeX2
    , powerDistributionWidth - powerDistributionDistanceFromEdgeY2],
        [powerDistributionDistanceFromEdgeX, powerDistributionWidth -
        powerDistributionDistanceFromEdgeY]];
*/

powerDistributionHolesDiameter = holeSize;//     3;

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
        [powerDistributionLength - powerDistributionDistanceFromEdgeX * 2,
        0, 0],
        [0, powerDistributionWidth -
            powerDistributionDistanceFromEdgeY * 2, 0],
        [powerDistributionLength - powerDistributionDistanceFromEdgeX * 2
        , powerDistributionWidth - powerDistributionDistanceFromEdgeY * 2, 0]
    ];

//size = [48, 46, 2];
size = [powerDistributionLength, powerDistributionWidth, 11.5];
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
