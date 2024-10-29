// include <../Server Rack/1U/boards/friendlyelec nanopi duo2 dimensions.scad>
//include <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
include <../Server Rack/1U/boards/friendlyelec R5s dimensions.scad>
include <128x32-oled-screen-harness.scad>
include <NopSCADlib/vitamins/inserts.scad>
use <legs.scad>
use <../Server Rack/1U/parts/generic bracket.scad>


insertBlockHeight = 10;
//cylinder(r=1.5, h=1, $fn=100);//

// Distance between the two vertical holes in the SBC
distanceBetweenSBCHoles = feet[3][1] - feet[0][1];
echo("Distance between SBC holes is", distanceBetweenSBCHoles);

// Distance between the two vertical holes in the screen harness
distanceBetweenScreenHoles = distanceBetweenScrewHoles;//screwDistance;
echo("Distance between screen holes is", distanceBetweenScreenHoles);

differenceBetweenHoles = (distanceBetweenSBCHoles - screwDistance) / 2;
armLength = 04.2;

newFeet = [[0, 0, 0], [distanceBetweenScreenHoles, 0, 0], [differenceBetweenHoles, armLength, 0], [
        distanceBetweenScreenHoles - differenceBetweenHoles, armLength, 0]];

echo("New feet are", newFeet);

adapter();

module adapter() {
    union() {
        insertRadius = insertRadius(realHoleSize = 3);
        echo("Boss radius is :", insertRadius);
        /*translate([0, 0, insertBlockHeight])/*rotate([0, 180, 0])*/
        /*translate([- insertRadius(realHoleSize = 3) / 2, - topHeight / 2, insertBlockHeight])
        assembly();*/
        difference() {
            // The main bracket
            bracket_bracket(newFeet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
            // from which we subtract the insert block equivalent as a cylinder
            cylinder(r = insertRadius, h = insertBlockHeight + .1, $fn = 100);
            translate([distanceBetweenScreenHoles, 0, 0])
                cylinder(r = insertRadius, h = insertBlockHeight + .1, $fn = 100);
        }

        insertBlock(realHoleSize = 3, height = insertBlockHeight);
        translate([distanceBetweenScreenHoles, 0, 0])
            insertBlock(realHoleSize = 3, height = insertBlockHeight);
    }

}