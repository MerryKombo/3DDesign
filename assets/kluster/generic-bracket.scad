include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>
include <NopSCADlib/vitamins/inserts.scad>
include <NopSCADlib/vitamins/screw.scad>
include <NopSCADlib/vitamins/screws.scad>
use <../Booth Display/inserts.scad>;
include <NopSCADlib/utils/layout.scad>
include <utils.scad>

/**
 * This module creates a 90° elbow using the rotate_extrude operation.
 *
 * @param radius The radius of the circle that is extruded to create the elbow.
 * @param angle The angle of rotation for the extrusion, defaults to 90.
 *
 * The function works by first translating the circle by the specified radius along the X-axis.
 * It then uses the rotate_extrude operation to rotate this translated circle around the Z-axis.
 * The result is a 90° elbow with a circular cross-section.
 */
module elbow_rotate_extrude(radius, angle = 90) {
    rotate_extrude(angle = angle)
        translate([radius, 0, 0])
            circle(r = radius);
}

/**
 * This module creates a hole through the "ear" of the bracket.
 *
 * @param insertRadius The radius of the insert.
 * @param bracketRadius The radius of the bracket.
 * @param holeSize The size of the hole.
 *
 * The function works by first rotating the coordinate system by 90 degrees around the Y-axis.
 * It then translates the coordinate system by the radius of the insert and the radius of the bracket along the Y and Z axes, respectively.
 * Finally, it uses the union operation to combine two cylinders that form the hole.
 * The first cylinder has a height of three times the bracket radius and a radius of half the hole size.
 * The second cylinder is translated by the bracket radius along the Z-axis and has a height of twice the hole size and a radius equal to the hole size.
 */
module drawHole(insertRadius, bracketRadius, holeSize) {
    rotate([0, 90, 0])
        translate([0, -insertRadius, bracketRadius])
            color("white")
                union() {
                    cylinder(h = 3 * bracketRadius, r = holeSize / 2, center = true, $fn = 100);
                    translate([0, 0, bracketRadius])
                        cylinder(h = holeSize * 2, r = holeSize, center = true, $fn = 100);
                }
}

/**
 * This module creates an "ear" elbow for the bracket.
 *
 * @param bracketRadius The radius of the bracket.
 * @param insertRadius The radius of the insert.
 * @param angle The angle of the elbow, defaults to 90.
 * @param holeSize The size of the hole in the "ear".
 *
 * The function works by first echoing the parameters for debugging purposes.
 * It then uses the hull operation to create the "ear" elbow.
 * The elbow is created by combining a rotated extruded elbow (created by the elbow_rotate_extrude module) and a translated and rotated insert boss.
 * The insert boss is created inside a difference operation, which also includes a hole created by the drawHole module.
 * This results in an "ear" elbow with a hole through it.
 */
