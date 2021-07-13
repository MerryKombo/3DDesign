include <khadas vim3L dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>

khadas_vim3L_feet();
translate(size) khadas_vim3L_bracket();
translate(size) translate(size) khadas_vim3L_drilling_template();
translate(size) translate(size) translate(size) khadas_vim3L_dimensions_verifier();
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) khadas_vim3L_hotShoe_adapters();
translate([- size.x, size.y, size.z]) khadas_vim3L_vertical_bracket();

module khadas_vim3L_feet() {
    feet_feet(feet, holeSize, baseSize, baseHeight, totalHeight) ;
}

module khadas_vim3L_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}

module khadas_vim3L_drilling_template() {
    drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module khadas_vim3L_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}


module khadas_vim3L_hotShoe_adapters() {
    khadas_vim3L_hotShoe_adapter_main();
    translate([- size.x * 2, 0, 0]) khadas_vim3L_hotShoe_adapter_reverted();
    translate([- size.x * 3, 0, 0]) khadas_vim3L_hotShoe_adapter_vertical();
}

module khadas_vim3L_hotShoe_adapter_reverted() {
    khadas_vim3L_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
        khadas_vim3L_bracket();
}

module khadas_vim3L_hotShoe_adapter_main() {
    khadas_vim3L_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) khadas_vim3L_bracket();
}

module khadas_vim3L_hotShoe_adapter_vertical() {
    khadas_vim3L_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs((size.x - (xMiddle * 2)) / 2);

    translate([10, 10,hotShoeHeightClearance+ xOverHang]) khadas_vim3L_vertical_bracket();
}

module khadas_vim3L_vertical_bracket() {
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module khadas_vim3L_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}