include <BOSL2/std.scad>

// Panel dimensions
width = 100;
height = 63.311;
thickness = 2;

$fn = 64;  // Higher resolution for smoother circles

module roundedPanel() {
    // Main panel with rounded corners (R2.5)
    hull() {
        translate([3, 3, 0])
            cylinder(r = 2.5, h = thickness);
        translate([width - 3, 3, 0])
            cylinder(r = 2.5, h = thickness);
        translate([3, height - 3, 0])
            cylinder(r = 2.5, h = thickness);
        translate([width - 3, height - 3, 0])
            cylinder(r = 2.5, h = thickness);
    }
}

module mountingHoles() {
    // Corner mounting holes (d=4mm)
    translate([3, 3, -1])
        cylinder(h = thickness + 2, d = 4);
    translate([width - 3, 3, -1])
        cylinder(h = thickness + 2, d = 4);
    translate([3, height - 3, -1])
        cylinder(h = thickness + 2, d = 4);
    translate([width - 3, height - 3, -1])
        cylinder(h = thickness + 2, d = 4);
}

module reelHoles() {
    // Reel holes based on drawing dimensions
    translate([25, height - 35.5, -1])
        cylinder(h = thickness + 2, d = 10);  // Left reel
    translate([75.5, height - 35.5, -1])
        cylinder(h = thickness + 2, d = 10);  // Right reel
}

module reelMount() {
    // reel mounting area
    translate([34.262, 15.5, -1]) {
        // Main reel hole
        cylinder(h = thickness + 2, d = 4.5);

        // Left mounting feature
        translate([8, -2, 0])
            cube([2, 2, thickness + 2]);

        // Right mounting feature
        translate([22.5, -2, 0])
            cube([2, 2, thickness + 2]);
    }
}

module cassetteByAI() {
    // Combine all features
    difference() {
        roundedPanel();
        mountingHoles();
        reelHoles();
        reelMount();
    }
}

cassetteWidth = 100;
cassetteHeight = 63.311;
cassetteRoundedRadius = 3;
cassettePanelRoundedRadius = 2;
cassettePanelWidth = 84 + 2 * cassettePanelRoundedRadius;
cassettePanelHeight = 35.5 + 2 * cassettePanelRoundedRadius;
distanceBetweenPanelAndCassetteTop = 5.5;
cassettePanelTranslation = -((cassetteHeight - cassettePanelHeight) / 2 - distanceBetweenPanelAndCassetteTop);
cassetteInsidePanelWidth = 59.5;
cassetteInsidePanelHeight = 18;
cassetteInsidePanelRadius = 2;
distanceBetweenInsidePanelAndPanelTop = 14.247;
cassetteInsidePanelTranslation = (cassettePanelTranslation - (cassettePanelHeight - cassetteInsidePanelHeight) / 2) +
    distanceBetweenInsidePanelAndPanelTop;
cassettereelHoleRadius = 5;
cassettereelHoleCenter = [9, 9];
cassettereelHoleXTranslation = (cassetteInsidePanelWidth / 2) - cassettereelHoleCenter.x;

// Trapezoidal bottom dimensions
cassettePolygonTopWidth = 30.5 * 2;
cassettePolygonSideLength = 15.5;
cassettePolygonAngle = 12;

// Angle conversion to radians
cassettePolygonAngleRad = cassettePolygonAngle * 3.14159265359 / 180;

// Calculated dimensions
cassettePolygonBottomWidth = cassettePolygonTopWidth + 2 * cassettePolygonSideLength * cos(cassettePolygonAngleRad);
cassettePolygonHeight = cassettePolygonSideLength * sin(cassettePolygonAngleRad);

// Define trapezoidal bottom part using polygon
module cassetteBottomPolygon() {
    polygon(points=[
            [0, 0],  // Bottom left corner
            [cassettePolygonBottomWidth, 0],  // Bottom right corner
            [(cassettePolygonBottomWidth - cassettePolygonTopWidth) / 2, cassettePolygonHeight],  // Top right corner
            [(cassettePolygonBottomWidth - cassettePolygonTopWidth) / 2 + cassettePolygonTopWidth, cassettePolygonHeight]  // Top left corner
        ]);
}

difference() {
    union() {
        rect([cassetteWidth, cassetteHeight], rounding = cassetteRoundedRadius);
        color("blue")
            translate([0, cassettePanelTranslation, 0])
                rect([cassettePanelWidth, cassettePanelHeight], rounding = cassettePanelRoundedRadius);
        color("red")
            translate([0, cassetteInsidePanelTranslation, 0])
                rect([cassetteInsidePanelWidth, cassetteInsidePanelHeight], rounding = cassetteInsidePanelRadius);
        color("white")
            translate([0, cassetteHeight / 2])
                cassetteBottomPolygon();
    }
    color("black")
        union() {
            translate([cassettereelHoleXTranslation, cassetteInsidePanelTranslation, -1])
                cylinder(r = cassettereelHoleRadius, h = 2);
            translate([-cassettereelHoleXTranslation, cassetteInsidePanelTranslation, -1])
                cylinder(r = cassettereelHoleRadius, h = 2);
        }
    echo("cassettereelHoleXTranslation is", cassettereelHoleXTranslation);
}
