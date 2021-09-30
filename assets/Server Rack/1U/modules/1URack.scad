include <1U.scad>
include <ears.scad>
include <power-module/power-supply.scad>

union() {
    for (a = [0:numberOfUnits - 1]) {
        translate([moduleWidth * a, 0, 0]) oneU();
    }
    ears();
    translate([0, moduleLength + fanEnclosureLength + 2 * dovetailHeight, 0]) powerSupplyModule();

    //translate([moduleWidth * 5, 0, 0])oneU();
}