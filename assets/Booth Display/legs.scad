use <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec nanopi duo2 dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec R5s dimensions.scad>
use <../Server Rack/1U/parts/board.scad>
use <../Server Rack/1U/boards/friendlyelec R5s.scad>
use <openscad-extra/src/torus.scad>
use <inserts.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screw.scad>
include <NopSCADlib/vitamins/screws.scad>
use <../LEGO.scad/LEGO.scad>
//include <BOSL2/std.scad>
include <../Round-Anything/polyround.scad>

/*radiiPoints = [
        [- 4, 0, 1],
        [5, 3, 1.5],
        [0, 7, 0.1],
        [8, 7, 10],
        [20, 20, 0.8],
        [10, 0, 10]
    ];
linear_extrude(3)polygon(polyRound(radiiPoints, 30));
*/
/*
length = 78; r1 = 25; R = 65;
r2 = floor(lookup($t, [[0, 5], [0.5, 30], [1, 5]]));
egg(length, r1, r2, R, $fn = 180);
color("black") text(str("r2=", r2), size = 8, halign = "center", valign = "center");
*/

startingHeight = 20;
endingHeight = 20;
// We're supposed to have the four heights, but the torus will collide, so we'll have to use less torus and make
// some adapter brackets of some sort
// unsortedHeights = [21.05, 23, 56, 22.57];
unsortedHeights = [84, 57.56];
angles = [60, 120, 180, 240];
heights = quicksort(concat([0], unsortedHeights));

function quicksort(list) = !(len(list) > 0) ? [] : let(
    pivot = list[floor(len(list) / 2)],
    lesser = [for (i = list) if (i < pivot) i],
    equal = [for (i = list) if (i == pivot) i],
    greater = [for (i = list) if (i > pivot) i]
) concat(
quicksort(lesser), equal, quicksort(greater)
);

echo("heights=", heights);
legs(heights, angles, startingHeight, torusRadius = 5, $fn = 180);

// heights is a list of heights of the boards' holes
module legs(heights, angles, startingHeight = 0, startingAngle = 0, torusRadius = 5, torusDiameter = 50, nutRatio = 1.05
, topHoleSize = 3) {
    leg(heights, startingHeight, torusRadius, torusDiameter, nutRatio = 1.05, topHoleSize = 3);
}

module leg(heights, startingHeight = 0, torusRadius = 5, torusDiameter = 50, nutRatio = 1.05, topHoleSize = 3) {
    feetHoleSize = (torusRadius * 3 / 5);
    torusSize = torusRadius;
    echo("feetHoleSize=", feetHoleSize);
    color("DarkKhaki")
        union() {
            difference() {
                union() {
                    // The base is a dummy cylinder
                    translate([0, 0, startingHeight + torusRadius])
                        cylinder(r = torusRadius, h = heights[len(heights) - 1] - torusRadius, $fn = 100)
                            ;
                    // With half a sphere on the top
                    //translate([0, 0, heights[len(heights) - 1] + startingHeight + endingHeight])
                    //    sphere(r = torusRadius, $fn = 100);
                    // With a torus on the bottom
                    elbow(startingHeight, torusRadius);
                    // Would be nice to add a second torus on the top, aiming the center of the torus, with holes to host the display board
                    topElbow(startingHeight, torusRadius, torusDiameter, topHoleSize);
                }
                // We remove from the cylinder holes to attach to the torus
                for (currentHeight = heights) {
                    // The main hole
                    translate([0, heights[len(heights) - 1] / 2, currentHeight + startingHeight])
                        rotate([90, 0, 0])
                            union() {
                                cylinder(r = feetHoleSize, h = heights[len(heights) - 1], $fn = 100);
                                // We should also add a nut recess behind
                                translate([0, 0, heights[len(heights) - 1] / 2 - torusRadius - nutHeight(feetHoleSize)])
                                    feetNutRecess(2 *
                                        torusRadius * 3 / 5, nutRatio = nutRatio);
                            }
                    // We also have to remove the torus footprint
                    yTranslation = torusRadius;
                    translate([- heights[len(heights) - 1] / 2, - yTranslation, currentHeight + startingHeight])
                        rotate([90, 0, 90])
                            cylinder(r = torusSize, h = heights[len(heights) - 1], $fn = 100);
                }
            }
        }
    // boltHelper(torusRadius, feetHoleSize);
}

