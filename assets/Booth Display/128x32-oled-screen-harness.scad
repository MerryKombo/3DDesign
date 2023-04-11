use <legs.scad>

topWidth = 48.55;
topHeight = 22.5;
topDepth = 0.8;

bottomDepth = 3.6;
bottomFirstRecessDepth = 1.84;
bottomFirstRecessWidth = 39;//38.55;
bottomFirstRecessHeight = 12.5;
bottomFirstRecessX = (topWidth - bottomFirstRecessWidth) / 2;
bottomFirstRecessY = (topHeight - bottomFirstRecessHeight) / 2;

bottomSecondRecessDepth = bottomDepth;
bottomSecondRecessWidth = 21.89;
bottomSecondRecessHeight = 12.5;
bottomSecondRecessX = 11.66;
bottomSecondRecessY = bottomFirstRecessY;

bottomThirdRecessDepth = bottomDepth;
bottomThirdRecessWidth = 2.7;
bottomThirdRecessHeight = 12.5;
bottomThirdRecessX = (topWidth - bottomFirstRecessWidth) / 2;  //5;
echo("[128x32-oled-screen-harness] bottomThirdRecessX: ", bottomThirdRecessX);
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

borderWidth = 3;

insertRadius = insertRadius(realHoleSize = 3);
echo("[128x32-oled-screen-harness] Boss radius is :", insertRadius);

distanceBetweenScrewHoles = (topWidth - screwX + insertRadius / 2)- (screwX - insertRadius / 2);
echo("[128x32-oled-screen-harness] The distance between the screw holes is :", distanceBetweenScrewHoles);

bottom();
// top();

// assembly();

module assembly() {
    union() {
        bottom();
        translate([0, topHeight, bottomDepth + topDepth + reinforcementDepth])
            rotate([0, 180, 180])
                top();
    }
}

module bottom() {
    union() {
        color("grey")
            difference() {
                union() {
                    cube(size = [topWidth, topHeight, bottomDepth]);
                    color("red")
                        union() {
                            translate([screwX - insertRadius / 2, screwY, 0])
                                //insertBlock(realHoleSize = 3, height = bottomDepth);
                                cylinder(h = bottomDepth, r = insertRadius, $fn = 100);
                            translate([topWidth - screwX + insertRadius / 2, screwY, 0])
                                //insertBlock(realHoleSize = 3, height = bottomDepth);
                                cylinder(h = bottomDepth, r = insertRadius, $fn = 100);
                        }
                }
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
}

module top() {
    color("olive")
        union() {
            difference() {
                union() {
                    // The main part, a simple rectangle, not very deep
                    cube(size = [topWidth, topHeight, topDepth]);
                    // ears
                    translate([screwX - insertRadius / 2, screwY, 0])
                        //insertBlock(realHoleSize = 3, height = bottomDepth);
                        cylinder(h = topDepth + reinforcementDepth, r = insertRadius, $fn = 100);
                    translate([topWidth - screwX + insertRadius / 2, screwY, 0])
                        //insertBlock(realHoleSize = 3, height = bottomDepth);
                        cylinder(h = topDepth + reinforcementDepth, r = insertRadius, $fn = 100);

                    translate([0, 0, topDepth])
                        // to which we'll add a border
                        difference() {
                            // which consists of a rectangle
                            cube(size = [topWidth, topHeight, reinforcementDepth]);
                            // from which we'll subtract a smaller rectangle so it becomes a border.
                            // We could do better by making a smaller border, then a reinforcement around the screw hole
                            translate([borderWidth, borderWidth, 0])
                                cube(size = [topWidth - 2 * borderWidth, topHeight - 2 * borderWidth, reinforcementDepth
                                    + .1]);
                        }
                    // We need to add a reinforcement around the screw hole
                    // not anymore screwReinforcement();
                }
                // The oled display-part opening
                translate([holeX, holeY, - .05]) cube(size = [holeWidth, holeHeight, topDepth + 0.1]);
                // We drill screw holes in the top
                screwHoles();
            }
            // The reinforcement
            /*translate([reinforcementX, reinforcementY, topDepth])
                union() {
                    cube(size = [reinforcementWidth, reinforcementHeight, reinforcementDepth]);
                    translate([reinforcementWidth, 0, 0])
                        cube(size = [reinforcementFootLength, reinforcementFootHeight, reinforcementDepth]);
                }*/
        }
}

module screwHoles() {
    translate([screwX - insertRadius / 2, screwY, - .05]) cylinder(h = bottomDepth + .1, r = screwHoleDiameter / 2, $fn
    = 100);
    translate([topWidth - screwX + insertRadius / 2, screwY, - .05]) cylinder(h = bottomDepth + .1, r =
        screwHoleDiameter / 2, $fn =
    100);
}

module screwReinforcement() {
    color("DarkKhaki")union() {
        translate([screwX, screwY, 0]) cylinder(h = reinforcementDepth + topDepth, r =
                screwHoleDiameter / 2 + .5, $fn = 100);
        translate([topWidth - screwX, screwY, 0]) cylinder(h = reinforcementDepth + topDepth, r = screwHoleDiameter / 2
            + .5, $fn =
        100);
    }
}