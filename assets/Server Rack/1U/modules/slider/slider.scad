include <slider dimensions.scad>
use <../../utils/dovetails.scad>
include <../../boards/orangepi zero dimensions.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>
include <NopSCADlib/vitamins/batteries.scad>

//slider();
//printSliderBitsForChecking();
//sliderWithPins();

module printSliderBitsForChecking() {
    union() {
        /*translate([threadedRodDiameter * 2, 0, 0]) */ intersection() {
            sliderWithPins();
            // Threaded rod insert
            translate([- pinSize.x, - pinSize.y, 0]) rotate([270, 0, 0])  cube([usableSize[0] * .3, usableSize[1],
                    pinSize.y + usableSize[2]])
                ;
        }
    }
}

module sliderWithPins() {
    union() {
        color("#296E01") slider_plate_pins();
        color("#296E01") translate([0, 0, 0]) slider_plate();
        // C:\Support\users\stf\3DDesign\assets\OrangePiZeroUps\OrangePi_Zero_LTS_Board.stl
        // When working in slider
        /*translate([size.x / 2, size.z * 2.6, - size.y * 1.3]) rotate([270, 90, 0]) import(
        "../../../../OrangePiZeroUps/OrangePi_Zero_LTS.stl",*/
        // When working in the 1U rack
        color("#003366") translate([size.x / 2, size.z * 2.6, - size.y * 1.5]) rotate([270, 90, 0]) import(
        "../../../OrangePiZeroUps/OrangePi_Zero_LTS.stl",
        convexity = 10);
        translate([usableSize.x - battery_diameter(S25R18650) / 2, battery_diameter(S25R18650) / 2, - usableSize.x -
                battery_length(S25R18650) / 2 + contact_tab_length(S25R18650) / 2]) battery18650();
    }
}

module battery18650() {

    battery = S25R18650;
    rotate(- 135)                            // To show Lumintop USB socket and LEDs
        battery(battery);

    contact = battery_contact(battery);
    translate_z(battery_length(battery) / 2 + contact_pos(contact).x)
    rotate([0, 180, 0])
        battery_contact(contact);

    translate_z(- battery_length(battery) / 2 - contact_neg(contact).x)
    battery_contact(contact, false);
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