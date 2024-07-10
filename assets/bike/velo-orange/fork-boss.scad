// Définition des variables
h = 12; // Hauteur de l'arc
c = 28; // Longueur de la corde
thickness = 1; // Épaisseur de l'arc en mm
height = 30; // Hauteur de l'extrusion en mm

// Calcul du rayon du cercle
r = (h / 2) + (c^2 / (8 * h));

// Calcul de l'angle de l'arc
angle = 2 * asin(c / (2 * r));

// Création de l'arc avec épaisseur
difference() {
    difference() {
        circle(r = r, $fn=200);
        circle(r = r - thickness, $fn=200);
    }
    translate([-r, -r])
        square([2*r, r]);
    rotate([0, 0, -angle/2])
        translate([0, -r])
            square([r, 2*r]);
    rotate([0, 0, angle/2])
        translate([-r, -r])
            square([r, 2*r]);
}

// Extrusion de l'arc
linear_extrude(height = height)
    difference() {
        difference() {
            circle(r = r, $fn=200);
            circle(r = r - thickness, $fn=200);
        }
        translate([-r, -r])
            square([2*r, r]);
        rotate([0, 0, -angle/2])
            translate([0, -r])
                square([r, 2*r]);
        rotate([0, 0, angle/2])
            translate([-r, -r])
                square([r, 2*r]);
    }

// Annotations (optionnelles, à commenter pour l'impression 3D)
/*color("black") {
    translate([0, -r-2])
        text(str("Corde: ", c, " mm"), size = 2, halign = "center");
    translate([-r-3, h/2])
        rotate([0,0,90])
            text(str("Hauteur: ", h, " mm"), size = 2, halign = "center");
    translate([0, r+2])
        text(str("Rayon: ", round(r*100)/100, " mm"), size = 2, halign = "center");
}*/
