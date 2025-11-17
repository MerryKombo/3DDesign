// ==================== PLOT DE CADRE DE VÉLO ANNÉES 1990 (VERSION BOSL2) ====================
// Modèle OpenSCAD paramétrique pour plot de cadre de vélo
// Conçu pour s'adapter à un tube de cadre de 28,6 mm de diamètre
// Version utilisant BOSL2/threading.scad au lieu de threads-scad
// ==========================================================================================

include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn = 100;  // Résolution élevée pour un rendu lisse

// ==================== PARAMÈTRES PRINCIPAUX ====================

// Tube du cadre
tube_diametre_externe = 28.6;           // mm - diamètre du tube de cadre
tube_rayon = tube_diametre_externe / 2; // mm - rayon calculé (14,3 mm)

// Base d'adaptation au tube
base_epaisseur_minimale = 2.1;          // mm - épaisseur au centre (point le plus fin)
base_largeur = 12.5;                    // mm - largeur du plateau supérieur
base_profondeur = 12.5;                 // mm - profondeur du plateau supérieur

// Bloc supérieur (avec méplats)
bloc_largeur = 9.5;                     // mm - largeur du bloc cylindrique
bloc_profondeur = 9.5;                  // mm - profondeur du bloc cylindrique
bloc_hauteur_nominale = 12.5;           // mm - hauteur totale avant méplats
meplat_profondeur = 4.0;                // mm - profondeur de chaque méplat horizontal
bloc_hauteur_plat_a_plat = 6.1;         // mm - hauteur résultante entre les deux méplats

// Calcul de la hauteur totale du bloc avec méplats
bloc_hauteur_totale = meplat_profondeur + bloc_hauteur_plat_a_plat;  // = 10.1 mm

// Trou cylindrique porte-filetage (évidement dans le bloc)
porte_filetage_diametre = 4.2;          // mm - diamètre du trou cylindrique
porte_filetage_hauteur = 9.35;          // mm - profondeur du trou depuis le haut du méplat inférieur

// Filetage M5 ISO 262
filetage_diametre = 5.0;                // mm - diamètre nominal M5
filetage_pas = 0.8;                     // mm - pas standard M5

// Calcul de la hauteur de la base
base_hauteur = tube_rayon + base_epaisseur_minimale;  // hauteur totale de la base


// ==================== MODULES DE CONSTRUCTION ====================

/**
 * Module: base_adaptation_tube()
 * Crée la base qui s'adapte au tube cylindrique du cadre
 */
module base_adaptation_tube() {
    difference() {
        // Plateau rectangulaire plein
        translate([-base_largeur / 2, -base_profondeur / 2, 0])
            cube([base_largeur, base_profondeur, base_hauteur]);

        // Soustraction du cylindre négatif (tube du cadre)
        surface_superieure = base_hauteur;
        point_contact_haut = surface_superieure - base_epaisseur_minimale;
        centre_cylindre_z = point_contact_haut - tube_rayon;

        translate([0, 0, centre_cylindre_z])
            rotate([0, 90, 0])
                cylinder(h = base_profondeur * 3, r = tube_rayon, center = true);
    }
}

/**
 * Module: bloc_superieur_avec_meplats()
 * Crée le bloc supérieur cylindrique avec deux méplats horizontaux
 */
module bloc_superieur_avec_meplats() {
    difference() {
        // Cylindre principal
        translate([0, 0, base_hauteur])
            cylinder(d = bloc_largeur, h = bloc_hauteur_totale, center = false);

        // Méplat inférieur
        translate([-bloc_largeur / 2, -bloc_profondeur / 2, base_hauteur + bloc_hauteur_totale - meplat_profondeur])
            cube([bloc_largeur, (bloc_largeur - bloc_hauteur_plat_a_plat) / 2, meplat_profondeur]);

        // Méplat supérieur
        translate([-bloc_largeur / 2, (bloc_profondeur / 2) - (bloc_largeur - bloc_hauteur_plat_a_plat) / 2,
                    base_hauteur + bloc_hauteur_totale - meplat_profondeur])
            cube([bloc_largeur, (bloc_largeur - bloc_hauteur_plat_a_plat) / 2, meplat_profondeur]);
    }
}

/**
 * Module: trou_porte_filetage()
 * Crée le trou cylindrique Ø4.2mm dans le bloc
 */
module trou_porte_filetage() {
    z_depart_trou = base_hauteur + meplat_profondeur;

    translate([0, 0, z_depart_trou])
        cylinder(h = porte_filetage_hauteur, d = porte_filetage_diametre, center = false);
}

/**
 * Module: filetage_m5_bosl2()
 * Crée un vrai filetage M5 ISO 262 avec BOSL2
 */
module filetage_m5_bosl2() {
    hauteur_totale_piece = base_hauteur + bloc_hauteur_totale;

    // BOSL2 threaded_rod pour filetage interne
    translate([0, 0, -1]) {
        threaded_rod(
            d = filetage_diametre,               // 5.0 mm
            l = hauteur_totale_piece + 2,        // Longueur totale
            pitch = filetage_pas,                // 0.8 mm
            internal = true,                     // Filetage interne (taraudage)
            bevel = false,                       // Pas de biseau automatique
            blunt_start = false,                 // Démarrage net
            blunt_start1 = false,
            blunt_start2 = false,
            anchor = BOTTOM,
            orient = UP
        );
    }
}

/**
 * Module: chanfrein_entree_filetage()
 * Ajoute un chanfrein à l'entrée du filetage
 */
module chanfrein_entree_filetage() {
    hauteur_totale_piece = base_hauteur + bloc_hauteur_totale;

    translate([0, 0, hauteur_totale_piece - 0.5])
        cylinder(h = 1, d1 = filetage_diametre, d2 = filetage_diametre + 1.5, center = false);
}

/**
 * Module: plot_cadre_velo()
 * Assemblage final
 */
module plot_cadre_velo() {
    difference() {
        union() {
            base_adaptation_tube();
            bloc_superieur_avec_meplats();
        }

        trou_porte_filetage();
        filetage_m5_bosl2();
        chanfrein_entree_filetage();
    }
}


// ==================== RENDU PRINCIPAL ====================

plot_cadre_velo();


// ==================== INFORMATIONS DE DÉBOGAGE ====================

echo("=== VERSION BOSL2 ===");
echo(str("Rayon du tube: ", tube_rayon, " mm"));
echo(str("Hauteur de la base: ", base_hauteur, " mm"));
echo(str("Hauteur totale du bloc: ", bloc_hauteur_totale, " mm"));
echo(str("Hauteur totale de la pièce: ", base_hauteur + bloc_hauteur_totale, " mm"));
echo("=====================");
