use <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec nanopi duo2 dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec R5s dimensions.scad>
use <../Server Rack/1U/parts/board.scad>
use <../Server Rack/1U/boards/friendlyelec R5s.scad>
use <openscad-extra/torus.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>
include <NopSCADlib/vitamins/rod.scad>

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
torusHeight = 5;

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
firstBoardZTranslation = definitivePositionBoards[0].x.x + (torusHeight - firstBoardMiddleOfHole);
firstBoardTranslation = [((torusRadius + torusHeight) * 2 - definitivePositionBoards[0].x.y) / 2, 0,
    firstBoardZTranslation];
firstBoardRotation = [90, 90, 0];
translate(firstBoardTranslation)
    rotate(firstBoardRotation)
        union() {
            board(definitivePositionBoards[0].x, definitivePositionBoards[0].y, definitivePositionBoards[0].z,
            definitivePositionBoards[0][3]);
            //buildFeet(definitivePositionBoards[0], false, torusHeight);
            buildFeet(definitivePositionBoards[0], true, torusHeight);
        }
// The second biggest board, on the left of the biggest board
secondBoardMiddleOfHole = (definitivePositionBoards[1].x.x - (definitivePositionBoards[1][1][1].x -
    definitivePositionBoards[1][1][0].x)) / 2;
echo("secondBoardMiddleOfHole", secondBoardMiddleOfHole);
secondBoardZTranslation = definitivePositionBoards[1].x.x + (torusHeight - secondBoardMiddleOfHole) + (
    definitivePositionBoards[1][1][0].x - torusHeight);
secondBoardTranslation = [0, (torusRadius * 2 - definitivePositionBoards[1].x.y) / 2 + definitivePositionBoards[1].x.y,
    secondBoardZTranslation];
secondBoardRotation = [90, 90, 270];
translate(secondBoardTranslation)
    rotate(secondBoardRotation)
        union() {
            echo("Second board is ", definitivePositionBoards[1][3]);
            board(definitivePositionBoards[1].x, definitivePositionBoards[1].y, definitivePositionBoards[1].z,
            definitivePositionBoards[1][3]);
            buildFeet(definitivePositionBoards[1], true, torusHeight);
        }
// The third biggest board, on the right of the biggest board
thirdBoardMiddleOfHole = (definitivePositionBoards[2].x.x - (definitivePositionBoards[2][1][1].x -
    definitivePositionBoards[2][1][0].x)) / 2;
echo("thirdBoardMiddleOfHole", thirdBoardMiddleOfHole);
thirdBoardZTranslation = definitivePositionBoards[2].x.x + (torusHeight - thirdBoardMiddleOfHole);
thirdBoardTranslation = [torusRadius * 2 + torusHeight * 2 + definitivePositionBoards[2].x.z - definitivePositionBoards[
2].x.z, (torusRadius * 2 -
    definitivePositionBoards[2].x.y) / 2, thirdBoardZTranslation];
thirdBoardRotation = [90, 90, 90];
translate(thirdBoardTranslation)
    rotate(thirdBoardRotation)
        union() {
            board(definitivePositionBoards[2].x, definitivePositionBoards[2].y, definitivePositionBoards[2].z,
            definitivePositionBoards[2][3]);
            buildFeet(definitivePositionBoards[2], true, torusHeight);
        }
// The smallest board, which faces the biggest board
fourthBoardMiddleOfHole = (definitivePositionBoards[3].x.x - (definitivePositionBoards[3][1][1].x -
    definitivePositionBoards[3][1][0].x)) / 2;
echo("fourthBoardMiddleOfHole", fourthBoardMiddleOfHole);
fourthBoardZTranslation = definitivePositionBoards[3].x.x + (torusHeight - fourthBoardMiddleOfHole);
fourthBoardTranslation = [(torusRadius * 2 - definitivePositionBoards[3].x.y) / 2 + definitivePositionBoards[3].x.y,
                    torusRadius * 2 + torusHeight * 2 +
            definitivePositionBoards[3].x.z - definitivePositionBoards[3].x.z, fourthBoardZTranslation];
fourthBoardRotation = [180, 90, 270];
translate(fourthBoardTranslation)
    //translate([definitivePositionBoards[3].x.y, - definitivePositionBoards[3].x.z, definitivePositionBoards[3].x.x])
    rotate(fourthBoardRotation)
        union() {
            board(definitivePositionBoards[3].x, definitivePositionBoards[3].y, definitivePositionBoards[3].z,
            definitivePositionBoards[3][3]);
            buildFeet(definitivePositionBoards[3], true, torusHeight);
        }
