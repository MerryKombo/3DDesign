h = 12;
c = 28;
r = (h / 2) + (c^2 / (8 * h));

echo(str("Le rayon du cercle est approximativement : ", r, " unités."));

// Arc de cercle
difference() {
    circle(r = r);
    translate([0, -r])
        square(r * 2, center = true);
}

// Corde
color("red")
    translate([-c/2, 0])
        line([0, 0], [c, 0]);

// Hauteur (ajustée pour s'arrêter au sommet de l'arc)
color("blue")
    line([0, 0], [0, h]);

// Repères de mesure
color("green") {
    translate([-c/2, -1])
        line([0, 0], [c, 0]);
    translate([-c/2-1, 0])
        line([0, 0], [0, h]);
}

// Annotations
color("black") {
    translate([0, -2])
        text(str("Corde: ", c, " mm"), size = 2, halign = "center");
    translate([-c/2-3, h/2])
        rotate([0,0,90])
            text(str("Hauteur: ", h, " mm"), size = 2, halign = "center");
    translate([0, r+2])
        text(str("Rayon: ", round(r*100)/100, " mm"), size = 2, halign = "center");
}

module line(start, end, thickness = 0.1) {
    hull() {
        translate(start) circle(d = thickness);
        translate(end) circle(d = thickness);
    }
}
