include <../module-dimensions.scad>
include <power-supply-dimensions.scad>

//size = [30, 40];
// scallopedVent(size);
// scallops(size);
// insideScallops(size);

module scallopedVent(size) {
    translate([0, - (rodSurroundingDiameter - surroundingDiameter),
        size.y])
        rotate([270, 0, 270])
            difference() {
                scallops(size);
                color("red") insideScallops(size);
            }
}

module insideScallops(size) {
    ySizeDifference = 2 * surroundingDiameter;
    insideSize = [size.x - 2 * surroundingDiameter, size.y - ySizeDifference];
    translate([0, - ySizeDifference / 2, surroundingDiameter])
        union() {
            difference() {
                hull() {
                    union() {
                        translate([0, ySizeDifference, 0]) scallop(insideSize);
                        translate([0, size.y, insideSize.x]) rotate([180, 0, 0]) scallop (insideSize);
                    }
                }

                // The top one
                color("red") translate([0, ySizeDifference - surroundingDiameter, 0]) scallop(insideSize);
                // The bottom one
                color("black") translate([0, insideSize.y + 3 * surroundingDiameter, insideSize.x]) rotate([180, 0, 0]) scallop(insideSize);
            }
        }
}

module scallops(size) {
    difference() {
        hull() union() {
            scallop(size);
            color("green") translate([0, size.y, size.x]) rotate([180, 0, 0]) scallop(size);
        }
        // The top one
        color("black") translate([0, - surroundingDiameter, 0]) scallop(size);
        // The bottom one
        color("black") translate([0, size.y + surroundingDiameter, size.x]) rotate([180, 0, 0]) scallop(size);
    }
}

module scallop(size) {
    linear_extrude(height = size.x) union() {
        firstBlowerScallopArc();
        firstBlowerScallopExtension();
    }
}

module firstBlowerScallopExtension() {
    translate([- (rodSurroundingDiameter - surroundingDiameter) / 2, - surroundingDiameter / 2 + (rodSurroundingDiameter
        + surroundingDiameter) / 2]) square(size = [
            rodSurroundingDiameter -
            surroundingDiameter, surroundingDiameter], center = true);
}

module firstBlowerScallopArc() {
    difference() {
        circle(d = rodSurroundingDiameter + surroundingDiameter, $fn = 100);
        circle(d = threadedRodDiameter, $fn = 100);

        translate([- rodSurroundingDiameter, - rodSurroundingDiameter]) square(size = [rodSurroundingDiameter * 2,
            rodSurroundingDiameter], center = false);
        rotate([0, 0, 90]) square(size = [rodSurroundingDiameter * 2, rodSurroundingDiameter], center = false);
    }
}