include <two-stories-module.scad>
include <module-dimensions.scad>
include <BOSL2/std.scad>
include <BOSL2/metric_screws.scad>
include <slider/slider dimensions.scad>
use <../utils/dovetails.scad>
use <dovetails/dovetails.scad>

pathRadius = rodSurroundingDiameter * 1.125;
/*translate([0, - moduleHeight, 0]) platePath(pathRadius, moduleLength - 2 * (rodSurroundingDiameter + surroundingDiameter
), wallThickness, pinSize.x, pinDepth);*/
// basicModule(moduleWidth, moduleLength, moduleHeight);


module perpendicularRodAlcoves(moduleWidth, moduleLength, moduleHeight, nutRecess = true) {
    perpendicularRodAlcove(moduleWidth, moduleLength, moduleHeight, nutRecess);
    translate([moduleWidth, 0, 0]) perpendicularRodAlcove(moduleWidth, moduleLength, moduleHeight, nutRecess);
}

module basicModule(moduleWidth, moduleLength, moduleHeight, pinsPath = true, nutRecess = true, rearDovetails=true, frontDovetails=false) {
    echo("In basicModule, nutRecess is ", nutRecess);
    difference() {
        union() {
            difference() {
                union() {
                    cube([moduleWidth, moduleLength, moduleHeight]);
                    rightEar(moduleWidth, moduleLength, moduleHeight);
                    //strangePlate();
                }
                if (pinsPath) {
                    pinsPath(moduleWidth, moduleLength, moduleHeight);
                    translate([moduleWidth - wallThickness - (wallThickness - pinDepth), 0, 0]) pinsPath(moduleWidth,
                    moduleLength, moduleHeight);
                }
                hollowOut(moduleWidth, moduleLength, moduleHeight);
                leftEar(moduleWidth, moduleLength, moduleHeight);
                perpendicularRodAlcoves(moduleWidth, moduleLength, moduleHeight, nutRecess);
            }
            rodAlcoves(moduleWidth, moduleLength, moduleHeight);
            if (rearDovetails) {
                moduleDovetails(moduleWidth, moduleLength, moduleHeight);
            }
            if (frontDovetails) {
                echo("You asked for front dovetails, here you go!");
                maleDovetails(moduleWidth);
            }
        }
        threadedRods(moduleWidth, moduleLength, moduleHeight);
    }
}

module hollowOut(moduleWidth, moduleLength, moduleHeight, hollowWalls = true) {
    union() {
        translate([wallThickness, - wallThickness, - .1]) cube([moduleWidth - 2 * wallThickness, moduleLength + 10,
                moduleHeight + 1]);
        if (hollowWalls) {
            // Let's remove a big cube from left to right
            translate([- 0.1, rodSurroundingDiameter + rodEarDistanceFromSide, rodSurroundingDiameter +
                surroundingDiameter
                + pinSize.x + threadedRodDiameter]
            ) cube([moduleWidth * 1.1, moduleLength - 2 *
                wallThickness - rodSurroundingDiameter - rodEarDistanceFromSide, moduleHeight - rodSurroundingDiameter -
                    wallThickness * 2 - pinSize.x - /* because we now have a perpendicularRodAlcove*/
                rodSurroundingDiameter
                ]);
        }
    }
}

module pinsPath(moduleWidth, moduleLength, moduleHeight) {
    translate([wallThickness - pinDepth, 0, radius + sizeOfEars]) rotate([90, 0, 90]) platePath(pathRadius, moduleLength
        - rodSurroundingDiameter * 4,
    wallThickness, pinSize.x, pinDepth);
}

module rodAlcoves(moduleWidth, moduleLength, moduleHeight) {
    rodAlcove(moduleWidth, moduleLength, moduleHeight);
    translate([0, moduleLength - (threadedRodDiameter + surroundingDiameter * 2), 0]) rodAlcove(moduleWidth,
    moduleLength, moduleHeight);
    translate([0, moduleLength - (threadedRodDiameter + surroundingDiameter * 2), moduleHeight - (threadedRodDiameter +
            surroundingDiameter * 2)]) rodAlcove(moduleWidth, moduleLength, moduleHeight);
}

module rodAlcove(moduleWidth, moduleLength, moduleHeight) {
    translate([0, (threadedRodDiameter + surroundingDiameter * 2) / 2, (threadedRodDiameter + surroundingDiameter * 2) /
        2])
        rotate([90, 0, 90])
            union() {
                difference() {
                    cylinder(d = threadedRodDiameter + surroundingDiameter * 2, h = moduleWidth, $fn = 100);
                    threadedRod(moduleWidth, moduleLength, moduleHeight);
                }
                //
            }
}

