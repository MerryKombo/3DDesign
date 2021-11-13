use <1U.scad>
include <ears.scad>
use <power-module/power-supply.scad>
include <power-module/power-supply-dimensions.scad>
include <fan/noctua-dimensions.scad>
use <switch-module/8-ports-gigabit-switch.scad>
use <switch-module/8-ports-fast-ethernet-switch.scad>

union() {
    for (a = [0:numberOfUnits - 1]) {
        translate([moduleWidth * a, 0, 0]) oneU();
    }
    ears();
    translate([0, moduleLength + fanEnclosureLength + 2 * dovetailHeight, 0]) powerSupplyModule(iec = true, psu = true,
    blower = true);
    translate([3 * moduleWidth, moduleLength + fanEnclosureLength + 2 * dovetailHeight, 0])
        eightPortsGigabitSwitchModule();
    translate([4 * moduleWidth, moduleLength + fanEnclosureLength + 2 * dovetailHeight, 0])
        eightPortsFastEthernetSwitchModule();
    //translate([moduleWidth * 5, 0, 0])oneU();
}