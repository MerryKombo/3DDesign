include <NopSCADlib/lib.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/iecs.scad>
include <NopSCADlib/vitamins/iec.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/psus.scad>

use <NopSCADlib/utils/layout.scad>


include <../module-dimensions.scad>
include <NopSCADlib/utils/layout.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/blowers.scad>
include <../module-dimensions.scad>
include <../module.scad>
include <power-supply-dimensions.scad>

include <../../utils/hexgrid.scad>

//powerSupplyModule(false);

module powerSupplyModule(hiveWall = true) {
    //echo("IEC body width is : ", iecBodyWidth);
    //echo("IEC body height is : ", iecBodyHeight);

    echo("The power supply length is", psuLength);
    echo("The power module width is", moduleWidth);
    echo("We would then need ", psuModuleWidth, " modules to host the PSU");

    union() {
        difference() {
            union() {
                // The full module
                basicModule(psuModuleWidth * moduleWidth, psuModuleLength, moduleHeight, pinsPath = false, nutRecess =
                false, rearDovetails=false, frontDovetails=true);
                powerSupplyModuleWalls(hiveWall);
            }
            // We dig a big funky hole inside it
            /*   translate([0, powerSupplyLength, 0]) cube([powerSupplyWidth + 2 * wallThickness, dovetailHeight * 1.1,
                       moduleHeight * 1.1]);*/
            // Let's get rid of the dovetails
            /*translate([- 0.1, psuModuleLength, 0]) color("yellow") cube([psuModuleWidth * moduleWidth * 1.5,
                    dovetailHeight * 2, moduleHeight * 1.5]);*/
            powerSupplySideWallTrack();

            translate([0, psuModuleLength - (psuModuleLength - powerSupplyLength) / 2, 0]) rotate([0, 0, 270])
                color("purple")  powerSupplySideWallTrackNotTranslated();
        }

        /* translate([0, psuModuleLength - (psuModuleLength - powerSupplyLength) / 2, 0]) rotate([0, 0, 270])
             color("purple")  powerSupplySideWallTrackNotTranslated();*/
        //powerSupplySideWallTrackNotTranslated();
        // This is a comment :-D
        powerSupply();
        powerSupplySideWallInsert();
        translate([0, - powerSupplyLength * .9, 0]) powerSupplySideWallInsert(true);
        /* translate([psuModuleWidth * moduleWidth - blower_depth(PE4020) - wallThickness, psuModuleLength -
             rodSurroundingDiameter - surroundingDiameter, 0]) powerSupplyRearBlower();*/
        /*difference() {
            cube([blower_length(PE4020), blower_length(PE4020), blower_depth(PE4020)]);
            blower_hole_positions(PE4020) cylinder(d = 3, h = blower_depth(PE4020));

        }*/
    }
}


module powerSupplyRearBlower() {
    translate([blower_depth(powerSupplyModuleBlower), 0, blower_depth(powerSupplyModuleBlower) * 2]) rotate([0, 90, 180]
    ) blower(powerSupplyModuleBlower);
}

module powerSupplyModuleWalls(hiveWall = true) {
    powerSupplySideWall(true);
    //powerSupplyRearWall();
    translate([wallThickness, psuModuleLength, 0]) powerSupplyRearWallDebug(hiveWall);
}

