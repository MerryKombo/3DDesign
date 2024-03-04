include <NopSCADlib/vitamins/inserts.scad>
include <NopSCADlib/vitamins/screw.scad>
include <NopSCADlib/vitamins/screws.scad>
use <../../Booth Display/inserts.scad>;

leverAxleBaseDiameter = 12;
leverAxleBaseHeight = 1;
leverAxleTopDiameter = 10;
leverAxleTopRecessedWidth = 7;
leverAxleTopHeight = 15;
leverAxleTopThreadSize = 5;

union() {
    cylinder(r = leverAxleBaseDiameter / 2, h = leverAxleBaseHeight, $fn = 100);
    translate([0, 0, leverAxleBaseHeight])
    intersection() {
        //cylinder(r = leverAxleTopDiameter / 2, h = leverAxleTopHeight, $fn = 100);

        type = insertName(5);
        insert_boss(type, z = leverAxleTopHeight, wall = 2);
        cube([leverAxleTopRecessedWidth, leverAxleTopDiameter, leverAxleTopHeight], center = true);
    }
}