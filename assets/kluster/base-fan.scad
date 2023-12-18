include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/printed/fan_guard.scad>

module base_fan() {
    // cylinder(h = 25, d = 120, $fn=100);
    fan140x25= [140, 25, 116,52.5,  M4_dome_screw, 41,   4,  140, 9, 0,   137];
    fan(fan140x25);
}