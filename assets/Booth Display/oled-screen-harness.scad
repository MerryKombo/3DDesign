topWidth = 48.55;
topHeight = 22.5;
topDepth = 0.4;

bottomDepth = 3.6;
bottomFirstRecessDepth = 1.84;
bottomFirstRecessWidth = 38.55;
bottomFirstRecessHeight = 12.5;
bottomFirstRecessX = (topWidth - bottomFirstRecessWidth) / 2;
bottomFirstRecessY = (topHeight - bottomFirstRecessHeight) / 2;

bottomSecondRecessDepth = bottomDepth;
bottomSecondRecessWidth = 21.89;
bottomSecondRecessHeight = 12.5;
bottomSecondRecessX = 11.66;
bottomSecondRecessY = bottomFirstRecessY;

bottomThirdRecessDepth = bottomDepth;
bottomThirdRecessWidth = 2.6;
bottomThirdRecessHeight = 12.5;
bottomThirdRecessX = 5;
bottomThirdRecessY = bottomFirstRecessY;

holeWidth = 24.38;
holeHeight = 7.58;
holeX = 11.66;
holeY = 7.46;

screwHoleDiameter = 3;
screwDistance = 43.5;
screwX = (topWidth - screwDistance) / 2;
screwY = 11.25;

reinforcementHeight = 12.5;
reinforcementWidth = 2.95;
reinforcementDepth = 1.8;
reinforcementX = 7.6;
reinforcementY = 5;
reinforcementFootLength = 1.11;
reinforcementFootHeight = 0.8;

//bottom();
top();

module assembly() {
    union() {
        bottom();
        translate([0, topHeight, bottomDepth + topDepth])
            rotate([0, 180, 180])
                top();
    }
}

module bottom() {
    color("grey")
        difference() {
            cube(size = [topWidth, topHeight, bottomDepth]);
            screwHoles();
            // First recess
            translate([bottomFirstRecessX, bottomFirstRecessY, bottomDepth - bottomFirstRecessDepth + 0.1])
                cube(size = [bottomFirstRecessWidth, bottomFirstRecessHeight, bottomFirstRecessDepth + 0.1]);
            // Second recess
            translate([bottomSecondRecessX, bottomSecondRecessY, - 0.1])
                cube(size = [bottomSecondRecessWidth, bottomSecondRecessHeight, bottomDepth + 0.1]);
            // Third recess
            translate([bottomThirdRecessX, bottomThirdRecessY, - 0.1])
                cube(size = [bottomThirdRecessWidth, bottomThirdRecessHeight, bottomDepth + 0.1]);
        }
}

module top() {
    color("olive")
        union() {
            difference() {
                cube(size = [topWidth, topHeight, topDepth]);
                translate([holeX, holeY, - .05]) cube(size = [holeWidth, holeHeight, topDepth + 0.1]);
                screwHoles();
            }
            translate([reinforcementX, reinforcementY, 0])
                union() {
                    cube(size = [reinforcementWidth, reinforcementHeight, reinforcementDepth]);
                    translate([reinforcementWidth, 0, 0])
                        cube(size = [reinforcementFootLength, reinforcementFootHeight, reinforcementDepth]);
                }
        }
}

module screwHoles() {
    translate([screwX, screwY, - .05]) cylinder(h = bottomDepth + .1, r = screwHoleDiameter / 2, $fn = 100);
    translate([topWidth - screwX, screwY, - .05]) cylinder(h = bottomDepth + .1, r = screwHoleDiameter / 2, $fn =
    100);
}