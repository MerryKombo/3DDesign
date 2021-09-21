include <module-dimensions.scad>
include <module.scad>

//ears();
//earFacePlate();

module ears() {
    union() {
        leftModuleEar();
        rightModuleEar();
    }
}
module leftModuleEar() {
    translate([- moduleWidth, 0, 0])
        union() {
            difference() {
                basicModule(moduleWidth, moduleLength, moduleHeight, pinsPath = false, nutRecess = true);
                translate([- wallThickness * 2, 0, 0]) hollowOut(moduleWidth + wallThickness * 2, moduleLength +
                    wallThickness, moduleHeight, false);
                translate([wallThickness, moduleLength, 0]) cube([moduleWidth, dovetailHeight, moduleHeight]);
            }
            earFacePlate();
        }
}

module rightModuleEar() {
    translate([moduleWidth*numberOfUnits, 0, 0])
        union() {
            difference() {
                basicModule(moduleWidth, moduleLength, moduleHeight, pinsPath = false, nutRecess = true);
                // let's remove a big chunk in the middle
                translate([0, 0, 0]) hollowOut(moduleWidth + wallThickness * 2, moduleLength +
                    wallThickness, moduleHeight, false);
                // let's remove the dovetails
                translate([0, moduleLength, 0]) cube([moduleWidth, dovetailHeight, moduleHeight]);
            }
            translate([moduleWidth, 0, moduleHeight])
                rotate([0, 180, 0]) earFacePlate();
        }
}

module earFacePlate() {
    translate([moduleWidth - (earsWidth + wallThickness), - wallThickness, 0])
        difference() {
            union() {
                cube([earsWidth + wallThickness, wallThickness, moduleHeight]);
            }
            earFacePlateHoles();
        }
}

module earFacePlateHoles() {
    earFaceMiddleHole();
    translate([0, 0, earsBetweenHolesDistance]) earFaceMiddleHole();
    translate([0, 0, - earsBetweenHolesDistance]) earFaceMiddleHole();
}

module earFaceMiddleHole() {
    hull() {
        translate([- earsHoleDiameter / 4, 0, 0]) mainEarFaceMiddleHole();
        mainEarFaceMiddleHole();
        translate([earsHoleDiameter / 4, 0, 0]) mainEarFaceMiddleHole();
    }
}

module mainEarFaceMiddleHole() {
    translate([(earsWidth - earsHoleDiameter) / 2, 0, (moduleHeight - earsHoleDiameter) / 2 + (earsHoleDiameter / 2)])
        rotate([90, 0, 0])  translate([
                earsHoleDiameter / 2, 0, 0]) cylinder(h = moduleLength, r = earsHoleDiameter / 2,
        center = true, $fn = 100);
}