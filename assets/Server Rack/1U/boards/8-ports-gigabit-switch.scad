include <8-ports-gigabit-switch-dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
use <../../../Mobile Studio/hot shoe/files/hotshoe_adapter_v2.scad>
use <../utils/intersection.scad>
include <../../../Mobile Studio/15mm rod mount/rod mount.scad>


/*eight_ports_gigabit_switch_feet_feet();
translate(size) eight_ports_gigabit_switch_feet_bracket();
translate(size) translate(size) eight_ports_gigabit_switch_feet_drilling_template();
translate(size) translate(size) translate(size) eight_ports_gigabit_switch_feet_dimensions_verifier();
translate([- size.x, size.y, size.z]) translate(size) translate(size) translate(size) eight_ports_gigabit_switch_feet_hotShoe_adapters();
translate([- size.x, size.y, size.z]) eight_ports_gigabit_switch_feet_vertical_bracket();
translate([- size.x, - size.y, - size.z]) eight_ports_gigabit_switch_feet_rod_module();
*/

module eight_ports_gigabit_switch_feet_feet() {
    feet_feet(feet, holeSize, baseSize, baseHeight, totalHeight) ;
}

module eight_ports_gigabit_switch_feet_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}

module eight_ports_gigabit_switch_feet_drilling_template() {
    drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module eight_ports_gigabit_switch_feet_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}


module eight_ports_gigabit_switch_feet_hotShoe_adapters() {
    union() {
        eight_ports_gigabit_switch_feet_hotShoe_adapter_main();
        translate([- size.x * 2, 0, 0]) eight_ports_gigabit_switch_feet_hotShoe_adapter_reverted();
        translate([- size.x * 3, 0, 0]) eight_ports_gigabit_switch_feet_hotShoe_adapter_vertical();
        translate([- size.x * 4, 0, 0]) eight_ports_gigabit_switch_feet_hotShoe_adapter_vertical_90_degrees();
    }
}

module eight_ports_gigabit_switch_feet_hotShoe_adapter_reverted() {
    union() {
        eight_ports_gigabit_switch_feet_hotShoe_adapter_base();
        middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
        rotate(a = [0, 0, 180]) translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
            eight_ports_gigabit_switch_feet_bracket();
    }
}

module eight_ports_gigabit_switch_feet_hotShoe_adapter_main() {
    union() {
        eight_ports_gigabit_switch_feet_hotShoe_adapter_base();
        middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
        translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)
            eight_ports_gigabit_switch_feet_bracket();
    }
}

module eight_ports_gigabit_switch_feet_hotShoe_adapter_vertical() {
    union() {
        eight_ports_gigabit_switch_feet_hotShoe_adapter_base();
        middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

        xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
        // How much of the board will go past the X holes?
        xOverHang = abs(size.x - (xMiddle * 2));

        translate([17, 24, hotShoeHeightClearance * 2 + xOverHang * 2 + 1])
            eight_ports_gigabit_switch_feet_vertical_bracket
            ();
    }
}

module eight_ports_gigabit_switch_feet_hotShoe_adapter_vertical_90_degrees() {
    union() {
        eight_ports_gigabit_switch_feet_hotShoe_adapter_base();
        middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);

        xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
        // How much of the board will go past the X holes?
        xOverHang = abs(size.x - (xMiddle * 2));

        translate([- 24, 17, hotShoeHeightClearance * 2 + xOverHang * 2 + 1]) rotate([0, 0, 90])
            eight_ports_gigabit_switch_feet_vertical_bracket();
    }
}

module eight_ports_gigabit_switch_feet_vertical_bracket() {
    union() {
        middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
        //    translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint)vertical_bracket(feet, holeSize,
        //baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
        translate([0, 0, hotShoeHeightClearance - baseHeight]) translate(- middlePoint) vertical_bracket(feet, holeSize,
        baseSize, baseHeight, totalHeight, linkThickness, linkHeight, true);
    }
}

module eight_ports_gigabit_switch_feet_hotShoe_adapter_base() {
    union() {
        hotshoe_adapter(1);
        color("silver") hotshoe_adapter(hotShoeHeightClearance, true);
    }
}

module eight_ports_gigabit_switch_feet_rod_module() {
    union() {
        translate([0, 0, bar_z]) rotate([0, 0, 90]) difference() {
            rod_module();
            cube(size = [bar_x, rod_spread - (rod_d + linkThickness), bar_x / 2], center = true);
        }
        minPoint = getMinPoint(feet);
        maxPoint = getMaxPoint(feet);
        echo("Feet is ", feet);
        echo("Max Point is ", maxPoint);
        echo("Min Point is ", minPoint);
        xMaxDistance = maxPoint.x - minPoint.x;
        yMaxDistance = maxPoint.y - minPoint.y;
        echo("Y max distance is ", yMaxDistance);
        echo("X max distance is ", xMaxDistance);
        translate([(- bar_y + xMaxDistance) / 2 - 17, - (bar_x + yMaxDistance) / 2 + 7, bar_z + totalHeight + baseHeight
            ])eight_ports_gigabit_switch_feet_bracket();
    }
}