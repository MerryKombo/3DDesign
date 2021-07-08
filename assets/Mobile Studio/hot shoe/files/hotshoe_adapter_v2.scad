/*
Camera hot shoe adapter base / cover
by Alex Matulich, April 2021
on Thingiverse: https://www.thingiverse.com/thing:4832722

This is intended to be used as a base for building something else to mount on a camera hot shoe. By default, it serves as a hot shoe cover (which comes with the camera but is among the first things lost because the part is so small).

The object is rendered so that the top of the 12x16.4 pedestal (the surface on which you would mount something) is centered at [0,0,0].

The only print setting to be concerned with is the layer height. Printing at 0.25mm height gives the most accurate thicknesses for this piece. Tolerances are tight so this is important.
*/

// ---------- parts that can be made ----------

// this builds a hotshoe adapter with a pedestal sticking up 1mm, with the TOP of the pedestal centered at [0,0,0]
hotshoe_adapter(1);

// this shows ONLY a pedestal of the given height (1mm), with the BOTTOM of the pedestal centered at [0,0,0]. Useful with a hull() operation for some other mount.
color("silver") hotshoe_adapter(1, true);

// ---------- hotshoe adapter module ----------

// parameters:
// pedestal_ht: height of center pedestal
// base_only:
//  true = show only pedestal with bottom at z=0
//  false = show adapter with TOP of pedstal at z=0
module hotshoe_adapter(pedestal_ht, base_only=false) {
    // Internal shoe dimensions measured on a Nikon D5100:
    intwid = 18.7;  // internal width of hot shoe
    intlen = 18.0;  // internal length (sliding distance)
    intht = 2.05;   // internal height
    wingspc = 12.6; // space between wing edges
    winglen = 16.4; // length of wings (sliding distance)

    // adapter dimensions to fit in the shoe, with clerances:
    halfwid = 0.5*intwid - 0.2;
    halflen = 0.5*intlen;
    ht = intht - 0.1;
    centerspc = wingspc - 0.5;
    cliplen = winglen - 2.0;

    if (base_only) {
        // pedestal with bottom centered at [0,0,0]
        translate([0,0,0.5*pedestal_ht]) cube([centerspc, winglen, pedestal_ht], center=true);
    } else {
        translate([0,0.5*(winglen-intlen),-ht-pedestal_ht])
        difference() {
            union() {
                // pedestal with top centered at [0,0,0]
                translate([0,0.5*(intlen-winglen),0.5*(ht+pedestal_ht)]) cube([centerspc, winglen, ht+pedestal_ht], center=true);
            
                // beveled back edge
                translate([halfwid,0,0]) rotate([0,-90,0])
                linear_extrude(2*halfwid) polygon(points=[
                    [0,-halflen], [0, halflen-cliplen-0.5],
                    [ht, halflen-cliplen-0.5], [ht, halflen-winglen],
                    [0.4, -halflen]
                ]);
            
                // wing clips
                wing();
                mirror([1,0,0]) wing();
            }
            // subrract bevel from lower front edge
            frontbevel(-1);
        }
    }
    // wing clip (one side)
    module wing() {
        difference() {
            linear_extrude(ht, convexity=4) polygon(points = [
                [0, halflen], [halfwid-1, halflen], [halfwid, halflen-1],
                [halfwid, halflen-cliplen+4],
                [halfwid+1, halflen-cliplen+1],
                [halfwid+1, halflen-cliplen],
                [halfwid-1, halflen-cliplen],
                [halfwid-1.5, halflen-cliplen+1],
                [0.5*centerspc+0.5, halflen-3.5],
                [0, halflen-2]
            ]);
            frontbevel(1); // bevel top edge of wing
        }
    }

    // triangular bevel for front edge
    module frontbevel(side) { //side: 1=top, -1=bottom
        b = 2;
        translate([0,0,0.5*ht]) rotate([0,side*90,0]) translate([0,halflen+0.25*ht,-0.5*intwid-1]) linear_extrude(intwid+2) polygon(points=[[0,0], [-b,-b], [-b,0]]);
    }
}
