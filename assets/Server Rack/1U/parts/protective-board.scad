include <../boards/starfive visionfive 2 dimensions.scad>

boardProtectiveBox(size, feet, holeSize, height);

module boardProtectiveBox(size, feet, holeSize, height) {
    boardProtectiveBoxTop(size, feet, holeSize, height);
    translate([0, -size.y*1.5,0]) boardProtectiveBoxBottom(size, feet, holeSize, height);
}

module boardProtectiveBoxTop(size, feet, holeSize, height) {
    difference() {
    cube([size.x+10, size.y+10, size.z + height.x]);
    translate([1,1,1]) cube([size.x+8, size.y+8, size.z + height.x]);
    }
}

module boardProtectiveBoxBottom(size, feet, holeSize, height) {
    difference() {
    cube([size.x+10, size.y+10, size.z + height.y]);
    translate([1,1,1]) cube([size.x+8, size.y+8, size.z + height.y+8]);
    }
}