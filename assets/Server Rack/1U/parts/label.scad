include <BOSL2/std.scad>

module drawLabel(label, labelHeight, plateHeight, textExtrusionHeight, feet) {
// Fit text into an area
// Found there: https://stackoverflow.com/a/39564288/2938320
diagonal = sqrt(feet[3].x^2+feet[3].y^2);

length = (diagonal / 2)*0.8;
w = labelHeight;

translate([(diagonal / 2)*0.15,0,0]) union() {
    // cube([length, w, plateHeight]);
    linear_extrude(plateHeight) 
    translate([length/2,w/2,0])
    rect([length, w], rounding=w/4, $fn=100);
    color("white")
        translate([0, w / 2, 0.6])
            linear_extrude(textExtrusionHeight, convexity = 4)
                resize([length, 0], auto = true)
                    text(label, valign = "center", font = "Isonorm 3098,Isonorm:style=Regular,3098", $fn=100);
}
}