module perpendicularRodAlcove(moduleWidth, moduleLength, moduleHeight, nutHoles = true) {
    echo("In perpendicularRodAlcove, nutHoles is ", nutHoles);
    echo("In perpendicularRodAlcove, moduleLength is ", moduleLength);
    translate([0, moduleLength + 2 * rodSurroundingDiameter + threadedRodDiameter, threadedRodDiameter * 2 + 2 *
        surroundingDiameter])
        rotate([90, 0, 0])
            union() {/*
                difference() {
                    cylinder(d = threadedRodDiameter + surroundingDiameter * 2, h = moduleLength, $fn = 100);*/
                perpendicularThreadedRod(moduleWidth, moduleLength, moduleHeight);
                /**  }*/
                if (nutHoles) {
                    translate([0, 0, (moduleLength + surroundingDiameter)]) scale([m5NutScalingRatio, m5NutScalingRatio,
                        m5NutScalingRatio]) metric_nut(size = threadedRodDiameter, hole = false);
                } else {
                    echo("No need to worry, nutHoles is ", nutHoles);
                    // Let's make a longer hole, then, as we don't have a nut, we believe we need a traversing threaded rod
                    perpendicularThreadedRod(moduleWidth, moduleLength * 2, moduleHeight);
                }
            }
}

module perpendicularThreadedRod(moduleWidth, moduleLength, moduleHeight) {
    echo("In perpendicularThreadedRod, module Length is ", moduleLength);
    cylinder(d = threadedRodDiameterHole, h = moduleLength, $fn = 100);
}

module threadedRods(moduleWidth, moduleLength, moduleHeight) {
    union() {
        translate([- moduleWidth * .1, (threadedRodDiameter + surroundingDiameter * 2) / 2, (threadedRodDiameter +
                surroundingDiameter * 2) / 2])
            rotate([90, 0, 90])
                threadedRod(moduleWidth, moduleLength, moduleHeight);
        translate([- moduleWidth * .1, moduleLength - (threadedRodDiameter + surroundingDiameter * 2) / 2, (
            threadedRodDiameter +
                surroundingDiameter * 2) / 2])
            rotate([90, 0, 90])
                threadedRod(moduleWidth, moduleLength, moduleHeight);
        translate([- moduleWidth * .1, moduleLength - (threadedRodDiameter + surroundingDiameter * 2) / 2, moduleHeight
            - (threadedRodDiameter + surroundingDiameter * 2) / 2])            rotate([90, 0, 90])
            threadedRod(moduleWidth, moduleLength, moduleHeight);
    }
}

module threadedRod(moduleWidth, moduleLength, moduleHeight) {
    cylinder(d = threadedRodDiameterHole, h = moduleWidth * 1.2, $fn = 100);
}

module leftEar(moduleWidth, moduleLength, moduleHeight) {
    translate([- moduleWidth, 0, 0]) color("red") {
        translate([moduleWidth, rodEarDistanceFromSide, moduleHeight - rodEarDistanceFromSide]) rotate(a = 90, v
        = [0, 1, 0]) {
            difference() {
                scale([1.1, 1.1, 1.1])earLobe();
                scale([1.0, 1.0, 1.0])earInternals();
            }
        }
    }
}

module rightEar(moduleWidth, moduleLength, moduleHeight) {
    color("red") {
        translate([moduleWidth, rodEarDistanceFromSide, moduleHeight - rodEarDistanceFromSide]) rotate(a = 90, v
        = [0, 1, 0]) {
            ear(moduleWidth, moduleLength, moduleHeight);
        }
    }
}

module ear(moduleWidth, moduleLength, moduleHeight) {
    difference() {
        earLobe(moduleWidth, moduleLength, moduleHeight);
        earInternals(moduleWidth, moduleLength, moduleHeight);
    }
}

module earInternals(moduleWidth, moduleLength, moduleHeight) {
    translate([0, 0, - wallThickness]) cylinder(h = rodEarHeight + wallThickness + 1, d = threadedRodDiameter, $fn = 100
    );
}

module earLobe(moduleWidth, moduleLength, moduleHeight) {
    cylinder(h = rodEarHeight * .8, d = rodSurroundingDiameter, $fn = 100);
}

module strangePlate() {
    radius = 5;
    height = 3;
    color("blue") hull() {
        for (p = points) {
            translate(p) cylinder(r = radius, h = height);
        }
    }
}


module maleDovetails(width) {
    translate([0,-dovetailHeight,0]) union() {
        maleDovetail(width);
        translate([0, 0, (moduleHeight - dovetailMaleToFemaleRatio * (dovetailEnclosureWidth + dovetailBaseMaxWidth))])
            maleDovetail(width);
    }
}

module maleDovetail(width) {
    translate([width, dovetailHeight, dovetailMaleToFemaleRatio * dovetailEnclosureWidth]) rotate([180, 90, 0])
        linear_extrude(height =
        width)  scale([dovetailMaleToFemaleRatio, dovetailMaleToFemaleRatio])
            mainDovetailEnclosureDovetail();
}