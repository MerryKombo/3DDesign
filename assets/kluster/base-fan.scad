include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/printed/fan_guard.scad>

module fan() {
    // cylinder(h = 25, d = 120, $fn=100);
    fan(fan120x25);
}