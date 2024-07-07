// Include the BOSL2 standard library for additional functionality
include <BOSL2/std.scad>

// Define constants for the fender's dimensions
fenderDiameter = 700; // Diameter of the fender
fenderWidth = 47.5; // Width of the fender
fenderDepth = fenderWidth / 2; // Depth of the fender, assumed to be half of the width
rearFenderLength = 1200; // Length of the rear fender
frontFenderLength = 900; // Length of the front fender
fenderThickness = 2; // Thickness of the fender

// Function to calculate the angle for an arc based on its length and the diameter of the circle
// @param arcLength The length of the arc
// @param diameter The diameter of the circle the arc is part of
// @return The angle of the arc in degrees
function arcAngle(arcLength, diameter) = (arcLength / (PI * diameter)) * 360;

// Calculate angles for the rear and front fenders based on their lengths and the fender diameter
rearFenderAngle = arcAngle(rearFenderLength, fenderDiameter);
frontFenderAngle = arcAngle(frontFenderLength, fenderDiameter);

// Module to create a fender with specified length and angle
// @param length The length of the fender
// @param angle The angle of the fender
module create_fender(length, angle) {
    rotate([0, 180, 0])
        difference() {
            rotate_extrude(angle = angle, $fn = 200)
                translate([fenderDiameter / 2 - fenderWidth / 2, 0, 0])
                    rotate([0, 0, 180])
                        difference() {
                            circle(d = fenderWidth, $fn = 200); // Utiliser fenderWidth ici
                            circle(d = fenderWidth - fenderThickness * 2, $fn = 200);
                            translate([0, -fenderWidth / 2, 0])
                                square([fenderWidth / 2, fenderWidth]);
                        }
            translate([-fenderDiameter / 2, -fenderDiameter / 2, -fenderWidth])
                cube([fenderDiameter, fenderDiameter / 2, fenderWidth * 2]);
        }
}

module rearFender() {
    // Create and color the rear fender in red
    color("red")
        create_fender(rearFenderLength, rearFenderAngle);
}

module frontFender() {
    // Create and color the front fender in blue, translated to avoid overlap with the rear fender
    color("blue")
        translate([0, fenderDiameter + 50, 0])
            create_fender(frontFenderLength, frontFenderAngle);
}

// Constants
arcLength = 45; // Length of the arc in mm

// Calculate the angle
angle = arcAngle(arcLength, fenderDiameter);

// Output the angle
echo(str("Angle for a 4.5cm subsection of the fender: ", angle, " degrees"));

color("silver")
    translate([0, fenderDiameter + 270, 0])
        create_fender(arcLength, angle);

// Given values
sectionRadius = fenderDepth / 2; // Rayon de la section transversale du garde-boue
chordLength = 35; // La distance en ligne droite que vous voulez que l'arc couvre

// Calculer l'angle central en radians
theta = 2 * asin(chordLength / (2 * sectionRadius));
echo(str("Angle central pour une sous-section s'inscrivant dans une boîte de 35 mm de large : ", theta, " radians"));

// Calculer correctement la longueur de l'arc
correctedArcLength = sectionRadius * theta;

// Afficher la longueur d'arc corrigée
echo(str("Longueur d'arc corrigée pour une sous-section s'inscrivant dans une boîte de 35 mm de large : ",
correctedArcLength, " mm"));

