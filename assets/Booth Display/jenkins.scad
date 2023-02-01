// Positionner le butler à cheval sur les pieds du tore des MangoPi, avec une
// extension qui vient se visser sur les pieds d'une mangue
// On pourrait aussi retrancher le tore construit, ce serait plus simple

use <round-booth-display.scad>

difference() {
    union() {

        translate([0, 1, 5.5])
            scale([0.5, 0.5, 0.5])
                import("ETS_Jenkins2.stl", convexity = 5);
        /*translate([0, 0, 5])
            cylinder(h = 5, r = 6.8, $fn = 100);*/
    }

    translate([51.5, - 5, 0])
        rotate([0, 0, 90])   buildToruses();

}