use <../module.scad>
include <../module-dimensions.scad>
include <../fan/noctua-dimensions.scad>
include <../fan/noctua.scad>
include <../dovetails/dovetails.scad>

//fanAndPowerEnclosure(moduleWidth, fanEnclosureLength, moduleHeight);
//fanModule(moduleWidth, fanEnclosureLength, moduleHeight);
//fanHarness();

module fanAndPowerEnclosure(moduleWidth, fanEnclosureLength, moduleHeight) {
    union() {
        difference() {
            union() {
                color("OliveDrab") maleDovetails(moduleWidth);
                // il faut que tu calcules la largeur de l'harbess, puisque tout dépend de ça...
                // aussi bien pour déplacer le harness, que de faire un trou pour le loger
                fanAndPowerModule(moduleWidth, fanEnclosureLength, moduleHeight);
            }
            //translate([wallThickness, - fanAndHarnessDepth + fanScrewHoleSize - 2.2, 0]) fanHarnessEraser();
            //translate(centeredFanTranslationBehindTheEnclosure) fan();
            translate([wallThickness, fanAndHarnessDepth - 1.5 * fanDepth, 0]) color("blue") linear_extrude(height = moduleHeight) projection() fanHarness(false);

        }
        //translate([wallThickness + 3, fanEnclosureLength - fanDepth, 3]) fan();
        translate([wallThickness, fanAndHarnessDepth - 1.5 * fanDepth, 0]) fanHarness();
        //translate([-moduleWidth, fanAndHarnessDepth - fanDepth, 0]) color("blue") linear_extrude(height = moduleHeight) projection() fanHarness(false);
    }
}

module fanHarness(makeHoles = true) {
    /*translate([65, 0, 0])*/
    /* translate([moduleWidth - wallThickness, 0, 0])*/
    /*translate([fanAndHarnessWidth,0,0])*/
    mirror([1, 0, 0])
        translate([0, fanEnclosureLength + fanVerticalReinforcementDepth, 0])
            translate([fanVerticalReinforcementWidth, fanVerticalReinforcementDepth * dovetailMaleToFemaleRatio,
                0])
                rotate([0, 0, 180])  difference() {
                    fanVerticalReinforcements(moduleWidth, makeHoles);
                    translate([- fanVerticalReinforcementWidth * 2, 0, 0]) fanScrewHoles();
                }
}

module fanHarnessEraser() {
    color("DarkSeaGreen") translate([0, fanEnclosureLength - 0.5 * fanAndHarnessDepth, 0]) cube([fanAndHarnessWidth,
            fanAndHarnessDepth * 1.5,
        moduleHeight]);
    // rotate([- 90, 0, 0]) linear_extrude(height = fanDepth, center = true, convexity = 10)      projection() rotate([90,        0, 0]) fanHarness();
}

module fanAndPowerModule(moduleWidth, fanEnclosureLength, moduleHeight) {
    //echo("In fanAndPowerModule, )
    color("OliveDrab")
        translate([0, dovetailHeight, 0])
        union() {
            difference() {
                union() {
                    basicModule(moduleWidth, fanEnclosureLength, moduleHeight, false, false);

                }
                // Hollow out so that we dont get a threaded rod insert that blocks the fan bottom
                //hollowOutFanAndPowerModule(moduleWidth, fanEnclosureLength, moduleHeight);
                // We need the threaded rod path to clear the whole rodEarDistanceFromSide
                fanPerpendicularRodAlcoves(moduleWidth, fanEnclosureLength, moduleHeight, false);
            }
            //eraseRodInsert();
            //translate([0, 0, moduleHeight]) eraseRodInsert();
        }
}

module hollowOutFanAndPowerModule(moduleWidth, fanEnclosureLength, moduleHeight) {
    translate([wallThickness, fanEnclosureLength - (rodSurroundingDiameter + surroundingDiameter), 0]) cube([moduleWidth
        - 2 * wallThickness, rodSurroundingDiameter + surroundingDiameter
        , moduleHeight]);
}

module eraseRodInsert() {
    translate([0, 0, - moduleHeight]) rodAlcoves(moduleWidth, fanEnclosureLength, moduleHeight);

    /*    translate([wallThickness, fanEnclosureLength - 5, 0]) cube([moduleWidth - 2 * wallThickness, 5,
            threadedRodDiameter]);*/
}