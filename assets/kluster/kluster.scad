include <raspberry-pi-3-b-plus.scad>;
include <base-fan.scad>;

module ensureBoardsFit(fan_diameter, board_width) {
    two_boards_width = 2 * board_width;

    if (two_boards_width <= fan_diameter) {
        echo("Two boards can fit face to face on top of the fan.");
    } else {
        echo("Two boards cannot fit face to face on top of the fan.");
    }
}

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

module centerCylinder(radius, wall_thickness, board_width, board_height, num_boards) {
    angle_step = 360 / num_boards;
    translate([0, 0, 25]) {
        difference() {
            // Outer cylinder
            cylinder(r = radius, h = 85, center = true, $fn = 100);
            // Inner cylinder
            translate([0, 0, - 5])
                cylinder(r = radius - wall_thickness, h = 95, center = true, $fn = 100);
            // Subtract a rectangular prism for each board
            for (i = [0 : num_boards - 1]) {
                angle = i * angle_step;
                x = (radius - wall_thickness / 2) * cos(angle);
                y = (radius - wall_thickness / 2) * sin(angle);
                translate([x, y, - 5])
                    rotate([0, 0, angle])
                        cube([board_width, wall_thickness, 95], center = true);
            }
        }
    }
}

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

module tree() {
    branch(20, 0, 2);
}

function pseudo_random(seed, i) = (seed * i) % 1;

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
 * This module arranges a given number of boards in a radial pattern on top of a fan.
 *
 * @param num_boards The number of boards to arrange.
 * @param fan_diameter The diameter of the fan.
 * @param board_width The width of the board.
 *
 * The function works by calculating the angle between each board (angle_step) and the radius of the fan.
 * It then uses a for loop to create each board at the correct angle and distance from the center of the fan.
 * The position of each board is calculated using the cosine and sine of the angle and the radius of the fan.
 * The board is then translated to this position and rotated to face outwards from the center of the fan.
 * Finally, the fan is placed at the center of the arrangement.
 */
module arrangeBoardsAndFan(num_boards, fan_diameter, board_width, board_height, holes) {
    // Calculate the angle between each board
    angle_step = 360 / num_boards;
    // Calculate the radius of the fan
    radius = fan_diameter / 2 - board_width;
    union() {
        // Loop over each board
        for (i = [0 : num_boards - 1]) {
            // Calculate the angle for this board
            angle = i * angle_step;
            // Calculate the x and y position for this board
            x = radius * cos(angle);
            y = radius * sin(angle);
            // Translate the board to its position and then rotate it to stand up vertically
            translate([x, y, 25])
                rotate([0, 0, angle])
                    translate([board_width, 0, 0])
                        rotate([0, 0, 180])
                            rotate([0, - 180, 0])
                                rotate([0, 0, 90])
                                    rotate([0, 90, 0])
                                        union() {
                                            k_sbc();
                                            for (i = [0 : len(holes) - 1]) {
                                                drawCylinderThroughHole(holes, i);
                                            }
                                        }
        }

        // Place the fan at the center of the arrangement
        translate([0, 0, 12.5]) base_fan();

        // Add a cylinder at the center of the arrangement
        translate([0, 0, 25])

            centerCylinder(radius, 0.4, board_width, board_height, 8);
        //centerTorus(radius/2, radius/4);
        //tree();
        //coral(10, 20, 0, 2,0.123);

    }
}

module arrangeBoardsInGrid(num_boards_x, num_boards_y, board_width, board_height) {
    // Calculate the spacing between the boards
    spacing_x = (140 - num_boards_x * board_width) / (num_boards_x + 1);
    spacing_y = (140 - num_boards_y * board_height) / (num_boards_y + 1);

