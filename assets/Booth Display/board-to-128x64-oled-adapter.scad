// include <../Server Rack/1U/boards/friendlyelec nanopi duo2 dimensions.scad>
// include <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
include <../Server Rack/1U/boards/friendlyelec R5s dimensions.scad>

include <NopSCADlib/vitamins/inserts.scad>
use <legs.scad>
use <../Server Rack/1U/parts/generic bracket.scad>

oledFeet = [[0, 0, 0], [23.77, 0, 0], [0, 24, 0], [23.77, 24, 0]];
screenHoleSize = 2;
insertBlockHeight = 10;

//cylinder(r=1.5, h=1, $fn=100);//

// Distance between the two vertical holes in the SBC
distanceBetweenSBCHoles = feet[3][1] - feet[0][1];
echo("[board-to-128x64-oled-adapter] Distance between SBC holes is :", distanceBetweenSBCHoles);

// Distance between the two vertical holes in the screen harness
distanceBetweenScreenHoles = oledFeet[3][0] - oledFeet[0][0];
echo("[board-to-128x64-oled-adapter] Distance between screen holes is :", distanceBetweenScreenHoles);

differenceBetweenScreenHolesAndSBCHoles = (distanceBetweenSBCHoles - distanceBetweenScreenHoles) / 2;
echo("[board-to-128x64-oled-adapter] Difference between screen holes and SBC holes is :",
differenceBetweenScreenHolesAndSBCHoles);

armLength = 10;

newFeet = [[0, 0, 0], [distanceBetweenSBCHoles, 0, 0], [differenceBetweenScreenHolesAndSBCHoles, armLength, 0], [
        distanceBetweenSBCHoles - differenceBetweenScreenHolesAndSBCHoles, armLength, 0]];
echo("[board-to-128x64-oled-adapter] New feet are", newFeet);

128x64_bracket();


// We would need a hexagonal adapter to connect the screen to the SBC
// There is not enough room to lay a "standard" (my standard) foot on the SBC, so we'll have to rely on a nylon or brass
// hexagonal adapter to screw the SBC to the structure, and then screw the screen harness to the female hexagonal adapter.
// But I'm not so sure the screw part of the hexagonal adapter will be long enough to screw the screen harness to the
// SBC.
// We should maybe find a double screw of some sort, or a screw with a long shaft and an inside.
hexagonal head.
module 128x64_bracket() {
    union() {
        insertRadius = insertRadius(realHoleSize = screenHoleSize);
        echo("[board-to-128x64-oled-adapter] Boss radius is :", insertRadius);
        /*translate([0, 0, insertBlockHeight])/*rotate([0, 180, 0])*/
        /*translate([- insertRadius(realHoleSize = screenHoleSize) / 2, - topHeight / 2, insertBlockHeight])
            assembly();*/
        difference() {
            bracket_bracket(newFeet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
            translate([differenceBetweenScreenHolesAndSBCHoles, armLength, 0]) cylinder(r = insertRadius, h =
                insertBlockHeight + .1, $fn = 100);
            translate([differenceBetweenScreenHolesAndSBCHoles + distanceBetweenScreenHoles, armLength, 0])
                cylinder(r = insertRadius, h = insertBlockHeight + .1, $fn = 100);
        }

        translate([differenceBetweenScreenHolesAndSBCHoles, armLength, 0])
            difference() {
                insertBlock(realHoleSize = screenHoleSize, height = insertBlockHeight);
                translate([0, 0, - .1]) cylinder(r = screenHoleSize / 2, h = insertBlockHeight + .1, $fn = 100);
            }
        translate([differenceBetweenScreenHolesAndSBCHoles + distanceBetweenScreenHoles, armLength, 0])
            difference() {
                insertBlock(realHoleSize = screenHoleSize, height = insertBlockHeight);
                translate([0, 0, - .1]) cylinder(r = screenHoleSize / 2, h = insertBlockHeight + .1, $fn = 100);
            }
    }
}