module earElbow(bracketRadius, insertRadius, angle = 90, holeSize = 3, footTranslation = 0) {
    echo("earElbow bracketRadius: ", bracketRadius);
    echo("earElbow insertRadius: ", insertRadius);
    echo("earElbow angle: ", angle);
    // We know should calculate how much we need to translate the ear to make it fit
    // We don't know yet the size of the torus, the size of the board
    // What are bracketRadius and insertRadius BTW?
    // insertRadius is the radius of the insert boss, so that is not really interesting for the translation
    // bracketRadius is the radius of the bracket, so that is not interesting either for the translation
    // We definitely need to know the size of the board, and the size of the torus
    baseRadius = getTorusSize() / 2;
    boardSize = getBoardSize().y;
    echo("earElbow baseRadius: ", baseRadius);
    echo("earElbow boardSize: ", boardSize);
    echo("earElbow footTranslation: ", footTranslation);
    earTranslation = (getTorusSize() - getFanDiameter()) / 2 ;
    echo("earElbow earTranslation: ", earTranslation);
    holeRadius = screw_clearance_radius(type = M3_cap_screw);
    echo("holeRadius: ", holeRadius);
    screwHeadHeight = screw_head_height(type = M3_cap_screw);
    echo("screwHeadHeight: ", screwHeadHeight);
    screwRadius = screw_radius(type = M3_cap_screw);
    echo("screwRadius: ", screwRadius);
    union() {
        difference() {
            hull() {
                color("blue")
                    elbow_rotate_extrude(radius = bracketRadius, angle = angle);
                //rotate([- 13, 0, 0])
                // color("MediumPurple")
                //translate([0, - 4.45, 0.22])
                translate([0, -earTranslation, 0])
                    difference() {
                        hull() {
                            color("cyan")
                                translate([0, bracketRadius, 0])
                                    rotate([0, 0, -90])
                                        //translate([0, 0, - 2 * insertRadius])
                                        elbow_rotate_extrude(radius = insertRadius, angle = angle);
                            color("green")
                                //translate([0, - insertRadius, 0])
                                rotate([0, 90, 0])
                                    insert_boss(insertName(holeSize), z = insertRadius, wall = 2);

                            // translate([insertRadius, - 0, 0])
                            // rotate([0, 90, 0])
                            //    scale(1.05)
                            //       screw(type = M3_cap_screw, length = 30, hob_point = 0, nylon = false);
                        }
                        //drawHole(insertRadius, bracketRadius, holeSize);
                        translate([bracketRadius * 2, -0, 0])
                            rotate([0, 90, insertRadius])
                                union() {
                                    color("black")
                                        cylinder(h = screwHeadHeight * 3, r = holeRadius, center = true, $fn = 100);
                                    translate([0, 0, (screwHeadHeight * 3) - (screwHeadHeight * 5)])
                                        cylinder(h = screwHeadHeight * 10, r = screwRadius, center = true, $fn = 100);
                                }
                    }
            }
            translate([0, -earTranslation, 0])
                translate([bracketRadius * 2, -0, 0])
                    rotate([0, 90, insertRadius])
                        union() {
                            color("black")
                                cylinder(h = screwHeadHeight * 3, r = holeRadius, center = true, $fn = 100);
                            translate([0, 0, (screwHeadHeight * 3) - (screwHeadHeight * 5)])
                                cylinder(h = screwHeadHeight * 10, r = screwRadius, center = true, $fn = 100);
                        }
        }
        translate([0, -earTranslation, 0])
            translate([insertRadius, -0, 0])
                rotate([0, 90, 0])
                    screw(type = M3_cap_screw, length = 30, hob_point = 0, nylon = false);
        // Check the distance from the PCB to the middle of the screw

        /*color("red")
            translate([0, - earTranslation, 0])
                translate([insertRadius * 2, - 0, earTranslation/2])
                    cube([1, 1, earTranslation], center = true);*/
    }
}

/**
 * This module creates a 90° elbow using the hull operation.
 *
 * @param radius The radius of the spheres that are used to create the elbow.
 *
 * The function works by first translating a sphere by the specified radius along the X-axis.
 * It then translates another sphere by the specified radius along the Y-axis.
 * Finally, it uses the hull operation to create a 90° elbow from the two translated spheres.
 */
module elbow_hull(radius) {
    hull() {
        translate([radius, 0, 0])
            sphere(r = radius);
        translate([0, radius, 0])
            sphere(r = radius);
    }
}
//elbow_hull(10);

// elbow_rotate_extrude(10);

/**
 * This function creates an array of coordinates for the feet of the bracket.
 *
 * @param holes An array of arrays, where each sub-array represents a hole and contains the x-coordinate, y-coordinate, and size in that order.
 * @param i An optional parameter that represents the current index in the recursion. It defaults to 0.
 * @param result An optional parameter that represents the current result in the recursion. It defaults to an empty array.
 *
 * The function works by recursively iterating over the holes array. For each hole, it appends the x and y coordinates to the result array.
 * The recursion ends when i equals the length of holes, at which point the result array is returned.
 */
function createFeet(holes, i = 0, result = []) =
    i == len(holes) ?
    result :
        createFeet(holes, i + 1, concat(result, [[holes[i][0], holes[i][1], 0]]));

