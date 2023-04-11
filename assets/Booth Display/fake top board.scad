include <fake top board dimensions.scad>
include <../Server Rack/1U/boards/round tft display 1.scad>
use <../Server Rack/1U/parts/feet.scad>
use <../Server Rack/1U/parts/generic bracket.scad>
use <../Server Rack/1U/parts/generic drilling templates.scad>
use <../Server Rack/1U/parts/dimensions verifier.scad>
use <../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../Server Rack/1U/utils/intersection.scad>
include <fake top board label.scad>
use <legs.scad>


/*
fake_top_board_feet();
translate(size) fake_top_board_bracket();
translate(size) translate(size) fake_top_board_drilling_template();
translate(size) translate(size) translate(size) fake_top_board_dimensions_verifier();
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) fake_top_board_hotShoe_adapters();*/
/*translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) translate(size)
    fake_top_board_screw_on_plank();*/
/*translate([- size.x, size.y, size.z]) fake_top_board_vertical_bracket();*/

insertBlockHeight = 10;
realHoleSize = 2;
insertRadius = insertRadius(realHoleSize);

union() {
    echo("Feet are", feet);
    feetTranslation = [feet[0][0], feet[0][1], 0];
    echo("Feet translation is", feetTranslation);
    newFeet = feet - [feetTranslation, feetTranslation, feetTranslation, feetTranslation];
    echo("New feet are", newFeet);
    xtranslation = (fakeTopBoard_feet[3][0] - newFeet[3][0]) / 2;
    ytranslation = (fakeTopBoard_feet[3][1] - newFeet[3][1]) / 2;
    echo("X translation is", xtranslation);
    echo("Y translation is", ytranslation);
    difference() {
        fake_top_board_bracket();
        translate([xtranslation, ytranslation, 0])
            for (point = newFeet) {
                // translate(point) bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight);
                // translate(point) insertBlock(realHoleSize, height = insertBlockHeight);
                color("black")
                    translate(point) cylinder(h = insertBlockHeight + .1, d = insertRadius * 2, $fn = 100);
            }
    }
    translate([xtranslation, ytranslation, 0])
        for (point = newFeet) {
            // translate(point) bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight);
            difference() {
                translate(point) insertBlock(realHoleSize, height = insertBlockHeight);
                color("black")
                    translate([0, 0, - .1])translate(point) cylinder(h = insertBlockHeight + .1, d = realHoleSize, $fn =
                    100
                    );
            }
        }
}

//fake_top_board_dimensions_verifier();

module fake_top_board_feet() {
    feet_feet(fakeTopBoard_feet, fakeTopBoard_holeSize, fakeTopBoard_baseSize, fakeTopBoard_baseHeight,
    fakeTopBoard_totalHeight) ;
}

module fake_top_board_bracket() {
    union() {
        bracket_bracket(fakeTopBoard_feet, fakeTopBoard_holeSize, fakeTopBoard_baseSize, fakeTopBoard_baseHeight,
        fakeTopBoard_totalHeight, fakeTopBoard_linkThickness, fakeTopBoard_linkHeight);
        tanOppositeAngle = (fakeTopBoard_feet[1].x - fakeTopBoard_feet[0].x) / (fakeTopBoard_feet[3].y -
            fakeTopBoard_feet[1].y);
        echo("Tan is", tanOppositeAngle);
        oppositeAngle = 90 - atan(tanOppositeAngle);
        echo("Angle is", oppositeAngle);
        //rotate([0,0,oppositeAngle]) translate([0,0,baseHeight-plateHeight])
        //    drawLabel(label, baseSize, plateHeight, linkHeight, feet);

    }
}

module fake_top_board_drilling_template() {
    drillTemplate(fakeTopBoard_feet, fakeTopBoard_holeSize, fakeTopBoard_drillTemplateThickness,
    fakeTopBoard_drillTemplateGuideHeight);
}

