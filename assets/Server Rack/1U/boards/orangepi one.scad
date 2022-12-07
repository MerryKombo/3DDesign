include <orangepi one dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>

/*
orangepi_one_feet();
translate(size) orangepi_one_bracket();
translate(size) translate(size) orangepi_one_drilling_template();
translate(size) translate(size) translate(size) orangepi_one_dimensions_verifier();
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) orangepi_one_hotShoe_adapters();*/
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) translate(size)
    orangepi_one_screw_on_plank();
/*translate([- size.x, size.y, size.z]) orangepi_one_vertical_bracket();*/

module orangepi_one_feet() {
    feet_feet(feet, holeSize, baseSize, baseHeight, totalHeight) ;
}

module orangepi_one_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}

module orangepi_one_drilling_template() {
    drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module orangepi_one_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}

module orangepi_one_hotShoe_adapters() {
    orangepi_one_hotShoe_adapter_main();
    translate([- size.x * 2, 0, 0]) orangepi_one_hotShoe_adapter_reverted();
    translate([- size.x * 3, 0, 0]) orangepi_one_hotShoe_adapter_vertical();
    translate([- size.x * 4, 0, 0]) orangepi_one_hotShoe_adapter_vertical_90_degrees();
}

module orangepi_one_hotShoe_adapter_reverted() {
    orangepi_one_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
        orangepi_one_bracket();
}

module orangepi_one_hotShoe_adapter_main() {
    orangepi_one_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) orangepi_one_bracket();
}

module orangepi_one_hotShoe_adapter_vertical() {
    orangepi_one_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([1, 15, hotShoeHeightClearance * 2]) orangepi_one_vertical_bracket();
}

module orangepi_one_hotShoe_adapter_vertical_90_degrees() {
    orangepi_one_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([- 15, 2, hotShoeHeightClearance * 2]) rotate([0, 0, 90])orangepi_one_vertical_bracket();
}

module orangepi_one_vertical_bracket() {
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module orangepi_one_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}

module orangepi_one_screw_on_plank() {
    union() {
        orangepi_one_bracket();
        earsForScrewingIntoAPlank(feet, linkThickness, linkHeight, baseSize, baseHeight, totalHeight);
    }
}
