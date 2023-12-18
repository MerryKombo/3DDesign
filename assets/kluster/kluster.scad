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

module centerCylinder(radius) {
    // Add a cylinder at the center of the arrangement
    translate([0, 0, 25 + 25])
        cylinder(h = 85, r = radius, center = true);
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
module arrangeBoardsAndFan(num_boards, fan_diameter, board_width) {
    // Calculate the angle between each board
    angle_step = 360 / num_boards;
    // Calculate the radius of the fan
    radius = fan_diameter / 2 - board_width;

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
                                    k_sbc();
    }

    // Place the fan at the center of the arrangement
    translate([0, 0, 12.5]) base_fan();

    // Add a cylinder at the center of the arrangement
    centerCylinder(radius);
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

union() {
    sbc_model = ["rpi3b+"];
    s = search(sbc_model, sbc_data);

    // pcb and holes
    // pcbsize_x, pcbsize_y, pcbsize_z, pcbcorner_radius, topmax_component_z, bottommax_component_z
    pcbsize_x = sbc_data[s[0]][1];
    pcbsize_y = sbc_data[s[0]][2];
    pcbsize_z = sbc_data[s[0]][3];
    pcbcorner_radius = sbc_data[s[0]][4];
    sbc_topmax_component_z = sbc_data[s[0]][5];
    // cube([pcbsize_x, pcbsize_y, sbc_topmax_component_z + pcbsize_z]);
    echo("pcbsize_x: ", pcbsize_x);
    echo("pcbsize_y: ", pcbsize_y);
    echo("pcbsize_z: ", pcbsize_z);
    echo("pcbcorner_radius: ", pcbcorner_radius);
    echo("sbc_topmax_component_z: ", sbc_topmax_component_z);
    ensureBoardsFit(140, pcbsize_y);

    // translate([pcbsize_y, 0, 0])
    // rotate([0, -90, 90])
    // k_sbc();
    arrangeBoardsAndFan(8, 140, pcbsize_y);
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