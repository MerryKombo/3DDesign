include <fake top board dimensions.scad>
use <../Server Rack/1U/parts/feet.scad>
use <../Server Rack/1U/parts/generic bracket.scad>
use <../Server Rack/1U/parts/generic drilling templates.scad>
use <../Server Rack/1U/parts/dimensions verifier.scad>
use <../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../Server Rack/1U/utils/intersection.scad>
include <fake top board label.scad>

/*
fake_top_board_feet();
translate(size) fake_top_board_bracket();
translate(size) translate(size) fake_top_board_drilling_template();
translate(size) translate(size) translate(size) fake_top_board_dimensions_verifier();
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) fake_top_board_hotShoe_adapters();*/
/*translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) translate(size)
    fake_top_board_screw_on_plank();*/
/*translate([- size.x, size.y, size.z]) fake_top_board_vertical_bracket();*/

fake_top_board_bracket();
//fake_top_board_dimensions_verifier();

module fake_top_board_feet() {
    feet_feet(feet, holeSize, baseSize, baseHeight, totalHeight) ;
}

module fake_top_board_bracket() {
    union() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    tanOppositeAngle=(feet[1].x-feet[0].x)/(feet[3].y-feet[1].y);
    echo("Tan is", tanOppositeAngle);
    oppositeAngle=90 - atan(tanOppositeAngle);
    echo("Angle is", oppositeAngle);
    //rotate([0,0,oppositeAngle]) translate([0,0,baseHeight-plateHeight])
    //    drawLabel(label, baseSize, plateHeight, linkHeight, feet); 

    }
}

module fake_top_board_drilling_template() {
    drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module fake_top_board_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}

module fake_top_board_hotShoe_adapters() {
    fake_top_board_hotShoe_adapter_main();
    translate([- size.x * 2, 0, 0]) fake_top_board_hotShoe_adapter_reverted();
    translate([- size.x * 3, 0, 0]) fake_top_board_hotShoe_adapter_vertical();
    translate([- size.x * 4, 0, 0]) fake_top_board_hotShoe_adapter_vertical_90_degrees();
}

module fake_top_board_hotShoe_adapter_reverted() {
    fake_top_board_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
        fake_top_board_bracket();
}

module fake_top_board_hotShoe_adapter_main() {
    fake_top_board_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) fake_top_board_bracket();
}

module fake_top_board_hotShoe_adapter_vertical() {
    fake_top_board_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([1, 15, hotShoeHeightClearance * 2]) fake_top_board_vertical_bracket();
}

module fake_top_board_hotShoe_adapter_vertical_90_degrees() {
    fake_top_board_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([- 15, 2, hotShoeHeightClearance * 2]) rotate([0, 0, 90])fake_top_board_vertical_bracket();
}

module fake_top_board_vertical_bracket() {
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module fake_top_board_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}

module fake_top_board_screw_on_plank() {
    union() {
        fake_top_board_bracket();
        earsForScrewingIntoAPlank(feet, linkThickness, linkHeight, baseSize, baseHeight, totalHeight);
    }
}