module powerSupplyRearWallDebug(hiveWall = true) {
    union() {
        difference() {
            union() {
                // The wall
                //translate([0, - wallThickness, 0]) cube([iec_width(iecs[iecBodyType]) * 1.5, wallThickness, moduleHeight                    ]);
                translate([0, - wallThickness, 0]) rounded_cube_xy([iec_width(iecs[iecBodyType]) * 1.5, wallThickness,
                    moduleHeight], wallThickness / 2.2);
                translate([0, - wallThickness, 0]) cube([wallThickness, wallThickness, moduleHeight]);
                if (hiveWall) {
                    // The ventilated wall
                    // first arg is vector that defines the bounding box, length, width, height
                    // second arg in the 'diameter' of the holes. In OpenScad, this refers to the corner-to-corner diameter, not flat-to-flat
                    // this diameter is 2/sqrt(3) times larger than flat to flat
                    // third arg is wall thickness.  This also is measured that the corners, not the flats.
                    translate([0, 0, 0]) rotate([90, 0, 0]) hexgrid([
                                psuModuleWidth *
                                moduleWidth - 2 * wallThickness, moduleHeight, wallThickness], 5, 1);}
            }
            moduleThreadedRod();
            translate([0, 0, moduleHeight - rodSurroundingDiameter - surroundingDiameter]) moduleThreadedRod();
            // The IEC hole
            translate([iecBodyWidth + wallThickness, 0, iecBodyHeight / 2 + rodSurroundingDiameter +
                surroundingDiameter + 1]) rotate([90, 0, 180]) iec_holes(iecs[iecBodyType], h = 100, poly = false,
            horizontal = false,
            insert = false);
        }
        // The IEC plug
        translate([iecBodyWidth + wallThickness, 0, iecBodyHeight / 2 + rodSurroundingDiameter +
            surroundingDiameter + 1]) rotate([90, 0, 180]) iec_assembly(iecs[iecBodyType], wallThickness);
    }
}

module powerSupplySideWall(translateWall = true) {
    if (translateWall) {
        translate([wallThickness, (psuModuleLength - powerSupplyLength) / 2, 0]) rotate([0, 0, 90])
            powerSupplySideWallNotTranslated(false);
    } else {
        powerSupplySideWallNotTranslated(false);
    }
}

module powerSupplySideWallNotTranslated(translateWall = true) {
    union() {
        difference() {
            union() {
                rounded_cube_xy([powerSupplyLength, wallThickness, moduleHeight], wallThickness / 2.2);
            }
            powerSupplySideWallTrack(translateWall);
            powerSupplySideWallHoles();
            perpendicularRodAlcove(psuModuleWidth * moduleWidth, psuModuleLength, moduleHeight, nutHoles = true);
        }
    }
}

module powerSupplySideWallHoles() {
    translate([wallThickness, (psuModuleLength - powerSupplyLength) / 2, 0]) rotate([0, 0, 90])union() {
        // one cylinder to find the PSU holes
        translate([19, moduleWidth / 2, 9]) rotate([0, 0, - 90]) translate([0, - 1.5, 1.5])
            rotate([0, 90, 0])
                cylinder(d = 3, h = moduleWidth * 2, $fn = 100);
        // another cylinder to find the PSU holes
        translate([19, moduleWidth / 2, 28]) rotate([0, 0, - 90]) translate([0, - 1.5, 1.5])
            rotate([0, 90, 0])
                cylinder(d = 3, h = moduleWidth * 2, $fn = 100);
        // and another one
        translate([powerSupplyLength - 20.5, moduleWidth, 18.7]) rotate([0, 0, - 90]) translate([0, - 1.5, 1.5])
            rotate([0, 90, 0])
                cylinder(d = 3, h = moduleWidth * 2, $fn = 100);
    }
}

module powerSupplySideWallTrack(translateWall = true) {
    if (translateWall) {
        echo("powerSupplySideWallTrack shall be translated");
        translate([wallThickness, (psuModuleLength - powerSupplyLength) / 2, 0])   rotate([0, 0, 90])
            powerSupplySideWallTrackNotTranslated();
    } else {
        echo("powerSupplySideWallTrack shall NOT be translated");
        powerSupplySideWallTrackNotTranslated();
    }
}

