include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>
include <NopSCADlib/vitamins/inserts.scad>
include <NopSCADlib/vitamins/screw.scad>
include <NopSCADlib/vitamins/screws.scad>
use <../Booth Display/inserts.scad>;
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
 * This module draws a foot of the bracket.
 *
 * @param foot An array representing the x and y coordinates of the foot.
 * @param baseSize The size of the base of the foot.
 * @param baseHeight The height of the base of the foot.
 * @param topHeight The height of the top of the foot.
 * @param totalHeight The total height of the foot.
 * @param holeSize The size of the hole in the foot.
 *
 * The function works by first drawing the base of the foot using the translate and cube functions.
 * It then draws the top of the foot in a similar way, but with a different height.
 * Finally, it draws a hole through the foot using the translate and cylinder functions.
 */
module drawFoot(foot, baseSize, baseHeight, topHeight, totalHeight, holeSize, insertBoss = false, insertElbow = false) {
    echo("drawFoot: ", foot);
    echo("baseSize: ", baseSize);
    echo("baseHeight: ", baseHeight);
    echo("topHeight: ", topHeight);
    echo("totalHeight: ", totalHeight);
    echo("holeSize: ", holeSize);

    translate(foot)
        difference() {
            union() {
                color("red")
                    hull() {
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
                            color("blue")
                                insert_boss(insertName(holeSize), z = totalHeight);

                    }
                if (insertElbow) {
                    echo("inserting elbow");
                    insertRadius = insert_boss_radius(insertName(holeSize), wall = 2 * extrusion_width);
                    translate([baseHeight / 3, -baseHeight / 2, 0])
                        rotate([0, 0, 0])
                            earElbow(bracketRadius = baseHeight / 2, insertRadius = insertRadius, angle = 90, holeSize =
                            holeSize, footTranslation = foot.x);
                }
            }
            // Draw the hole through the foot
            color("black")
                cylinder(h = totalHeight * 2, r = holeSize / 2, center = true, $fn = 100);
        }
}

/**
 * This module draws all the feet of the bracket.
 *
 * @param feet An array of arrays, where each sub-array represents the coordinates of a foot.
 * @param baseSize The size of the base of each foot.
 * @param baseHeight The height of the base of each foot.
 * @param topHeight The height of the top of each foot.
 * @param totalHeight The total height of each foot.
 * @param holeSize The size of the hole in each foot.
 *
 * The function works by iterating over the feet array. For each foot, it calls the drawFoot module
 * with the appropriate parameters to draw the foot at the correct position.
 */
module drawAllFeet(feet, baseSize, baseHeight, topHeight, totalHeight, holeSize) {
    for (i = [0 : len(feet) - 1]) {
        if (i == 0) {
            drawFoot(feet[i], baseSize, baseHeight, topHeight, totalHeight, holeSize, insertBoss = false, insertElbow =
            true);
        } else {
            drawFoot(feet[i], baseSize, baseHeight, topHeight, totalHeight, holeSize, insertBoss = false, insertElbow =
            false);
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
module bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight) {
    topHeight = totalHeight - baseHeight;
    difference() {
        union() {
            drawAllFeet(feet, baseSize, baseHeight, topHeight, totalHeight, holeSize);
            drawLinks(feet, linkHeight, linkThickness);
        }
        // Draw a hole in each foot after the feet and links are drawn
        for (i = [0 : len(feet) - 1]) {
            foot = feet[i];
            x = foot[0];
            y = foot[1];
            translate([x, y, totalHeight / 4]) {
                cylinder(h = totalHeight*2, r = holeSize / 2, center = true, $fn = 100);
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


include <raspberry-pi-3-b-plus.scad>;
sbc_model = ["rpi3b+"];
s = search(sbc_model, sbc_data);
holes = [
        [sbc_data[s[0]][7], sbc_data[s[0]][8], sbc_data[s[0]][9]],
        [sbc_data[s[0]][10], sbc_data[s[0]][11], sbc_data[s[0]][12]],
        [sbc_data[s[0]][13], sbc_data[s[0]][14], sbc_data[s[0]][15]],
        [sbc_data[s[0]][16], sbc_data[s[0]][17], sbc_data[s[0]][18]]
    ];

//drawAllFeet(feet = createFeet(holes), baseSize = 9, baseHeight = 6, topHeight = 3, totalHeight = 9, holeSize = 3);
bracket_bracket(feet = createFeet(holes), holeSize = 3, baseSize = 9, baseHeight = 6, totalHeight = 9, linkThickness = 3
, linkHeight = 6) ;