/**
 * This module draws a foot with optional insert boss and elbow.
 *
 * @param foot An array representing the x, y, and z coordinates of the foot.
 * @param baseSize The diameter of the base of the foot.
 * @param baseHeight The height of the base of the foot.
 * @param topHeight The height of the top of the foot.
 * @param totalHeight The total height of the foot.
 * @param holeSize The diameter of the hole in the foot.
 * @param insertBoss A boolean value indicating whether to insert a boss in the foot. Defaults to false.
 * @param insertElbow A boolean value indicating whether to insert an elbow in the foot. Defaults to false.
 *
 * The function works by first echoing the parameters for debugging purposes.
 * It then uses the translate function to move the coordinate system to the location of the foot.
 * Inside a union operation, it uses the difference operation to subtract a cylinder (representing the hole) from another union operation.
 * This union operation includes a base and a top of the foot, and optionally an insert boss and an elbow.
 * The base and the top of the foot are cylinders, and the insert boss and the elbow are created using the insert_boss and earElbow modules, respectively.
 * If insertBoss is true, an insert boss is added to the foot.
 * If insertElbow is true, an elbow is added to the foot.
 */
module drawFoot(foot, baseSize, baseHeight, topHeight, totalHeight, holeSize, insertBoss = false, insertElbow = false) {
    echo("drawFoot: ", foot);
    echo("baseSize: ", baseSize);
    echo("baseHeight: ", baseHeight);
    echo("topHeight: ", topHeight);
    echo("totalHeight: ", totalHeight);
    echo("holeSize: ", holeSize);

    translate(foot)
        union() {
            difference() {
                hull() {
                    //color("green")
                    union() {
                        // Draw the base of the foot
                        color("red")
                            // cube([baseSize, baseSize, baseHeight], center = true);
                            cylinder(h = baseHeight, r = baseSize / 2, center = true, $fn = 100);

                        // Draw the top of the foot
                        color("green")
                            translate([0, 0, baseHeight / 2 + topHeight / 2])
                                // cube([baseSize * 0.7, baseSize * 0.7, topHeight], center = true);
                                cylinder(h = topHeight, r = baseSize * 0.7 / 2, center = true, $fn = 100);
                        // TODO add an insert boss in here instead of a simple foot
                        // or not, depends on the final design
                        // we should maybe add a parameter to the function to decide whether to add a boss or not
                        if (insertBoss)
                        // TODO: change holeSize to 2.5, as it will give us room to play with the screw, if the print is not perfect
                            union() {
                                color("blue")
                                    translate([0, 0, -totalHeight / 2 + baseHeight / 4])
                                        insert_boss(insertName(holeSize), z = totalHeight);
                                color("yellow")
                                    translate([0, 0, insert_length(type = insertName(holeSize))])
                                        insert(type = insertName(holeSize));
                            }
                    }
                    if (insertElbow) {
                        echo("inserting elbow");
                        insertRadius = insert_boss_radius(insertName(holeSize), wall = 2 * extrusion_width);
                        translate([baseHeight / 3, -baseHeight / 2, 0])
                            rotate([0, 0, 0])
                                earElbow(bracketRadius = baseHeight / 2, insertRadius = insertRadius, angle = 90,
                                holeSize =
                                holeSize, footTranslation = foot.x);
                    }
                }

                if (insertBoss)
                    union() {
                        color("blue")
                            translate([0, 0, -totalHeight / 2 + baseHeight / 4])
                                insert_boss(insertName(holeSize), z = totalHeight);
                        color("yellow")
                            translate([0, 0, insert_length(type = insertName(holeSize))])
                                insert(type = insertName(holeSize));
                    }
                // Draw the hole through the foot
                color("black")
                    cylinder(h = totalHeight * 2, r = holeSize / 2, center = true, $fn = 100);
            }
            if (insertBoss)
                union() {
                    color("blue")
                        translate([0, 0, -totalHeight / 2 + baseHeight / 4])
                            insert_boss(insertName(holeSize), z = totalHeight);
                }
        }
}

/**
 * This module draws a smaller version of a foot, which only includes the base and a hole.
 *
 * @param foot An array representing the x, y, and z coordinates of the foot.
 * @param baseSize The diameter of the base of the foot.
 * @param baseHeight The height of the base of the foot.
 * @param holeSize The diameter of the hole in the foot.
 *
 * The function works by first echoing the parameters for debugging purposes.
 * It then uses the translate function to move the coordinate system to the location of the foot.
 * Finally, it uses the difference operation to subtract a cylinder (representing the hole) from another cylinder (representing the base of the foot).
 */
