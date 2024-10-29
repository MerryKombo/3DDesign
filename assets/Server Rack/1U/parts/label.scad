include <BOSL2/std.scad>

module drawLabel(label, labelHeight, labelLength, plateHeight, textExtrusionHeight, feet, fontColor = "white",
plateColor = "yellow") {
    // Fit text into an area
    // Found there: https://stackoverflow.com/a/39564288/2938320

    w = labelHeight;

    // Calculer plutôt la moitié de la diagonale moins la taille du pied moins la largeur des liens... Là, on aura la bonne taille

    union() {
        // cube([length, w, plateHeight]);
        color(plateColor)
            linear_extrude(plateHeight)
                translate([labelLength / 2, w / 2, 0])
                    rect([labelLength, w], rounding = w / 4, $fn = 100);
        color(fontColor)
            translate([0, w / 2, 0.4])
                linear_extrude(textExtrusionHeight, convexity = 4)
                    resize([labelLength, 0], auto = true)
                        text(label, valign = "center", font = "Isonorm 3098,Isonorm:style=Regular,3098", $fn = 100);
    }
}