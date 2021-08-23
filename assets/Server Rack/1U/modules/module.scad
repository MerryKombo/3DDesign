include <two-stories-module.scad>
include <module-dimensions.scad>

basicModule();

module basicModule() {
    difference() {
        union() {
            difference() {
                union() {
                    cube([moduleWidth, moduleLength, moduleHeight]);
                    ears();
                    strangePlate();
                }
                pinsPath();
                hollowOut();
            }
            rodAlcoves();
        }
        threadedRods();
    }
}

module hollowOut() {
    translate([wallThickness, - wallThickness, - .1]) cube([moduleWidth - 2 * wallThickness, moduleLength + 1,
            moduleHeight
            + 1]);
}

module pinsPath() {
    translate([wallThickness - width + 1.1, 0, radius + sizeOfEars]) rotate([90, 0, 90]) platePath(radius,
    firstArcAngles, secondArcAngles, thirdArcAngles, trackLength, width);
}

module rodAlcoves() {
    rodAlcove();
    translate([0, moduleLength - (threadedRodDiameter + surroundingDiameter * 2) , 0]) rodAlcove();
}

module rodAlcove() {
    translate([0, (threadedRodDiameter + surroundingDiameter * 2) / 2, (threadedRodDiameter + surroundingDiameter * 2) /
        2])
        rotate([90, 0, 90])
            difference() {
                cylinder(d = threadedRodDiameter + surroundingDiameter * 2, h = moduleWidth);
                threadedRod();
            }
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
    }
}

module threadedRod() {
    cylinder(d = threadedRodDiameter, h = moduleWidth * 1.2, $fn = 100);
}

module ears() {
    color("red") {
        translate([moduleWidth, rodEarDistanceFromSide, moduleHeight - rodEarDistanceFromSide]) rotate(a = 90, v
        = [
            0, 1, 0]) {
            difference() {
                cylinder(rodEarHeight, r = rodSurroundingDiameter, $fn = 100);
                translate([0, 0, - wallThickness]) cylinder(rodEarHeight + wallThickness + 1, r =
                threadedRodDiameter, $fn = 100);
            }
        }
    }
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