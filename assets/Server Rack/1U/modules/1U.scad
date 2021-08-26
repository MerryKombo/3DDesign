include <module.scad>

//printBitsForChecking();
oneModuleJustForFun();

module oneModuleJustForFun() {
    translate([- moduleWidth * 1.1, 0, 0]) basicModule();
}

module printBitsForChecking() {
    union() {
        /*intersection() {
            basicModule();
            // Threaded rod insert
            translate([wallThickness, 0, 0]) cube([20, rodSurroundingDiameter + surroundingDiameter,
                    rodSurroundingDiameter
                    +
                    surroundingDiameter]);
        }/*
        intersection() {
            basicModule();
            // Male ear
            translate([moduleWidth - wallThickness, 0, moduleHeight - (rodSurroundingDiameter +
                wallThickness)]) cube([rodSurroundingDiameter + wallThickness,
                    rodSurroundingDiameter +
                    wallThickness, rodSurroundingDiameter +
                    wallThickness]);
            // Female ear
        }*/
        intersection() {
            basicModule();
            // Female ear
            translate([0, 0, moduleHeight - (rodSurroundingDiameter +
                wallThickness)]) cube([rodSurroundingDiameter + wallThickness,
                    rodSurroundingDiameter +
                    wallThickness, rodSurroundingDiameter +
                    wallThickness]);
        }
    }
}