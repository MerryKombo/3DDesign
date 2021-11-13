include <module.scad>
include <slider/slider.scad>
include <fan/noctua.scad>
include <power-and-fan/fan-and-power.scad>

//printBitsForChecking();

module oneU() {
    oneModuleJustForFun();
    // color("DarkKhaki") translate([(moduleWidth - fanEnclosureWidth) / 2, moduleLength, 0]) fanEnclosure();
    translate([0, moduleLength /*+ fanEnclosureLength+ dovetailHeight*/, 0]) fanAndPowerEnclosure(moduleWidth,
    fanEnclosureLength, moduleHeight);
}

module oneModuleJustForFun() {
    /*translate([- moduleWidth * 1.1, 0, 0]) */ basicModule(moduleWidth, moduleLength, moduleHeight);
    /*color("red") translate([wallThickness, rodSurroundingDiameter + surroundingDiameter, threadedRodDiameter + .6])
        rotate([90, 0, 0])
            sliderWithPins();*/
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