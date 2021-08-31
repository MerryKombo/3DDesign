include <slider dimensions.scad>
use <../../utils/dovetails.scad>

//slider();
//printSliderBitsForChecking();
//sliderWithPins();

module printSliderBitsForChecking() {
    union() {
        /*translate([threadedRodDiameter * 2, 0, 0]) */ intersection() {
            sliderWithPins();
            // Threaded rod insert
            translate([- pinSize.x, -pinSize.y, 0]) rotate([270, 0, 0])  cube([usableSize[0] * .3, usableSize[1], pinSize.y+usableSize[2]])
                ;
        }
    }
}

module sliderWithPins() {
    union() {
        slider_plate_pins();
        translate([0, 0, 0]) slider_plate();
    }
}

module slider() {
    union() {
        slider_dovetails();
        slider_plate();
    }
}

module slider_plate_pins() {
    union() {
        // Front pins
        translate([- pinDepth, (plateThickness - (pinSize.x / 2)), - (frontPinsShift)]) pin();
        translate([usableSize[0] - (pinSize.x - pinDepth), (plateThickness - (pinSize.x / 2)), - (frontPinsShift)]) pin(
        );
        // Rear pins
        translate([- pinDepth, (plateThickness - (pinSize.x / 2)), - usableSize[1] + rearPinsShift]) pin();
        translate([usableSize[0] - (pinSize.x - pinDepth), (plateThickness - (pinSize.x / 2)), - usableSize[1] +
            rearPinsShift]) pin();
    }
}

module pin() {
    rotate([0, 90, 0])cylinder(h = pinSize.y, d = pinSize.y, center = false, $fn = 100);
}

module slider_plate() {
    rotate([270, 0, 0]) color("yellow") cube(usableSize);
}

module slider_single_dovetail() {
    echo(baseDovetailBottomHeight);
    echo(baseDovetailTopHeight);
    color("blue") linear_extrude(usableSize[1]) polygon(points = [[0, 0], [0, dovetailHeight], [dovetailHeight,
        baseDovetailTopHeight], [dovetailHeight, baseDovetailBottomHeight]]);
}

module slider_dovetails() {
    union() {
        color("red") slider_single_dovetail();
        translate([usableSize[0] + dovetailHeight * 2, 0, usableSize[1]]) color("blue") rotate([0, 180, 0])
            slider_single_dovetail();
    }
}