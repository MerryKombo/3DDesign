use <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec nanopi duo2 dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec R5s dimensions.scad>
use <../Server Rack/1U/parts/board.scad>
use <../Server Rack/1U/boards/friendlyelec R5s.scad>
use <legs.scad>
use <openscad-extra/torus.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/nuts.scad>
use <../LEGO.scad/LEGO.scad>

// input : list of points
// output : sorted by x vector of points
function quicksortVectorByX(vec) = !(len(vec) > 0) ? [] : let(
    pivot = vec[floor(len(vec) / 2)],
    lesser = [for (y = vec) if (y[0].x < pivot[0].x) y],
    equal = [for (y = vec) if (y[0].x == pivot[0].x) y],
    greater = [for (y = vec) if (y[0].x > pivot[0].x) y]
) concat(
quicksortVectorByX(lesser), equal, quicksortVectorByX(greater)
);

nanoPiDuo2Feet = [[7.56, 0, 0], [52.5, 0, 0], [7.56, 21.05, 0], [52.5, 21.05, 0]];
nanoPiDuo2Size = [55, 25.4, 2];
nanoPiDuo2HoleSize = 2.2;
mpiMQProFeet = [[0, 0, 0], [58, 0, 0], [0, 23, 0], [58, 23, 0]];
mpiMQProSize = [65, 30, 2];
mpiMQProHoleSize = 2.75;
R5SFeet = [[0, 0, 0], [84, 0, 0], [0, 56, 0], [84, 56, 0]];
R5SSize = [90, 62, 1.6];
R5SHoleSize = 3;
mpiMQQuadFeet = [[0, 0, 0], [57.56, 0, 0], [0, 22.57, 0], [57.56, 22.57, 0]];
mpiMQQuadSize = [65, 30, 2];
mpiMQQuadHoleSize = 2.75;

minDistanceBetweenBoards = [5.8, 5.8];
boards = [[nanoPiDuo2Size, nanoPiDuo2Feet, nanoPiDuo2HoleSize, "nanoPiDuo2"], [mpiMQProSize, mpiMQProFeet,
    mpiMQProHoleSize, "mpiMQPro"], [R5SSize,
    R5SFeet, R5SHoleSize, "R5S"], [mpiMQQuadSize, mpiMQQuadFeet, mpiMQQuadHoleSize, "mpiMQQuad"]];
sortedBoards = quicksortVectorByX(boards);
// From the smallest board in X to the biggest board in X.
echo(sortedBoards);

// The biggest board first, then the smallest, then the     second biggest one, then...
definitivePositionBoards = [sortedBoards[3], sortedBoards[0], sortedBoards[2], sortedBoards[1]];
echo(definitivePositionBoards);


torusRadius = definitivePositionBoards[0].x.y ;
torusInsideRadius = 5;

// Pour simplifier, il faudrait se dire que le diamètre du tore serait celui de la largeur de la plus grande carte
// Ensuite, il faudrait centrer la carte suivante
// The biggest board
// In Z, we have the length of the board, but we want to add some height so that the holes are in the middle of the torus
// Middle of the hole is size minus distance between holes / 2
//  definitivePositionBoards[1] is holes definition
//  definitivePositionBoards[0][1][1] is the second hole
// definitivePositionBoards[0][1][1] is the first hole
firstBoardMiddleOfHole = (definitivePositionBoards[0].x.x - (definitivePositionBoards[0][1][1].x -
    definitivePositionBoards[0][1][0].x)) / 2;
echo("firstBoardMiddleOfHole", firstBoardMiddleOfHole);
firstBoardZTranslation = definitivePositionBoards[0].x.x + (torusInsideRadius - firstBoardMiddleOfHole);
firstBoardTranslation = [((torusRadius + torusInsideRadius) * 2 - definitivePositionBoards[0].x.y) / 2, 0,
    firstBoardZTranslation];
firstBoardRotation = [90, 90, 0];

// The second biggest board, on the left of the biggest board
secondBoardMiddleOfHole = (definitivePositionBoards[1].x.x - (definitivePositionBoards[1][1][1].x -
    definitivePositionBoards[1][1][0].x)) / 2;
echo("secondBoardMiddleOfHole", secondBoardMiddleOfHole);
secondBoardZTranslation = definitivePositionBoards[1].x.x + (torusInsideRadius - secondBoardMiddleOfHole * 2) + (
    definitivePositionBoards[1][1][0].x + definitivePositionBoards[1][2] / 2);
