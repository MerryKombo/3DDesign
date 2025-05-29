include <BOSL2/std.scad>
include <BOSL2/metric_screws.scad>
use <smooth_prim.scad>

bedSize = [300, 300];
bracketLength = bedSize.x * .9;
bracketThickness = 3;
transparentSheetThickness = 16.16;
bracketWidth = 2.5 * transparentSheetThickness;
nutDiameter = 5;
nutsPerPiece = 4;
distanceBetweenNuts = bracketLength / nutsPerPiece;
insertRatio = 1;//1.04;
bitsHeight = 20;
topThickness = 1;
topSquareSize = bracketWidth * 1.5;
//bitsForTesting();
//wholeAssembly(body = true, insert = false, top = false);
//halfSquare();
//translate([0, - 2 * bracketWidth, 0]) plasticClip();
//topSquare();
// Generic helper module for square components
module squareCore(include_middle_halfSquare = true);

// Generic helper module for square components
module squareCore(include_middle_halfSquare = true) {
    difference() {
        intersection() {
            color("black") translate([0, - topSquareSize, - topSquareSize / 3]) cube(size = [topSquareSize,
                topSquareSize,
                topSquareSize]);
            union() {
                if (include_middle_halfSquare) {
                    translate([0, 0, bracketWidth]) rotate([180, 0, 0]) halfSquare();
                }
                if (include_middle_halfSquare) {
                    translate([0, 0, bracketWidth]) rotate([- 90, 0, - 90]) halfSquare will be provided as children
            children();
                }
               squareCore(include_middle_halfSquare = false) {
        // The screw holes
      translate([2 * topSquareSize / 3 - bracketWidth / 4, 0, - translate([0, 0,- 2 * topSquareSize / 3 + bracketWidth / 4, - bracketWidth]) rotate([90 90, 27180]();
      }
bolt();
    }
}

module topSquare() {
    squareCore(include_middle_halfSquare = true) {
        // The screw holes will be provided as children
                }
}

module backSquare() {
    squareCore(include_middle_halfSquare = false) {
        // The screw holes
    translate([2 * topSquareSize / 3 - bracketWidth / 4, 0, - bracketWidth]) rotate([90, 0, 0]) bolt();
        translate([0, - 2 * topSquareSize / 3 + bracketWidth / 4, - bracketWidth]) rotate([90, 0, - 270]) bolt();
}

module topSquare() {
    squareCore(include_middle_halfSquare = true) {
        // The screw holes
        translate([2 * topSquareSize / 3 - bracketWidth / 4, 0, - bracketWidth]) rotate([90, 0, 0]) bolt();
        translate([0, - 2 * topSquareSize / 3 + bracketWidth / 4, - bracketWidth]) rotate([90, 0, - 270]) bolt();
    }
}

module halfSquare() {
    intersection() {
        bracketSides();
        //translate([distanceBetweenNuts / 2 - nutDiameter, 0, 0])
        cube([bracketLength / 2, bracketLength, bracketLength]);
    }
}

module plasticClip() {
    clipWidth = 2 * bracketThickness + transparentSheetThickness;
    union() {
        difference() {
            cube([bracketLength / 2, clipWidth, transparentSheetThickness + bracketThickness]);
            translate([- bracketLength / 3, bracketThickness, 0])
                cube([bracketLength, transparentSheetThickness, transparentSheetThickness]);
            translate([0, transparentSheetThickness + 2 * bracketThickness, - transparentSheetThickness -
                bracketThickness])
                rotate([90, 0, 0])
                    for (i = [1 : 1 : nutsPerPiece]) {
                        translate([i * distanceBetweenNuts - distanceBetweenNuts / 2, 0, 0])
                            bolt();
                    }
        }

    }
}

module bitsForTesting() {
    union() {
        /*translate([- (distanceBetweenNuts / 2 - nutDiameter), 0, 0])
            intersection() {
                bracketSides();
                translate([distanceBetweenNuts / 2 - nutDiameter, 0, 0])
                    cube([bitsHeight, bracketLength, bracketLength]);
            }*/
        translate([0, - (transparentSheetThickness + bracketThickness), 0])
            intersection() {
                translate([0, transparentSheetThickness / 2 * insertRatio, transparentSheetThickness / 2 * insertRatio])
                    connector();
                cube([bitsHeight, bracketLength, bracketLength]);
            }
    }
}
module wholeAssembly(body = true, insert = true, add_top = false) {
    union() {
        if (body) {
            bracketSides();
        }
        initialOffset = transparentSheetThickness / 2 + bracketThickness;
        offset = ((initialOffset * insertRatio) - initialOffset) / 2 + initialOffset;
        echo("initialOffset is ", initialOffset);
        echo("final offset is ", offset);
        if (insert) {
            translate([bracketLength, offset, offset]) connector();
        }
        if (add_top) {
            top();
        }
    }
}

module top() {
    translate([bracketLength + topThickness, bracketWidth / 2, bracketWidth / 2])
        union() {
            color("Black")
                rotate([0, - 90, 0])
                    // Let's go 3D
                    linear_extrude(height = topThickness)
                        rotate([0, 180, 0])
                            difference() {
                                union() {
                                    // Main rounded rectangle
                                    rect([bracketWidth, bracketWidth], rounding = bracketThickness, $fn = 100);
                                    // A small square because this top left angle should not be rounded
                                    translate([- bracketWidth / 2, - bracketWidth / 2])
                                        square([bracketThickness, bracketThickness]);
                                    // A small square because this bottom right angle should not be rounded
                                    translate([bracketWidth / 2 - bracketThickness, bracketWidth / 2 - bracketThickness]
                                    )
                                        square([bracketThickness, bracketThickness]);
                                }
                                // Let's remove the top right rectangle
                                holeSize = bracketWidth - 2 * bracketThickness - transparentSheetThickness * insertRatio
                                ;
                                //translate([- bracketWidth / 2, 0])
                                //   square([bracketWidth / 2, bracketWidth / 2]);
                                translate([- holeSize - bracketThickness, bracketThickness])
                                    square([holeSize, holeSize]);
                            }
            // The plug
            translate([0, - bracketWidth / 2 + bracketThickness + transparentSheetThickness / 2, - bracketWidth / 2 +
                bracketThickness + transparentSheetThickness / 2])
                translate([- 10, 0, 0])
                    intersection() {
                        connector();
                        translate([0, - transparentSheetThickness, - transparentSheetThickness])
                            cube([10, bracketLength, bracketLength]);
                    }
        }
}

module connector() {
    color("Silver")
        scale([insertRatio, insertRatio, insertRatio])
            cuboid(size = [bracketLength / 3, transparentSheetThickness, transparentSheetThickness], rounding =
                transparentSheetThickness / 4, $fn = 100);
}

module bracketSides() {
    union() {
        // switch it to difference once done
        difference() {
            union() {
                bracketSide();
                translate([0, transparentSheetThickness + bracketThickness, 0])
                    rotate([0, 0, 180])
                        translate([- bracketLength, transparentSheetThickness + bracketThickness, 0])
                            rotate([90, 0, 0])
                                bracketSide();
            }
            color("black")
                translate([- bracketLength / 2, 0, 0])
                    cube(size = [bracketLength * 2, bracketThickness, bracketThickness]);
        }
        // 1/4th of a cylinder
        // switch to difference once done
        difference() {
            translate([bracketLength, bracketThickness, bracketThickness])
                rotate([0, - 90, 0]) cylinder(d = 2 * bracketThickness, l = bracketLength, $fn = 100);
            translate([- bracketLength / 2, bracketThickness, bracketThickness])
                color("black")
                    cube(size = [bracketLength * 2, bracketThickness, bracketThickness]);
        }
    }
}

module bracketSide() {
    difference() {
        union() {
            cube(size = [bracketLength, bracketWidth, bracketThickness]);
            translate([0, 0, bracketThickness + transparentSheetThickness * 1.05])
                cube(size = [bracketLength, bracketWidth, bracketThickness]);
        }
        for (i = [1 : 1 : nutsPerPiece]) {
            translate([i * distanceBetweenNuts - distanceBetweenNuts / 2, 0, 0]) bolt();
        }
    }
}

module bolt() {
    translate([0, bracketWidth * 2 / 3 + nutDiameter, 0])
        rotate([180, 0, 0])
            metric_bolt(size = nutDiameter, l = (bracketThickness * 2 + transparentSheetThickness) * 1.05 +
                get_metric_bolt_head_height(nutDiameter), details = true, headtype = "socket");
}