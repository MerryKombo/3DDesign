
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
module drawFoot(foot, baseSize, baseHeight, topHeight, totalHeight, holeSize) {
    // Draw the base of the foot
    color("red")
        translate(foot)
            cube([baseSize, baseSize, baseHeight], center = true);

    // Draw the top of the foot
    color("green")
        translate([foot[0], foot[1], baseHeight + topHeight / 2])
            cube([baseSize, baseSize, topHeight], center = true);

    // Draw the hole through the foot
    color("black")
        translate([foot[0], foot[1], totalHeight / 2])
            cylinder(h = totalHeight, r = holeSize / 2, center = true);
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
        drawFoot(feet[i], baseSize, baseHeight, topHeight, totalHeight, holeSize);
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
    midpoint1 = [(feet[0][0] + feet[3][0]) / 2, (feet[0][1] + feet[3][1]) / 2, linkHeight];
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
        rotate([0, 0, angle1+90])
            cube([linkThickness, distance1, linkThickness], center = true);

    // Calculate the midpoint between the second pair of diagonally opposed feet
    midpoint2 = [(feet[1][0] + feet[2][0]) / 2, (feet[1][1] + feet[2][1]) / 2, linkHeight];
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
        rotate([0, 0, angle2+90])
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
    drawAllFeet(feet, baseSize, baseHeight, topHeight, totalHeight, holeSize);

    drawLinks(feet, linkHeight, linkThickness);
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
        cylinder(h = size, r = size / 2, center = true);
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