module drawSmallFoot(foot, baseSize, baseHeight, holeSize) {
    echo("smallFoot: ", foot);
    echo("baseSize: ", baseSize);
    echo("baseHeight: ", baseHeight);
    echo("holeSize: ", holeSize);
    translate([0, 0, -baseHeight / 2])
        translate(foot)
            difference() {
                // Draw the base of the foot
                color("red")
                    cylinder(h = baseHeight, r = baseSize / 2, center = true, $fn = 100);

                // Draw the hole through the foot
                color("black")
                    cylinder(h = baseHeight * 2, r = holeSize / 2, center = true, $fn = 100);
            }
}

/**
 * This module draws a nut on top of a small foot.
 *
 * @param foot An array representing the x and y coordinates of the foot.
 * @param baseSize The size of the base of the foot.
 * @param baseHeight The height of the base of the foot.
 * @param holeSize The size of the hole in the foot.
 *
 * The function works by first defining the parameters for a high M3 nut.
 * It then uses the translate function to move the coordinate system to the location of the foot.
 * Finally, it uses the nut function to draw the nut.
 */
module drawSmallFootTopNut(foot, baseSize, baseHeight, holeSize) {
    echo("smallFoot: ", foot);
    echo("baseSize: ", baseSize);
    echo("baseHeight: ", baseHeight);
    echo("holeSize: ", holeSize);
    high_M2_nut = ["high_M2_nut", 2, 4.9, baseHeight * 4, 2.4, M2_washer, M2_nut_trap_depth, 0];
    high_M3_nut = ["high_M3_nut", 3, 6.4, baseHeight * 4, 4, M3_washer, M3_nut_trap_depth, 0];
    if (holeSize == 2)
        translate([0, 0, 0])
            translate(foot)
                nut(type = high_M2_nut, nyloc = false, brass = false, nylon = false);
    else
        translate([0, 0, 0])
            translate(foot)
                nut(type = high_M3_nut, nyloc = false, brass = false, nylon = false);
}

/**
 * This module draws all the feet for a bracket.
 *
 * @param feet An array of arrays, where each sub-array represents the coordinates of a foot.
 * @param baseSize The size of the base of each foot.
 * @param baseHeight The height of the base of each foot.
 * @param topHeight The height of the top of each foot.
 * @param totalHeight The total height of each foot.
 * @param holeSize The size of the hole in each foot.
 * @param insertBoss A boolean value indicating whether to insert a boss in the foot. Defaults to false.
 *
 * The function works by iterating over the feet array. For each foot, it draws the foot using the drawFoot module.
 * If the foot is the first or third foot, it also draws a twin foot on its right using the drawSmallFoot module.
 * If the foot is the second or fourth foot, it also draws a twin foot on its left using the drawSmallFoot module.
 * Finally, it draws a top nut on each twin foot using the drawSmallFootTopNut module.
 */