module fake_top_board_dimensions_verifier() {
    verifier_checkDimensions(fakeTopBoard_feet, fakeTopBoard_holeSize, fakeTopBoard_verifierPlateThickness);
}

module fake_top_board_hotShoe_adapters() {
    fake_top_board_hotShoe_adapter_main();
    translate([- fakeTopBoard_size.x * 2, 0, 0]) fake_top_board_hotShoe_adapter_reverted();
    translate([- fakeTopBoard_size.x * 3, 0, 0]) fake_top_board_hotShoe_adapter_vertical();
    translate([- fakeTopBoard_size.x * 4, 0, 0]) fake_top_board_hotShoe_adapter_vertical_90_degrees();
}

module fake_top_board_hotShoe_adapter_reverted() {
    fake_top_board_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(fakeTopBoard_feet[0], fakeTopBoard_feet[3], fakeTopBoard_feet[2],
    fakeTopBoard_feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, fakeTopBoard_hotShoeHeightClearance - fakeTopBoard_baseHeight]) translate(-
    middlePoint)
        fake_top_board_bracket();
}

module fake_top_board_hotShoe_adapter_main() {
    fake_top_board_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(fakeTopBoard_feet[0], fakeTopBoard_feet[3], fakeTopBoard_feet[2],
    fakeTopBoard_feet[1]);
    translate([0, 0, fakeTopBoard_hotShoeHeightClearance - fakeTopBoard_baseHeight]) translate(- middlePoint)
        fake_top_board_bracket();
}

module fake_top_board_hotShoe_adapter_vertical() {
    fake_top_board_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(fakeTopBoard_feet[0], fakeTopBoard_feet[3], fakeTopBoard_feet[2],
    fakeTopBoard_feet[1]);

    xMiddle = max(fakeTopBoard_feet[0][0], fakeTopBoard_feet[1][0], fakeTopBoard_feet[2][0], fakeTopBoard_feet[3][0]) /
        2;
    // How much of the board will go past the X holes?
    xOverHang = abs(fakeTopBoard_size.x - (xMiddle * 2));

    translate([1, 15, fakeTopBoard_hotShoeHeightClearance * 2]) fake_top_board_vertical_bracket();
}

module fake_top_board_hotShoe_adapter_vertical_90_degrees() {
    fake_top_board_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(fakeTopBoard_feet[0], fakeTopBoard_feet[3], fakeTopBoard_feet[2],
    fakeTopBoard_feet[1]);

    xMiddle = max(fakeTopBoard_feet[0][0], fakeTopBoard_feet[1][0], fakeTopBoard_feet[2][0], fakeTopBoard_feet[3][0]) /
        2;
    // How much of the board will go past the X holes?
    xOverHang = abs(fakeTopBoard_size.x - (xMiddle * 2));

    translate([- 15, 2, fakeTopBoard_hotShoeHeightClearance * 2]) rotate([0, 0, 90])fake_top_board_vertical_bracket();
}

module fake_top_board_vertical_bracket() {
    middlePoint = IntersectionOfLines(fakeTopBoard_feet[0], fakeTopBoard_feet[3], fakeTopBoard_feet[2],
    fakeTopBoard_feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, fakeTopBoard_hotShoeHeightClearance - fakeTopBoard_baseHeight]) translate(- middlePoint)
        vertical_bracket(fakeTopBoard_feet, fakeTopBoard_holeSize,
        fakeTopBoard_baseSize, fakeTopBoard_baseHeight, fakeTopBoard_totalHeight, fakeTopBoard_linkThickness,
        fakeTopBoard_linkHeight, true);
}

module fake_top_board_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(fakeTopBoard_hotShoeHeightClearance, true);
}

module fake_top_board_screw_on_plank() {
    union() {
        fake_top_board_bracket();
        earsForScrewingIntoAPlank(fakeTopBoard_feet, fakeTopBoard_linkThickness, fakeTopBoard_linkHeight,
        fakeTopBoard_baseSize, fakeTopBoard_baseHeight, fakeTopBoard_totalHeight);
    }
}