module topElbow(startingHeight, torusRadius = 5, torusDiameter = 50, topHoleSize = 3) {
    translate([0, 0, heights[len(heights) - 1] + startingHeight + endingHeight + torusRadius])
        difference() {
            union() {
                rotate([180, 0, 0])
                    elbow(startingHeight, torusRadius);
                // The angle of the cone is found thanks to Thalès/. tan(bac) = bc/ac
                coneHeight = torusDiameter / 2;
                coneBaseWidth = torusRadius;
                coneTopWidth = torusRadius / 2;
                //angle = 90- atan(coneHeight / ((coneBaseWidth - coneTopWidth) / 2));
                angle = 2 * atan(((coneBaseWidth - coneTopWidth) / 2) / coneHeight);
                echo("The cone angle is :", angle);
                /*translate([0, 0, - (coneBaseWidth - coneTopWidth) / 2])
                    rotate([angle, 0, 0])
                        translate([0, torusDiameter / 2 - torusRadius, - torusRadius])
                            rotate([- 90, 0, 0])
                                cylinder(r1 = coneBaseWidth, r2 = coneTopWidth, h = coneHeight, $fn = 100);*/

                translate([0, torusDiameter / 2 - torusRadius, - torusRadius])
                    union() {
                        rotate([- 90, 0, 0])
                            cylinder(r = coneBaseWidth, h = coneHeight, $fn = 100);
                        translate([0, torusDiameter / 2, 0])
                            sphere(r = coneBaseWidth, $fn = 100);
                    }
                // We add a top insert hole to allow the display board to be inserted
                translate([0, torusDiameter / 2, - torusRadius * 2])
                    insertBlock(topHoleSize, torusRadius * 2);
            }
            color("white")
                translate([0, torusDiameter / 2, - torusRadius * 3])
                    union() {
                        cylinder(r = topHoleSize / 2, h = torusRadius * 4, $fn = 100);
                        translate([0, 0, torusRadius * 3])
                        insert(insertName(topHoleSize));
                    }
        }
}

module elbow(startingHeight, torusRadius = 5) {
    union() {
        translate([0, - startingHeight, startingHeight + torusRadius])
            rotate([0, - 90, 0])
                rotate([0, 0, 45])
                    torus(r1 = torusRadius, r2 = startingHeight, angle = 90, endstops = 0, $fn = 100);
        // Let's put a sphere at the end of the torus
        translate([0, - startingHeight, torusRadius])
            sphere(r = torusRadius);
    }
}

module feetNutRecess(realHoleSize, nutRatio = 1.05) {
    roundedHoleSize = roundToNearestHalf(realHoleSize);
    holeSize = roundedHoleSize < realHoleSize ? roundedHoleSize : roundedHoleSize == realHoleSize? realHoleSize :
                roundedHoleSize - .5 ;
    echo("Real hole size is", realHoleSize);
    echo("Computed hole size is", holeSize);
    union() {
        scale([nutRatio, nutRatio, nutRatio])
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

function nutHeight(holeSize) = (holeSize == 3) ?
    nut_thickness(M3_nut) : (holeSize == 2) ?
            nut_thickness(M2_nut) : (holeSize == 2.5) ?
                    nut_thickness(M2p5_nut): (holeSize == 4) ?
                            nut_thickness(M4_nut) : (holeSize == 5) ?
                                    nut_thickness(M5_nut) : (holeSize == 6) ?
                                            nut_thickness(M6_nut) : nut_thickness(M8_nut);

function screwName(holeSize) = (holeSize == 3) ?
    M3_cap_screw : (holeSize == 2) ?
            M2_cap_screw : (holeSize == 2.5) ?
                    M2p5_cap_screw: (holeSize == 4) ?
                            M4_cap_screw : (holeSize == 5) ?
                                    M5_cap_screw : (holeSize == 6) ?
                                            M6_cap_screw : M8_cap_screw;


module boltHelper(torusInternalRadius, realHoleSize) {
    difference() {
        sphere(r = torusInternalRadius * 5 / 3);
        translate([- torusInternalRadius * 5, 0, 0])
            rotate([0, 90, 0])
                cylinder(r = torusInternalRadius, h = torusInternalRadius * 10, $fn = 100);
        translate([- torusInternalRadius * 5, 0, - torusInternalRadius * 2.5])
            cube([torusInternalRadius * 10, torusInternalRadius * 10, torusInternalRadius * 5]);
        echo("Screw name is ", screwName(realHoleSize));
        translate([0, - torusInternalRadius * 4 / 3, 0])
            rotate([90, 0, 0])
                screw(screwName(realHoleSize * 5 / 3), 30);
        rotate([90, 0, 0])
            cylinder(r = realHoleSize, h = torusInternalRadius * 10, $fn = 100);
    }
}

module insertBlock(realHoleSize = 3, height = 20) {
    roundedHoleSize = roundToNearestHalf(realHoleSize);
    holeSize = roundedHoleSize < realHoleSize ? roundedHoleSize : roundedHoleSize == realHoleSize? realHoleSize :
                roundedHoleSize - .5 ;
    echo("Real hole size is", realHoleSize);
    echo("Computed hole size is", holeSize);
    echo("Block height is", height);
    echo("Boss size is", insertName(holeSize));
    echo("insert_boss_radius(type, wall)	", insert_boss_radius(insertName(holeSize), wall=2));
    insert_boss(insertName(holeSize), z = height, wall = 2);
}

function insertRadius(realHoleSize) = insert_boss_radius(insertName(realHoleSize), wall=2);