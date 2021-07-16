include <battery charger dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>

battery_charger_feet();
translate(size) battery_charger_bracket();
translate(size) translate(size) battery_charger_drilling_template();
translate(size) translate(size) translate(size) battery_charger_dimensions_verifier();

translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) battery_charger_hotShoe_adapters();
translate([- size.x, size.y, size.z]) battery_charger_vertical_bracket();

module battery_charger_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module battery_charger_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    
  
module battery_charger_drilling_template() {
   drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module battery_charger_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}


module battery_charger_hotShoe_adapters() {
    battery_charger_hotShoe_adapter_main();
    translate([- size.x * 2, 0, 0]) battery_charger_hotShoe_adapter_reverted();
    translate([- size.x * 3, 0, 0]) battery_charger_hotShoe_adapter_vertical();
    translate([- size.x * 4, 0, 0]) battery_charger_hotShoe_adapter_vertical_90_degrees();
}

module battery_charger_hotShoe_adapter_reverted() {
    battery_charger_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
        battery_charger_bracket();
}

module battery_charger_hotShoe_adapter_main() {
    battery_charger_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) battery_charger_bracket();
}

module battery_charger_hotShoe_adapter_vertical() {
    battery_charger_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([6, 10,hotShoeHeightClearance*2+1]) battery_charger_vertical_bracket();
}

module battery_charger_hotShoe_adapter_vertical_90_degrees() {
    battery_charger_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([-9, 6,hotShoeHeightClearance*2+1]) rotate([0,0,90])battery_charger_vertical_bracket();
}

module battery_charger_vertical_bracket() {
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module battery_charger_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}