module drawAllFeet(feet, baseSize, baseHeight, topHeight, totalHeight, holeSize, insertBoss = false) {
    for (i = [0 : len(feet) - 1]) {
        difference() {
            union() {
                if (i == 0) {
                    drawFoot(feet[i], baseSize, baseHeight, topHeight, totalHeight, holeSize, insertBoss, insertElbow =
                    false);
                } else {
                    drawFoot(feet[i], baseSize, baseHeight, topHeight, totalHeight, holeSize, insertBoss, insertElbow =
                    false);
                }
                // If the foot is #1 or 3, then draw a twin foot on its right, so we can attach it to the center support
                if (i == 1 || i == 3) {
                    echo("Drawing right twin foot");
                    //drawSmallFoot(foot, baseSize, baseHeight, holeSize)
                    drawSmallFoot(foot = [feet[i][0], feet[i][1] + (baseSize + holeSize) / 2, feet[i][2]], baseSize =
                    baseSize, baseHeight = baseHeight / 2, holeSize = holeSize);
                }
                // If the foot is #0 or 2, then draw a twin foot on its left, so we can attach it to the center support
                if (i == 0 || i == 2) {
                    echo("Drawing left twin foot");
                    //drawSmallFoot(foot, baseSize, baseHeight, holeSize)
                    drawSmallFoot(foot = [feet[i][0], feet[i][1] - (baseSize + holeSize) / 2, feet[i][2]], baseSize =
                    baseSize, baseHeight = baseHeight / 2, holeSize = holeSize);
                }
            }
            drawSmallFootTopNut(foot = [feet[i][0], feet[i][1] + (baseSize + holeSize) / 2, feet[i][2]], baseSize =
            baseSize, baseHeight = baseHeight / 2, holeSize = holeSize);
            drawSmallFootTopNut(foot = [feet[i][0], feet[i][1] - (baseSize + holeSize) / 2, feet[i][2]], baseSize =
            baseSize, baseHeight = baseHeight / 2, holeSize = holeSize);
        }
    }
}

/**
 * This module draws links between pairs of diagonally opposed feet.
 *
 * @param feet An array of arrays, where each sub-array represents the coordinates of a foot.
 * @param linkHeight The height of the links.
 * @param linkThickness The thickness of the links.
 *
 * The function works by first calculating the midpoint, distance, and angle between the first pair of diagonally opposed feet.
 * It then draws a link between this pair of feet using the translate, rotate, and cube functions.
 * The same process is repeated for the second pair of diagonally opposed feet.
 */
module drawLinks(feet, linkHeight, linkThickness) {
    // Calculate the midpoint between the first pair of diagonally opposed feet
    midpoint1 = [(feet[0][0] + feet[3][0]) / 2, (feet[0][1] + feet[3][1]) / 2, linkHeight - linkThickness * 1.5];
    echo("Midpoint 1: ", midpoint1); // Echo the midpoint1

    // Calculate the distance between the first pair of diagonally opposed feet
    distance1 = sqrt(pow(feet[0][0] - feet[3][0], 2) + pow(feet[0][1] - feet[3][1], 2));
    echo("Distance 1: ", distance1); // Echo the distance1

    // Calculate the angle between the first pair of diagonally opposed feet
    angle = atan((feet[3][1] - feet[0][1]) / (feet[3][0] - feet[0][0])) * 180 / PI;
    echo("Angle 1: ", angle); // Echo the angle1
    angle1 = (feet[2][0] < feet[0][0]) ? angle + 180 : angle;
    echo("Angle 1: ", angle1); // Echo the angle1

    // Draw the link between the first pair of diagonally opposed feet
    translate(midpoint1)
        rotate([0, 0, angle1 + 90])
            cube([linkThickness, distance1, linkThickness], center = true);

    // Calculate the midpoint between the second pair of diagonally opposed feet
    midpoint2 = [(feet[1][0] + feet[2][0]) / 2, (feet[1][1] + feet[2][1]) / 2, linkHeight - linkThickness * 1.5];
    echo("Midpoint 2: ", midpoint2); // Echo the midpoint2

    // Calculate the distance between the second pair of diagonally opposed feet
    distance2 = sqrt(pow(feet[1][0] - feet[2][0], 2) + pow(feet[1][1] - feet[2][1], 2));
    echo("Distance 2: ", distance2); // Echo the distance2

    // Calculate the angle between the second pair of diagonally opposed feet
    baseAngle = atan((feet[2][1] - feet[1][1]) / (feet[2][0] - feet[1][0])) * 180 / PI;
    angle2 = (feet[2][0] < feet[1][0]) ? baseAngle + 180 : baseAngle;
    echo("Angle 2: ", angle2); // Echo the angle2

    // Draw the link between the second pair of diagonally opposed feet
    translate(midpoint2)
        rotate([0, 0, angle2 + 90])
            cube([linkThickness, distance2, linkThickness], center = true);
}

