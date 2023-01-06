use <printedbearing.scad>
include <BOSL2/std.scad>
include <BOSL2/metric_screws.scad>

wheelExternalDiameter = 68;
internalFlangeHeight = 11;
wheelInternalDiameter = wheelExternalDiameter - internalFlangeHeight;
bearingDiameter = 32.35;
bearingDepth = 12;
bearingOffset = 2;
bearingInnerDiameter = 8;
bearingWallWidth = 1;
totalWidth = 16.5;
baseValleyWidth = 6;
nutDiameter = 5;

sizeTest();

module wholePart() {
    difference() {
        union() {
            mainWheel();
            printedbearing(bearingInnerDiameter, bearingDiameter, bearingDepth, bearingWallWidth);
        }
        bolts();
    }
}

module bolts() {
    translate([(wheelExternalDiameter - bearingDiameter + nutDiameter) / 2, 0, 0]) bolt();
    translate([- (wheelExternalDiameter - bearingDiameter + nutDiameter) / 2, 0, 0]) bolt();
    translate([0, (wheelExternalDiameter - bearingDiameter + nutDiameter) / 2, 0]) bolt();
    translate([0, - (wheelExternalDiameter - bearingDiameter + nutDiameter) / 2, 0]) bolt();
}

module bolt() {
    translate([0, 0, totalWidth])
        metric_bolt(size = nutDiameter, l = totalWidth * 1.05 +
            get_metric_bolt_head_height(nutDiameter), details = true, headtype = "socket");
}

module sizeTest() {
    intersection() {
        mainWheel();
        flange();
    }
}
module mainWheel() {
    flange();
    translate([0, 0, bearingDepth + bearingOffset]) flange();
    translate([0, 0, (bearingDepth + bearingOffset) / 2]) core();
}

module flange() {
    linear_extrude(height = 1, center = true, convexity = 10, twist = 0)
        difference() {
            circle(d = wheelExternalDiameter, $fn = 100);
            circle(d = bearingDiameter, $fn = 100);
        }
}

module core() {
    linear_extrude(height = bearingDepth + bearingOffset, center = true, convexity = 10, twist = 0)
        difference() {
            circle(d = wheelInternalDiameter, $fn = 100);
            circle(d = bearingDiameter, $fn = 100);
        }
}