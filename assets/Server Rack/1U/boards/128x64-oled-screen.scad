include <128x64-oled-screen-dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>
include <128x64-oled-screen-label.scad>

/*
128x64_oled_screen_feet();
translate(size) 128x64_oled_screen_bracket();
translate(size) translate(size) 128x64_oled_screen_drilling_template();
translate(size) translate(size) translate(size) 128x64_oled_screen_dimensions_verifier();
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) 128x64_oled_screen_hotShoe_adapters();*/
/*translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) translate(size)
    128x64_oled_screen_screw_on_plank();*/
/*translate([- size.x, size.y, size.z]) 128x64_oled_screen_vertical_bracket();*/

128x64_oled_screen_bracket();

module 128x64_oled_screen_feet() {
    feet_feet(feet, holeSize, baseSize, baseHeight, totalHeight) ;
}

module 128x64_oled_screen_bracket() {
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

module 128x64_oled_screen_drilling_template() {
    drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module 128x64_oled_screen_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}

module 128x64_oled_screen_hotShoe_adapters() {
    128x64_oled_screen_hotShoe_adapter_main();
    translate([- size.x * 2, 0, 0]) 128x64_oled_screen_hotShoe_adapter_reverted();
    translate([- size.x * 3, 0, 0]) 128x64_oled_screen_hotShoe_adapter_vertical();
    translate([- size.x * 4, 0, 0]) 128x64_oled_screen_hotShoe_adapter_vertical_90_degrees();
}

module 128x64_oled_screen_hotShoe_adapter_reverted() {
    128x64_oled_screen_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
        128x64_oled_screen_bracket();
}

module 128x64_oled_screen_hotShoe_adapter_main() {
    128x64_oled_screen_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) 128x64_oled_screen_bracket();
}

module 128x64_oled_screen_hotShoe_adapter_vertical() {
    128x64_oled_screen_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([1, 15, hotShoeHeightClearance * 2]) 128x64_oled_screen_vertical_bracket();
}

module 128x64_oled_screen_hotShoe_adapter_vertical_90_degrees() {
    128x64_oled_screen_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([- 15, 2, hotShoeHeightClearance * 2]) rotate([0, 0, 90])128x64_oled_screen_vertical_bracket();
}

module 128x64_oled_screen_vertical_bracket() {
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module 128x64_oled_screen_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}

module 128x64_oled_screen_screw_on_plank() {
    union() {
        128x64_oled_screen_bracket();
        earsForScrewingIntoAPlank(feet, linkThickness, linkHeight, baseSize, baseHeight, totalHeight);
    }
}