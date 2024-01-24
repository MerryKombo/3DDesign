include <NopSCADlib/vitamins/inserts.scad>
include <NopSCADlib/vitamins/screw.scad>
include <NopSCADlib/vitamins/screws.scad>
include <utils.scad>;
include <base-fan.scad>;
use <../Booth Display/inserts.scad>;
include <../Booth Display/fake top board dimensions.scad>

/**
 * This module draws "ears" around the torus.
 *
 * @param outerRadius The outer radius of the torus.
 * @param earSize The size of the "ears".
 * @param numEars The number of "ears" to be added to the torus.
 *
 * The function works by using a for loop to draw the "ears" around the torus.
 * The rotate and translate functions are used to position each "ear",
 * and the cube function is used to draw the "ear".
 */
module drawEars(outerRadius, earSize, numEars, hole = false) {
    holeSize = getHoleSize();//3;
    for (i = [0 : numEars - 1]) {
        rotate([0, 0, i * 360 / numEars])
            translate([outerRadius / 2, 0, 0])
                union() {
                    difference() {
                        cube([earSize, earSize, earSize], center = true);
                        if (hole) {
                            color("black")
                                cylinder(r = holeSize / 2, h = earSize + 1, center = true, $fn = 100);
                            insert(insertName(holeSize));
                        }
                    }
                    insert_boss(insertName(holeSize), z = earSize, wall = 2);
                }
    }
}

module drawEarWithAdapterShim(outerRadius, earSize, adapterHeight, hole, holeSize) {
    difference() {
        hull() {
            difference() {
                cylinder(r = earSize / 2, h = earSize / 2, center = true, $fn = 100);
                if (hole) {
                    color("black")
                        cylinder(r = holeSize / 2, h = earSize + 1, center = true, $fn = 100);
                }
            }

        }

        if (hole) {
            color("black")
                cylinder(r = holeSize / 2, h = earSize + 1, center = true, $fn = 100);
        }
    }
}

module drawFanEarsAdapter(outerRadius, earSize, numEars, adapterHeight = 10, hole = false) {
    holeSize = 4;
    for (i = [0 : numEars - 1]) {
        rotate([0, 0, i * 360 / numEars])
            translate([outerRadius / 2, 0, getFanHeight() / 2 + earSize / 2 - adapterHeight])
                drawEarWithAdapterShim(outerRadius, earSize, adapterHeight, hole, holeSize);
    }
}

module drawEarsForFan(outerRadius, earSize, numEars, hole = false) {
    holeSize = 4;
    for (i = [0 : numEars - 1]) {
        rotate([0, 0, i * 360 / numEars])
            translate([outerRadius / 2, 0, getFanHeight() / 2 + earSize / 2])
                difference() {
                    hull() {
                        difference() {
                            //cube([earSize, earSize, earSize / 2], center = true);
                            cylinder(r = earSize / 2, h = earSize / 2, center = true, $fn = 100);
                            if (hole) {
                                color("black")
                                    cylinder(r = holeSize / 2, h = earSize + 1, center = true, $fn = 100);
                            }
                        }
                        translate([-getTorusInnerRadius() * 2, 0, 0])
                            reinforcementUnit(length = getTorusInnerRadius() * 2, width = getFinThickness(), thickness =
                            getFinThickness());
                    }

                    if (hole) {
                        color("black")
                            cylinder(r = holeSize / 2, h = earSize + 1, center = true, $fn = 100);
                    }
                }
    }
}

module reinforcementUnit(length, width, thickness) {
    //cube([length, width, thickness], center = true);
    rotate([0, 90, 0])
        cylinder(r = width / 2, h = length, center = true, $fn = 100);
}

module createReinforcement(outerRadius, innerRadius, finThickness, numEars) {
    if (outerRadius != 0) {
        for (i = [0 : numEars - 1]) {
            rotate([0, 0, i * 360 / numEars])
                translate([outerRadius / 4, 0, 0])
                    reinforcementUnit(outerRadius / 2, finThickness, finThickness);
        }
    }
}

/**
 * This module builds a torus with "ears" and internal reinforcements.
 *
 * @param outerRadius The outer radius of the torus.
 * @param innerRadius The inner radius of the torus.
 * @param earSize The size of the "ears". Default is 10.
 * @param numEars The number of "ears" to be added to the torus. Default is 8.
 * @param finThickness The thickness of the internal reinforcements. Default is 12.
 *
 * The function works by first drawing the main body of the torus using the rotate_extrude and circle functions.
 * Then, it removes the "ears" from the torus using the drawEars module.
 * After that, it draws the "ears" on the torus using the drawEars module.
 * Finally, it creates the internal reinforcements using the createReinforcement module.
 */
