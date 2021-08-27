include <PWM to V dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>
 
PWM_to_V_feet();
translate(size) PWM_to_V_bracket();
translate(size) translate(size) PWM_to_V_drilling_template();
translate(size) translate(size) translate(size) PWM_to_V_dimensions_verifier();

translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) PWM_to_V_hotShoe_adapters();
translate([- size.x, size.y, size.z]) PWM_to_V_vertical_bracket();

module PWM_to_V_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module PWM_to_V_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    
module PWM_to_V_drilling_template() {
   drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module PWM_to_V_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}


module PWM_to_V_hotShoe_adapters() {
    PWM_to_V_hotShoe_adapter_main();
    translate([- size.x * 2, 0, 0]) PWM_to_V_hotShoe_adapter_reverted();
    translate([- size.x * 3, 0, 0]) PWM_to_V_hotShoe_adapter_vertical();
    translate([- size.x * 4, 0, 0]) PWM_to_V_hotShoe_adapter_vertical_90_degrees();
}

module PWM_to_V_hotShoe_adapter_reverted() {
    PWM_to_V_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
        PWM_to_V_bracket();
}

module PWM_to_V_hotShoe_adapter_main() {
    PWM_to_V_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) PWM_to_V_bracket();
}

module PWM_to_V_hotShoe_adapter_vertical() {
    PWM_to_V_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([0, 10,hotShoeHeightClearance*2+7]) PWM_to_V_vertical_bracket();
}

module PWM_to_V_hotShoe_adapter_vertical_90_degrees() {
    PWM_to_V_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([-10, 0,hotShoeHeightClearance*2+7]) rotate([0,0,90])PWM_to_V_vertical_bracket();
}

module PWM_to_V_vertical_bracket() {
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module PWM_to_V_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}