/**
 * This module draws a bracket with feet and links.
 *
 * @param feet An array of arrays, where each sub-array represents the coordinates of a foot.
 * @param holeSize The size of the hole in each foot.
 * @param baseSize The size of the base of each foot.
 * @param baseHeight The height of the base of each foot.
 * @param totalHeight The total height of each foot.
 * @param linkThickness The thickness of the links.
 * @param linkHeight The height of the links.
 *
 * The function works by first calculating the height of the top of each foot.
 * It then calls the drawAllFeet module to draw all the feet of the bracket.
 * Finally, it calls the drawLinks module to draw links between pairs of diagonally opposed feet.
 */
module bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight, insertBoss = false)
{
    topHeight = totalHeight - baseHeight;
    difference() {
        union() {
            drawAllFeet(feet, baseSize, baseHeight, topHeight, totalHeight, holeSize, insertBoss);
            drawLinks(feet, linkHeight, linkThickness);
        }
        // Draw a hole in each foot after the feet and links are drawn
        for (i = [0 : len(feet) - 1]) {
            foot = feet[i];
            x = foot[0];
            y = foot[1];
            translate([x, y, totalHeight / 4]) {
                cylinder(h = totalHeight * 2, r = holeSize / 2, center = true, $fn = 100);
            }
        }
    }
}

/**
 * This module draws a cylinder through a specified hole and adds the hole number on top of the cylinder.
 *
 * @param holes An array of arrays, where each sub-array represents a hole and contains the x-coordinate, y-coordinate, and size in that order.
 * @param hole_number The index of the hole in the holes array through which the cylinder should be drawn.
 *
 * The function works by first retrieving the hole data from the holes array using the hole_number.
 * It then uses the translate and cylinder functions to draw a cylinder centered on the hole.
 * The cylinder's height and radius are both equal to the size of the hole.
 * Finally, the function uses the translate, rotate, linear_extrude, and text functions to add the hole number on top of the cylinder.
 * The hole number is centered and extruded to give it some height, creating a 3D effect.
 */
module drawCylinderThroughHole(holes, hole_number) {
    // Retrieve the hole data
    hole = holes[hole_number];
    x = hole[0];
    y = hole[1];
    size = hole[2];

    // Draw a cylinder centered on the hole
    translate([x, y, size / 2]) {
        cylinder(h = size, r = size / 2, center = true, $fn = 100);
    }

    // Add the hole number on top of the cylinder
    translate([x, y, size - 0.9]) {
        color("black")
            linear_extrude(height = 1) {
                text(str(hole_number), size = size / 2, halign = "center", valign = "center");
            }
    }

    // Add the hole number at the back of the cylinder
    translate([x, y, 0.9]) {
        color("black")
            rotate([0, 180, 0]) {
                linear_extrude(height = 1) {
                    text(str(hole_number), size = size / 2, halign = "center", valign = "center");
                }
            }
    }
}

/**
 * This module creates an "ear" for a vertical support structure in a 3D model.
 *
 * @param baseHeight The height of the base of the "ear".
 * @param baseSize The size of the base of the "ear".
 * @param holeSize The diameter of the hole in the "ear".
 *
 * The function works by first rotating the coordinate system by 90 degrees around the X-axis.
 * It then uses the difference operation to subtract a hull (representing the hole) from another hull (representing the "ear").
 * The "ear" is created by combining three cylinders using the hull operation.
 * The hole is created by combining three cylinders using the hull operation.
 * The cylinders for the "ear" are translated along the Y-axis by the baseHeight for each subsequent cylinder.
 * The cylinders for the hole are translated along the Y-axis by the baseHeight and along the Z-axis by a fraction of the baseHeight for each subsequent cylinder.
 */
