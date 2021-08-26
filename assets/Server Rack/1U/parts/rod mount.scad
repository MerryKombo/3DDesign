include <../../../Mobile Studio/15mm rod mount/rod mount.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>


module rod_module() {//create module
    difference() {
        union() {//start union
            /**difference() {*/
            color("yellow", 0.1)translate([0, 0, 0]) cube([bar_x, bar_y, bar_z], center = true);
            translate([0, (((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2), (bar_z / 2) + (cap_height /2)+8.8])
                threaded_nut(od = 8*1.02, id = 5, h = 4.8, pitch = 1.25, left_handed = true, $slop = 0.2, $fa = 1, $fs = 1);
            //create mounting caps for bolts
            /*   translate([0, (((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2), (bar_z / 2) + (cap_height / 2)])
                   cylinder(cap_height, bar_x / 2, bar_x / 2, center = true);
               translate([0, - ((((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2)), (bar_z / 2) + (cap_height / 2)]
               ) cylinder(cap_height, bar_x / 2, bar_x / 2, center = true);
   *//*}*/
        } //end union

        //start subtraction of difference

        //create rod pockets
        translate([0, rod_spread / 2, 0]) rotate([0, 90, 0]) cylinder(bar_x + 3, rod_d / 2, rod_d / 2, center = true);
        translate([0, - (rod_spread / 2), 0]) rotate([0, 90, 0]) cylinder(bar_x + 3, rod_d / 2, rod_d / 2, center = true
        );

        //create 1/4-20 bolt hole
        translate([0, 0, 0]) rotate([0, 0, 0]) cylinder(bar_x + cap_height + 3, bolt_d / 2, bolt_d / 2, center = true);

        //create strain relief to chinch on rods
        translate([0, (((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2), 0]) cube([bar_x + 3, ((bar_y / 2) - (
            rod_spread / 2)), gap], center = true);

        translate([0, - ((((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2)), 0]) cube([bar_x + 3, ((bar_y / 2) -
            (rod_spread / 2)), gap], center = true);

        //create mounting bolt openings
        translate([0, (((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2), 5]) cylinder(bar_x + cap_height + 3,
            bolt_d / 2, bolt_d / 2, center = true);
        translate([0, - ((((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2)), 5]) cylinder(bar_x + cap_height + 3
        , bolt_d / 2, bolt_d / 2, center = true);

        //create hex cap head recess for mounting bolts
        translate([0, (((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2), (bar_z / 2) + (cap_height / 2) + 1])
            cylinder(cap_height, cap_d / 2, cap_d / 2, $fn = 6, center = true);
        translate([0, - ((((bar_y / 2) - (rod_spread / 2)) / 2) + (rod_spread / 2)), (bar_z / 2) + (cap_height / 2) + 1]
        ) cylinder(cap_height, cap_d / 2, cap_d / 2, $fn = 6, center = true);

        //create center recess for cap head
        translate([0, 0, ((bar_z / 2) + 1) - (cap_height / 2)]) cylinder(cap_height, cap_d / 2, cap_d / 2, $fn = 6,
        center = true);


    } //end difference
}//end module