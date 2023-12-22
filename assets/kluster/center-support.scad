/**
 * This module creates a torus (donut shape) in OpenSCAD.
 *
 * @param radius The distance from the center of the torus to the center of the tube.
 * @param tube_radius The radius of the tube.
 *
 * The function works by rotating a circle around an axis to create the torus.
 * The rotate_extrude function is used to perform the rotation, and the circle function is used to create the circle.
 * The translate function is used to position the circle at the correct distance from the center of the torus.
 */
module centerTorus(radius, tube_radius) {
    rotate_extrude($fn = 100)
        translate([radius, 0, 0])
            circle(r = tube_radius);
}

module centerCylinder(radius, wall_thickness, board_width, board_height, num_boards) {
    angle_step = 360 / num_boards;
    translate([0, 0, 25]) {
        difference() {
            // Outer cylinder
            cylinder(r = radius, h = 85, center = true, $fn = 100);
            // Inner cylinder
            translate([0, 0, - 5])
                cylinder(r = radius - wall_thickness, h = 95, center = true, $fn = 100);
            // Subtract a rectangular prism for each board
            for (i = [0 : num_boards - 1]) {
                angle = i * angle_step;
                x = (radius - wall_thickness / 2) * cos(angle);
                y = (radius - wall_thickness / 2) * sin(angle);
                translate([x, y, - 5])
                    rotate([0, 0, angle])
                        cube([board_width, wall_thickness, 95], center = true);
            }
        }
    }
}

module tree() {
    branch(20, 0, 2);
}

function pseudo_random(seed, i) = (seed * i) % 1;

module coral(depth, length, angle, thickness, seed) {
    if (depth > 0) {
        rotate([0, angle, 0])
            cylinder(h = length, r1 = thickness, r2 = thickness * 0.8, center = true);
        hull() {
            for (i = [1:max(1, pseudo_random(seed, depth) * 3)]) {
                translate([0, 0, length])
                    coral(depth - 1, length * pseudo_random(seed, i) * 0.9, angle + pseudo_random(seed, i) * 90 - 45,
                        thickness * 0.8, seed);
            }
        }
    }
}



module branch(length, angle, thickness) {
    if (length > 1) {
        rotate([0, angle, 0])
            cylinder(h = length, r1 = thickness, r2 = thickness * 0.8, center = true);
        translate([0, 0, length / 2])
            branch(length * 0.8, angle + 45, thickness * 0.8);
        translate([0, 0, length / 2])
            branch(length * 0.8, angle - 45, thickness * 0.8);
    }
}