boardsTranslations = [firstBoardTranslation, secondBoardTranslation, thirdBoardTranslation, fourthBoardTranslation];
echo("boardsTranslations is ", boardsTranslations);
boardsRotations = [firstBoardRotation, secondBoardRotation, thirdBoardRotation, fourthBoardRotation];
echo("boardsRotations is ", boardsRotations);

buildToruses();
firstCircleHeight = min([(nanoPiDuo2Size.y - nanoPiDuo2Feet[3].y) / 2, (mpiMQProSize.y - mpiMQProFeet[3].y) / 2, (
    R5SSize.y
    - R5SFeet[0].y) / 2]);
echo("First circle height is ", firstCircleHeight);
lastTorusHeight = definitivePositionBoards[0][1][3][0];
lastTorus = [torusRadius, torusHeight, lastTorusHeight];
displayBoard = [[44, 36, 1.5], [[6.3, 3, 0], [44 - 7.7, 3, 0], [6.3, 33, 0], [44 - 7.7, 33, 0]], 2,
    "TFT Round Display 1"];
translate([(torusRadius * 2 + torusHeight * 2 - displayBoard.x.x) / 2, (torusRadius * 2 + torusHeight * 2 - displayBoard
.x.y) / 2, lastTorusHeight + torusHeight + displayBoard.x.z])
    board(displayBoard.x, displayBoard.y, displayBoard.z, displayBoard[3]);
torusToDisplayBracketAdapter(lastTorus, displayBoard);

// buildFeetInTorus(definitivePositionBoards, boardsTranslations, boardsRotations, false, torusHeight);

// The toruses
module buildToruses() {
    firstCircleHeight = min([(nanoPiDuo2Size.y - nanoPiDuo2Feet[3].y) / 2, (mpiMQProSize.y - mpiMQProFeet[3].y) / 2, (
        R5SSize.y
        - R5SFeet[0].y) / 2]);
    echo("First circle height is ", firstCircleHeight);
    translate(([torusRadius + torusHeight, torusRadius + torusHeight, torusHeight]))
        difference() {
            torus(r1 = torusHeight, r2 = torusRadius, angle = 360, endstops = 0, $fn = 100);
            color("green")
                rotate([0, 0, 45])
                    translate([- (torusHeight+torusRadius)*1.1, 0, 0])
                        rotate([0, 90, 0])
                            studding(2*torusHeight*3/5, (torusHeight+torusRadius)*2.2, center=false, $fn=100);
            //leadscrew(2*torusHeight*3/5, (torusHeight+torusRadius)*2,(torusHeight+torusRadius)*.2,4);
                            //cylinder(r = torusHeight * 3 / 5, h = (torusHeight + torusRadius) * 2, $fn = 100);

            color("blue")
                rotate([0, 0, - 45])
                    translate([- (torusHeight+torusRadius)*1.1, 0, 0])
                        rotate([0, 90, 0])
                            studding(2*torusHeight*3/5, (torusHeight+torusRadius)*2.2, center=false, $fn=100);
                            //cylinder(r = torusHeight * 3 / 5, h = (torusHeight + torusRadius) * 2, $fn = 100);
        }
    // Second torus
    // The height must be the one of the smallest board highest hole
    secondCircleHeight = definitivePositionBoards[3][1][3][0];
    translate(([torusRadius + torusHeight, torusRadius + torusHeight, firstCircleHeight + torusHeight / 2 +
        secondCircleHeight]))
        torus(r1 = torusHeight, r2 = torusRadius, angle = 360, endstops = 0, $fn = 100);

    // Third torus
    // The height must be the one of the other board highest hole
    thirdCircleHeight = definitivePositionBoards[0][1][3][0];
    translate(([torusRadius + torusHeight, torusRadius + torusHeight, firstCircleHeight + torusHeight / 2 +
        thirdCircleHeight]))
        torus(r1 = torusHeight, r2 = torusRadius, angle = 360, endstops = 0, $fn = 100);

    // Fourth torus
    // The height must be the one of the other board highest hole
    fourthCircleHeight = definitivePositionBoards[1][1][3][0];
    translate(([torusRadius + torusHeight, torusRadius + torusHeight, firstCircleHeight + torusHeight / 2 +
        fourthCircleHeight]))
        torus(r1 = torusHeight, r2 = torusRadius, angle = 360, endstops = 0, $fn = 100);
}

