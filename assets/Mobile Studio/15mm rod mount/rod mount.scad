/* Open SCAD Name.: 15mm_rail_sys_v2.scad
*  Copyright (c)..: 2016 www.DIY3DTech.com
*
*  Creation Date..: 12/01/2016
*  Description....:
*
*  Rev 1: Develop Model
*  Rev 2:
*
*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 2 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*/

/*------------------Customizer View-------------------*/

// preview[view:north, tilt:top]

/*---------------------Parameters---------------------*/

//bar width in mm
bar_y       = 120;
bar_x       = 25;
bar_z       = 25;

//rod diameter
rod_d       = 15.2;
//center to center rod seperation
rod_spread  = 60;

//bolt diameter
bolt_d      = 6.7;

//bolt cap height
cap_height  = 8;
//bolt cap diameter
cap_d       = 12.8;
//cap sides
cap_s       = 6;

//gap to chinch rod
gap         = 3;

/*-----------------------Execute----------------------*/

block_module();

/*-----------------------Modules----------------------*/

module block_module(){ //create module
    difference() {
            union() {//start union
                 translate ([0,0,0]) cube([bar_x,bar_y,bar_z],center=true);

                    //create mounting caps for bolts
                translate ([0,(((bar_y/2)-(rod_spread/2))/2)+(rod_spread/2),(bar_z/2)+(cap_height/2)]) cylinder(cap_height,bar_x/2,bar_x/2, center=true);
                translate ([0,-((((bar_y/2)-(rod_spread/2))/2)+(rod_spread/2)),(bar_z/2)+(cap_height/2)]) cylinder(cap_height,bar_x/2,bar_x/2, center=true);

                    } //end union

    //start subtraction of difference

                //create rod pockets
                translate ([0,rod_spread/2,0]) rotate ([0,90,0]) cylinder(bar_x+3,rod_d/2,rod_d/2, center=true);
                translate ([0,-(rod_spread/2),0]) rotate ([0,90,0]) cylinder(bar_x+3,rod_d/2,rod_d/2, center=true);

                //create 1/4-20 bolt hole
                translate ([0,0,0]) rotate ([0,0,0]) cylinder(bar_x+cap_height+3,bolt_d/2,bolt_d/2, center=true);

                //create strain relief to chinch on rods
                translate ([0,(((bar_y/2)-(rod_spread/2))/2)+(rod_spread/2),0]) cube([bar_x+3,((bar_y/2)-(rod_spread/2)),gap],center=true);

                translate ([0,-((((bar_y/2)-(rod_spread/2))/2)+(rod_spread/2)),0]) cube([bar_x+3,((bar_y/2)-(rod_spread/2)),gap],center=true);

                //create mounting bolt openings
                translate ([0,(((bar_y/2)-(rod_spread/2))/2)+(rod_spread/2),5]) cylinder(bar_x+cap_height+3,bolt_d/2,bolt_d/2, center=true);
                translate ([0,-((((bar_y/2)-(rod_spread/2))/2)+(rod_spread/2)),5]) cylinder(bar_x+cap_height+3,bolt_d/2,bolt_d/2, center=true);

                //create hex cap head recess for mounting bolts
                translate ([0,(((bar_y/2)-(rod_spread/2))/2)+(rod_spread/2),(bar_z/2)+(cap_height/2)+1]) cylinder(cap_height,cap_d/2,cap_d/2,$fn=6, center=true);
                translate ([0,-((((bar_y/2)-(rod_spread/2))/2)+(rod_spread/2)),(bar_z/2)+(cap_height/2)+1]) cylinder(cap_height,cap_d/2,cap_d/2,$fn=6, center=true);

                //create center recess for cap head
                translate ([0,0,((bar_z/2)+1)-(cap_height/2)]) cylinder(cap_height,cap_d/2,cap_d/2,$fn=6, center=true);


    } //end difference
}//end module

/*----------------------End Code----------------------*/