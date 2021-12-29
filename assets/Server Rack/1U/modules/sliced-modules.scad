use <module.scad>
include <module-dimensions.scad>
include <slider/slider dimensions.scad>

reinforcementRodDiameter = 3;
moduleTopPartHeight = moduleHeight - (
// The bottom part
    (rodSurroundingDiameter + surroundingDiameter + pinSize.x + threadedRodDiameter) +
    // The middle part
    (moduleHeight - rodSurroundingDiameter - wallThickness * 2 - pinSize.x - rodSurroundingDiameter));

justTheArms();
//two_parts();

module justTheArms() {
    union() {
        color("white") translate([0, wallThickness * 3, 0])
            intersection() {
                slicedModuleFront(moduleWidth, moduleLength, moduleHeight, pinsPath = true, nutRecess = true,
                frontDovetails
                =
                true,
                frontDovetailSupport = true, frontRod = true);
                translate([0, moduleLength / 2, moduleHeight - moduleTopPartHeight])
                    union() {
                        cube(size = [wallThickness, 4.5 * wallThickness, moduleTopPartHeight]);
                        translate([moduleWidth - wallThickness, 0, 0])
                            cube(size = [wallThickness, 4.5 * wallThickness, moduleTopPartHeight]);
                    }
            }
        /*color("blue")*/
        intersection() {
            translate([0, 0, 0])
                slicedModuleRear(moduleWidth, moduleLength, moduleHeight, pinsPath = true, nutRecess = true,
                rearDovetails =
                true,
                frontDovetailSupport = false, frontRod = false);
            translate([0, moduleLength / 2 + 2.5 * wallThickness, moduleHeight - moduleTopPartHeight])
                union() {color("blue")
                    cube(size = [wallThickness, 4.5 * wallThickness, moduleTopPartHeight]);
                    translate([moduleWidth - wallThickness, 0, 0])
                        cube(size = [wallThickness, 4.5 * wallThickness, moduleTopPartHeight]);
                }

        }
    }
}

module two_parts() {
    union() {
        color("white")
            slicedModuleFront(moduleWidth, moduleLength, moduleHeight, pinsPath = true, nutRecess = true, frontDovetails
            =
            true,
            frontDovetailSupport = true, frontRod = true);

        /*color("blue")*/
        translate([0, moduleLength / 2, 0])
            slicedModuleRear(moduleWidth, moduleLength, moduleHeight, pinsPath = true, nutRecess = true, rearDovetails =
            true,
            frontDovetailSupport = false, frontRod = false);
    }
}

module slicedModuleFront(moduleWidth, moduleLength, moduleHeight, pinsPath = true, nutRecess = true, frontDovetails =
false, frontDovetailSupport = false, frontRod = true) {
    // Then we remove half of it, the "tail"
    moduleTopPartHeight = moduleHeight - (
    // The bottom part
        (rodSurroundingDiameter + surroundingDiameter + pinSize.x + threadedRodDiameter) +
        // The middle part
        (moduleHeight - rodSurroundingDiameter - wallThickness * 2 - pinSize.x - rodSurroundingDiameter));
    union() {
        // Let's now build some vertical reinforcements with a hole for a screw
        slicedModuleFrontVerticalReinforcements();
        slicedModuleFrontHorizontalReinforcements();
        difference() {
            // We start from the standard module
            basicModule(moduleWidth, moduleLength, moduleHeight, pinsPath, nutRecess, rearDovetails = false,
            frontDovetails, frontDovetailSupport, frontRod);
            translate([- 0.1, moduleLength / 2, - 0.1])
                difference() {
                    union() {
                        // A big chunky cube to remove most of the rear²
                        scale([1.1, 1.1, 1.0])
                            color("black")
                                cube(size = [moduleWidth, moduleLength / 2 + dovetailHeight, moduleHeight -
                                    moduleTopPartHeight]
                                );
                        // Now, let's keep 1/10th of the top part, and make something funky with it
                        color("black") scale([1.1, 1.1, 1.1])
                            translate([0, moduleLength / 10, 0])
                                cube(size = [moduleWidth, moduleLength / 2 + dovetailHeight, moduleHeight]);

                        // The arms
                        union() {
                            translate([0.1, 0, 0]) scale([1.1, 1, 1])
                                slicedModuleArms(moduleHeight, moduleTopPartHeight);
                            translate([0.1, 0, 0.2]) scale([1.1, 1, 1])
                                slicedModuleArms(moduleHeight, moduleTopPartHeight);
                        }
                        translate([moduleWidth - wallThickness - 0.1, 0, 0])
                            union() {
                                translate([0.1, 0, 0]) scale([1.1, 1, 1])
                                    slicedModuleArms(moduleHeight, moduleTopPartHeight);
                                translate([0.1, 0, 0.2]) scale([1.1, 1, 1])
                                    slicedModuleArms(moduleHeight, moduleTopPartHeight);
                            }
                    }
                }
            // And then me make holes to host a threaded rod
            //slicedModuleFrontTopRods(moduleWidth);
        }
        /*mirror([0, 0, 1])*/
        //slicedModuleArms(moduleHeight, moduleTopPartHeight);
    }
}

