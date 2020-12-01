include <slider dimensions.scad>
use <../../utils/dovetails.scad>

slider();

module slider() {
    union() {
        slider_dovetails();
        slider_plate();
    }
}

module slider_plate() {
    translate([dovetailHeight,baseDovetailBottomHeight,usableSize[1]]) rotate([270,0,0]) color("yellow") cube(usableSize);
}

module slider_single_dovetail() {
    echo(baseDovetailBottomHeight);
    echo(baseDovetailTopHeight);
    color("blue") linear_extrude(usableSize[1]) polygon(points=[[0,0],[0,dovetailHeight], [dovetailHeight, baseDovetailTopHeight], [dovetailHeight, baseDovetailBottomHeight]]);
}

module slider_dovetails() {
    union() {
        color("red") slider_single_dovetail();
        translate([usableSize[0] + dovetailHeight*2, 0, usableSize[1]]) color("blue") rotate([0,180,0]) slider_single_dovetail();
    }
}