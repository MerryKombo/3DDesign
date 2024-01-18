use <generic-bracket.scad>
use <boards.scad>
include <utils.scad>;

union() {
    torusBaseRadius = getTorusSize();
    arrangeBoardsAndFan(numberOfBoards, fan_diameter, pcbsize_y, pcbsize_x, pcbsize_z, holes, showSBC = true, showFan =
    false);
    buildBase(outerRadius = getTorusSize(), innerRadius = getTorusInnerRadius(), earSize = earSize, numEars =
    numberOfBoards, baseHeight = baseHeight, showFan=false);

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