module verticalSupportEar(baseHeight, baseSize, holeSize, hullWithCylinder = true) {
    rotate([90, 0, 0])
        difference() {
            color("red")
                hull() {
                    cylinder(h = baseHeight / 2, r = baseSize / 2, center = true, $fn = 100);
                    translate([0, baseHeight, 0])
                        cylinder(h = baseHeight / 2, r = baseSize / 2, center = true, $fn = 100);
                    translate([0, baseHeight * 2, 0])
                        cylinder(h = baseHeight / 2, r = baseSize / 2, center = true, $fn = 100);
                    if (hullWithCylinder)
                        rotate([-90, 0, 0])
                            translate([baseHeight / 2 + holeSize, 0, baseHeight])
                                cylinder(h = 3 * baseHeight, r = holeSize, center = true, $fn = 100);
                }
            color("black")
                hull() {
                    translate([0, 0, -1])
                        cylinder(h = baseHeight * 2, r = holeSize / 2, center = true, $fn = 100);
                    translate([0, baseHeight, -baseHeight / 5])
                        cylinder(h = baseHeight * 2, r = holeSize / 2, center = true, $fn = 100);
                    translate([0, baseHeight * 2, -baseHeight / 5])
                        cylinder(h = baseHeight * 2, r = holeSize / 2, center = true, $fn = 100);
                }
        }
}

/**
 * This module creates a foot for a vertical support structure in a 3D model.
 *
 * @param size An array representing the dimensions of the foot in the form [width, length, height]. Default is [6, 20, 6].
 * @param zPosition The z-coordinate for the position of the foot in the 3D model. Default is 43.
 * @param holeSize The diameter of the hole in the foot. Default is 3.
 *
 * The function works by first translating the coordinate system to the location of the foot.
 * It then uses the difference operation to subtract a hull (representing the hole) from another hull (representing the foot).
 * The foot is created by combining a rounded cube and two cylinders using the hull operation.
 * The hole is created by combining two cylinders using the hull operation.
 */
module verticalSupportFoot(size = [6, 20, 6], zPosition = 43, holeSize = 3) {
    difference() {
        translate([0, -10, -zPosition])
            color("green")
                hull() {
                    rounded_cube_xz(size, r = size.x / 6, xy_center = true, z_center = true);
                    translate([0, size.y / 2, 0])
                        cylinder(h = size.z, r = size.x / 2, center = true, $fn = 100);
                    translate([0, -size.y / 2, 0])
                        cylinder(h = size.z, r = size.x / 2, center = true, $fn = 100);
                }
        color("black")
            hull() {
                translate([0, -size.y, -zPosition])
                    cylinder(h = 2 * size.z, r = holeSize / 2, center = true, $fn = 100);
                translate([0, -size.z, -zPosition])
                    cylinder(h = 2 * size.z, r = holeSize / 2, center = true, $fn = 100);
            }
    }
}

module exteriorVerticalSupport(feet, supportHeight = pcbsize_x, baseSize, baseHeight = 6, holeSize = 3) {
    // The support will be vertical, based on a cylinder and connected to the two "twin" feet on the left of the bracket
    // bytwo links. Each of these links will be a simple cylinder, with a hole in the middle to allow for a screw to go
    // through. The support will be connected to the feet by a screw and a nut.
    // The support will be approximately the same size as the board 85. This value can be found in the variable named
    // pcbsize_x in utils.scad.
    // The support will have a base that will connect to the base (built by the buildBase module in torus.scad) of the
    // model. The connection will be made through an oblong hole, to allow for some fine tuning of the position of the
    // support.
    //translate([0, 0, supportHeight / 2])
    union() {
        // The support will be vertical, based on a cylinder
        cylinder(h = supportHeight, r = holeSize, center = true, $fn = 100);

        translate([-holeSize * 2, 0, -supportHeight / 2 + feet[0].x])
            verticalSupportEar(baseHeight, baseSize, holeSize);
        translate([-holeSize * 2, 0, -supportHeight / 2 + feet[2].x])
            verticalSupportEar(baseHeight, baseSize, holeSize);
        // Connected to the two "twin" feet on the left of the bracket by two links
        echo("feet: ", feet);
        echo("feet[0]: ", feet[0]);
        echo("feet[0][0].z: ", feet[0].x);
        translate([-holeSize * 2, 0, -supportHeight / 2 + feet[0].x])
            verticalSupportEar(baseHeight, baseSize, holeSize);


        // The support will have a base that will connect to the base of the model
        // The connection will be made through an oblong hole, to allow for some fine tuning of the position of the support
        verticalSupportFoot(size = [6, 20, 6], zPosition = supportHeight / 2, holeSize = holeSize);
    }
}

