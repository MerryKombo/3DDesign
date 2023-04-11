include <round tft display 1 dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>
include <round tft display 1 label.scad>

/*
round_tft_display_1_feet();
translate(size) round_tft_display_1_bracket();
translate(size) translate(size) round_tft_display_1_drilling_template();
translate(size) translate(size) translate(size) round_tft_display_1_dimensions_verifier();
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) round_tft_display_1_hotShoe_adapters();*/
/*translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) translate(size)
    round_tft_display_1_screw_on_plank();*/
/*translate([- size.x, size.y, size.z]) round_tft_display_1_vertical_bracket();*/

// round_tft_display_1_bracket();
// round_tft_display_1_dimensions_verifier();

module round_tft_display_1_feet() {
    feet_feet(feet, holeSize, baseSize, baseHeight, totalHeight) ;
}

module round_tft_display_1_bracket() {
    union() {
        bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
        tanOppositeAngle = (feet[1].x - feet[0].x) / (feet[3].y - feet[1].y);
        echo("Tan is", tanOppositeAngle);
        oppositeAngle = 90 - atan(tanOppositeAngle);
        echo("Angle is", oppositeAngle);

        diagonal = sqrt(feet[3].x^2 + feet[3].y^2);
        labelLength = (diagonal / 2) - baseSize / 2 - linkThickness *1.5;
        labelHeight = baseSize / 3;

        translate([feet[0].x + linkThickness + labelHeight*.8, feet[0].y, 0])
            rotate([0, 0, oppositeAngle]) translate([0, 0, baseHeight - plateHeight])
                //drawLabel(label, baseSize, plateHeight, linkHeight, feet);

                drawLabel(label, labelHeight, labelLength, plateHeight, linkHeight / 2, feet);
    }
}

module round_tft_display_1_drilling_template() {
    drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module round_tft_display_1_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}

module round_tft_display_1_hotShoe_adapters() {
    round_tft_display_1_hotShoe_adapter_main();
    translate([- size.x * 2, 0, 0]) round_tft_display_1_hotShoe_adapter_reverted();
    translate([- size.x * 3, 0, 0]) round_tft_display_1_hotShoe_adapter_vertical();
    translate([- size.x * 4, 0, 0]) round_tft_display_1_hotShoe_adapter_vertical_90_degrees();
}

module round_tft_display_1_hotShoe_adapter_reverted() {
    round_tft_display_1_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
        round_tft_display_1_bracket();
}

module round_tft_display_1_hotShoe_adapter_main() {
    round_tft_display_1_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) round_tft_display_1_bracket();
}

module round_tft_display_1_hotShoe_adapter_vertical() {
    round_tft_display_1_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([1, 15, hotShoeHeightClearance * 2]) round_tft_display_1_vertical_bracket();
}

module round_tft_display_1_hotShoe_adapter_vertical_90_degrees() {
    round_tft_display_1_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([- 15, 2, hotShoeHeightClearance * 2]) rotate([0, 0, 90])round_tft_display_1_vertical_bracket();
}

module round_tft_display_1_vertical_bracket() {
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module round_tft_display_1_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}

module orangepi_zero_screw_on_plank() {
    union() {
        orangepi_zero_bracket();
        earsForScrewingIntoAPlank(feet, linkThickness, linkHeight, baseSize, baseHeight, totalHeight);
    }
}