    // Loop over each board
    for (i = [0 : num_boards_x - 1]) {
        for (j = [0 : num_boards_y - 1]) {
            // Calculate the x and y position for this board
            x = spacing_x + i * (board_width + spacing_x);
            y = spacing_y + j * (board_height + spacing_y);

            // Translate the board to its position and rotate it to stand up
            translate([x, y, 85 + 25])
                rotate([90, 90, 0])
                    k_sbc();
        }
    }

    // Place the fan at the center of the arrangement
    translate([0, 0, 0]) base_fan();
}

module arrangeBoardsInSquare(num_boards_x, num_boards_y, board_width, board_height) {
    for (i = [0 : num_boards_x - 1]) {
        for (j = [0 : num_boards_y - 1]) {
            translate([i * board_width, j * board_height, 0])
                rotate([0, - 90, 0]) // Rotate the boards to stand up
                    k_sbc();
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
        cylinder(h = size, r = size / 2, center = true);
    }

    // Add the hole number on top of the cylinder
    translate([x, y, size -0.9]) {
        color("black")
            linear_extrude(height = 1) {
                text(str(hole_number), size = size / 2, halign = "center", valign = "center");
            }
    }

    // Add the hole number at the back of the cylinder
    translate([x, y, 0.9 ]) {
        color("black")
            rotate([0, 180, 0]) {
                linear_extrude(height = 1) {
                    text(str(hole_number), size = size / 2, halign = "center", valign = "center");
                }
            }
    }
}

union() {
    sbc_model = ["rpi3b+"];
    s = search(sbc_model, sbc_data);
    /*schema:
    "model",pcbsize_x, pcbsize_y, pcbsize_z, pcbcorner_radius, topmax_component_z, bottommax_component_z
    pcb_hole1_x, pcb_hole1_y, pcb1_hole_size, pcb_hole2_x, pcb_hole2_y, pcb2_hole_size
    pcb_hole3_x, pcb_hole3_y, pcb3_hole_size, pcb_hole4_x, pcb_hole4_y, pcb4_hole_size
    pcb_hole5_x, pcb_hole5_y, pcb5_hole_size, pcb_hole6_x, pcb_hole6_y, pcb6_hole_size
    pcb_hole7_x, pcb_hole7_y, pcb7_hole_size, pcb_hole8_x, pcb_hole8_y, pcb8_hole_size
    pcb_hole9_x, pcb_hole9_y, pcb9_hole_size, pcb_hole10_x, pcb_hole10_y, pcb10_hole_size
    soc1size_x, soc1size_y, soc1size_z, soc1loc_x, soc1loc_y, soc1loc_z, soc1_rotation, "soc1_side",
    soc2size_x, soc2size_y, soc2size_z, soc2loc_x, soc2loc_y, soc2loc_z, soc2_rotation, "soc2_side",
    soc3size_x, soc3size_y, soc3size_z, soc3loc_x, soc3loc_y, soc3loc_z, soc3_rotation, "soc3_side",
    soc4size_x, soc4size_y, soc4size_z, soc4loc_x, soc4loc_y, soc4loc_z, soc4_rotation, "soc4_side",
    component_x, component_y, component_rotation, "component_side", "component_class","component_type"*/
    // MANUFACTURER: RasberryPi Foundation
    // NAME: RPi 3B+
    // SOURCE: OEM Mechanical drawings
    // TODO: Add SOC data
    // STATUS: yellow, unverified
    /* ["rpi3b+",85,56,1,3.5,16,6,                             // sbc model, pcb size and component height
    3.5,3.5,3,3.5,52.5,3,                                   // pcb holes 1 and 2
    61.5,3.5,3,61.5,52.5,3,                                 // pcb holes 3 and 4
    0,0,0,0,0,0,                                            // pcb holes 5 and 6
    0,0,0,0,0,0,                                            // pcb holes 7 and 8
    0,0,0,0,0,0,                                            // pcb holes 9 and 10
    13,13,1.25,23,23,0,0,"top",                             // soc1 size, location, rotation and side
    0,0,0,0,0,0,0,"",                                       // soc2 size, location, rotation and side
    0,0,0,0,0,0,0,"",                                       // soc3 size, location, rotation and side
    0,0,0,0,0,0,0,"",                                       // soc4 size, location, rotation and side
    1,21.7,270,"bottom","storage","microsdcard",            // sdcard
    6.8,-1,0,"top","usb2","micro",                          // usb2 otg
    24.5,-1,0,"top","video","hdmi_a",                       // hdmi
    65,2.25,270,"top","network","rj45_single",              // ethernet
    69.61,39.6,270,"top","usb2","double_stacked_a",         // usb2
    69.61,21.6,270,"top","usb2","double_stacked_a",         // usb1
    7,50,0,"top","gpio","header_40",                        // gpio
    6.5,36,0,"top","ic","ic_11x13",                         // wifi
    53,30,0,"top","ic","ic_7x7",                            // usbhub 5mm
    1.1,17.5,90,"top","video", "mipi_csi",                  // display
    43.5,1,270,"top","video", "mipi_csi",                   // camera
    50.25,0,0,"top","audio", "jack_3.5",                    // audio port
    1.1, 43.2, 90, "top", "misc", "led_3x1.5",              // activity led
    1.1, 47, 90, "top", "misc", "led_3x1.5"],               // power led
    */
    // pcb and holes
    // pcbsize_x, pcbsize_y, pcbsize_z, pcbcorner_radius, topmax_component_z, bottommax_component_z
    pcbsize_x = sbc_data[s[0]][1];
    pcbsize_y = sbc_data[s[0]][2];
    pcbsize_z = sbc_data[s[0]][3];
    pcbcorner_radius = sbc_data[s[0]][4];
    sbc_topmax_component_z = sbc_data[s[0]][5];
    holes = [
            [sbc_data[s[0]][7], sbc_data[s[0]][8], sbc_data[s[0]][9]],
            [sbc_data[s[0]][10], sbc_data[s[0]][11], sbc_data[s[0]][12]],
            [sbc_data[s[0]][13], sbc_data[s[0]][14], sbc_data[s[0]][15]],
            [sbc_data[s[0]][16], sbc_data[s[0]][17], sbc_data[s[0]][18]]
        ];
    fan_diameter = 140;
    // cube([pcbsize_x, pcbsize_y, sbc_topmax_component_z + pcbsize_z]);
    echo("pcbsize_x: ", pcbsize_x);
    echo("pcbsize_y: ", pcbsize_y);
    echo("pcbsize_z: ", pcbsize_z);
    echo("pcbcorner_radius: ", pcbcorner_radius);
    echo("sbc_topmax_component_z: ", sbc_topmax_component_z);
    ensureBoardsFit(fan_diameter, pcbsize_y);

    // translate([pcbsize_y, 0, 0])
    // rotate([0, -90, 90])
    // k_sbc();
    arrangeBoardsAndFan(8, 140, pcbsize_y, pcbsize_x, holes);

    // Calculate the radius of the fan
    radius = fan_diameter / 2 - pcbsize_y;
    // centerCylinder(radius, 0.4, pcbsize_y, pcbsize_x,8);

    // num_boards_x is the number of boards you want to arrange lengthwise, and num_boards_y is the number of boards
    // you want to arrange heightwise.
    // The for loops create each board, and the translate function positions each board in a grid pattern within the square.
    // arrangeBoardsInSquare(2, 3, 56, 26);
    // num_boards_x is the number of boards you want to arrange lengthwise, and num_boards_y is the number of boards
    // you want to arrange heightwise.
    // The for loops create each board, and the translate and rotate functions position each board in a grid pattern
    // within the square.
    // The spacing_x and spacing_y variables determine the spacing between the boards.
    // arrangeBoardsInGrid(num_boards_x=3, num_boards_y=3, board_width=pcbsize_y, board_height=26);
}