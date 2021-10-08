include <../module-dimensions.scad>
include <../module.scad>
include <8-ports-gigabit-switch-dimensions.scad>
include <../../boards/8-ports-gigabit-switch.scad>

eightPortsGigabitSwitchModule();
// eightPortsGigabitSwitchPCB();

module eightPortsGigabitSwitchModule() {
    union() {
        basicModule(eightPortsGigabitSwitchModuleWidth, eightPortsGigabitSwitchModuleLength, moduleHeight, pinsPath =
        false, nutRecess = false, rearDovetails = false, frontDovetails = true);
        xMove = (eightPortsGigabitSwitchModuleWidth - eightPortsGigabitSwitchWidth - wallThickness * 2) / 2;
        yMove = (eightPortsGigabitSwitchModuleLength - eightPortsGigabitSwitchLength - (rodSurroundingDiameter +
            surroundingDiameter) * 2) / 2;
        translate([wallThickness + xMove, rodSurroundingDiameter + surroundingDiameter + yMove, 0])
            eightPortsGigabitSwitchPCB();
    }
}

module eightPortsGigabitSwitchPCB() {
    translate([eightPortsGigabitSwitchWidth, 0, 0])
        rotate([0, 0, 90])
            union() {
                translate([0, 0, totalHeight])
                    color("#296E01") difference() {
                    cube([eightPortsGigabitSwitchLength, eightPortsGigabitSwitchWidth, 1.6]);
                    for (currentPoint = eightPortsGigabitSwitchHoles) {
                        translate([currentPoint.x, currentPoint.y, - moduleHeight / 2]) cylinder(d =
                        eightPortsGigabitSwitchHolesDiameter, h = moduleHeight, $fn = 100);
                    }
                }
                eightPortsGigabitSwitchPCBFeet();
            }
}

module eightPortsGigabitSwitchPCBFeet() {
    translate([eightPortsGigabitSwitchDistanceFromEdgeX, eightPortsGigabitSwitchDistanceFromEdgeY,])
        eight_ports_gigabit_switch_feet_bracket();
}