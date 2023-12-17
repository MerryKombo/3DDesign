include <raspberry-pi-3-b-plus.scad>;
include <base-fan.scad>;

union() {
    translate([0, 12.5, 85+25])
        rotate([90, 90, 0])
            sbc();
    translate([-56, 12.5, 85+25])
        rotate([90, 90, 0])
            sbc();
    translate([-12.5, 12.5, 85+25])
        rotate([90, 90, 90])
            sbc();
    translate([-12.5, -56, 85+25])
        rotate([90, 90, 90])
            sbc();
    translate([0, 0, 85+25])
        rotate([90, 90, 135])
            sbc();
    translate([0, 0, 0]) fan();
}