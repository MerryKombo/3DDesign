include <../Server Rack/1U/boards/friendlyelec nanopi duo2 dimensions.scad>
//include <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
include <NopSCADlib/vitamins/inserts.scad>
use <legs.scad>
use <../Server Rack/1U/parts/generic bracket.scad>

oledFeet = [[0, 0, 0], [23.77, 0, 0], [0, 24, 0], [23.77, 24, 0]];
screenHoleSize = 2;
insertBlockHeight = 10;

//cylinder(r=1.5, h=1, $fn=100);//

// Distance between the two vertical holes in the SBC
distanceBetweenSBCHoles = feet[3][1] - feet[0][1];

// Distance between the two vertical holes in the screen harness
distanceBetweenScreenHoles = oledFeet[3][0] - oledFeet[0][0];

differenceBetweenHoles = (distanceBetweenScreenHoles - distanceBetweenSBCHoles) / 2;
armLength = 10;

newFeet = [[0, 0, 0], [distanceBetweenScreenHoles, 0, 0], [differenceBetweenHoles, armLength, 0], [
        distanceBetweenScreenHoles - differenceBetweenHoles, armLength, 0]];

echo("New feet are", newFeet);

128x64_bracket();

module 128x64_bracket() {
    union() {
        insertRadius = insertRadius(realHoleSize = screenHoleSize);
        echo("Boss radius is :", insertRadius);
        /*translate([0, 0, insertBlockHeight])/*rotate([0, 180, 0])*/
        /*translate([- insertRadius(realHoleSize = screenHoleSize) / 2, - topHeight / 2, insertBlockHeight])
            assembly();*/
        difference() {
            bracket_bracket(newFeet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
            cylinder(r = insertRadius, h = insertBlockHeight + .1, $fn = 100);
            translate([distanceBetweenScreenHoles, 0, 0])
                cylinder(r = insertRadius, h = insertBlockHeight + .1, $fn = 100);
        }

        insertBlock(realHoleSize = screenHoleSize, height = insertBlockHeight);
        translate([distanceBetweenScreenHoles, 0, 0])
            insertBlock(realHoleSize = screenHoleSize, height = insertBlockHeight);
    }
}