/**
 * This module creates an interior support structure in a 3D model.
 *
 * @param baseHeight The height of the base of the support structure.
 * @param holeSize The diameter of the hole in the support structure.
 * @param baseSize The size of the base of the support structure.
 *
 * The function works by first creating a hull that combines a cylinder and an "ear" (created by the verticalSupportEar module).
 * The cylinder is created inside a difference operation, which also includes a larger cylinder.
 * The "ear" is translated and rotated to the correct position.
 * The function then subtracts a union of cylinders and a nut from the hull.
 * The cylinders are translated and rotated to the correct positions, and the nut is created using the nut function.
 * Finally, the function subtracts a union of a hull and a nut from the hull.
 * The hull is created by combining cylinders, and the nut is created using the drawSmallFootTopNut module.
 * The hull and the nut are translated and rotated to the correct positions.
 */
module interiorSupport(baseHeight = 6, holeSize = 3, baseSize = 9) {
    difference() {
        hull() {
            translate([-baseHeight / 4, 0, 0])
                rotate([90, 0, 90])
                    difference() {
                        color("red")
                            cylinder(h = baseHeight / 2, r = holeSize, center = true, $fn = 100);
                        color("black")
                            cylinder(h = baseHeight, r = holeSize / 2, center = true, $fn = 100);
                    }
            translate([baseSize / 2, baseSize / 2, -baseHeight])
                verticalSupportEar(baseHeight, baseSize, holeSize, hullWithCylinder = false);
        }

        translate([-baseHeight / 4, 0, 0])
            rotate([90, 0, 90])
                union() {
                    color("black")
                        cylinder(h = baseHeight * 8, r = holeSize / 2, center = true, $fn = 100);
                    color("red")
                    translate([0, 0, baseHeight / 2])
                        cylinder(h = baseHeight / 2, r = holeSize, center = true, $fn = 100);
                    translate([0, 0, baseHeight / 4])
                        nut(type = M3_nut, nyloc = false, brass = false, nylon = false);
                }

        translate([baseSize / 2, baseSize / 2, -baseHeight])
            rotate([90, 0, 0])
                union() {
                    color("black")
                        hull() {
                            translate([0, 0, -1])
                                cylinder(h = baseHeight * 2, r = 1, center = true, $fn = 100);
                            translate([0, baseHeight, -baseHeight / 5])
                                cylinder(h = baseHeight * 2, r = 1, center = true, $fn = 100);
                            translate([0, baseHeight * 2, -baseHeight / 5])
                                cylinder(h = baseHeight * 2, r = 1, center = true, $fn = 100);
                        }
                    color("grey")
                        translate([0, 0, holeSize / 2])
                            hull() {
                                translate([0, baseHeight * 2, 0])
                                    drawSmallFootTopNut([0, 0, 0], baseSize, baseHeight, holeSize = 2);
                                drawSmallFootTopNut([0, 0, 0], baseSize, baseHeight, holeSize = 2);
                            }
                }
    }
}

include <raspberry-pi-3-b-plus.scad>;
sbc_model = ["rpi3b+"];
s = search(sbc_model, sbc_data);
holes = [
        [sbc_data[s[0]][7], sbc_data[s[0]][8], sbc_data[s[0]][9]],
        [sbc_data[s[0]][10], sbc_data[s[0]][11], sbc_data[s[0]][12]],
        [sbc_data[s[0]][13], sbc_data[s[0]][14], sbc_data[s[0]][15]],
        [sbc_data[s[0]][16], sbc_data[s[0]][17], sbc_data[s[0]][18]]
    ];

// drawAllFeet(feet = createFeet(holes), baseSize = 9, baseHeight = 6, topHeight = 3, totalHeight = 9, holeSize = 3);
// bracket_bracket(feet = createFeet(holes), holeSize = 3, baseSize = 9, baseHeight = 6, totalHeight = 9, linkThickness = 3, linkHeight = 6, insertBoss = true) ;
// exteriorVerticalSupport(feet = createFeet(holes), supportHeight = pcbsize_x, baseSize = 9, baseHeight = 6, holeSize = 3);
interiorSupport(baseHeight = 6, holeSize = 3, baseSize = 9);