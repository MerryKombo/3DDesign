use <../module.scad>
include <../module-dimensions.scad>
include <./sunon-pf40281bx-d060-s99-dimensions.scad>
include <../dovetails/dovetails.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/fan.scad>

//fanSuspender();
//fanSuspenders();
//fanCradle();
fanEnclosure(displayFan=false);
//translate(centeredFanTranslationBehindTheEnclosure) fan();
//sunonPf40281bxD060S99Fan();
//fanScrewHoles();
/*union() {
    fanCradle();
    translate(fanTranslationVector) fan();
}*/

module fanEnclosure(displayFan = true) {
    fanCradleDepth = fanDepth / fanEnclosureRatio + wallThickness;
    yTranslation = (fanEnclosureLength - fanCradleDepth) / 2;
    difference() {
        union() {
            difference() {
                fanModule(moduleWidth, fanEnclosureLength, moduleHeight);

                linear_extrude(height = moduleHeight) projection() translate([wallThickness / 2, yTranslation, 0])
                    translate(fanTranslationVector)scale([1, 1.03, 1])
                        sunonPf40281bxD060S99Fan();
            }
            translate([wallThickness / 2, yTranslation, 0]) union() {
                fanCradle();
                if (displayFan) {
                    translate(fanTranslationVector) sunonPf40281bxD060S99Fan();
                }
            }
        }
        fanPerpendicularRodAlcoves(moduleWidth, fanEnclosureLength, moduleHeight);
    }
}

module fanCradle(displaySuspenders = true) {
    union() {
        difference() {
            // The main part, the big cube that we will dig in
            cube(size = fanCradleSize, center = false);
            // The first hole, from the top to the bottom
            translate([wallThickness / 2, wallThickness / 2, wallThickness / 2 - fanScrewHolePad]) cube(size = [fanWidth
                /
                fanEnclosureRatio
                , fanDepth /
                    fanEnclosureRatio, fanWidth / fanEnclosureRatio],
            center = false);
            translate([wallThickness / 2, - 0.1, wallThickness / 2]) cube(size = [fanWidth / fanEnclosureRatio, fanDepth
                /
                fanEnclosureRatio + wallThickness + 0.2, fanWidth / fanEnclosureRatio -
                wallThickness], center
            = false);
            translate([- 0.1, wallThickness / 2, wallThickness / 2]) cube(size = [fanWidth / fanEnclosureRatio +
                wallThickness + 0.2, fanDepth / fanEnclosureRatio, fanWidth / fanEnclosureRatio -
                wallThickness], center
            = false);
            translate([0, - wallThickness, 0])
                translate(fanTranslationVector)
                    union() {
                        fanBlades();
                        for (currentHole = fanScrewHoles) {
                            if (currentHole.z > fanScrewHolePad)
                                translate(currentHole) elongatedScrewHole();
                            else
                                translate(currentHole) fanScrewHole();
                        }
                    }
        }
        fanCradleLegs();
        fanCradlePads();
    }
}

module fanCradleLegs() {
    union() {
        fanCradleLeg();
        translate([0, fanCradleSize.y - wallThickness / 2, 0]) fanCradleLeg();
    }
}

module fanCradleLeg() {
    translate([fanCradleSize.x, 0, 0])
        cube(size = [moduleWidth - (fanCradleSize.x + wallThickness * 1.5), wallThickness / 2, wallThickness / 2]);
}

module fanCradlePads() {
    union() {
        fanCradlePad();
        translate([0, fanDepth / fanEnclosureRatio + wallThickness / 2, 0]) fanCradlePad();
    }
}

module fanCradlePad() {
    difference() {
        cube(size = [fanWidth / fanEnclosureRatio + wallThickness, wallThickness / 2, fanHeight / fanEnclosureRatio]);
        translate([0, - wallThickness, 0])
            translate(fanTranslationVector)
                union() {
                    fanBlades();
                    for (currentHole = fanScrewHoles) {
                        if (currentHole.z > fanScrewHolePad)
                            translate(currentHole) elongatedScrewHole();
                        else
                            translate(currentHole) fanScrewHole();
                    }
                }
    }
}

module fanModule(moduleWidth, fanEnclosureLength, moduleHeight) {
    translate([0, dovetailHeight, 0]) difference() {
        union() {
            basicModule(moduleWidth, fanEnclosureLength, moduleHeight, false, false, frontDovetails = true,
            frontDovetailSupport = true, frontRod = false);
            translate([0, (threadedRodDiameter + surroundingDiameter * 2) / 2, (threadedRodDiameter +
                    surroundingDiameter * 2) / 2]) difference() {
                rotate([90, 0, 90]) scale([1, 1, 1 / 1.2]) threadedRod(moduleWidth, fanEnclosureLength, moduleHeight);
                translate([wallThickness, - threadedRodDiameter / 2, - threadedRodDiameter / 2]) cube(size = [
                        moduleWidth - 2 * wallThickness, threadedRodDiameterHole, threadedRodDiameterHole]);
            }
        }
        // Hollow out so that we dont get a threaded rod insert that blocks the fan bottom
        //hollowOutFanModule(moduleWidth, fanEnclosureLength, moduleHeight);
        // We need the threaded rod path to clear the whole rodEarDistanceFromSide
        fanPerpendicularRodAlcoves(moduleWidth, fanEnclosureLength, moduleHeight);
    }
}

module hollowOutFanModule(moduleWidth, fanEnclosureLength, moduleHeight) {
    //translate([wallThickness, dovetailHeight, 0]) cube([fanCradleSize.x - wallThickness / 2, fanCradleSize.y, fanCradleSize.z]);
    translate([wallThickness, 0, 0]) cube([moduleWidth - 2 * wallThickness, rodSurroundingDiameter + surroundingDiameter
        , rodSurroundingDiameter + surroundingDiameter]);
}