secondBoardTranslation = [0, (torusRadius * 2 - definitivePositionBoards[1].x.y) / 2 + definitivePositionBoards[1].x
.y,
    secondBoardZTranslation];
secondBoardRotation = [90, 90, 270];

// The third biggest board, on the right of the biggest board
thirdBoardMiddleOfHole = (definitivePositionBoards[2].x.x - (definitivePositionBoards[2][1][1].x -
    definitivePositionBoards[2][1][0].x)) / 2;
echo("thirdBoardMiddleOfHole", thirdBoardMiddleOfHole);
thirdBoardZTranslation = definitivePositionBoards[2].x.x + (torusInsideRadius - thirdBoardMiddleOfHole);
thirdBoardTranslation = [torusRadius * 2 + torusInsideRadius * 2 + definitivePositionBoards[2].x.z -
    definitivePositionBoards[
    2].x.z, (torusRadius * 2 -
    definitivePositionBoards[2].x.y) / 2, thirdBoardZTranslation];
thirdBoardRotation = [90, 90, 90];

// The smallest board, which faces the biggest board
fourthBoardMiddleOfHole = (definitivePositionBoards[3].x.x - (definitivePositionBoards[3][1][1].x -
    definitivePositionBoards[3][1][0].x)) / 2;
echo("fourthBoardMiddleOfHole", fourthBoardMiddleOfHole);
fourthBoardZTranslation = definitivePositionBoards[3].x.x + (torusInsideRadius - fourthBoardMiddleOfHole);
fourthBoardTranslation = [(torusRadius * 2 - definitivePositionBoards[3].x.y) / 2 + definitivePositionBoards[3].x.y,
                    torusRadius * 2 + torusInsideRadius * 2 +
            definitivePositionBoards[3].x.z - definitivePositionBoards[3].x.z, fourthBoardZTranslation];
fourthBoardRotation = [180, 90, 270];

buildBoards();

module buildBoards() {
    translate(firstBoardTranslation)
        rotate(firstBoardRotation)
            union() {
                board(definitivePositionBoards[0].x, definitivePositionBoards[0].y, definitivePositionBoards[0].z,
                definitivePositionBoards[0][3]);
                //buildFeet(definitivePositionBoards[0], false, torusInsideRadius);
                buildFeet(definitivePositionBoards[0], true, torusInsideRadius);
            }
    translate(secondBoardTranslation)
        rotate(secondBoardRotation)
            union() {
                echo("Second board is ", definitivePositionBoards[1][3]);
                board(definitivePositionBoards[1].x, definitivePositionBoards[1].y, definitivePositionBoards[1].z,
                definitivePositionBoards[1][3]);
                buildFeet(definitivePositionBoards[1], true, torusInsideRadius);
            }
    translate(thirdBoardTranslation)
        rotate(thirdBoardRotation)
            union() {
                board(definitivePositionBoards[2].x, definitivePositionBoards[2].y, definitivePositionBoards[2].z,
                definitivePositionBoards[2][3]);
                buildFeet(definitivePositionBoards[2], true, torusInsideRadius);
            }
    translate(fourthBoardTranslation)
        //translate([definitivePositionBoards[3].x.y, - definitivePositionBoards[3].x.z, definitivePositionBoards[3].x.x])
        rotate(fourthBoardRotation)
            union() {
                board(definitivePositionBoards[3].x, definitivePositionBoards[3].y, definitivePositionBoards[3].z,
                definitivePositionBoards[3][3]);
                buildFeet(definitivePositionBoards[3], true, torusInsideRadius);
            }

}

boardsTranslations = [firstBoardTranslation, secondBoardTranslation, thirdBoardTranslation, fourthBoardTranslation];
echo("boardsTranslations is ", boardsTranslations);
boardsRotations = [firstBoardRotation, secondBoardRotation, thirdBoardRotation, fourthBoardRotation];
echo("boardsRotations is ", boardsRotations);

buildToruses();
displayBoard();

echo("First circle height is ", firstCircleHeight);
lasttorusInsideRadius = definitivePositionBoards[0][1][3][0];
lastTorus = [torusRadius, torusInsideRadius, lasttorusInsideRadius];
displayBoard = [[44, 36, 1.5], [[6.3, 3, 0], [44 - 7.7, 3, 0], [6.3, 33, 0], [44 - 7.7, 33, 0]], 2,
    "TFT Round Display 1"];

