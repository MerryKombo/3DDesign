include <../Server Rack/1U/utils/hexgrid.scad>;

function getStandHeight() = 35;
// The margins between the PSU and the stand
function standMargins() = 2;
// The thickness of the walls of the stand
function standWallThickness() = 2;
// The height of the walls of the stand
function standWallHeight() = 2;
// The thickness of the feet of the stand
function standFeetThickness() = 3 * standWallThickness();
// The height of the feet of the stand
function standPlateThickness() = 4 * standWallThickness();
// The length of the PSU
function squarePSULength() = 150;
// The diameter of the PSU fan hole
function getPSUFanHoleDiameter() = squarePSULength() * .8;

module psu(length = squarePSULength(), width = squarePSULength(), height = 86) {
    color("darkgray")
        cube([length, width, height]);
}

// The `stand` module creates a stand for the PSU with the specified length, width, and height.
// It uses a union of two shapes: a base cube and a top wall with a hole in the center.
// The base cube's dimensions are calculated to be larger than the PSU, accounting for margins and wall thickness.
// The top wall is a thin layer that sits on top of the base cube, with a hole in the center for the PSU.
// The hole is offset from the edges of the wall by the wall thickness, creating a lip around the hole.
module stand(length, width, height) {
    // Calculate the dimensions of the base cube
    x = length + standMargins() * 2 + standWallThickness() * 2;
    y = width + standMargins() * 2 + standWallThickness() * 2;
    // Calculate the translation needed to center the base cube
    xTranslation = (x - length) / 2;
    echo("xTranslation", xTranslation);
    yTranslation = (x - width) / 2;
    echo("yTranslation", yTranslation);
    echo("standFeetThickness", standFeetThickness());
    // Create the base cube
    difference() {
        // Create the outer part of the base cube
        union() {
            // Create the base cube
            translate([-xTranslation, -yTranslation, 0])
                cube([x, y, height]);
            // Create the top wall with a hole in the center
            translate([-xTranslation, -yTranslation, height])
                difference() {
                    // Create the outer part of the wall
                    color("darkgray")
                        cube([x, y, standWallHeight()]);
                    // Create the hole in the center of the wall
                    color("red")
                        translate([standWallThickness(), standWallThickness(), -standWallHeight()])
                            cube([x - standWallThickness() * 2, y - standWallThickness() * 2, standWallHeight() * 2]);
                }
        }
        // Remove the cylinder representing the fan hole from the base cube
        translate([xTranslation + length / 2, yTranslation + width / 2, -height])
            cylinder(d = getPSUFanHoleDiameter(), h = height * 3, $fn = 100);
        // Remove the inside of the main cube in order to allow for air to enter the PSU
        color("red")
            translate([standFeetThickness() - xTranslation, standFeetThickness() - yTranslation, -(height +
                standPlateThickness())])
                cube([x - standFeetThickness() * 2, y - standFeetThickness() * 2, height * 2]);
    }
}

union() {
    // translate([0, 0, getStandHeight()])
    //     psu();
    stand(squarePSULength(), squarePSULength(), getStandHeight());
}