module fanPerpendicularRodAlcoves(moduleWidth, moduleLength, moduleHeight, nutHoles = true) {
    echo("In fanPerpendicularRodAlcoves, nutHoles is ", nutHoles);
    fanPerpendicularRodAlcove(moduleWidth, moduleLength, moduleHeight, nutHoles);
    translate([moduleWidth, 0, 0]) fanPerpendicularRodAlcove(moduleWidth, moduleLength, moduleHeight, nutHoles);
}

module fanPerpendicularRodAlcove(moduleWidth, moduleLength, moduleHeight, nutHoles = true) {
    echo("In fanPerpendicularRodAlcove, nutHoles is ", nutHoles);
    translate([- 0, moduleLength, threadedRodDiameter * 2 + 2 * surroundingDiameter])        rotate([90, 0, 0])
        perpendicularThreadedRod(moduleWidth, moduleLength, moduleHeight);
}

module fanScrewHole() {
    translate([0, fanWidth - 0.1, fanScrewHoleSize / 2])
        rotate([90, 0, 0])
            translate([fanScrewHoleSize / 2, 0, 0])
                cylinder(h = fanWidth, d = fanScrewHoleSize, center = false, $fn = 100);
}

module elongatedScrewHole() {
    scale([1 / fanEnclosureRatio, 1, 1]) hull() {
        fanScrewHole();
        translate([0, 0, wallThickness + fanScrewHolePad]) fanScrewHole();
    }
}

module sunonPf40281bxD060S99Fan() {
    horizontalDistanceFromTheCenter = (fanWidth / 2) - (fanScrewHolePad + fanScrewHoleSize / 2);
    verticalDistanceFromTheCenter = horizontalDistanceFromTheCenter;
    pitch = sqrt(horizontalDistanceFromTheCenter^2 + verticalDistanceFromTheCenter^2);
    echo("Fan pitch is ", pitch);
    fan40x28 = [40, 28, fanBladesDiameter, 16, M3_dome_screw, 25, 7.5, 100, 5, 0, undef];

    union() {
        translate([fanWidth / 2, fanDepth / 2, fanHeight / 2])
            rotate([- 90, 0, 0])
                //  fan_assembly(fan40x28, 28, include_fan = true, screw = false, full_depth = true);
                fan(fan40x28);
        /*translate([screw_head_radius(M3_dome_screw) / 2, - (fanCradleSize.y - fanDepth) / 2, screw_head_radius(
        M3_dome_screw) / 2])
            for (currentHole = fanScrewHoles) {
                translate(currentHole) rotate([90, 0, 0])
                    screw(M3_dome_screw, 10);
            }*/

        fanSuspenders();
        color(grey(80))
            translate([nut_flat_radius(M3_nut) / 2, fanCradleSize.y - get_metric_nut_thickness(threadedRodDiameter) / 2,
                    nut_flat_radius(M3_nut) / 2])
                for (currentHole = fanScrewHoles) {
                    if (currentHole.z > fanScrewHolePad)
                        translate(currentHole)
                            rotate([- 90, 0, 0])
                                metric_nut(size = fanScrewHoleSize, hole = true);
                }
    }
}

module oldfan() {
    difference() {
        color("black") cube(size = [fanWidth, fanDepth, fanWidth], center = false);
        fanBlades();
        for (currentHole = fanScrewHoles) {
            translate(currentHole) fanScrewHole();
        }
    }
}

module fanBlades() {
    translate([(fanWidth - fanBladesDiameter) / 2, fanWidth - 0.1, (fanWidth - fanBladesDiameter) / 2 +
            fanBladesDiameter / 2]) rotate([90, 0, 0]) translate([fanBladesDiameter / 2, 0, 0])
        cylinder(h
        = fanWidth, d = fanBladesDiameter, center = false, $fn = 100);
}

module fanSuspenders() {
    //translate(fanTranslationVector)
    for (currentHole = fanScrewHoles) {
        if (currentHole.z > fanScrewHolePad)
            translate(currentHole) fanSuspender();
    }
    //fanSuspender();
}

module fanSuspender() {
    // The total size should be fanCradleSize plus whatever we need to screw on
    // First part is some kind of screw, second part is what is inside the fan, and last part should be tapped so that
    // we can add a nut later on
    firstPartLength = (fanCradleSize.y - fanDepth) / 2 + get_metric_nut_thickness(fanScrewHoleSize);
    echo("fanScrewHoleSize is ", fanScrewHoleSize);
    echo("nut_flat_radius(fanScrewHoleSize) is ", nut_flat_radius(M3_nut));
    color("Seashell")
        translate([nut_flat_radius(M3_nut) / 2, - get_metric_nut_thickness(fanScrewHoleSize)
            - ((fanCradleSize.y - fanDepth) / 2),
                nut_flat_radius(M3_nut) / 2])
            rotate([- 90, 0, 0])
                union() {
                    // some kind of screw
                    union() {
                        cylinder(h = firstPartLength, d = fanScrewHoleSize, center = false, $fn = 100);
                        translate([0, 0, get_metric_nut_thickness(fanScrewHoleSize) / 2])
                            metric_nut(size = fanScrewHoleSize, hole = false);
                    }
                    // the core of the suspender, going inside the 3.45 hole
                    color("black")
                        translate([0, 0, firstPartLength]) cylinder(h = fanDepth, d = fanEnclosureRatio *
                            fanScrewHoleMeasuredSize, $fn = 100);
                    // last part, the kind of rod we'll tap later on
                    translate([0, 0, firstPartLength + fanDepth])
                        cylinder(h = firstPartLength, d = fanScrewHoleSize, center = false, $fn = 100);
                }
}