module slicedModuleArms(moduleHeight, moduleTopPartHeight) {
    /**/
    union() {
        union() {
            color("black") translate([0, 0, moduleHeight - moduleTopPartHeight])
                cube(size = [wallThickness / 2, wallThickness, moduleTopPartHeight]);
            color("blue") translate([wallThickness / 2, wallThickness * 2, moduleHeight -
                moduleTopPartHeight])
                cube(size = [wallThickness / 2, wallThickness, moduleTopPartHeight]);
            color("red") translate([wallThickness / 2, moduleLength / 10, moduleHeight -
                    moduleTopPartHeight / 2])
                cube(size = [wallThickness / 2, wallThickness, moduleTopPartHeight / 2]);
            color("white") translate([0, moduleLength / 10 - wallThickness, moduleHeight -
                    moduleTopPartHeight / 2])
                cube(size = [wallThickness / 2, wallThickness, moduleTopPartHeight / 2]);
            color("brown") translate([0, moduleLength / 10 - 2 * wallThickness, moduleHeight -
                    moduleTopPartHeight / 2])
                cube(size = [wallThickness / 2, wallThickness, moduleTopPartHeight / 2]);
        }
        color("white") translate([0, wallThickness / 2, moduleHeight - moduleTopPartHeight / 4]) rotate([0, 90, 0])
            cylinder(d =
            3, h = wallThickness * 2, $fn = 100);
        color("red") translate([0, moduleLength / 10 - wallThickness / 2, moduleHeight - moduleTopPartHeight +
                moduleTopPartHeight / 4])
            rotate([0, 90, 0])cylinder(d =
            3, h = wallThickness * 2, $fn = 100);
    }
}