module displayBoard() {
    translate([(torusRadius * 2 + torusInsideRadius * 2 - displayBoard.x.x) / 2, (torusRadius * 2 + torusInsideRadius *
        2 -
        displayBoard
        .x.y) / 2, lasttorusInsideRadius + torusInsideRadius + displayBoard.x.z+startingHeight+torusInsideRadius/1.5])
        board(displayBoard.x, displayBoard.y, displayBoard.z, displayBoard[3]);
    //torusToDisplayBracketAdapter(lastTorus, displayBoard);
}
// buildFeetInTorus(definitivePositionBoards, boardsTranslations, boardsRotations, false, torusInsideRadius);

firstCircleHeight = min([(nanoPiDuo2Size.y - nanoPiDuo2Feet[3].y) / 2, (mpiMQProSize.y - mpiMQProFeet[3].y) / 2, (
    R5SSize.y
    - R5SFeet[0].y) / 2]);
secondCircleHeight = definitivePositionBoards[3][1][3][0];
thirdCircleHeight = definitivePositionBoards[0][1][3][0];
fourthCircleHeight = definitivePositionBoards[1][1][3][0] - definitivePositionBoards[1][1][0][0];

startingHeight = 20;

module buildLegs() {
    unsortedHeights = [thirdCircleHeight, fourthCircleHeight];//[84, 52.5];
    angles = [60, 120, 180, 240];
    heights = quicksort(concat([0], unsortedHeights));

    echo("heights=", heights);
    // First leg
    translate([- torusRadius + torusInsideRadius * 4.4, - torusRadius + torusInsideRadius * 4.4,
        0])
        rotate([0, 0, - 45])
            translate([0, 0, - startingHeight])
                legs(heights, angles, startingHeight, torusRadius = 5, $fn = 180);
    // Second leg
    translate([torusRadius - torusInsideRadius * 4.4, - torusRadius + torusInsideRadius * 4.4, 0])
        rotate([0, 0, 45])
            translate([0, 0, - startingHeight])
                legs(heights, angles, startingHeight, torusRadius = 5, $fn = 180);
    // Third leg
    translate([- torusRadius + torusInsideRadius * 4.4, torusRadius - torusInsideRadius * 4.4,
        0])
        rotate([0, 0, - 135])
            translate([0, 0, - startingHeight])
                legs(heights, angles, startingHeight, torusRadius = 5, $fn = 180);
    // Fourth leg
    translate([torusRadius - torusInsideRadius * 4.4, torusRadius - torusInsideRadius * 4.4, 0])
        rotate([0, 0, 135])
            translate([0, 0, - startingHeight])
                legs(heights, angles, startingHeight, torusRadius = 5, $fn = 180);
}

// The toruses
// We could have a look at https://github.com/UBaer21/UB.scad/blob/main/Images/generator.png to get funnier torus
module buildToruses() {

