include <utils.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/printed/fan_guard.scad>
include <NopSCADlib/vitamins/inserts.scad>
include <NopSCADlib/vitamins/screw.scad>
include <NopSCADlib/vitamins/screws.scad>
use <../Booth Display/inserts.scad>;

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


/** The fan should have feet that allow air to pass under the fan. The power PCBA is 25mm high, so we shouldn't go under
* 30mm to allow fresh air to enter.
* I was thinking of using pre-designed feet like https://github.com/nophead/NopSCADlib?tab=readme-ov-file#foot, but I'm
* afraid they could be too large to fit under the fan "ears". The ears are 30mm wide at their widest, 10mm at their
* narrowest.
* The holes in the "ears" are 4mm wide, but I don't have long enough 4mm screws, so we'll go with 3mm diameter
* The hole center is 7,42 mm from the edge of the ear.
*/

module fanFoot() {
    // small trapezium side, large trapezium side, height
    holeCenterFromEdge = 7.42;
    echo("Hole center from edge: ", holeCenterFromEdge);
    type = insertName(3);
    echo("Insert type: ", type);
    insertHeight = insert_hole_length(type) * 3 / 2    ;
    echo("Insert height: ", insertHeight);
    wall = 2;
    echo("Wall: ", wall);
    insertBossRadius = insert_boss_radius(type, wall);
    echo("Insert boss radius: ", insertBossRadius);
    footDimensions = [10, 30, 30];
    footPoints = [[footDimensions[0], 0, 0], //0,
            [0, footDimensions[2], 0], //1
            [footDimensions[1], footDimensions[2], 0], //2
            [footDimensions[1] - footDimensions[0], 0, 0], //1
            [footDimensions[0], 0, footDimensions[1]], //4
            [0, footDimensions[2], footDimensions[1]], //5
            [footDimensions[1], footDimensions[2], footDimensions[1]], //6
            [footDimensions[1] - footDimensions[0], 0, footDimensions[1]]];
    echo("Foot points: ", footPoints);
    footFaces = [
        // bottom
            [0, 1, 2, 3],
        // front
            [0, 3, 7, 4],
        // top
            [4, 5, 6, 7],
        // left
            [0, 1, 5, 4],
        // right
            [2, 3, 7, 6],
        // back
            [1, 2, 6, 5]];

    echo("Foot faces: ", footFaces);
    union() {
        intersection() {
            difference() {
                hull()
                    polyhedron(points = footPoints, faces = footFaces);

                translate([footDimensions[2] / 2 - insertBossRadius, holeCenterFromEdge - insertBossRadius, 0])
                    translate([insertBossRadius, insertBossRadius, footDimensions[2] - insertHeight])
                        union() {
                            color("red")
                                translate([0, 0, insertHeight]) insert(type);
                            color("purple")
                                insert_boss(type, z = insertHeight * 2, wall = wall);
                            color("black")
                                translate([0, 0, -insertHeight * 3 + .01])
                                    cylinder(h = insertHeight * 4, d = 3, $fn = 100);
                        }
                // Remove a rounded chunk, corresponding to the fan blades footprint.
                color("green")
                    translate([footDimensions[1] / 2, getFanDiameter() / 2 + footDimensions[2] * .8, -footDimensions[2]
                        / 2]
                    )
                        cylinder(h = footDimensions[2] * 2, d = getFanDiameter(), $fn = 100);
            }
            biggerBlueCylinderDiameter = getFanDiameter() + footDimensions[1];
            color("blue")
                translate([footDimensions[1] / 2, biggerBlueCylinderDiameter / 2, -footDimensions[2] / 2]
                )
                    cylinder(h = footDimensions[2] * 2, d = biggerBlueCylinderDiameter, $fn = 100);
        }
        translate([footDimensions[2] / 2 - insertBossRadius, holeCenterFromEdge - insertBossRadius, 0])
            translate([insertBossRadius, insertBossRadius, footDimensions[2] - insertHeight])
                insert_boss(type, z = insertHeight, wall = wall);
    }
}

module fanFeet() {
    insert(F1BM3);
}

module base_fan() {
    // cylinder(h = 25, d = 120, $fn=footDimensions[0]0);
    echo("I'm about to draw the fan");
    rotate([0, 0, calculateAngle(getTorusSize())])
        union() {
            fan(fan140x25);
            union() {
                // cube([140, 140, 25], center = true);
                for (x = [-1, 1], y = [-1, 1]) {
                    translate([x * distanceBetweenFanHoles / 2, y * distanceBetweenFanHoles / 2, 0])
                        cylinder(h = fanHoleHeight, d = fanHoleDiameter, $fn = 100);
                }
            }
        }
}

//base_fan();
// fanFeet();
fanFoot();

