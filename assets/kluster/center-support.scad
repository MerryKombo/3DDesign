include <utils.scad>;
include <NopSCADlib/vitamins/inserts.scad>
include <NopSCADlib/vitamins/screw.scad>
include <NopSCADlib/vitamins/screws.scad>
use <../Booth Display/inserts.scad>;

/**
 * This module creates a torus (donut shape) in OpenSCAD.
 *
 * @param radius The distance from the center of the torus to the center of the tube.
 * @param tube_radius The radius of the tube.
 *
 * The function works by rotating a circle around an axis to create the torus.
 * The rotate_extrude function is used to perform the rotation, and the circle function is used to create the circle.
 * The translate function is used to position the circle at the correct distance from the center of the torus.
 */
module centerTorus(radius, tube_radius) {
    rotate_extrude($fn = 100)
        translate([radius, 0, 0])
            circle(r = tube_radius);
}

/**
 * This module creates a torus and a set of cylinders arranged in a circular pattern.
 * The position of the torus and cylinders can be either at the top or bottom based on the 'position' parameter.
 *
 * @param radius The distance from the center of the circle to the center of each cylinder.
 * @param cylinder_height The height of each cylinder.
 * @param pedestal The height of the pedestal on which the cylinders are placed.
 * @param cylinder_radius The radius of each cylinder.
 * @param num_boards The number of boards that the cylinders are attached to.
 * @param angle_step The angle between each board.
 * @param insertName The name of the insert to be used.
 * @param position The position of the torus and cylinders ("top" or "bottom").
 *
 * The function works by first determining the translation based on the position.
 * Then, it creates a torus at the specified position of the cylinders.
 * After that, it calculates the angle step and insert size.
 * It then creates each cylinder and its corresponding insert boss in a loop.
 */
module createTorusAndCylinders(radius, cylinder_height, pedestal, cylinder_radius, num_boards, angle_step, insertName,
position)
{
    // Determine the translation based on the position
    z_translation = position == "top" ? (cylinder_height + pedestal) / 2 - cylinder_radius : -(cylinder_height +
        pedestal) / 2 + cylinder_radius;

    type = insertName(3);
    echo("Insert type: ", type);
    insertHeight = insert_hole_length(type) * 3 / 2    ;
    echo("Insert height: ", insertHeight);
    insertZTranslation = position == "top" ? -insertHeight + cylinder_radius : insertHeight;
    echo("Insert z translation: ", insertZTranslation);
    translate([0, 0, z_translation])
        union() {
            difference() {
                union() {
                    // Create a torus at the specified position of the cylinders
                    color("white")
                        rotate_extrude($fn = 100/*numEars*/)
                            translate([radius, 0, 0])
                                circle(r = cylinder_radius, $fn = 100);

                    // Create each cylinder and its corresponding insert boss in a loop
                    for (i = [0 : num_boards - 1]) {
                        angle = i * angle_step;
                        x = radius * cos(angle);
                        y = radius * sin(angle);
                        hypotenuse = radius;
                        adjacent = cos(angle) * hypotenuse ;
                        opposite = sin(angle) * hypotenuse;
                        color("black")
                            translate([-adjacent, -opposite, 0])
                                rotate([0, 90, angle])
                                    cylinder(h = radius, r = cylinder_radius, center = false, $fn = 100);
                        screwHeadRadius = screw_head_radius(M3_cap_screw);
                        // echo("Screw radius: ", screwRadius);
                        echo("Screw head radius: ", screwHeadRadius);
                        // color("white")
                        // %cylinder(h = 2 * cylinder_radius, r = screwHeadRadius, center = true, $fn = 100);
                    }
                }

                translate([0, 0, insertZTranslation])
                    union() {
                        translate([0, 0, insertHeight])
                            insert(type);
                        cylinder(h = cylinder_height, r = insert_screw_diameter(type), center = true, $fn = 100);
                    }
            }

            translate([0, 0, insertZTranslation])
                union() {
                    insert_boss(type, z = insertHeight, wall = 2);
                }
        }
}

/**
 * This module creates a set of cylinders arranged in a circular pattern, with a torus at the top and bottom.
 *
 * @param radius The distance from the center of the circle to the center of each cylinder.
 * @param board_width The width of the board that the cylinders are attached to.
 * @param num_boards The number of boards that the cylinders are attached to.
 * @param cylinder_height The height of each cylinder. Default is 10.
 * @param cylinder_radius The radius of each cylinder. Default is 1.
 * @param insertHeights An array containing the heights of the inserts. Default is [0, board_width].
 * @param pedestal The height of the pedestal on which the cylinders are placed. Default is 10.
 *
 * The function works by first creating a torus at the bottom of the cylinders. Then, it calculates the angle step and insert size.
 * It then creates each cylinder and its corresponding insert boss in a loop. After all cylinders are created, it creates a torus at the top.
 */
