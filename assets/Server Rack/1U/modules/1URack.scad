include <1U.scad>
include <ears.scad>

for (a = [0:numberOfUnits - 1]) {
    translate([moduleWidth * a, 0, 0]) oneU();
}
ears();
//translate([moduleWidth * 5, 0, 0])oneU();