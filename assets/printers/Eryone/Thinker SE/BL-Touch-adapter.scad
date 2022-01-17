use <../../../smooth_prim.scad>

blTouchAdapterWidth = 26.3218;
blTouchAdapterDepth = 25.45;
blTouchAdapterHeight = 19.7;
blTouchAdapterTopWidth = 12;
blTouchAdapterBottomWidth = blTouchAdapterWidth - blTouchAdapterTopWidth;
blTouchAdapterBottomHeight = 5;
blTouchAdapterFromBackToCutCorner = 19;
blTouchAdapterBottomCenterSectionLength = 14.5;
blTouchAdapterMainHoleDiameter = 12;
blTouchAdapterBottomHoleDiameter = 3;
blTouchAdapterTopHolesDiameter = 3;
blTouchAdapterTopHolesDistanceFromEdge = 4;
blTouchAdapterBottomHoleDistanceFromEdge = 3.2;
blTouchAdapterCutBottomToCutCorner = 15;
blTouchAdapterCutBottomLength = 5.66;
blTouchAdapterBottomCutCornerLength = 8.49;
blTouchDistanceBetweenTwoHoles = 18;

union() {
    //projection() import("Eryone_thinker_BLtouch_mounting_plates.STL");
    //projection() rotate([- 90, 0, 0]) translate([- 40, 0, 0]) import("Eryone_thinker_BLtouch_mounting_plates.STL");
    //translate([- 40, - 40, 0]) import("Eryone_thinker_BLtouch_mounting_plates.STL");
    translate([0, - 2 * blTouchAdapterWidth, 0])
        difference() {
            union() {
                difference() {
                    union() {
                        cube(size = [blTouchAdapterWidth, blTouchAdapterTopWidth, blTouchAdapterHeight]);
                        bottom();
                        chamfer();
                    }
                    // The main hole
                    color("black")
                        translate([(blTouchAdapterWidth - blTouchAdapterMainHoleDiameter) / 2, blTouchAdapterTopWidth *
                            .75,
                                blTouchAdapterBottomHeight + ((blTouchAdapterHeight - blTouchAdapterBottomHeight) -
                                blTouchAdapterMainHoleDiameter) / 2
                            ])
                            translate([blTouchAdapterMainHoleDiameter / 2, blTouchAdapterMainHoleDiameter / 2,
                                    blTouchAdapterMainHoleDiameter / 2])
                                rotate([90, 0, 0])
                                    cylinder(d = blTouchAdapterMainHoleDiameter, h = blTouchAdapterTopWidth * 1.5, $fn =
                                    100
                                    );
                    topHoles();
                    bottomCut();
                }
            }
            bottomHole();
            bottomCornerCut();
        }
}

module topHoles() {
    // The top holes
    color("black")
        union() {
            translate([(blTouchAdapterWidth - blTouchDistanceBetweenTwoHoles) / 2 - blTouchAdapterTopHolesDiameter / 2,
                        blTouchAdapterTopWidth / 2 - blTouchAdapterTopHolesDiameter / 2, -
                blTouchAdapterTopHolesDiameter])
                translate([blTouchAdapterTopHolesDiameter / 2, blTouchAdapterTopHolesDiameter / 2, 0])
                    cylinder(d = blTouchAdapterTopHolesDiameter, h = blTouchAdapterHeight * 1.5, $fn = 100);
            translate([blTouchAdapterWidth - (blTouchAdapterWidth - blTouchDistanceBetweenTwoHoles) / 2 -
                    blTouchAdapterTopHolesDiameter / 2, blTouchAdapterTopWidth / 2 - blTouchAdapterTopHolesDiameter / 2,
                -
                blTouchAdapterTopHolesDiameter])
                translate([blTouchAdapterTopHolesDiameter / 2, blTouchAdapterTopHolesDiameter / 2, 0])
                    cylinder(d = blTouchAdapterTopHolesDiameter, h = blTouchAdapterHeight * 1.5, $fn = 100);
        }
}

module bottomHole() {
    // The top holes
    color("white")
        union() {
            translate([blTouchAdapterWidth / 2 - blTouchAdapterBottomHoleDiameter / 2, - (blTouchAdapterDepth -
                blTouchAdapterTopWidth) + blTouchAdapterBottomHoleDistanceFromEdge, - 1])
                translate([blTouchAdapterBottomHoleDiameter / 2, blTouchAdapterBottomHoleDiameter / 2, 0])
                    cylinder(d = blTouchAdapterBottomHoleDiameter, h = blTouchAdapterHeight * 1.5, $fn = 100);
        }
}

module bottom() {
    // The bottom
    color("red")
        translate([0, - (blTouchAdapterDepth - blTouchAdapterTopWidth), 0])
            cube(size = [blTouchAdapterWidth, blTouchAdapterBottomWidth, blTouchAdapterBottomHeight]);
}

module bottomCut() {
    color("blue")
        translate([- blTouchAdapterWidth * .25, blTouchAdapterTopWidth, - sqrt(2 * blTouchAdapterCutBottomLength^2) / 2]
        )
            rotate([45, 0, 0])
                cube(size = [blTouchAdapterWidth * 1.5, blTouchAdapterCutBottomLength, blTouchAdapterCutBottomLength]);
}

module bottomCornerCut() {
    color("green")
        translate([0, 0, - 1])
            translate([0, sqrt(2 * blTouchAdapterBottomCutCornerLength^2) / 2 - blTouchAdapterDepth, 0])
                union() {
                    rotate([0, 0, 45])
                        cube(size = [blTouchAdapterBottomCutCornerLength, blTouchAdapterBottomCutCornerLength,
                                blTouchAdapterHeight
                                *
                                1.5]);
                    translate([blTouchAdapterWidth, 0, 0])
                        rotate([0, 0, 45])
                            cube(size = [blTouchAdapterBottomCutCornerLength, blTouchAdapterBottomCutCornerLength,
                                    blTouchAdapterHeight
                                    *
                                    1.5]);
                }
}

module chamfer() {
    cubeSide = blTouchAdapterDepth - blTouchAdapterTopWidth;
    smoothinRadius = 0.15 * cubeSide;
    color("blue")
        translate([- blTouchAdapterWidth * .25, - cubeSide, blTouchAdapterBottomHeight])
            difference() {
                cube(size = [blTouchAdapterWidth * 1.5, cubeSide, cubeSide]);
                SmoothCube(size = [blTouchAdapterWidth * 1.5, cubeSide, cubeSide], smooth_rad = smoothinRadius, $fn =
                100);
                translate([- blTouchAdapterWidth * .1, 0, smoothinRadius])
                    cube(size = [blTouchAdapterWidth * 1.8, cubeSide, cubeSide]);
                translate([- blTouchAdapterWidth * .1, - smoothinRadius, 0])
                    cube(size = [blTouchAdapterWidth * 1.8, cubeSide, cubeSide]);
                translate([blTouchAdapterWidth * 1.25, - blTouchAdapterTopWidth * 0.9, - blTouchAdapterBottomHeight])
                    cube(size = [blTouchAdapterTopWidth, blTouchAdapterDepth, blTouchAdapterHeight]);
                translate([- blTouchAdapterWidth * .2, - blTouchAdapterTopWidth * 0.9, - blTouchAdapterBottomHeight])
                    cube(size = [blTouchAdapterTopWidth, blTouchAdapterDepth, blTouchAdapterHeight]);
            }
}