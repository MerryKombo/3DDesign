include <BOSL2/std.scad>
include <BOSL2/beziers.scad>
// Définition des variables
c = 31.15; // Longueur de la corde
h = 11.7; // Hauteur maximale
thickness = 1; // Épaisseur de l'arc en mm
height = 30; // Hauteur de l'extrusion en mm

bez = [[0, 0], [c / 4, h / 2], [c / 2, h], [c * 0.75, h / 2], [c, 0]];
debug_bezier(bez, N = len(bez) - 1);
translate(bezier_points(bez, u = 0.5)) color("red") sphere(1);