    echo("First circle height is ", firstCircleHeight);
    union() {
        difference() {
            translate(([torusRadius + torusInsideRadius, torusRadius + torusInsideRadius, torusInsideRadius]))
                difference() {
                    union() {
                        torus(r1 = torusInsideRadius, r2 = torusRadius, angle = 360, endstops = 0, $fn = 100);
                        buildLegs();
                    }
                    color("green")
                        rotate([0, 0, 45])
                            translate([- (torusInsideRadius + torusRadius) * 1.1, 0, 0])
                                rotate([0, 90, 0])
                                    let($show_threads = true)
                                    studding(2 * torusInsideRadius * 3 / 5, (torusInsideRadius + torusRadius) * 2.2,
                                    center = false,
                                    $fn = 100);
                    //leadscrew(2*torusInsideRadius*3/5, (torusInsideRadius+torusRadius)*2,(torusInsideRadius+torusRadius)*.2,4);
                    //cylinder(r = torusInsideRadius * 3 / 5, h = (torusInsideRadius + torusRadius) * 2, $fn = 100);

                    color("blue")
                        rotate([0, 0, - 45])
                            translate([- (torusInsideRadius + torusRadius) * 1.1, 0, 0])
                                rotate([0, 90, 0])
                                    let($show_threads = true)
                                    studding(2 * torusInsideRadius * 3 / 5, (torusInsideRadius + torusRadius) * 2.2,
                                    center = false,
                                    $show_threads = true, $fn =
                                    100);
                }
            color("white")
                translate(firstBoardTranslation)
                    rotate(firstBoardRotation)
                        buildInvertedFeet(definitivePositionBoards[0], true, torusInsideRadius);
            color("white")
                translate(secondBoardTranslation)
                    rotate(secondBoardRotation)
                        buildInvertedFeet(definitivePositionBoards[1], true, torusInsideRadius);
            color("white")
                translate(thirdBoardTranslation)
                    rotate(thirdBoardRotation)
                        buildInvertedFeet(definitivePositionBoards[2], true, torusInsideRadius);
            color("white")
                translate(fourthBoardTranslation)
                    rotate(fourthBoardRotation)
                        buildInvertedFeet(definitivePositionBoards[3], true, torusInsideRadius);
        }
        color("white")
            translate(firstBoardTranslation)
                rotate(firstBoardRotation)
                    buildFeet(definitivePositionBoards[0], true, torusInsideRadius);
        color("white")
            translate(secondBoardTranslation)
                rotate(secondBoardRotation)
                    buildFeet(definitivePositionBoards[1], true, torusInsideRadius);
        color("white")
            translate(thirdBoardTranslation)
                rotate(thirdBoardRotation)
                    buildFeet(definitivePositionBoards[2], true, torusInsideRadius);
        color("white")
            translate(fourthBoardTranslation)
                rotate(fourthBoardRotation)
                    buildFeet(definitivePositionBoards[3], true, torusInsideRadius);
        //buildLegos(torusRadius, torusInsideRadius);
    }
    // Second torus
    // The height must be the one of the smallest board highest hole
    /*
     difference() {
         translate(([torusRadius + torusInsideRadius, torusRadius + torusInsideRadius, firstCircleHeight +
                 torusInsideRadius / 2 +
             secondCircleHeight]))
             torus(r1 = torusInsideRadius, r2 = torusRadius, angle = 360, endstops = 0, $fn = 100);
     }*/
    // Third torus
    // The height must be the one of the other board highest hole
    echo("We'll address the board ", definitivePositionBoards[0][3]);
    echo("Third circle height is ", thirdCircleHeight);
    translate(([torusRadius + torusInsideRadius, torusRadius + torusInsideRadius, firstCircleHeight + torusInsideRadius
        / 2 +
        thirdCircleHeight]))
        torus(r1 = torusInsideRadius, r2 = torusRadius, angle = 360, endstops = 0, $fn = 100);

    // Fourth torus
    // The height must be the one of the other board highest hole

    echo("We'll address the board ", definitivePositionBoards[1][3]);
    echo("Fourth circle height is ", fourthCircleHeight);
    translate(([torusRadius + torusInsideRadius, torusRadius + torusInsideRadius, firstCircleHeight + torusInsideRadius
        / 2 +
        fourthCircleHeight]))
        torus(r1 = torusInsideRadius, r2 = torusRadius, angle = 360, endstops = 0, $fn = 100);
}

module buildLegos(torusRadius, torusInsideRadius) {
    legoBasePlateHeight = 1.3;
    legoBasePlateWidth = 8;
    angleWhereToPlaceLegoBasePlate = [60, 120, 240, 290];
    for (angle = angleWhereToPlaceLegoBasePlate) {
        // Base torus size + movement to place it correclty
        legoBasePlateXCoordinate = torusRadius + cos(angle) * (torusRadius + 2 *
            torusInsideRadius) - legoBasePlateWidth / 4;
        echo("legoBasePlateXCoordinate is ", legoBasePlateXCoordinate);
        legoBasePlateYCoordinate = torusRadius + sin(angle) * (torusRadius + 2 *
            torusInsideRadius) - legoBasePlateWidth / 4;
        echo("legoBasePlateYCoordinate is ", legoBasePlateYCoordinate);
        //translate([(torusInsideRadius + torusRadius)*2, torusInsideRadius, torusInsideRadius*2 - legoBasePlateHeight*2.45])
        translate([legoBasePlateYCoordinate, legoBasePlateYCoordinate, torusInsideRadius * 2 - legoBasePlateHeight *
            2.45])
            rotate([0, 0, 90])
                rotate([0, 0, angle])
                    /*uncenter(0, 0)*/
                    block(width = 2, length = 1, height = 1 / 3, type = "block", block_bottom_type = "closed");
    }
}

