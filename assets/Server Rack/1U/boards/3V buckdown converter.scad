include <3V buckdown converter dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>

3V_buckdown_converter_feet();
translate(size) 3V_buckdown_converter_bracket();
translate(size) translate(size) 3V_buckdown_converter_drilling_template();
translate(size) translate(size) translate(size) 3V_buckdown_converter_dimensions_verifier();

translate([ - size.x * 4, size.y * 4, size.z]) translate(size) translate(size) translate(size) 3V_buckdown_converter_hotShoe_adapters();

translate([ - size.x * 5, size.y * 5, size.z]) 3V_buckdown_converter_vertical_bracket();

module 3V_buckdown_converter_feet() {
feet_feet(feet, holeSize, baseSize, baseHeight, totalHeight) ;
}

module 3V_buckdown_converter_bracket() {
bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}

module 3V_buckdown_converter_drilling_template() {
drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module 3V_buckdown_converter_dimensions_verifier() {
verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}

module 3V_buckdown_converter_hotShoe_adapters() {
3V_buckdown_converter_hotShoe_adapter_main();
translate([ - size.x * 5, - size.x * 5, 0]) 3V_buckdown_converter_hotShoe_adapter_reverted();
translate([ - size.x * 6, - size.x * 65, 0]) 3V_buckdown_converter_hotShoe_adapter_vertical();
translate([ - size.x * 7, - size.x * 7, 0]) 3V_buckdown_converter_hotShoe_adapter_vertical_90_degrees();
}

module 3V_buckdown_converter_hotShoe_adapter_reverted() {
3V_buckdown_converter_hotShoe_adapter_base();
middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
3V_buckdown_converter_bracket();
}

module 3V_buckdown_converter_hotShoe_adapter_main() {
3V_buckdown_converter_hotShoe_adapter_base();
middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) 3V_buckdown_converter_bracket();
}

module 3V_buckdown_converter_hotShoe_adapter_vertical() {
3V_buckdown_converter_hotShoe_adapter_base();
middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
// How much of the board will go past the X holes?
xOverHang = abs(size.x - (xMiddle * 2));

translate([0, 10, hotShoeHeightClearance * 2 + 7]) 3V_buckdown_converter_vertical_bracket();
}

module 3V_buckdown_converter_hotShoe_adapter_vertical_90_degrees() {
3V_buckdown_converter_hotShoe_adapter_base();
middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
// How much of the board will go past the X holes?
xOverHang = abs(size.x - (xMiddle * 2));

translate([ - 4, 0, hotShoeHeightClearance * 2 +7]) rotate([0, 0, 90])3V_buckdown_converter_vertical_bracket();
}

module 3V_buckdown_converter_vertical_bracket() {
middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
//    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
//baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module 3V_buckdown_converter_hotShoe_adapter_base() {
hotshoe_adapter(1);
color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}