module slicedModuleRear(moduleWidth, moduleLength, moduleHeight, pinsPath = true, nutRecess = true, frontDovetails =
false, rearDovetails, frontDovetailSupport = false, frontRod = false) {
    moduleTopPartHeight = moduleHeight - (
    // The bottom part
        (rodSurroundingDiameter + surroundingDiameter + pinSize.x + threadedRodDiameter) +
        // The middle part
        (moduleHeight - rodSurroundingDiameter - wallThickness * 2 - pinSize.x - rodSurroundingDiameter));
    union() {
        // change to difference asap
        difference() {
            union() {
                // Let's now build some vertical reinforcements with a hole for a screw
                translate([0, rodSurroundingDiameter + rodEarDistanceFromSide + wallThickness / 5, 0])
                    slicedModuleFrontVerticalReinforcements();
                translate([moduleWidth, moduleLength + (rodSurroundingDiameter + rodEarDistanceFromSide), 0])
                    rotate([0, 0, 180]) slicedModuleFrontHorizontalReinforcements();
                difference() {
                    // We start from the standard module
                    basicModule(moduleWidth, moduleLength, moduleHeight, pinsPath, nutRecess, rearDovetails = false,
                    frontDovetails, frontDovetailSupport, frontRod);
                    // Then we remove half of it, the "head"
                    translate([- 0.1, 0, - 0.1])
                        scale([1.1, 1.1, 1.1])
                            color("black")
                                cube(size = [moduleWidth, moduleLength / 2 + dovetailHeight, moduleHeight]);
                    // And then me make holes to host a threaded rod
                    /*translate([0, - moduleLength / 4 + (rodSurroundingDiameter + rodEarDistanceFromSide) - 0.2, 0])
                        slicedModuleRearTopRods(moduleWidth);*/
                }
            }
            color("orange")
                union() {
                    translate([0, moduleLength / 2 + 2.5 * wallThickness, moduleHeight - moduleTopPartHeight])
                        cube(size = [wallThickness, 4.5 * wallThickness, moduleTopPartHeight]);
                    translate([moduleWidth - wallThickness, moduleLength / 2 + 2.5 * wallThickness, moduleHeight -
                        moduleTopPartHeight])
                        cube(size = [wallThickness, 4.5 * wallThickness, moduleTopPartHeight]);
                }
        }
        translate([0, moduleLength / 2 + 3 * wallThickness, 0])
            union() {
                // The arms
                union() {
                    translate([0.1, 0, 0]) scale([1.1, 1, 1])
                        slicedModuleArms(moduleHeight, moduleTopPartHeight);
                    translate([0.1, 0, 0.2]) scale([1.1, 1, 1])
                        slicedModuleArms(moduleHeight, moduleTopPartHeight);
                }
                translate([moduleWidth - wallThickness - 0.1, 0, 0])
                    union() {
                        translate([0.1, 0, 0]) scale([1.1, 1, 1])
                            slicedModuleArms(moduleHeight, moduleTopPartHeight);
                        translate([0.1, 0, 0.2]) scale([1.1, 1, 1])
                            slicedModuleArms(moduleHeight, moduleTopPartHeight);
                    }
            }
    }
}
module slicedModuleFrontHorizontalReinforcements() {
    translate([0, moduleLength / 2 - wallThickness, moduleHeight - wallThickness / 5])
        difference() {
            union() {
                // The flat link between the two sides
                cube([moduleWidth, wallThickness, wallThickness / 5]);
                // The vertical part that will host the screw
                translate([moduleWidth / 2, wallThickness - wallThickness / 5, - wallThickness / 2])
                    hull() {
                        // The main round part for the screw hole
                        translate([wallThickness / 2, 0, 0])
                            rotate([- 90, 0, 0]) cylinder(d = wallThickness, h = wallThickness / 5, $fn = 100);
                        // linked to a rectangle
                        cube([wallThickness, wallThickness / 5, wallThickness / 2]);
                        // and then linked to two "chamfers"
                        translate([- wallThickness / 2, 0, 0])
                            difference() {
                                cube([wallThickness, wallThickness / 5, wallThickness / 2]);
                                translate([0, - .1, 0]) rotate([- 90, 0, 0])
                                    cylinder(d = wallThickness, h = wallThickness, $fn = 100);
                            }
                        translate([wallThickness * 1.5, wallThickness / 5, 0]) rotate([0, 0, 180]) difference() {
                            cube([wallThickness, wallThickness / 5, wallThickness / 2]);
                            translate([0, - .1, 0]) rotate([- 90, 0, 0])
                                cylinder(d = wallThickness, h = wallThickness, $fn = 100);
                        }
                        // and linked to the quarter of a ball
                        translate([wallThickness / 2, 0, 0])
                            difference() {
                                sphere(d = wallThickness, $fn = 100);
                                translate([- wallThickness, 0, - wallThickness])
                                    cube(size = [wallThickness * 2, wallThickness, wallThickness * 2]);
                            }
                    }
            }
            // The screw hole
            translate([moduleWidth / 2 + wallThickness / 2, wallThickness * 2, - wallThickness / 2]) union() {
                // The hole
                color("blue")
                    rotate([90, 0, 0])
                        cylinder(d = reinforcementRodDiameter * 1.05, h = wallThickness * 2, $fn = 100);
                // We need a flat for the screw head to rest one
                translate([0, - wallThickness * 1.5, 0])
                    rotate([90, 0, 0])
                        cylinder(d = wallThickness, h = wallThickness / 5, $fn = 100);
            }
        }
}

module slicedModuleFrontVerticalReinforcements() {
    union() {
        slicedModuleFrontVerticalReinforcement();
        translate([moduleWidth - wallThickness, 0, 0]) slicedModuleFrontVerticalReinforcement();
    }
}

module slicedModuleFrontVerticalReinforcement() {
    translate([0, moduleLength / 2 - wallThickness / 5, rodSurroundingDiameter + surroundingDiameter + pinSize.x +
        threadedRodDiameter])
        difference() {
            color("black")
                cube(size = [wallThickness, wallThickness / 5, moduleHeight - rodSurroundingDiameter - wallThickness * 2
                    - pinSize.x - rodSurroundingDiameter]);
            color("blue") translate([wallThickness / 2, wallThickness, wallThickness])
                rotate([90, 0, 0])
                    cylinder(d = reinforcementRodDiameter * 1.05, h = 2 * wallThickness, $fn = 100);
        }
}

module slicedModuleRearTopRods(moduleWidth) {
    translate([0, moduleLength / 2, 0])
        union() {
            slicedModuleFrontTopRod();
            translate([moduleWidth - wallThickness, 0, 0]) slicedModuleFrontTopRod();
        }
}

module slicedModuleFrontTopRods(moduleWidth) {
    slicedModuleFrontTopRod();
    translate([moduleWidth - wallThickness, 0, 0]) slicedModuleFrontTopRod();
}

module slicedModuleFrontTopRod() {
    color("blue")
        translate([wallThickness / 2, moduleLength / 4 + .1, moduleHeight - reinforcementRodDiameter])
            rotate([- 90, 0, 0])
                cylinder(d = reinforcementRodDiameter * 1.05, h = moduleLength / 4, $fn = 100);
}