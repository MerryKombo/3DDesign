use <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
use <../Server Rack/1U/boards/orangepi zero dimensions.scad>
use <../Server Rack/1U/boards/khadas vim3L dimensions.scad>
use <../Server Rack/1U/parts/board.scad>

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

rotate([90, 0, 0]) board(opiZeroSize, opiZeroFeet, opiZeroHoleSize);
translate([0, 0, mpiMQProSize.x]) rotate([90, 90, 90]) board(mpiMQProSize, mpiMQProFeet, mpiMQProHoleSize);
translate([kvim3LSize.x, 0, kvim3LSize.x]) rotate([90, 90, 90]) board(kvim3LSize, kvim3LFeet, kvim3LHoleSize);
translate([kvim3LSize.x, kvim3LSize.x, mpiMQProSize.x]) rotate([0, 90, 90]) board(mpiMQProSize, mpiMQProFeet,
mpiMQProHoleSize);