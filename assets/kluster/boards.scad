use <generic-bracket.scad>;
include <base-fan.scad>;
use <center-support.scad>;
include <raspberry-pi-3-b-plus.scad>;
use <generic-bracket.scad>;

module ensureBoardsFit(fan_diameter, board_width) {
    two_boards_width = 2 * board_width;

    if (two_boards_width <= fan_diameter) {
        echo("Two boards can fit face to face on top of the fan.");
    } else {
        echo("Two boards cannot fit face to face on top of the fan.");
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
module arrangeBoardsAndFan(num_boards, fan_diameter, board_width, board_height, boardThickness, holes, showSBC = false)
{
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
                                            if (showSBC) {
                                                k_sbc();
                                            }
                                            for (i = [0 : len(holes) - 1]) {
                                                drawCylinderThroughHole(holes, i);
                                            }
                                            // feet = [[0,0,0], [42.11,0,0], [0,40.11,0], [42.11,40.11,0]];
                                            // feet = createFeet([holes[0], holes[2], holes[1], holes[3]]);
                                            feet = createFeet(holes);
                                            echo("feet: ", feet);
                                            holeSize = holes[0][2];
                                            baseSize = holeSize + 4;
                                            baseHeight = holeSize * 2;
                                            totalHeight = baseHeight * 1.5;
                                            linkThickness = holeSize;
                                            linkHeight = baseHeight;
                                            translate([0, 0, baseHeight / 2 - totalHeight])
                                                bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight,
                                                linkThickness, linkHeight);
                                            //bracket_bracket(feet, holeSize, baseSize,     baseHeight, totalHeight,  linkThickness, linkHeight);

                                        }
        }

        // Place the fan at the center of the arrangement
        translate([0, 0, 12.5]) base_fan();

        // Add a cylinder at the center of the arrangement
        holeSize = holes[0][2];
        baseSize = holeSize + 4;
        baseHeight = holeSize * 2;
        totalHeight = baseHeight * 1.5;
        linkThickness = holeSize;
        linkHeight = baseHeight;
        translate([0, 0, 25])
            createCylinders(radius = radius, board_width = board_width, num_boards = num_boards, cylinder_height =
            getBoardSize().x, cylinder_radius = getHoleSize() / 2, insertHeights = [getHole(holeNumber = 1).x, getHole
            (holeNumber = 3).x]);
        //        createCylinders(radius = (getTorusSize() / 2 - getBoardSize().y) / 2, board_width = getBoardSize().y, num_boards = numberOfBoards, cylinder_height = getBoardSize().x, cylinder_radius = getHoleSize() / 2);
        //centerCylinder(radius, 0.4, board_width, board_height, 8);
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
