//board(size);

module board(size, holes, holeSize) {union() {cube(size = [size.x, size.y, size.z], center = false);
    for (a = holes) {color("blue")
        translate([(size.x - holes[3].x) / 2 + a.x, (size.y - holes[3].y) / 2 + a.y, - 0.05 * size.z])
            cylinder(h = size.z * 1.1, r = holeSize, center = false, $fn = 100);}}}