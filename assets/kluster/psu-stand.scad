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


/**
 * The `feetCutout` module creates a cutout for the feet of the PSU stand.
 * It calculates the dimensions of the base cube and the translations needed to center it.
 * It then removes the inside of the main cube to allow for air to enter the PSU.
 * This is done by creating a union of several cubes with different dimensions and colors.
 *
 * @param length The length of the PSU. Default is the return value of `squarePSULength()`.
 * @param width The width of the PSU. Default is the return value of `squarePSULength()`.
 * @param height The height of the PSU. Default is the return value of `getStandHeight()`.
 */
module feetCutout(length = squarePSULength(), width = squarePSULength(), height = getStandHeight()) {
    // Calculate the dimensions of the base cube
    x = length + standMargins() * 2 + standWallThickness() * 2;
    y = width + standMargins() * 2 + standWallThickness() * 2;
    // Calculate the translation needed to center the base cube
    xTranslation = (x - length) / 2;
    echo("xTranslation", xTranslation);
    yTranslation = (x - width) / 2;
    echo("yTranslation", yTranslation);
    echo("standFeetThickness", standFeetThickness());
    // Remove the inside of the main cube in order to allow for air to enter the PSU
    translate([0, 0, -.1])
        union() {
            baseLength = length * 3 / 2;
            baseWidth = width * 2 / 3;
            lengthTranslation = -(baseLength - length) / 2;
            widthTranslation = -(baseWidth - width) / 2;
            smallWidthTranslation = widthTranslation + (baseWidth - baseWidth / 2) / 2;
            echo("smallWidthTranslation", smallWidthTranslation);
            smallLengthTranslation = lengthTranslation + (baseLength - baseLength / 2) / 2;
            echo("smallLengthTranslation", smallLengthTranslation);
            hull() {
                // Create a purple cube
                color("purple")
                    translate([lengthTranslation, widthTranslation, 0])
                        cube([baseLength, baseWidth, height / 2]);

                // Create a blue cube
                color("blue")
                    translate([lengthTranslation, smallWidthTranslation, height / 2])
                        cube([baseLength, baseWidth / 2, height / 4]);
            }
            hull() {
                // Create a red cube
                color("red")
                    translate([widthTranslation, lengthTranslation, 0])
                        cube([baseWidth, baseLength, height / 2]);
                // Create a green cube
                color("green")
                    translate([smallWidthTranslation, lengthTranslation, height / 2])
                        cube([baseWidth / 2, baseLength, height / 4]);
            }
        }
}

module kubernetesLogo() {
    rotate([0, 0, 90])
        rotate([0, 90, 0])
            scale([.03, .03, .03])
                linear_extrude(height = 10, center = true, scale = 1.2)
                    // Trick found here: https://www.baszerr.eu/doku.php?id=blog:2022:04:07:2022-04-07_-_importing_svg_in_openscad
                    offset(0.01)
                        import(file = "./logo.svg", center = true, dpi = 96);
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
                            cube([x - standWallThickness() * 2, y - standWallThickness() * 2, standWallHeight() * 2]
                            );
                }
            // Add the Kubernetes logo to one foot of the stand
            translate([xTranslation + standFeetThickness(), -(yTranslation + standMargins()), height / 2])
                kubernetesLogo();
        }
        // Remove the cylinder representing the fan hole from the base cube
        translate([xTranslation + length / 2, yTranslation + width / 2, -height])
            cylinder(d = getPSUFanHoleDiameter(), h = height * 3, $fn = 100);
        // Remove the inside of the main cube in order to allow for air to enter the PSU
        color("red")
            translate([standFeetThickness() - xTranslation, standFeetThickness() - yTranslation, -(height +
                standPlateThickness())])
                cube([x - standFeetThickness() * 2, y - standFeetThickness() * 2, height * 2]);

        translate([-(standFeetThickness() - xTranslation), -(standFeetThickness() - yTranslation), 0])
            feetCutout(x, y, height);
    }

}

difference() {
    // translate([0, 0, getStandHeight()])
    //     psu();
    stand(squarePSULength(), squarePSULength(), getStandHeight());
    length = squarePSULength();
    width = squarePSULength();
    x = length + standMargins() * 2 + standWallThickness() * 2;
    y = width + standMargins() * 2 + standWallThickness() * 2;
    // Calculate the translation needed to center the base cube
    xTranslation = (x - length) / 2;
    echo("xTranslation", xTranslation);
    yTranslation = (x - width) / 2;
    echo("yTranslation", yTranslation);
    echo("standFeetThickness", standFeetThickness());
    feetCutout(x, y, getStandHeight());
  //kubernetesLogo();
}