module createCylinders(radius, board_width, num_boards, cylinder_height = 10, cylinder_radius = 1, insertHeights = [0,
    board_width], pedestal = 10) {
    echo("Creating cylinders");
    echo("Radius: ", radius);
    echo("Board width: ", board_width);
    echo("Number of boards: ", num_boards);
    echo("Cylinder height: ", cylinder_height);
    echo("Cylinder radius: ", cylinder_radius);
    echo("Insert heights: ", insertHeights);
    difference() {
        translate([0, 0, cylinder_height / 2])
            union() {
                createTorusAndCylinders(radius = (getTorusSize() / 2 - getBoardSize().y) / 2, cylinder_height =
                getBoardSize().x, pedestal, cylinder_radius = getHoleSize() / 2, num_boards = numberOfBoards,
                angle_step = 360 / numberOfBoards, insertName = insertName(3), position = "top");
                angle_step = 360 / num_boards;
                insertSize = 2 * PI * radius / num_boards + cylinder_radius;
                for (i = [0 : num_boards - 1]) {
                    angle = i * angle_step;
                    x = radius * cos(angle);
                    y = radius * sin(angle);
                    // Calculate the sides
                    hypotenuse = insertSize - cylinder_radius;
                    adjacent = cos(angle) * hypotenuse ;
                    opposite = sin(angle) * hypotenuse;
                    translate([x, y, 0])
                        union() {
                            /**
                             * This block of code creates a difference between a cylinder and two holes.
                             * The cylinder represents the main body of the object, while the holes represent the spaces for the inserts.
                             * The difference operation subtracts the holes from the cylinder, creating the final shape of the object.
                             */
                            difference() {
                                /**
                                 * This block of code creates a cylinder.
                                 * The height of the cylinder is the sum of the cylinder height and the pedestal height.
                                 * The radius of the cylinder is specified by the 'cylinder_radius' parameter.
                                 * The cylinder is centered, and the number of fragments used to approximate the cylinder is 100.
                                 */
                                union() {
                                    cylinder(h = cylinder_height + pedestal, r = cylinder_radius, center = true, $fn =
                                    100);
                                }
                                /**
                                 * This block of code creates a hole within the cylinder for the first insert.
                                 * The hole is colored black for visualization purposes.
                                 * The hole is translated to the correct position within the cylinder, rotated to the correct angle, and then created.
                                 * The radius of the hole is determined by the 'insert_hole_radius' function, and the height of the hole is twice the insert size.
                                 * The hole is centered, and the number of fragments used to approximate the hole is 100.
                                 */
                                // Create a hole within the cylinder for the insert
                                color("black")
                                    translate([0, 0, insertHeights[0] - cylinder_height / 2])
                                        rotate([0, 90, angle])
                                            cylinder(r = insert_hole_radius(insertName(2)), h = insertSize * 2, center =
                                            true,
                                            $fn = 100);
                                /**
                                 * This block of code creates a hole within the cylinder for the second insert.
                                 * The hole is colored grey for visualization purposes.
                                 * The hole is translated to the correct position within the cylinder, rotated to the correct angle, and then created.
                                 * The radius of the hole is determined by the 'insert_hole_radius' function, and the height of the hole is twice the insert size.
                                 * The hole is centered, and the number of fragments used to approximate the hole is 100.
                                */
                                color("grey")
                                    translate([0, 0, insertHeights[1] - cylinder_height / 2])
                                        rotate([0, 90, angle])
                                            cylinder(r = insert_hole_radius(insertName(2)), h = insertSize * 2, center =
                                            true,
                                            $fn = 100);
                            }
                            // Create a boss for the insert
                            color("grey")
                                /**
                                 * This block of code translates the coordinate system to the position of the first insert.
                                 * The translation is done in the z-axis by the difference between the first insert height and half the cylinder height.
                                 * Then, it translates the coordinate system in the x and y axes by the negative values of the adjacent and opposite sides of the triangle formed by the insert size and the cylinder radius.
                                 * After the translation, it rotates the coordinate system by 90 degrees in the y-axis and by the angle of the current board in the z-axis.
                                 * Finally, it creates the boss for the first insert with the specified insert size and a wall thickness of 1.
                                */
                                translate([0, 0, insertHeights[0] - cylinder_height / 2])
                                    translate([-adjacent, -opposite, 0])
                                        rotate([0, 90, angle])
                                            insert_boss(insertName(2), z = insertSize, wall = 1);
                            // Create a boss for the insert
                            color("grey")
                                /**
                                 * This block of code translates the coordinate system to the position of the second insert.
                                 * The translation is done in the z-axis by the difference between the second insert height and half the cylinder height.
                                 * Then, it translates the coordinate system in the x and y axes by the negative values of the adjacent and opposite sides of the triangle formed by the insert size and the cylinder radius.
                                 * After the translation, it rotates the coordinate system by 90 degrees in the y-axis and by the angle of the current board in the z-axis.
                                 * Finally, it creates the boss for the second insert with the specified insert size and a wall thickness of 1.
                                */
                                translate([0, 0, insertHeights[1] - cylinder_height / 2])
                                    translate([-adjacent, -opposite, 0])
                                        rotate([0, 90, angle])
                                            insert_boss(insertName(2), z = insertSize, wall = 1);
                        }
                }
                /**
                 * This line of code calls the 'createTorusAndCylinders' module to create a torus and a set of cylinders arranged in a circular pattern at the bottom of the cylinders.
                 *
                 * @param radius The distance from the center of the circle to the center of each cylinder. It is calculated as half the difference between the torus size and the y dimension of the board size.
                 * @param cylinder_height The height of each cylinder. It is equal to the x dimension of the board size.
                 * @param pedestal The height of the pedestal on which the cylinders are placed. It is passed from the parent module.
                 * @param cylinder_radius The radius of each cylinder. It is calculated as half the hole size.
                 * @param num_boards The number of boards that the cylinders are attached to. It is defined by the variable 'numberOfBoards'.
                 * @param angle_step The angle between each board. It is calculated as 360 divided by the number of boards.
                 * @param insertName The name of the insert to be used. It is determined by the 'insertName' function with an argument of 3.
                 * @param position The position of the torus and cylinders. It is set to "bottom".
                 *
                 * The function works by calling the 'createTorusAndCylinders' module with the specified parameters.
                */
                createTorusAndCylinders(radius = (getTorusSize() / 2 - getBoardSize().y) / 2, cylinder_height =
                getBoardSize().x, pedestal, cylinder_radius = getHoleSize() / 2, num_boards = numberOfBoards,
                angle_step = 360 / numberOfBoards, insertName = insertName(3), position = "bottom");
            }
        /**
         * This line of code calculates the radius of the M3 cap screw using the 'screw_radius' function.
         * The result is stored in the 'screwRadius' variable.
        */
        screwRadius = screw_radius(M3_cap_screw);

        /**
         * This line of code calculates the head radius of the M3 cap screw using the 'screw_head_radius' function.
         * The result is stored in the 'screwHeadRadius' variable.
        */
        screwHeadRadius = screw_head_radius(M3_cap_screw);

        /**
         * These lines of code print the values of 'screwRadius' and 'screwHeadRadius' to the console.
         * This is useful for debugging and verifying that the correct values are being used.
        */
        echo("Screw radius: ", screwRadius);
        echo("Screw head radius: ", screwHeadRadius);

        /**
         * This block of code creates a white cylinder.
         * The radius of the cylinder is equal to the screw radius.
         * The height of the cylinder is twice the sum of the cylinder height and the pedestal height.
         * The cylinder is centered, and the number of fragments used to approximate the cylinder is 100.
         */
        // color("white")
        //    cylinder(r = screwRadius, h = (cylinder_height + pedestal) * 2, center = true, $fn = 100);
    }
}

