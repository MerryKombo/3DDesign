use <../module.scad>
include <../module-dimensions.scad>
include <./noctua-dimensions.scad>

fanEnclosure();
//fan();
//fanScrewHoles();

module fanEnclosure() {
    difference() {
        union() {
            maleDovetails();
            translate(centeredFanTranslationBehindTheEnclosure) fan();
            fanVerticalReinforcements();
        }
        fanScrewHoles();
    }
}

module fanVerticalReinforcements() {
    difference() {
        union() {
            fanVerticalReinforcement();
            translate([fanEnclosureWidth, 0, moduleHeight]) rotate([0, 180, 0]) fanVerticalReinforcement();

        }
        // Blades
        translate([(fanEnclosureWidth - fanBladesDiameter) / 2 + fanBladesDiameter / 2, fanWidth / 2, (moduleHeight
            - fanBladesDiameter) / 2 + fanBladesDiameter / 2]) rotate([90, 0, 0]) cylinder(d = fanBladesDiameter, h
        = fanWidth, $fn = 100);
    }
}

module fanVerticalReinforcement() {
    translate([0, dovetailMaleToFemaleRatio * dovetailHeight, 0])
        union() {
            // The main bar
            cube(size = [fanVerticalReinforcementWidth,
                fanScrewHoleSize,
                moduleHeight]);
            // Bottom ear
            translate([fanVerticalReinforcementWidth, 0, 0]) cube(size = [fanVerticalReinforcementWidth,
                fanScrewHoleSize,
                fanVerticalReinforcementWidth]);
            // Top ear
            translate([fanVerticalReinforcementWidth, 0, moduleHeight - fanVerticalReinforcementWidth]) cube(size =
                [
                fanVerticalReinforcementWidth,
                fanScrewHoleSize,
                fanVerticalReinforcementWidth]);
        }
}

module fanScrewHoles() {
    translate(centeredFanTranslation) union() {
        translate(fanHoles[0]) fanScrewHole();
        translate(fanHoles[1]) fanScrewHole();
        translate(fanHoles[2])fanScrewHole();
        translate(fanHoles[3])fanScrewHole();
    }
}

module fanScrewHole() {
    color("purple") rotate([90, 0, 0]) cylinder(d = fanScrewHoleSize, h = fanWidth, $fn = 100);
}

module maleDovetails() {
    maleDovetail();
    translate([0, 0, moduleHeight - (dovetailMaleToFemaleRatio * (dovetailBaseMaxWidth + dovetailMaxMinusMaxWidth))])
        maleDovetail();
}

module maleDovetail() {
    translate([fanEnclosureWidth, dovetailMaleToFemaleRatio * dovetailHeight, dovetailMaleToFemaleRatio * (
        dovetailBaseMaxWidth + dovetailMaxMinusMaxWidth)])    rotate([180, 90, 0]) linear_extrude(height =
    fanEnclosureWidth)  scale([dovetailMaleToFemaleRatio, dovetailMaleToFemaleRatio])
        mainDovetailEnclosureDovetail();
}

module fan() {
    color("#E8D9C5") translate([fanWidth / 2, fanDepth / 2,
            fanWidth / 2]) rotate([0, 90, 0]) import("./noctua-main-body.stl", convexity = 10);
}