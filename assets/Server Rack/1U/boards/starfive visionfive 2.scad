include <starfive visionfive 2 dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>
include <starfive visionfive 2 label.scad>

/*
starfive_visionfive_2_feet();
translate(size) starfive_visionfive_2_bracket();
translate(size) translate(size) starfive_visionfive_2_drilling_template();
translate(size) translate(size) translate(size) starfive_visionfive_2_dimensions_verifier();
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) starfive_visionfive_2_hotShoe_adapters();*/
/*translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) translate(size)
    starfive_visionfive_2_screw_on_plank();*/
/*translate([- size.x, size.y, size.z]) starfive_visionfive_2_vertical_bracket();*/

starfive_visionfive_2_bracket();

module starfive_visionfive_2_feet() {
    feet_feet(feet, holeSize, baseSize, baseHeight, totalHeight) ;
}

module starfive_visionfive_2_bracket() {
    union() {
        bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
        tanOppositeAngle=(feet[1].x-feet[0].x)/(feet[3].y-feet[1].y);
        echo("Tan is", tanOppositeAngle);
        oppositeAngle=90 - atan(tanOppositeAngle);
        echo("Angle is", oppositeAngle);
        rotate([0,0,oppositeAngle]) translate([baseSize/2,-baseSize,baseHeight-plateHeight])
            drawLabel(label, baseSize, plateHeight, linkHeight, feet);

    }
}

module starfive_visionfive_2_drilling_template() {
    drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module starfive_visionfive_2_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}

module starfive_visionfive_2_hotShoe_adapters() {
    starfive_visionfive_2_hotShoe_adapter_main();
    translate([- size.x * 2, 0, 0]) starfive_visionfive_2_hotShoe_adapter_reverted();
    translate([- size.x * 3, 0, 0]) starfive_visionfive_2_hotShoe_adapter_vertical();
    translate([- size.x * 4, 0, 0]) starfive_visionfive_2_hotShoe_adapter_vertical_90_degrees();
}

module starfive_visionfive_2_hotShoe_adapter_reverted() {
    starfive_visionfive_2_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
        starfive_visionfive_2_bracket();
}

module starfive_visionfive_2_hotShoe_adapter_main() {
    starfive_visionfive_2_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) starfive_visionfive_2_bracket();
}

module starfive_visionfive_2_hotShoe_adapter_vertical() {
    starfive_visionfive_2_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([1, 15, hotShoeHeightClearance * 2]) starfive_visionfive_2_vertical_bracket();
}

module starfive_visionfive_2_hotShoe_adapter_vertical_90_degrees() {
    starfive_visionfive_2_hotShoe_adapter_base();
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

    xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
    // How much of the board will go past the X holes?
    xOverHang = abs(size.x - (xMiddle * 2));

    translate([- 15, 2, hotShoeHeightClearance * 2]) rotate([0, 0, 90])starfive_visionfive_2_vertical_bracket();
}

module starfive_visionfive_2_vertical_bracket() {
    middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
    //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
    baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
}

module starfive_visionfive_2_hotShoe_adapter_base() {
    hotshoe_adapter(1);
    color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
}

module starfive_visionfive_2_screw_on_plank() {
    union() {
        starfive_visionfive_2_bracket();
        earsForScrewingIntoAPlank(feet, linkThickness, linkHeight, baseSize, baseHeight, totalHeight);
    }
}