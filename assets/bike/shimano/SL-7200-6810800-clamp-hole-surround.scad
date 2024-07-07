include <SL-7200-6810800-lever-axle.scad>
use <openscad-extra/torus.scad>

//leverAxleBaseDiameter = 10;
//leverAxleBaseHeight = 1.5;
//leverAxleTopDiameter = 9;
//leverAxleTopRecessedWidth = 6;
//leverAxleTopHeight = 8;
//leverAxleTopThreadSize = 3;
//type = insertName(leverAxleTopThreadSize);

clampDiameter = 32.36;
clampThickness = 1.3;
surroundingDiameter = 13.35;
surroundingOutgrowthWidth = 6.57;
surroundingOutgrowthMaxHeight = 15.5;
surroundingOutgrowthMinHeight = 13.29;
surroundingOutgrowthThickness = 3.32;


// Stop found there: https://www.printables.com/fr/model/241625-shifter-cable-downtube-stop/comments and https://www.thingiverse.com/thing:1984708

module leverAxleBoss() {
    difference() {
        union() {
            // The trapezoidal part of the clamp
            translate([0, 0, (surroundingOutgrowthThickness - clampThickness) / 2])
                intersection() {
                    cube([surroundingOutgrowthMinHeight, surroundingOutgrowthWidth, surroundingOutgrowthThickness -
                        clampThickness],
                    center = true);
                    translate([surroundingOutgrowthMinHeight / 2, 0, 0])
                        cube([surroundingOutgrowthMinHeight / 2, surroundingOutgrowthWidth,
                                surroundingOutgrowthThickness -
                                clampThickness],
                        center = true);
                }
            // Draw a triangle with width surroundingOutgrowthWidth, height (surroundingOutgrowthMaxHeight-surroundingOutgrowthMinHeight) and thickness surroundingOutgrowthThickness - clampThickness, positionned on top of the existing cube
            translate([surroundingOutgrowthMinHeight / 2, 0, 0])
                linear_extrude(height = surroundingOutgrowthThickness - clampThickness)
                    polygon(points = [[0, -surroundingOutgrowthWidth / 2], [0, surroundingOutgrowthWidth / 2], [
                            surroundingOutgrowthMaxHeight - surroundingOutgrowthMinHeight, -surroundingOutgrowthWidth /
                            2]])
                        ;
            // Does not really work. Should be torus-shaped.
            // The diameter of the torus should be surroundingDiameter, its inner radius should be surroundingDiameter-(leverAxleTopDiameter+1)
            innerRadius = (surroundingOutgrowthThickness - clampThickness);
            outerRadius = surroundingDiameter / 2 + innerRadius;
            echo("outer radius: ", outerRadius);
            echo("inner radius: ", innerRadius);
            rotate_extrude($fn = 100)
                translate([outerRadius / 2, 0, 0])
                    circle(r = innerRadius, $fn = 100);
            hull() {
                cylinder(d = surroundingDiameter, h = 0.1, $fn = 100);
                translate([0, 0, surroundingOutgrowthThickness - (clampThickness + .1)])
                    cylinder(d = leverAxleTopDiameter + 1, h = 0.1, $fn = 100);
            }
        }
        // Draw a resting cylinder of diameter clampDiameter and height clampDiameter*2 below the existing shape
        translate([-clampDiameter, 0, -clampDiameter / 2])
            rotate([0, 90, 0])
                cylinder(d = clampDiameter, h = clampDiameter * 2, $fn = 100);
        translate([0, 0, -leverAxleBaseHeight])
            rotate([0, 0, 90])
                leverAxle(footprint = true);
    }
}

module cableStop() {
    // ./bin/python3 find-size.py
    //exception (False, "b'\\x1eb!\\xc0%@\\x00\\x00\\xb8\\rp&\\x16x\\xd6>\\xa5|h?\\x10\\x7f\\xf8@\\x00p\\x1fb\\xa6\\xd7\\x1a@yy\\xf6@6c\\x1fb\\\\+\\x1b@ff\\xf0@\\x10' should start with b'facet normal'")
    //Size in x: 20.663857
    //Size in y: 21.999949
    //Size in z: 32.50557

