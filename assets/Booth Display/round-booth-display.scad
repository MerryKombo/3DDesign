use <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
use <../Server Rack/1U/boards/orangepi zero dimensions.scad>
use <../Server Rack/1U/boards/khadas vim3L dimensions.scad>
use <../Server Rack/1U/parts/board.scad>
use <openscad-extra/torus.scad>

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

opiZeroFeet = [[0, 0, 0], [42.11, 0, 0], [0, 40.11, 0], [42.11, 40.11, 0]];
opiZeroSize = [48, 46, 2];
opiZeroHoleSize = 3;
mpiMQProFeet = [[0, 0, 0], [58, 0, 0], [0, 23, 0], [58, 23, 0]];
mpiMQProSize = [65, 30, 2];
mpiMQProHoleSize = 2.75;
kvim3LFeet = [[0, 0, 0], [77, 0, 0], [14, 45.50, 0], [63, 45.5, 0]];
kvim3LSize = [82.0, 58.0, 2];
kvim3LHoleSize = 3;
minDistanceBetweenBoards = [58, 58];
boards = [[opiZeroSize, opiZeroFeet, opiZeroHoleSize], [mpiMQProSize, mpiMQProFeet, mpiMQProHoleSize], [kvim3LSize,
    kvim3LFeet, kvim3LHoleSize], [opiZeroSize, opiZeroFeet, opiZeroHoleSize]];
sortedBoards = quicksortVectorByX(boards);
// From the smallest board in X to the biggest board in X.
echo(sortedBoards);

// The biggest board first, theeeeeeeeeeeeeeeen the smallest, then the     second biggest onnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnne, then...
definitivePositionBoards = [sortedBoards[3], sortedBoards[0], sortedBoards[2], sortedBoards[1]];
echo(definitivePositionBoards);

rotate([90, 0, 0]) board(definitivePositionBoards[0].x, definitivePositionBoards[0].y, definitivePositionBoards[0].z);
translate([0, 0, definitivePositionBoards[1].x.x]) rotate([90, 90, 90]) board(definitivePositionBoards[1].x,
definitivePositionBoards[1].
y, definitivePositionBoards[1].z);
translate([definitivePositionBoards[2].x.x, 0, definitivePositionBoards[2].x.x]) rotate([90, 90, 90]) board(
definitivePositionBoards[2].x, definitivePositionBoards[2].y, definitivePositionBoards[2].z);
translate([definitivePositionBoards[3].x.x, definitivePositionBoards[3].x.x, definitivePositionBoards[3].x.x]) rotate([0, 90,
    90]) board(definitivePositionBoards[3].x, definitivePositionBoards[3].y, definitivePositionBoards[3].z);

firstCircleHeight = min([(opiZeroSize.y - opiZeroFeet[3].y) / 2, (mpiMQProSize.y - mpiMQProFeet[3].y) / 2, (kvim3LSize.y
    - kvim3LFeet[0].y) / 2]);
echo("First circle height is ", firstCircleHeight);
torusHeight = 5;
translate(([0, 0, firstCircleHeight + torusHeight / 2]))
    torus(r1 = torusHeight, r2 = 60, angle = 360, endstops = 0, $fn = 100);
