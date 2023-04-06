topWidth = 48.55;
topHeight = 22.5;
topDepth = 0.4;

holeWidth = 24.38;
holeHeight = 7.58;
holeX = 11.66;
holeY = 7.46;

screwHoleDiameter = 3;
screwDistance = 43.5;
screwX = (topWidth - screwDistance) / 2;
screwY = 11.25;

reinforcementHeight = 12.5;
reinforcementWidth = 2.95;
reinforcementDepth = 1.8;
reinforcementX = 7.6;
reinforcementY = 5;
reinforcementFootLength = 1.11;
reinforcementFootHeight = 0.8;

union() {
    difference() {
        cube(size = [topWidth, topHeight, topDepth]);
        translate([holeX, holeY, - .05]) cube(size = [holeWidth, holeHeight, topDepth + 0.1]);
        translate([screwX, screwY, - .05]) cylinder(h = topDepth + .1, r = screwHoleDiameter / 2, $fn = 100);
        translate([topWidth - screwX, screwY, - .05]) cylinder(h = topDepth + .1, r = screwHoleDiameter / 2, $fn = 100);
    }
    translate([reinforcementX, reinforcementY, 0])
        union() {
            cube(size = [reinforcementWidth, reinforcementHeight, reinforcementDepth]);
            translate([reinforcementWidth, 0, 0])
                cube(size = [reinforcementFootLength, reinforcementFootHeight, reinforcementDepth]);
        }
}