module buildFeet(board, lowHoles, torusHeight) {
    union() {
        echo("Board is", board);
        boardSize = board[0];
        echo("Board size is", boardSize);
        holeSize = board[2];
        echo("Hole size is", holeSize);
        feet = board[1];
        echo("Feet are", feet);
        feetHeight = torusHeight * 4;
        // Distance between two feets in X and Y
        feetTranslation = [(boardSize.x - feet[3].x) / 2, (boardSize.y - feet[3].y) / 2];
        translate([0, 0, - feetHeight])
            // The higher holes are the holes #1 and #3
            if (lowHoles) {
                firstFoot = feet[1];
                echo("First high foot", firstFoot);
                translate([firstFoot.x + feetTranslation.x, firstFoot.y + feetTranslation.y, 0])
                    difference() {
                        color("red") cylinder(r = torusHeight, h = feetHeight, $fn = 100);
                        color("blue") translate([0, 0, - feetHeight * .9]) cylinder(r = holeSize / 2, h = feetHeight * 2
                        , $fn = 100);
                    }
                secondFoot = feet[3];
                echo("Second high foot", secondFoot);
                translate([secondFoot.x + feetTranslation.x, secondFoot.y + feetTranslation.y, 0])
                    difference() {
                        color("red") cylinder(r = torusHeight, h = feetHeight, $fn = 100);
                        color("blue") translate([0, 0, - feetHeight * .9]) cylinder(r = holeSize / 2, h = feetHeight * 2
                        , $fn = 100);
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

module buildFeetInTorus(boards, boardsTranslations, boardsRotation, highHoles, torusHeight) {
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
                    translate([firstFoot.x, firstFoot.y, torusHeight + firstFoot.z])
                        rotate([- 90, - 0, 90])
                            rotate(boardsRotation[i])
                                cylinder(r = torusHeight, h = 5, $fn = 100);
                    secondFoot = feet[3];
                    echo("Second high foot", secondFoot);
                    translate([secondFoot.x, secondFoot.y, torusHeight + secondFoot.z])
                        rotate([- 90, - 0, 90])
                            rotate(boardsRotation[i])
                                cylinder(r = torusHeight, h = 5, $fn = 100);
                } else {
                    firstFoot = feet[0];
                    echo("First low foot", firstFoot);
                    translate([firstFoot.x, firstFoot.y, torusHeight + firstFoot.z])
                        //rotate([- 90, - 0, 0])
                        rotate(boardsRotation[i])
                            cylinder(r = torusHeight, h = 5, $fn = 100);
                    secondFoot = feet[2];
                    echo("Second low foot", secondFoot);
                    translate([secondFoot.x, secondFoot.y, torusHeight + secondFoot.z])
                        //rotate([- 90, - 0, 0])
                        rotate(boardsRotation[i])
                            cylinder(r = torusHeight, h = 5, $fn = 100);
                }
        }
}


// We'll need the size of the torus, the size of the board we want to attach
// on top of the torus, then the feet coordinates and we should be good to go
module torusToDisplayBracketAdapter(torus, board) {
    // torus should be [radius, height, thickness]?
    torusRadius = torus.x;
    torusHeight = torus.y;
    lastTorusHeight = torus.z;
    pointsAngle = 45;
    firstPoint = [cos(pointsAngle) * (torusRadius + torusHeight), sin(pointsAngle) * (torusRadius + torusHeight)];
    echo("First point is", firstPoint);
    translate([torusRadius, torusRadius, lastTorusHeight])
        translate([firstPoint.x, firstPoint.y, 0])
            color("green") cylinder(r = torusHeight, h = 5 * torusHeight, $fn = 100);
    secondPoint = [firstPoint.x, - firstPoint.y];
    translate([torusRadius, torusRadius, lastTorusHeight])
        translate([secondPoint.x, secondPoint.y, 0])
            color("green") cylinder(r = torusHeight, h = 5 * torusHeight, $fn = 100);
    thirdPoint = [- firstPoint.x, firstPoint.y];
    translate([torusRadius, torusRadius, lastTorusHeight])
        translate([thirdPoint.x, thirdPoint.y, 0])
            color("green") cylinder(r = torusHeight, h = 5 * torusHeight, $fn = 100);
    fourthPoint = [- firstPoint.x, - firstPoint.y];
    translate([torusRadius, torusRadius, lastTorusHeight])
        translate([fourthPoint.x, fourthPoint.y, 0])
            color("green") cylinder(r = torusHeight, h = 5 * torusHeight, $fn = 100);
    //friendlyelec_r5s_bracket();
    // board should be as often  [[sizex, sizey,sizez], [[foot1x, foot1y, foot1z], [84, 0, 0], [0, 56, 0], [84, 56, 0]], holesize, "name"]

    // We already have a utility class the adapts one board to another
    // Should we use it?
    // include <../parts/boards adapter.scad>
}