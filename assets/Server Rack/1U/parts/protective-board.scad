include <../boards/starfive visionfive 2 dimensions.scad>


// Put a label on a third part, with two holes to screw on top of the box (or in front). Like a label on an old machine, in brass
// Don't use hardcoded values, put everything into variables

// The offset we'll set between the board and the outer box wall
xOffset = 10;
yOffset = 10;
wallSize = 1;
pillarWallThickness = 1;

boardProtectiveBox(size, feet, holeSize, height);

module boardProtectiveBox(size, feet, holeSize, height) {
    boardProtectiveBoxTop(size, feet, holeSize, height);
    translate([0, - size.y * 1.5, 0]) boardProtectiveBoxBottom(size, feet, holeSize, height);
}

module boardProtectiveBoxTop(size, feet, holeSize, height) {
    union() {
        difference() {
            cube([size.x + xOffset, size.y + yOffset, size.z + height.x]);
            translate([wallSize, wallSize, wallSize]) cube([size.x + (xOffset - wallSize * 2), size.y + (yOffset -
                    wallSize * 2), size.z + height.x]);
        }
        feet(size, feet, holeSize, height);
    }
}

module boardProtectiveBoxBottom(size, feet, holeSize, height) {
    union() {
        difference() {
            cube([size.x + xOffset, size.y + yOffset, size.z + height.y]);
            translate([wallSize, wallSize, wallSize]) cube([size.x + (xOffset - wallSize * 2), size.y + (yOffset -
                    wallSize * 2), size.z + height.y]);
        }
        feet(size, feet, holeSize, [height.y, height.y]);
    }
}

module feet(size, feet, holeSize, height) {
    feetXOffset = (size.x - feet[1].x) / 2;
    feetYOffset = (size.y - feet[3].y) / 2;
    union() {
        for (foot = feet) {
            translate([foot.x + feetXOffset + xOffset / 2, foot.y + feetYOffset + yOffset / 2, size.z])
                difference() {
                    color("blue") cylinder(h = height.x, r = holeSize / 2 + pillarWallThickness, $fn = 100);
                    translate([0, 0, height.x / 2])
                        color("white") cylinder(h = height.x, r = holeSize / 2, $fn = 100);
                }
        }
    }
}