/**
 * This module creates a center cylinder with a number of rectangular prisms subtracted from it.
 *
 * @param radius The radius of the outer cylinder.
 * @param wall_thickness The thickness of the wall of the cylinder.
 * @param board_width The width of the board that the rectangular prisms are attached to.
 * @param board_height The height of the board that the rectangular prisms are attached to.
 * @param num_boards The number of boards that the rectangular prisms are attached to.
 *
 * The function works by first creating an outer cylinder and an inner cylinder to form a hollow cylinder.
 * Then, it calculates the angle step based on the number of boards.
 * After that, it creates each rectangular prism in a loop and subtracts it from the hollow cylinder.
 */
module centerCylinder(radius, wall_thickness, board_width, board_height, num_boards) {
    angle_step = 360 / num_boards;
    translate([0, 0, 25]) {
        difference() {
            // Outer cylinder
            cylinder(r = radius, h = 85, center = true, $fn = 100);
            // Inner cylinder
            translate([0, 0, -5])
                cylinder(r = radius - wall_thickness, h = 95, center = true, $fn = 100);
            // Subtract a rectangular prism for each board
            for (i = [0 : num_boards - 1]) {
                angle = i * angle_step;
                x = (radius - wall_thickness / 2) * cos(angle);
                y = (radius - wall_thickness / 2) * sin(angle);
                translate([x, y, -5])
                    rotate([0, 0, angle])
                        cube([board_width, wall_thickness, 95], center = true);
            }
        }
    }
}

