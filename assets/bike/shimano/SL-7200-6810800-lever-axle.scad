include <NopSCADlib/vitamins/inserts.scad>
include <NopSCADlib/vitamins/screw.scad>
include <NopSCADlib/vitamins/screws.scad>
use <threads-scad/threads.scad>
use <../../Booth Display/inserts.scad>;

leverAxleBaseDiameter = 10;
leverAxleBaseHeight = 1.5;
leverAxleTopDiameter = 9;
leverAxleTopRecessedWidth = 6;
leverAxleTopHeight = 8;
leverAxleTopThreadSize = 3;
type = insertName(leverAxleTopThreadSize);

module leverAxleWithInsert() {
    union() {
        color("grey")
            difference() {
                union() {
                    cylinder(r = leverAxleBaseDiameter / 2, h = leverAxleBaseHeight, $fn = 100);
                    translate([0, 0, leverAxleBaseHeight])
                        union() {
                            intersection() {
                                union() {
                                    difference() {
                                        cylinder(r = leverAxleTopDiameter / 2, h = leverAxleTopHeight, $fn = 100);
                                        cylinder(r = insert_hole_radius(type), h = leverAxleTopHeight, $fn = 100);
                                    }
                                    insert_boss(type, z = leverAxleTopHeight, wall = 1);
                                }
                                translate([0, 0, leverAxleTopHeight / 2])
                                    cube([leverAxleTopRecessedWidth, leverAxleTopDiameter, leverAxleTopHeight], center =
                                    true);
                            }
                        }
                }
                translate([0, 0, -0.1])
                    cylinder(r = leverAxleTopThreadSize / 2, h = (leverAxleBaseHeight + leverAxleTopHeight) * 1.1, $fn =
                    100
                    );
            }

        //translate([0, 0, leverAxleBaseHeight * 2 + insert_length(type)])
        //    insert(type);
    }
}

module leverAxle(footprint = false) {
    union() {
        color("grey")
            difference() {
                union() {
                    cylinder(r = leverAxleBaseDiameter / 2, h = leverAxleBaseHeight, $fn = 100);
                    translate([0, 0, leverAxleBaseHeight])
                        union() {
                            intersection() {
                                union() {
                                    difference() {
                                        cylinder(r = leverAxleTopDiameter / 2, h = leverAxleTopHeight, $fn = 100);
                                    }
                                }
                                translate([0, 0, leverAxleTopHeight / 2]) cube([leverAxleTopRecessedWidth,
                                    leverAxleTopDiameter, leverAxleTopHeight], center = true);
                            }
                        }
                }
                if (!footprint) {
                    translate([0, 0, -leverAxleTopHeight / 2])
                        ScrewThread(outer_diam = leverAxleTopThreadSize, height = leverAxleTopHeight * 2
                        , pitch = 0, tooth_angle = 30, tolerance = 0.4, tip_height = 0, tooth_height = 0
                        , tip_min_fract = 0);
                }
            }
    }
}

// leverAxle();
// leverAxleWithInsert();