module buildFeet(board, lowHoles, torusInsideRadius) {
    union() {
        echo("Board is", board);
        boardSize = board[0];
        echo("Board size is", boardSize);
        holeSize = board[2];
        echo("Hole size is", holeSize);
        feet = board[1];
        echo("Feet are", feet);
        feetHeight = torusInsideRadius * 4;
        // Distance between two feets in X and Y
        feetTranslation = [(boardSize.x - feet[3].x) / 2, (boardSize.y - feet[3].y) / 2];
        translate([0, 0, - feetHeight])
            // The higher holes are the holes #1 and #3
            if (lowHoles) {
                firstFoot = feet[1];
                echo("First high foot", firstFoot);
                translate([firstFoot.x + feetTranslation.x, firstFoot.y + feetTranslation.y, 0])
                    difference() {
                        color("red") cylinder(r = torusInsideRadius, h = feetHeight, $fn = 100);
                        color("blue") translate([0, 0, - feetHeight * .9]) cylinder(r = holeSize / 2, h = feetHeight
                            * 2
                        , $fn = 100);
                        translate([0, 0, - .1])
                            feetNutRecess(holeSize);
                    }
                secondFoot = feet[3];
                echo("Second high foot", secondFoot);
                translate([secondFoot.x + feetTranslation.x, secondFoot.y + feetTranslation.y, 0])
                    difference() {
                        color("red") cylinder(r = torusInsideRadius, h = feetHeight, $fn = 100);
                        color("blue") translate([0, 0, - feetHeight * .9]) cylinder(r = holeSize / 2, h = feetHeight * 2
                        , $fn = 100);
                        translate([0, 0, - .1])
                            feetNutRecess(holeSize);
                    }
            } else {
                firstFoot = feet[0];
                echo("First low foot", firstFoot);
                translate([firstFoot.x + feetTranslation.x, firstFoot.y + feetTranslation.y, 0])
                    cylinder(r = holeSize / 2, h = feetHeight, $fn = 100);
                secondFoot = feet[2];
                echo("Second low foot", secondFoot);
                translate([secondFoot.x + feetTranslation.x, secondFoot.y + feetTranslation.y, 0])
                    cylinder(r = holeSize / 2, h = feetHeight, $fn = 100);
            }
    }
}

module feetNutRecess(realHoleSize) {
    roundedHoleSize = roundToNearestHalf(realHoleSize);
    holeSize = roundedHoleSize < realHoleSize ? roundedHoleSize : roundedHoleSize == realHoleSize? realHoleSize :
                roundedHoleSize - .5 ;
    echo("Real hole size is", realHoleSize);
    echo("Computed hole size is", holeSize);
    union() {
        scale([1.1, 1.1, 1.1])
            feetNut(holeSize);
        feetNut(holeSize);
    }
}

function roundToNearestHalf(number) = round(number * 2) / 2;

module feetNut(holeSize) {

    if (holeSize == 3) {
        nut(M3_nut);
    } else if (holeSize == 2) {
        nut(M2_nut);
    } else if (holeSize == 2.5) {
        nut(M2p5_nut);
    } else if (holeSize == 4) {
        nut(M4_nut);
    } else if (holeSize == 5) {
        nut(M5_nut);
    } else if (holeSize == 6) {
        nut(M6_nut);
    } else if (holeSize == 8) {
        nut(M8_nut);
    }
}

module buildInvertedFeet(board, lowHoles, torusInsideRadius) {
    union() {
        echo("Board is", board);
        boardSize = board[0];
        echo("Board size is", boardSize);
        holeSize = board[2];
        echo("Hole size is", holeSize);
        feet = board[1];
        echo("Feet are", feet);
        feetHeight = torusInsideRadius * 4;
        // Distance between two feets in X and Y
        feetTranslation = [(boardSize.x - feet[3].x) / 2, (boardSize.y - feet[3].y) / 2];
        translate([0, 0, - feetHeight])
            // The higher holes are the holes #1 and #3
            if (lowHoles) {
                firstFoot = feet[1];
                echo("First high foot", firstFoot);
                translate([firstFoot.x + feetTranslation.x, firstFoot.y + feetTranslation.y, 0])
                    union() {
                        color("blue") translate([0, 0, - feetHeight * .9]) cylinder(r = holeSize / 2, h = feetHeight * 2
                        , $fn = 100);
                        color("red") cylinder(r = torusInsideRadius, h = feetHeight, $fn = 100);
                    }
                secondFoot = feet[3];
                echo("Second high foot", secondFoot);
                translate([secondFoot.x + feetTranslation.x, secondFoot.y + feetTranslation.y, 0])
                    union() {
                        color("blue") translate([0, 0, - feetHeight * .9]) cylinder(r = holeSize / 2, h = feetHeight * 2
                        , $fn = 100);
                        color("red") cylinder(r = torusInsideRadius, h = feetHeight, $fn = 100);
                    }
            } else {
                firstFoot = feet[0];
                echo("First low foot", firstFoot);
                translate([firstFoot.x + feetTranslation.x, firstFoot.y + feetTranslation.y, 0])
                    cylinder(r = holeSize / 2, h = feetHeight, $fn = 100);
                secondFoot = feet[2];
                echo("Second low foot", secondFoot);
                translate([secondFoot.x + feetTranslation.x, secondFoot.y + feetTranslation.y, 0])
                    cylinder(r = holeSize / 2, h = feetHeight, $fn = 100);
            }
    }
}