    // loads the Shifter_Boss_Cover_PRINT.STL file
    //translate([-14.3, 22.1,-24.165])
    translate([-20.663857 / 2, -21.999949 / 2, 0])
        translate([-3.942, 32.50557, -24.165])
            rotate([-270, 0, 0])
                //translate([-3.942, -21.999949, 32.50557/2])
                import(file = "Shifter_Cable_Downtube_Stop.STL", center = true, convexity = 10);
}

module bossCover() {
    // After projection(cut = false) bossCover();
    // ./bin/python3 find-size.py
    // Entity type: LWPOLYLINE, Width: 20.6802, Height: 20.6935, Depth: 0.0
    // Entity type: LWPOLYLINE, Width: 5.566, Height: 5.566, Depth: 0.0
    translate([-20.6802 / 2, 20.6935 / 2, 0])
        // To put it on 0,0,0
        translate([-.81, .32, -.827])
            rotate([-270, 0, 0])
                //translate([-3.942, -21.999949, 32.50557/2])
                import(file = "Shifter_Boss_Cover_PRINT.STL", center = true, convexity = 10);
}

module downTube() {
    color("red")
        translate([0, 0, -28.6 / 2])
            rotate([90, 0, 90])
                cylinder(d = 28.6, h = 32.50557, $fn = 100);
}

// As the clamp is bigger, we have some kind of virtual down tube, which is bigger than the actual down tube
module virtualDownTube() {
    color("grey")
        translate([0, 0, -clampDiameter / 2])
            rotate([90, 0, 90])
                cylinder(d = clampDiameter, h = 32.50557, $fn = 100);
}


module shim() {
    difference() {
        intersection() {
            translate([-32.50557 / 2, 0, 3])
                downTube();
            // cylinder(d = 18, h = 32.50557, $fn = 100);
            linear_extrude(height = 32.50557)
                projection(cut = false) bossCover();
        }
        translate([-32.50557 / 2, 0, 2])
            virtualDownTube();
    }
}

module bossInternalCylinders() {
    difference() {
        // 9 did work, but what about going for a tighter fit? Let's try with 9.2
        cylinder(d = 9, h = 10, $fn = 100);
        translate([0, 0, -0.1])
            cylinder(d = 6, h = 11, $fn = 100);

    }
}

module pringles() {
    union() {
        difference() {
            translate([0, 0, -0.981])
                shim();
            leverAxleBoss();
            rotate([0, 0, 90])
                leverAxle(footprint = true);
        }
    }
}

// pringles();

// ./bin/python3 find-size.py
// Entity type: LWPOLYLINE, Width: 20.2975, Height: 20.3019, Depth: 0.0
// Entity type: LWPOLYLINE, Width: 10.973590000000002, Height: 10.9647, Depth: 0.0
// That's the internal round in the boss cover, about 11 mm.
// So, the top hole (for the screw) is about 5.6 mm diameter, the we have a hole of about 11mm diameter and of 11 mm height.
// Now for the squarish hole:
// ./bin/python3 find-size.py
// Entity type: LWPOLYLINE, Width: 20.6757, Height: 20.686700000000002, Depth: 0.0
// Entity type: LWPOLYLINE, Width: 13.42, Height: 13.420000000000002, Depth: 0.0
// So a square of about 13,42 mm
//projection(cut = true)
//translate([0, -0, -0])
//rotate([-90,90,0])
//     bossCover();
//%bossCover();
module bossInternal() {
    difference() {
        union() {
            difference() {
                translate([0, 0, 2.5])
                    cube([11.3, 11.3, 6.1], center = true);
                translate([0, 32.50557 / 2, 4])
                    rotate([0, 0, -90]) downTube();
            }
            translate([0, 0, 5.5])
                bossInternalCylinders();
        }
        cylinder(d = 6, h = 30, $fn = 100, center = true);
    }
}

module shimshimshim() {
    difference() {
        // translate([0, 0, 1.5])
        cube([17.85, 16.78, 3], center = true);
        //pringles();
        leverAxleBoss();
        cylinder(d = 10, h = 10, $fn = 100);
        translate([-32.50557 / 2, 0, 1])
            virtualDownTube();
    }
}

shimshimshim();
difference() {
    translate([0, 0, -2.5])
        rotate([0, 0, 90])
            bossInternal();
    leverAxleBoss();
    //cylinder(d = 10, h = 10, $fn = 100);
}
