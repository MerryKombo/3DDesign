include <module.scad>
include <slider/slider.scad>
use <fans/sunon-pf40281bx-d060-s99.scad>
include <fans/sunon-pf40281bx-d060-s99-dimensions.scad>
use <NopSCADlib/vitamins/rod.scad>
include <BOSL2/metric_screws.scad>

//include <power-and-fan/fan-and-power.scad>

//printBitsForChecking();
//oneU();
        oneModuleJustForFun();

module oneU() {
    union() {
        oneModuleJustForFun();
        // color("DarkKhaki") translate([(moduleWidth - fanEnclosureWidth) / 2, moduleLength, 0]) fanEnclosure();
        /*translate([0, moduleLength + dovetailHeight/*+ fanEnclosureLength*//*, 0]) fanAndPowerEnclosure(moduleWidth,
    fanEnclosureLength, moduleHeight);*/
        translate([0, moduleLength, 0]) fanEnclosure();
        /*studding(5, 80);*/
        oneURods();
        /*translate([moduleWidth, fanEnclosureLength, 0])leadscrew(5, 80, 3, 4, center = true);*/
    }
}

module oneURods() {
    union() {
        oneUFrontToRearRods();
        oneULeftToRightRods();
    }
}

module oneULeftToRightRods() {
    union() {
        oneULeftToRightRod();
        translate([0, moduleLength - (rodSurroundingDiameter + surroundingDiameter), 0]) oneULeftToRightRod();
        translate([0, moduleLength - (rodSurroundingDiameter + surroundingDiameter), moduleHeight - (
            rodSurroundingDiameter + surroundingDiameter)]) oneULeftToRightRod();
        translate([0, moduleLength - (rodSurroundingDiameter + surroundingDiameter) + fanEnclosureLength +
            dovetailHeight, 0]) oneULeftToRightRod();
        translate([0, moduleLength - (rodSurroundingDiameter + surroundingDiameter) + fanEnclosureLength +
            dovetailHeight, moduleHeight - (rodSurroundingDiameter + surroundingDiameter)]) oneULeftToRightRod();
    }
}

module oneULeftToRightRod() {
    union() {
        translate([0, surroundingDiameter, surroundingDiameter])
            translate([- get_metric_nut_thickness(threadedRodDiameter), threadedRodDiameter / 2, threadedRodDiameter / 2
                ])
                rotate([0, 90, 0])
                    rod(threadedRodDiameter, moduleWidth + 2 * get_metric_nut_thickness(threadedRodDiameter), center =
                    false
                    );
        translate([0, surroundingDiameter + threadedRodDiameter / 2, surroundingDiameter + threadedRodDiameter / 2])
            translate([- get_metric_nut_thickness(threadedRodDiameter) / 2, 0, 0])
                rotate([0, 90, 0])
                    color(grey(80))  metric_nut(size = threadedRodDiameter, hole = true);
    }
}

module oneUFrontToRearRods() {
    union() {
        oneUFrontToRearRod();
        translate([moduleWidth, 0, 0]) oneUFrontToRearRod();
    }
}

module oneUFrontToRearRod() {
    translate([0, 2 * rodSurroundingDiameter + threadedRodDiameter - get_metric_nut_thickness(threadedRodDiameter),
                threadedRodDiameter * 2 + 2 * surroundingDiameter])
        rotate([- 90, 0, 0])
            union() {
                rod(threadedRodDiameter, moduleLength + fanEnclosureLength, center = false);
                color(grey(80)) translate([0, 0, get_metric_nut_thickness(threadedRodDiameter) / 2]) metric_nut(size
                = threadedRodDiameter, hole = true);
            }
}

module oneModuleJustForFun() {
    /*translate([- moduleWidth * 1.1, 0, 0]) */ basicModule(moduleWidth, moduleLength, moduleHeight);
    translate([wallThickness, rodSurroundingDiameter + surroundingDiameter, threadedRodDiameter + .6])
        rotate([90, 0, 0]) sliderWithPins();
}

module printBitsForChecking() {
    union() {
        /*
        translate([threadedRodDiameter * 2, 0, 0])intersection() {
        basicModule();
        // Threaded rod insert
        translate([wallThickness, 0, 0]) cube([20, rodSurroundingDiameter + surroundingDiameter,
            rodSurroundingDiameter
            +
            surroundingDiameter]);
        }
        intersection() {
        basicModule();
        // Male ear
        translate([moduleWidth - wallThickness, 0, moduleHeight - (rodSurroundingDiameter +
        wallThickness)]) cube([rodSurroundingDiameter + wallThickness,
            rodSurroundingDiameter +
            wallThickness, rodSurroundingDiameter +
            wallThickness]);
        // Female ear
        }
        intersection() {
        basicModule();
        // Female ear
        translate([0, 0, moduleHeight - (rodSurroundingDiameter +
        wallThickness)]) cube([rodSurroundingDiameter + wallThickness,
            rodSurroundingDiameter +
            wallThickness, rodSurroundingDiameter +
            wallThickness]);
        }
        intersection() {
        basicModule();
        // Left Pins path and perpendicular Rod Alcove
        translate([0, 0, 0]) cube([rodSurroundingDiameter + wallThickness,
        moduleLength, rodSurroundingDiameter * 2 + threadedRodDiameter]);
        }
        intersection() {
        basicModule();
        // Right Pins path and perpendicular Rod Alcove
        translate([moduleWidth - wallThickness - threadedRodDiameter, 0, 0]) cube([rodSurroundingDiameter +
        wallThickness, moduleLength, rodSurroundingDiameter * 2 + threadedRodDiameter]);
        }*/
        /*
                intersection() {
                    basicModule();
                    // Just the RIGHT nut housing
                    translate([moduleWidth - wallThickness - surroundingDiameter, 0, 0]) cube([rodSurroundingDiameter +
                        wallThickness, rodSurroundingDiameter * 2 + wallThickness * 2, rodSurroundingDiameter * 2 +
                        wallThickness]);
                }*/
        intersection() {
            translate([moduleWidth, 0, 0]) basicModule();
            // Just the left nut housing
            translate([moduleWidth - wallThickness, 0, 0]) cube([rodSurroundingDiameter + wallThickness,
                        rodSurroundingDiameter * 2 + wallThickness * 2, rodSurroundingDiameter * 2 + wallThickness])
                ;
        }

    }
}