module buildFeetInTorus(boards, boardsTranslations, boardsRotation, highHoles, torusInsideRadius) {
    echo("boards", boards);
    color("blue") rotate([90, 0, 0]) union()
        for (i = [0 : len(boards) - 1]) {
            echo("board", boards[i]);
            feet = boards[i][1];
            // The higher holes are the holes #1 and #3
            translate(boardsTranslations[i])
                if (highHoles) {
                    firstFoot = feet[1];
                    echo("First high foot", firstFoot);
                    translate([firstFoot.x, firstFoot.y, torusInsideRadius + firstFoot.z])
                        rotate([- 90, - 0, 90])
                            rotate(boardsRotation[i])
                                cylinder(r = torusInsideRadius, h = 5, $fn = 100);
                    secondFoot = feet[3];
                    echo("Second high foot", secondFoot);
                    translate([secondFoot.x, secondFoot.y, torusInsideRadius + secondFoot.z])
                        rotate([- 90, - 0, 90])
                            rotate(boardsRotation[i])
                                cylinder(r = torusInsideRadius, h = 5, $fn = 100);
                } else {
                    firstFoot = feet[0];
                    echo("First low foot", firstFoot);
                    translate([firstFoot.x, firstFoot.y, torusInsideRadius + firstFoot.z])
                        //rotate([- 90, - 0, 0])
                        rotate(boardsRotation[i])
                            cylinder(r = torusInsideRadius, h = 5, $fn = 100);
                    secondFoot = feet[2];
                    echo("Second low foot", secondFoot);
                    translate([secondFoot.x, secondFoot.y, torusInsideRadius + secondFoot.z])
                        //rotate([- 90, - 0, 0])
                        rotate(boardsRotation[i])
                            cylinder(r = torusInsideRadius, h = 5, $fn = 100);
                }
        }
}


// We'll need the size of the torus, the size of the board we want to attach
// on top of the torus, then the feet coordinates and we should be good to go
module torusToDisplayBracketAdapter(torus, board) {
    // torus should be [radius, height, thickness]?
    torusRadius = torus.x;
    torusInsideRadius = torus.y;
    lasttorusInsideRadius = torus.z;
    pointsAngle = 45;
    firstPoint = [cos(pointsAngle) * (torusRadius + torusInsideRadius), sin(pointsAngle) * (torusRadius +
        torusInsideRadius)];
    echo("First point is", firstPoint);
    translate([torusRadius, torusRadius, lasttorusInsideRadius])
        translate([firstPoint.x, firstPoint.y, 0])
            color("green") cylinder(r = torusInsideRadius, h = 5 * torusInsideRadius, $fn = 100);
    secondPoint = [firstPoint.x, - firstPoint.y];
    translate([torusRadius, torusRadius, lasttorusInsideRadius])
        translate([secondPoint.x, secondPoint.y, 0])
            color("green") cylinder(r = torusInsideRadius, h = 5 * torusInsideRadius, $fn = 100);
    thirdPoint = [- firstPoint.x, firstPoint.y];
    translate([torusRadius, torusRadius, lasttorusInsideRadius])
        translate([thirdPoint.x, thirdPoint.y, 0])
            color("green") cylinder(r = torusInsideRadius, h = 5 * torusInsideRadius, $fn = 100);
    fourthPoint = [- firstPoint.x, - firstPoint.y];
    translate([torusRadius, torusRadius, lasttorusInsideRadius])
        translate([fourthPoint.x, fourthPoint.y, 0])
            color("green") cylinder(r = torusInsideRadius, h = 5 * torusInsideRadius, $fn = 100);
    //friendlyelec_r5s_bracket();
    // board should be as often  [[sizex, sizey,sizez], [[foot1x, foot1y, foot1z], [84, 0, 0], [0, 56, 0], [84, 56, 0]], holesize, "name"]

    // We already have a utility class the adapts one board to another
    // Should we use it?
    // include <../parts/boards adapter.scad>
}