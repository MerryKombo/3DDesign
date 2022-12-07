use <../module.scad>
include <../module-dimensions.scad>
include <./noctua-dimensions.scad>
include <../dovetails/dovetails.scad>

//fanEnclosure();
//translate(centeredFanTranslationBehindTheEnclosure) fan();
//fan();
//fanScrewHoles();

module fanEnclosure() {
    difference() {
        union() {
            color("SaddleBrown") maleDovetails(moduleWidth);
            translate([(moduleWidth - fanEnclosureWidth) / 2, 0, 0]) fanVerticalReinforcements(moduleWidth);
            fanModule(moduleWidth, fanEnclosureLength, moduleHeight);
        }
        //translate(centeredFanTranslationBehindTheEnclosure) fan();
        fanScrewHoles();
    }
}

module fanModule(moduleWidth, fanEnclosureLength, moduleHeight) {
    translate([0, dovetailHeight, 0]) difference() {
        union() {
            basicModule(moduleWidth, fanEnclosureLength, moduleHeight, false, false);
        }
        // Hollow out so that we dont get a threaded rod insert that blocks the fan bottom
        hollowOutFanModule(moduleWidth, fanEnclosureLength, moduleHeight);
        // We need the threaded rod path to clear the whole rodEarDistanceFromSide
        fanPerpendicularRodAlcoves(moduleWidth, fanEnclosureLength, moduleHeight);
    }
}

module hollowOutFanModule(moduleWidth, fanEnclosureLength, moduleHeight) {
    translate([wallThickness, 0, 0]) cube([moduleWidth - 2 * wallThickness, rodSurroundingDiameter + surroundingDiameter
        , rodSurroundingDiameter +
            surroundingDiameter]);
}

module fanVerticalReinforcements(width, makeHoles = true) {
    echo("In fanVerticalReinforcements, makeHoles is", makeHoles);
    color("Seashell") difference() {
        union() {
            fanVerticalReinforcement(width, makeHoles);
            translate([fanEnclosureWidth, 0, moduleHeight]) rotate([0, 180, 0]) fanVerticalReinforcement(width,
            makeHoles);

        }
        // Blades
        translate([(fanEnclosureWidth - fanBladesDiameter) / 2 + fanBladesDiameter / 2, fanWidth / 2, (moduleHeight
            - fanBladesDiameter) / 2 + fanBladesDiameter / 2]) rotate([90, 0, 0]) cylinder(d = fanBladesDiameter, h
        = fanWidth, $fn = 100);
    }
}

module fanVerticalReinforcement(width, makeHoles = true) {
    //reinforcementXShift = (width - fanVerticalReinforcementWidth * 2) / 2;
    translate([fanVerticalReinforcementWidth, /*dovetailMaleToFemaleRatio **/ dovetailHeight, 0])
        difference() {
            union() {
                // The main bar
                cube(size = [fanVerticalReinforcementWidth,
                    fanScrewHoleSize,
                    moduleHeight]);
                // Bottom ear
                fanVerticalReinforcementBottomEar();
                // Top ear
                fanVerticalReinforcementTopEar();
            }
            if (makeHoles) {
                fanVerticalReinforcementEarHole();
            }
        }
}


module fanVerticalReinforcementBottomEar() {
    translate([0, 0, 0]) cube(size = [fanVerticalReinforcementWidth * 2,
        fanVerticalReinforcementWidth,
            fanVerticalReinforcementWidth * 1.5]);
}


module fanVerticalReinforcementTopEar() {
    translate([0, 0, moduleHeight - fanVerticalReinforcementWidth * 1.5]) cube(size = [
            fanVerticalReinforcementWidth * 2, fanVerticalReinforcementWidth, fanVerticalReinforcementWidth * 1.5]);
}

module fanVerticalReinforcementEarHole() {
    // First, the bottom nut
    union() {
        translate([fanScrewHolePad + fanVerticalReinforcementWidth - (m5NutWidthAcrossFlats * m5NutScalingRatio / 2),
                        m5FinishedJamNut * m5NutScalingRatio / 2 - 0.1, 0]) fanVerticalReinforcementNutMainRecess();
        translate([fanScrewHolePad + fanVerticalReinforcementWidth - (m5NutWidthAcrossFlats * m5NutScalingRatio / 2),
                        m5FinishedJamNut * m5NutScalingRatio / 2 - 0.1,
                    (threadedRodDiameterHole - fanScrewHolePad) / 2 + (m5NutWidthAcrossSpikes * m5NutScalingRatio) / 2])
            fanVerticalReinforcementNutSecondRecess();

        // Then, the top nut
        union() {
            translate([fanScrewHolePad + fanVerticalReinforcementWidth - (m5NutWidthAcrossFlats * m5NutScalingRatio / 2)
                , m5FinishedJamNut * m5NutScalingRatio / 2 - 0.1, moduleHeight - (m5NutScalingRatio *
                    m5NutWidthAcrossSpikes)])fanVerticalReinforcementNutMainRecess()            ;
            translate([fanScrewHolePad + fanVerticalReinforcementWidth - (m5NutWidthAcrossFlats * m5NutScalingRatio / 2)
                , m5FinishedJamNut * m5NutScalingRatio / 2 - 0.1, moduleHeight - (threadedRodDiameterHole -
                    fanScrewHolePad) / 2 + (m5NutWidthAcrossSpikes * m5NutScalingRatio) / 2])
                fanVerticalReinforcementNutSecondRecess();
        }
    }
}

module fanVerticalReinforcementNutSecondRecess() {
    rotate([0, 90, 90]) scale([m5NutScalingRatio, m5NutScalingRatio, m5NutScalingRatio]) metric_nut(size =
    threadedRodDiameter, hole = true, $fn = 100);
}

module fanVerticalReinforcementNutMainRecess() {
    linear_extrude(height = m5NutScalingRatio * m5NutWidthAcrossSpikes) projection() rotate([0, 90, 90]) scale([
        m5NutScalingRatio, m5NutScalingRatio, m5NutScalingRatio]) metric_nut(size =
    threadedRodDiameter, hole = true, $fn = 100);

}

module fanScrewHoles() {
    translate(centeredFanTranslation) union() {
        translate(fanHoles[0]) fanScrewHole();
        translate(fanHoles[1]) fanScrewHole();
        translate(fanHoles[2]) fanScrewHole();
        translate(fanHoles[3]) fanScrewHole();
    }
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
    color("purple") rotate([90, 0, 0]) cylinder(d = fanScrewHoleSize, h = fanDepth + fanVerticalReinforcementDepth,
    $fn
    = 100);
}
/*
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
}*/

module fan() {
    color("#E8D9C5") translate([fanWidth / 2, fanDepth / 2,
            fanWidth / 2]) rotate([0, 90, 0]) import("../fan/noctua-main-body.stl", convexity = 10);
}