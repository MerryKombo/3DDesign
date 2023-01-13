include <label.scad>
//board(size);

module board(size, holes, holeSize, label = "board") {
    union() {
        difference() {
            cube(size = [size.x, size.y, size.z], center = false);
            for (a = holes) {color("blue")
                translate([(size.x - holes[3].x) / 2 + a.x, (size.y - holes[3].y) / 2 + a.y, - 0.05 * size.z])
                    cylinder(h = size.z * 1.1, r = holeSize / 2, center = false, $fn = 100);
            }
        }
        labelHeight = size.y * .10;
        labelLength = size.x * .9;
        translate([(size.x - labelLength) / 2, (size.y - labelHeight) / 2 + 0.5, 0])
            drawLabel(label, labelHeight, labelLength, size.z, size.z, holes);
    }
}