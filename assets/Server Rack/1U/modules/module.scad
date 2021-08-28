include <two-stories-module.scad>
include <module-dimensions.scad>
include <BOSL2/std.scad>
include <BOSL2/metric_screws.scad>
include <slider/slider dimensions.scad>

pathRadius = rodSurroundingDiameter * 1.125;
/*translate([0, - moduleHeight, 0]) platePath(pathRadius, moduleLength - 2 * (rodSurroundingDiameter + surroundingDiameter
), wallThickness, pinSize.x, pinDepth);*/
//basicModule();

module perpendicularRodAlcoves() {
    perpendicularRodAlcove();
    translate([moduleWidth, 0, 0]) perpendicularRodAlcove();
}

module basicModule() {
    difference() {
        union() {
            difference() {
                union() {
                    cube([moduleWidth, moduleLength, moduleHeight]);
                    rightEar();
                    //strangePlate();
                }
                pinsPath();
                translate([moduleWidth - wallThickness - (wallThickness - pinDepth) , 0, 0]) pinsPath();
                hollowOut();
                leftEar();
                perpendicularRodAlcoves();
            }
            rodAlcoves();
        }
        threadedRods();
    }
}

module hollowOut() {
    union() {
        translate([wallThickness, - wallThickness, - .1]) cube([moduleWidth - 2 * wallThickness, moduleLength + 10,
                moduleHeight + 1]);
        // Let's remove a big cube from left to right
        translate([- 0.1, rodSurroundingDiameter + rodEarDistanceFromSide, rodSurroundingDiameter + surroundingDiameter
            + pinSize.x + threadedRodDiameter]
        ) cube([moduleWidth * 1.1, moduleLength - 2 *
            wallThickness - rodSurroundingDiameter - rodEarDistanceFromSide, moduleHeight - rodSurroundingDiameter -
                wallThickness * 2 - pinSize.x - /* because we now have a perpendicularRodAlcove*/ rodSurroundingDiameter
            ]);
    }
}

module pinsPath() {
    translate([wallThickness - pinDepth, 0, radius + sizeOfEars]) rotate([90, 0, 90]) platePath(pathRadius, moduleLength
        - rodSurroundingDiameter * 4,
    wallThickness, pinSize.x, pinDepth);
}

module rodAlcoves() {
    rodAlcove();
    translate([0, moduleLength - (threadedRodDiameter + surroundingDiameter * 2), 0]) rodAlcove();
    translate([0, moduleLength - (threadedRodDiameter + surroundingDiameter * 2), moduleHeight - (threadedRodDiameter +
            surroundingDiameter * 2)]) rodAlcove();
}

module rodAlcove() {
    translate([0, (threadedRodDiameter + surroundingDiameter * 2) / 2, (threadedRodDiameter + surroundingDiameter * 2) /
        2])
        rotate([90, 0, 90])
            union() {
                difference() {
                    cylinder(d = threadedRodDiameter + surroundingDiameter * 2, h = moduleWidth, $fn = 100);
                    threadedRod();
                }
                //
            }
}

module perpendicularRodAlcove() {
    translate([0, moduleLength + 2 * rodSurroundingDiameter + threadedRodDiameter, threadedRodDiameter * 2 + 2 *
        surroundingDiameter])
        rotate([90, 0, 0])
            union() {/*
                difference() {
                    cylinder(d = threadedRodDiameter + surroundingDiameter * 2, h = moduleLength, $fn = 100);*/
                perpendicularThreadedRod();
                /**  }*/
                translate([0, 0, (moduleLength + surroundingDiameter)]) scale([1.1, 1.1, 1.1]) metric_nut(size =
                threadedRodDiameter, hole =
                false);
            }
}

module perpendicularThreadedRod() {
    cylinder(d = threadedRodDiameterHole, h = moduleLength, $fn = 100);
}

module threadedRods() {
    union() {
        translate([- moduleWidth * .1, (threadedRodDiameter + surroundingDiameter * 2) / 2, (threadedRodDiameter +
                surroundingDiameter * 2) / 2])
            rotate([90, 0, 90])
                threadedRod();
        translate([- moduleWidth * .1, moduleLength - (threadedRodDiameter + surroundingDiameter * 2) / 2, (
            threadedRodDiameter +
                surroundingDiameter * 2) / 2])
            rotate([90, 0, 90])
                threadedRod();
        translate([- moduleWidth * .1, moduleLength - (threadedRodDiameter + surroundingDiameter * 2) / 2, moduleHeight
            - (threadedRodDiameter + surroundingDiameter * 2) / 2])            rotate([90, 0, 90])
            threadedRod();
    }
}

module threadedRod() {
    cylinder(d = threadedRodDiameterHole, h = moduleWidth * 1.2, $fn = 100);
}

module leftEar() {
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

module rightEar() {
    color("red") {
        translate([moduleWidth, rodEarDistanceFromSide, moduleHeight - rodEarDistanceFromSide]) rotate(a = 90, v
        = [0, 1, 0]) {
            ear();
        }
    }
}

module ear() {
    difference() {
        earLobe();
        earInternals();
    }
}

module earInternals() {
    translate([0, 0, - wallThickness]) cylinder(h = rodEarHeight + wallThickness + 1, d = threadedRodDiameter, $fn = 100
    );
}

module earLobe() {
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