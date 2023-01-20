use <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec nanopi duo2 dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec R5s dimensions.scad>
use <../Server Rack/1U/parts/board.scad>
use <../Server Rack/1U/boards/friendlyelec R5s.scad>
use <openscad-extra/torus.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/nuts.scad>
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
unsortedHeights = [84, 52.5];
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
module legs(heights, angles, startingHeight = 0, startingAngle = 0, torusRadius = 5, torusDiameter = 50) {
    leg(heights, startingHeight, torusRadius, torusDiameter);
}

module leg(heights, startingHeight = 0, torusRadius = 5, torusDiameter = 50) {
    feetHoleSize = (torusRadius * 3 / 5);
    torusSize = torusRadius;
    echo("feetHoleSize=", feetHoleSize);
    color("DarkKhaki")
        union() {
            difference() {
                union() {
                    // The base is a dummy cylinder
                    translate([0, 0, startingHeight + torusRadius])
                        cylinder(r = torusRadius, h = heights[len(heights) - 1] + endingHeight - torusRadius, $fn = 100)
                            ;
                    // With half a sphere on the top
                    translate([0, 0, heights[len(heights) - 1] + startingHeight + endingHeight])
                        sphere(r = torusRadius, $fn = 100);
                    // With a torus on the bottom
                    elbow(startingHeight, torusRadius);
                    // Would be nice to add a second torus on the top, aiming the center of the torus, with holes to host the display board
                    topElbow(startingHeight, torusRadius, torusDiameter);
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
                                        torusRadius * 3 / 5);
                            }
                    // We also have to remove the torus footprint
                    yTranslation = torusRadius;
                    translate([- heights[len(heights) - 1] / 2, - yTranslation, currentHeight + startingHeight])
                        rotate([90, 0, 90])
                            cylinder(r = torusSize, h = heights[len(heights) - 1], $fn = 100);
                }
            }
        }
}

module topElbow(startingHeight, torusRadius = 5, torusDiameter = 50) {
    translate([0, 0, heights[len(heights) - 1] + startingHeight + endingHeight + torusRadius])
        union() {
            rotate([180, 0, 0])
                elbow(startingHeight, torusRadius);
            cylinder(r = torusRadius, h = torusDiameter / 2, $fn = 100);
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

function nutHeight(holeSize) = (holeSize == 3) ?
    nut_thickness(M3_nut) : (holeSize == 2) ?
            nut_thickness(M2_nut) : (holeSize == 2.5) ?
                    nut_thickness(M2p5_nut): (holeSize == 4) ?
                            nut_thickness(M4_nut) : (holeSize == 5) ?
                                    nut_thickness(M5_nut) : (holeSize == 6) ?
                                            nut_thickness(M6_nut) : nut_thickness(M8_nut);