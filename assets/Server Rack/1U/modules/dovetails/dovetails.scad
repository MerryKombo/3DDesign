include <../module-dimensions.scad>

module moduleDovetails(moduleWidth, moduleLength, moduleHeight) {
    moduleDovetail(moduleWidth, moduleLength, moduleHeight);
    translate([moduleWidth, 0, moduleHeight]) rotate([0, 180, 0]) moduleDovetail(moduleWidth, moduleLength, moduleHeight);
}

module moduleDovetail(moduleWidth, moduleLength, moduleHeight) {
    translate([0, moduleLength + dovetailHeight, (dovetailEnclosureWidth - dovetailBaseMaxWidth) / 2 +
        dovetailMaxMinusMaxWidth]) rotate([180, 270, 0])
        linear_extrude(height = moduleWidth)
            union() {
                mainDovetailEnclosure(moduleWidth, moduleLength, moduleHeight);
                mainDovetailEnclosureLeftEar(moduleWidth, moduleLength, moduleHeight);
                mainDovetailEnclosureRightEar(moduleWidth, moduleLength, moduleHeight);
            }
}

module mainDovetailEnclosure(moduleWidth, moduleLength, moduleHeight) {
    difference() {
        mainDovetailEnclosureLayout(moduleWidth, moduleLength, moduleHeight);
        mainDovetailEnclosureDovetail(moduleWidth, moduleLength, moduleHeight);
    }
}

module mainDovetailEnclosureDovetail(moduleWidth, moduleLength, moduleHeight) {
    polygon(points = [[0, 0], [dovetailBaseMaxWidth, 0], [dovetailBaseMaxWidth +
        dovetailMaxMinusMaxWidth,
        dovetailHeight], [- dovetailMaxMinusMaxWidth, dovetailHeight]], paths = [[0, 1, 2, 3]],
    convexity = 1);
}

module mainDovetailEnclosureLayout(moduleWidth, moduleLength, moduleHeight) {
    translate([- (dovetailEnclosureWidth - dovetailBaseMaxWidth) / 2, 0]) square(size = [
        dovetailEnclosureWidth,
        dovetailEnclosureHeight]);
}

module mainDovetailEnclosureLeftEar(moduleWidth, moduleLength, moduleHeight) {
    translate([- (dovetailEnclosureWidth - dovetailBaseMaxWidth) / 2, 0, 0]) polygon(points = [[-
    dovetailMaxMinusMaxWidth, 0], [
        dovetailBaseMinWidth, 0], [- 0, dovetailEnclosureHeight], [- dovetailMaxMinusMaxWidth,
        dovetailEnclosureHeight
        ]], paths = [[0, 1, 2, 3]], convexity = 1);
}

module mainDovetailEnclosureRightEar(moduleWidth, moduleLength, moduleHeight) {
    translate([dovetailBaseMaxWidth + dovetailMaxMinusMaxWidth, 0, 0]) polygon(points = [[0, 0], [
        dovetailBaseMinWidth, 0], [0, dovetailEnclosureHeight], [dovetailMaxMinusMaxWidth,
        dovetailEnclosureHeight
        ]], paths = [[0, 1, 3, 2]], convexity = 1);
}


module maleDovetails(width) {
    maleDovetail(width);
    translate([0, 0, (moduleHeight - dovetailMaleToFemaleRatio * (dovetailEnclosureWidth + dovetailBaseMaxWidth))])
        maleDovetail(width);
}

module maleDovetail(width) {
    translate([width, dovetailHeight, dovetailMaleToFemaleRatio * dovetailEnclosureWidth]) rotate([180, 90, 0])
        linear_extrude(height =
        width)  scale([dovetailMaleToFemaleRatio, dovetailMaleToFemaleRatio])
            mainDovetailEnclosureDovetail();
}