module powerSupplySideWallInsert(translateWall = true) {
    if (translateWall) {
        difference() {
            /*scale([0.95,0.95,0.95,]) */    translate([0, psuModuleLength - (psuModuleLength - powerSupplyLength) / 2,
                0])   rotate([0, 0, 270])
                powerSupplySideWallInsertNotTranslated();
            translate([0, 0, (threadedRodDiameter + rodSurroundingDiameter + surroundingDiameter)]) rotate([- 90, 0, 0])
                threadedRod(psuModuleWidth * moduleWidth, psuModuleLength, moduleHeight);
            powerSupplySideWallInsertHoles();
        }
    } else {
        powerSupplySideWallInsertNotTranslated();
    }
}


module powerSupplySideWallInsertNotTranslated() {
    difference() {
        color("red") scale([0.1, 1, 1]) powerSupplySideWallTrack(false);
        powerSupplySideWallInsertHoles();
    }
}

module powerSupplySideWallInsertHoles() {
    color("black") union() {
        // one cylinder to find the PSU holes
        translate([19, moduleWidth / 2, 9]) rotate([0, 0, - 90]) translate([0, - 1.5, 1.5])
            rotate([0, 90, 0])
                cylinder(d = 3, h = moduleWidth * 2, $fn = 100);
        // another cylinder to find the PSU holes
        translate([19, moduleWidth / 2, 28]) rotate([0, 0, - 90]) translate([0, - 1.5, 1.5])
            rotate([0, 90, 0])
                cylinder(d = 3, h = moduleWidth * 2, $fn = 100);
        // and another one
        translate([psuModuleLength * 0.05, moduleWidth / 2, 18.7]) rotate([0, 0, - 90]) translate([0, - 1.5, 1.5])
            rotate([0, 90, 0])
                cylinder(d = 3, h = moduleWidth * 2, $fn = 100);
    }
}

module powerSupplySideWallTrackNotTranslated() {
    union() {
        // The smallest one, but with more depth
        translate([0, 0, rodSurroundingDiameter + wallThickness - 0.2 * (rodSurroundingDiameter + wallThickness)]) cube(
            [powerSupplyLength, wallThickness + 0.1,
                moduleHeight - 1.8 * (rodSurroundingDiameter + wallThickness)]);
        // The bigger one, that will stay on top
        translate([0, - 0.1, rodSurroundingDiameter]) cube([powerSupplyLength, 0.4 * wallThickness + 0.1, moduleHeight -
                2 *
                (rodSurroundingDiameter)]);
        // The optional one that will host the rod
        translate([0, - wallThickness, rodSurroundingDiameter]) cube([powerSupplyLength, wallThickness, moduleHeight - 2
            * (rodSurroundingDiameter)]);}
}

module moduleThreadedRod() {
    scale([1.1, 1, 1]) translate([0, - (threadedRodDiameter + surroundingDiameter * 2) / 2, (threadedRodDiameter
        +
            surroundingDiameter * 2) / 2]) rotate([90, 0, 90]) threadedRod(psuModuleWidth * moduleWidth,
    moduleLength,
    moduleHeight);
}

module powerSupply() {
    psuLength = psu_length(powerSupplyBase);
    /*translate([psuModuleWidth * moduleWidth - psuLength / 2 - wallThickness, psuModuleLength - powerSupplyWidth + 2 *
        rodSurroundingDiameter
        / 2, 0])*/
    translate([wallThickness, psuModuleLength - (psuModuleLength - powerSupplyLength) / 2, 0]) translate([
            powerSupplyWidth / 2, - powerSupplyLength / 2, 0]) rotate([0, 0, 270]) psu(powerSupplyBase);
    echo("The PSU module length is ", psuModuleLength, " and the powerSupplyLength ", powerSupplyLength);
    /*module psus()
    layout([for (p = psus) psu_width(p)], 10) let(p = psus[$i])
    rotate(atx_psu(p) ? 0 : 90) {
        psu(p);
    //echo("P is ", p);
        psu_screw_positions(p)
        translate_z(3)
        screw_and_washer(psu_screw(p), 8);*/
}
