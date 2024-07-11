// Définition des variables
c = 28; // Longueur de la corde
h = 12; // Hauteur maximale
thickness = 1; // Épaisseur de l'arc en mm
height = 30; // Hauteur de l'extrusion en mm

// Point de contrôle (à ajuster)
control_x = c/4;
control_y = h * 1.2;

// Fonction pour créer une courbe de Bézier quadratique
module bezier_curve(steps = 100) {
    step = 1 / steps;
    points = [
        for (t = [0 : step : 1])
        let(
            x = (1-t)^2 * 0 + 2*(1-t)*t * control_x + t^2 * c,
            y = (1-t)^2 * 0 + 2*(1-t)*t * control_y + t^2 * 0
        )
            [x, y]
        ];
    polygon(concat([[0,0]], points, [[c,0]]));
}

// Création de l'arc avec épaisseur
linear_extrude(height = height)
    difference() {
        bezier_curve();
        translate([0, thickness])
            scale([(c-2*thickness)/c, (h-thickness)/h])
                bezier_curve();
    }

// Point de contrôle (pour visualisation)
translate([control_x, control_y])
    color("red")
        circle(r = 0.5);

// Annotations
color("black") {
    translate([c/2, -2])
        text(str("Corde: ", c, " mm"), size = 2, halign = "center");
    translate([-3, h/2])
        rotate([0,0,90])
            text(str("Hauteur: ", h, " mm"), size = 2, halign = "center");
}