module buildTorus(outerRadius, innerRadius, earSize = 10, numEars = 8, finThickness = 5) {
    echo("Building torus with outer radius = ", outerRadius, ", inner radius = ", innerRadius, ", earSize = ", earSize,
    ", and number of ears = ", numEars);
    // Draw the main body of the torus
    //color("white")
    union() {
        difference() {
            union() {
                difference() {
                    rotate_extrude($fn = 100/*numEars*/)
                        translate([outerRadius / 2, 0, 0])
                            circle(r = innerRadius, $fn = 100);

                    // Remove the ears
                    drawEars(outerRadius, earSize, numEars);
                }
                // Draw the ears
                drawEars(outerRadius, earSize, numEars, hole = true);
                // Create the reinforcements
                for (i = [0 : numEars - 1]) {
                    rotate([0, 0, i * 360 / numEars])
                        createReinforcement(outerRadius, innerRadius, finThickness, numEars);
                }
            }
            color("red")
                translate([0, 0, innerRadius])
                    insert(insertName(3));

            translate([0, 0, innerRadius])
                screw(type = M3_cap_screw, length = 30, hob_point = 0, nylon = false);
        }
        difference() {
            // translate([0, 0, -innerRadius])
            //    insert_boss(insertName(3), z = innerRadius * 2, wall = 2);
            color("red")
                translate([0, 0, 0])
                    //  screw(type = M3_cap_screw, length = 30, hob_point = 0, nylon = false);
                    cylinder(r = innerRadius, h = innerRadius * 2, center = true, $fn = 100);
            color("black")
                translate([0, 0, innerRadius])
                    cylinder(r = getHoleSize(), h = innerRadius * 4, center = true, $fn = 100);
        }
    }
}

// Function to calculate the angle for the base of the torus.
// This function calculates the angle based on the ear translation and the outer radius of the torus.
// The angle is calculated using the atan function, which returns the arctangent of the quotient of its arguments.
// Returns: The calculated angle.
function calculateAngle(outerRadius) = atan(((getTorusSize() - getFanDiameter()) / 2 - (getBoardSize().z)) / (
    outerRadius / 2));


/**
 * This module builds the base of the torus.
 *
 * @param outerRadius The outer radius of the torus.
 * @param innerRadius The inner radius of the torus.
 * @param earSize The size of the "ears".
 * @param numEars The number of "ears" to be added to the torus.
 * @param baseHeight The height of the base of the torus.
 *
 * The function works by translating the torus down by the height of the base, then calling the buildTorus module to build the torus.
 */
module buildBase(outerRadius, innerRadius, earSize, numEars, baseHeight, showFan = false, drawFanEars = true, reverse=false) {
    earTranslation = (getTorusSize() - getFanDiameter()) / 2 - (getBoardSize().z);
    echo("buildBase: earTranslation = ", earTranslation);
    echo("earTranslation / outerRadius = ", earTranslation / (outerRadius / 1));
    angle = atan(earTranslation / (outerRadius / 2));// already in degrees * (180 / PI);
    echo("angle = ", angle);
    union() {
        rotate([0, 0, angle])
            difference() {
                union() {
                    translate([0, 0, 25 - baseHeight])
                        buildTorus(outerRadius, innerRadius, earSize, numEars, finThickness = getFinThickness());
                    if (showFan)
                    base_fan();
                    //buildTorusEarsForFan();
                    if (drawFanEars)
                    drawEarsForFan(outerRadius = getDiagonalDistance(), earSize = getTorusInnerRadius() * 2, numEars = 4
                    , hole = true);
                }

                color("black")
                    for (i = [0 : numEars - 1]) {
                        rotate([0, 0, i * 360 / numEars])
                            translate([outerRadius / 2, 0, 0])
                                cylinder(r = getHoleSize() / 2, h = 100, center = true, $fn = 100);
                    }
                // couper en dessous pour être sûr
                color("red")
                    translate([0, 0, getFanHeight() - getTorusInnerRadius() * 3])
                        cylinder(r = outerRadius, h = innerRadius, center = false, $fn = 100);
            }
    }
}

module buildCenterCover() {
    outerRadius = getTorusSize();
    innerRadius = baseHeight;
    numEars = numberOfBoards;
    difference() {

        cylinder(r = (getTorusSize() / 2 - getBoardSize().y) / 2, h = innerRadius * 2, center = true, $fn = 100);
        //buildBase(outerRadius = getTorusSize(), innerRadius = baseHeight, earSize, numEars = numberOfBoards, baseHeight)        ;
        cylinder(r = innerRadius, h = innerRadius * 2 + .1, center = true, $fn = 100);
        buildTorus(outerRadius, innerRadius, earSize, numEars, finThickness = getFinThickness());
        translate([0, 0, -innerRadius - .1])
            cylinder(r = (getTorusSize() / 2 - getBoardSize().y) / 2 + .1, h = innerRadius * 2, center = true, $fn = 100
            );
    }
}

buildBase(outerRadius = getTorusSize(), baseHeight, earSize, numEars = numberOfBoards, baseHeight, drawFanEars = false, reverse=true);
// drawEarWithAdapterShim(outerRadius, earSize, adapterHeight, hole, holeSize)
// drawEarWithAdapterShim(outerRadius = getTorusSize(), earSize = earSize, adapterHeight = 10, hole = true, holeSize = 4);
// buildCenterCover();