/**
 * This module creates a tree structure using the 'branch' module.
 *
 * The function works by calling the 'branch' module with a specified length, angle, and thickness.
 * The 'branch' module is responsible for creating the actual branches of the tree.
 */
module tree() {
    branch(20, 0, 2);
}

/**
 * This function generates a pseudo-random number based on a seed and an index.
 *
 * @param seed The seed for the pseudo-random number generator. Changing the seed will result in a different sequence of pseudo-random numbers.
 * @param i The index of the pseudo-random number in the sequence. For a given seed, each index will always produce the same pseudo-random number.
 *
 * The function works by multiplying the seed and the index, and then taking the modulus of the result by 1. This ensures that the result is always a fractional number between 0 and 1.
 */
function pseudo_random(seed, i) = (seed * i) % 1;

/**
 * This module creates a coral-like structure using recursion and pseudo-random numbers.
 *
 * @param depth The depth of recursion. The recursion stops when depth reaches 0.
 * @param length The length of the cylinder at the current depth.
 * @param angle The angle at which the cylinder is rotated.
 * @param thickness The thickness of the cylinder at the current depth.
 * @param seed The seed for the pseudo-random number generator.
 *
 * The function works by first checking if the depth is greater than 0. If it is, it creates a cylinder with the specified length and thickness, rotated at the specified angle.
 * Then, it creates a hull around a number of recursive calls to the 'coral' module. The number of recursive calls, the length and angle for each call, and the thickness are determined using pseudo-random numbers.
 */
module coral(depth, length, angle, thickness, seed) {
    if (depth > 0) {
        rotate([0, angle, 0])
            cylinder(h = length, r1 = thickness, r2 = thickness * 0.8, center = true);
        hull() {
            for (i = [1:max(1, pseudo_random(seed, depth) * 3)]) {
                translate([0, 0, length])
                    coral(depth - 1, length * pseudo_random(seed, i) * 0.9, angle + pseudo_random(seed, i) * 90 - 45,
                        thickness * 0.8, seed);
            }
        }
    }
}

/**
 * This module creates a branch-like structure using recursion.
 *
 * @param length The length of the branch at the current depth.
 * @param angle The angle at which the branch is rotated.
 * @param thickness The thickness of the branch at the current depth.
 *
 * The function works by first checking if the length is greater than 1. If it is, it creates a cylinder with the specified length and thickness, rotated at the specified angle.
 * Then, it creates two recursive calls to the 'branch' module, one rotated positively and one rotated negatively. The length and thickness for each call are reduced by 20%.
 */
module branch(length, angle, thickness) {
    if (length > 1) {
        rotate([0, angle, 0])
            cylinder(h = length, r1 = thickness, r2 = thickness * 0.8, center = true);
        translate([0, 0, length / 2])
            branch(length * 0.8, angle + 45, thickness * 0.8);
        translate([0, 0, length / 2])
            branch(length * 0.8, angle - 45, thickness * 0.8);
    }
}
/**
 * This line of code calls the 'createCylinders' module to create a set of cylinders arranged in a circular pattern, with a torus at the top and bottom.
 *
 * @param radius The distance from the center of the circle to the center of each cylinder. It is calculated as half the difference between the torus size and the board size.
 * @param board_width The width of the board that the cylinders are attached to. It is equal to the y dimension of the board size.
 * @param num_boards The number of boards that the cylinders are attached to. It is defined by the variable 'numberOfBoards'.
 * @param cylinder_height The height of each cylinder. It is equal to the x dimension of the board size.
 * @param cylinder_radius The radius of each cylinder. It is calculated as half the hole size.
 * @param insertHeights An array containing the x dimensions of the first and third holes.
 * @param pedestal The height of the pedestal on which the cylinders are placed. It is set to 25.
 *
 * The function works by calling the 'createCylinders' module with the specified parameters.
 */
createCylinders(radius = (getTorusSize() / 2 - getBoardSize().y) / 2, board_width = getBoardSize().y, num_boards =
numberOfBoards, cylinder_height = getBoardSize().x, cylinder_radius = getHoleSize() / 2, insertHeights = [getHole(
holeNumber = 1).x, getHole(holeNumber = 3).x], pedestal = 10/**25*/);
