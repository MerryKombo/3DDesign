// Define global variables
radius = 14; // Sphere radius, which is the radius of the shim supplied with the fenders. The shim does not fit under the fork crown, as the crown is not flat, but has a curve. I should probably mesure the curve, but how to calculate it?
cutHeight = 5; // Height of the shim. Between the fork crown and the shim, we have 5 mm. But as this shim will enter the fork crown, we'll have to print and measure several times before getting the right size.
screwDiameter = 6; // Screw diameter
module cutSphere(r, ch) {
    difference() {
        sphere(r = r, $fn = 100);
        translate([0, 0, -ch])
            cube([2*r, 2*r,2* r], center = true);
        cylinder(d = screwDiameter, h = 2*r, $fn = 100, center = true);
    }
}

// Use global variables as arguments
cutSphere(radius, cutHeight);

// Define variables
desired_shim_radius = radius;

// Calculate the sphere's radius
sphere_radius = sqrt(pow(cutHeight, 2) + pow(desired_shim_radius, 2));

// Example usage
echo(str("The sphere's radius needs to be: ", sphere_radius));
