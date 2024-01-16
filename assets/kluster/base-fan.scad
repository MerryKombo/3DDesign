include <utils.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/printed/fan_guard.scad>
//          w     d   b   h      s              h     t    o   b  b    a
//          i     e   o   o      c              u     h    u   l  o    p
//          d     p   r   l      r              b     i    t   a  s    p
//          t     t   e   e      e                    c    e   d  s    e
//          h     h              w              d     k    r   e       r
//                        p                     i     n        s  d    t
//                        i                     a     e    d           u
//                        t                           s    i           r
//                        c                           s    a           e
//                        h
//
//  +-----------------------+  +-----------------------+
fan140x25 = [192, 25, 136, 89, M4_dome_screw, 41, 4, 140, 9, 0, 137];
distanceBetweenFanHoles = 124.5;
fanHoleDiameter = 4; // adjust this to match the size of the hole
fanHoleHeight = 25; // adjust this to match the height of the hole

module base_fan() {
    // cylinder(h = 25, d = 120, $fn=100);
    echo("I'm about to draw the fan");
    rotate([0,0,calculateAngle(getTorusSize())])
    union() {
        fan(fan140x25);
        union() {
            // cube([140, 140, 25], center = true);
            for (x=[-1,1], y=[-1,1]) {
                translate([x*distanceBetweenFanHoles/2, y*distanceBetweenFanHoles/2, 0])
                    cylinder(h=fanHoleHeight, d=fanHoleDiameter, $fn=100);
            }
        }
    }
}

// base_fan();