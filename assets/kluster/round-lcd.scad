include <NopSCADlib/vitamins/pcb.scad>

module roundLCD() {
    roundLCDDistanceBetweenFeetCenter = 19.26;
    roundLCDSmallBoardSideSize = 22.92;
    roundLCDFeetHoleSize = 2;
    roundLCDHoleDistanceFromBottom = 5.83;
    roundLCDTotalHeight = 45.5;
    roundLCDPCBHeight = 1.4;
    roundLCDDisplayHeight = 1.6;
    roundLCDDisplayDiameter = 32.4;
    roundLCDBottomPart = [roundLCDSmallBoardSideSize, 11.32, roundLCDPCBHeight];
    roundLCDPinsFromBottom = 1.76;
    echo("roundLCDBottomPart: ", roundLCDBottomPart);
    roundLCDTopPart = [38, roundLCDTotalHeight - roundLCDBottomPart[1], roundLCDPCBHeight];
    echo("roundLCDTopPart: ", roundLCDTopPart);
    roundLCDfeet = [[(roundLCDSmallBoardSideSize - roundLCDDistanceBetweenFeetCenter) / 2,
        roundLCDHoleDistanceFromBottom],
            [roundLCDSmallBoardSideSize - (roundLCDSmallBoardSideSize - roundLCDDistanceBetweenFeetCenter) / 2,
            roundLCDHoleDistanceFromBottom]];
    echo("roundLCDfeet: ", roundLCDfeet);
    difference() {
        union() {
            color("#002d04")
                union() {
                    translate([-roundLCDBottomPart.y / 2, 0, 0])
                        rotate([0, 0, 90])
                            translate([0, 0, 0]) cube(size = roundLCDBottomPart, center = true);
                    translate([-(roundLCDTopPart.x + roundLCDBottomPart.y) / 2, 0, 0])
                        cylinder(h = roundLCDPCBHeight, r = roundLCDTopPart.x / 2, center = true, $fn = 100);
                }
            color("black")
                translate([-(roundLCDTopPart.x + roundLCDBottomPart.y) / 2, 0,
                    roundLCDPCBHeight])
                    cylinder(h = roundLCDDisplayHeight, r = roundLCDDisplayDiameter / 2, center = true, $fn = 100);
            translate([-roundLCDPinsFromBottom, 0, -roundLCDPCBHeight / 2])
                rotate([0, 180, 90])
                    pin_header(2p54header, 7, 1);

            for (i = [0:1]) {
                translate([-roundLCDfeet[i].y, roundLCDfeet[i].x - roundLCDSmallBoardSideSize / 2, roundLCDPCBHeight/2])
                    screw(type = M2_cap_screw, length = 8, hob_point = 0, nylon = false);
            }
        }
        // Iterate on feet to remove cylinders corresponding to the roundLCDfeet
        color("#B87333")
            for (i = [0:1])
            translate([-roundLCDfeet[i].y, roundLCDfeet[i].x - roundLCDSmallBoardSideSize / 2, 0])
                cylinder(h = roundLCDPCBHeight+.1, r = roundLCDFeetHoleSize / 2, center = true, $fn = 100);
    }
}

roundLCD();
