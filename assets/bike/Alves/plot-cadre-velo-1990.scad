// ==================== PLOT DE CADRE DE VÉLO ANNÉES 1990 ====================
// Modèle OpenSCAD paramétrique pour plot de cadre de vélo
// Conçu pour s'adapter à un tube de cadre de 28,6 mm de diamètre
// ============================================================================

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
bloc_largeur = 9.5;                    // mm - largeur du bloc carré
bloc_profondeur = 9.5;                 // mm - profondeur du bloc carré
bloc_hauteur_nominale = 12.5;           // mm - hauteur totale avant méplats
meplat_profondeur = 4.0;                // mm - profondeur de chaque méplat horizontal
bloc_hauteur_plat_a_plat = 6.1;         // mm - hauteur résultante entre les deux méplats

// Calcul de la hauteur totale du bloc avec méplats
bloc_hauteur_totale = meplat_profondeur + bloc_hauteur_plat_a_plat;  // = 14,1 mm

// Trou cylindrique porte-filetage (évidement dans le bloc carré)
porte_filetage_diametre = 4.2;          // mm - diamètre du trou cylindrique
porte_filetage_hauteur = 9.35;          // mm - profondeur du trou depuis le haut du méplat inférieur

// Filetage M5 ISO 262
filetage_diametre = 5.0;                // mm - diamètre nominal M5
filetage_pas = 0.8;                     // mm - pas standard M5
// Pour l'impression 3D, ajouter une tolérance
filetage_diametre_trou = 4.2;           // mm - trou pour taraudage M5 (ou 5.0 pour passage libre)

// Calcul de la hauteur de la base
// La base doit aller du point le plus bas (sous le tube) jusqu'au plateau supérieur
base_hauteur = tube_rayon + base_epaisseur_minimale;  // hauteur totale de la base


// ==================== MODULES DE CONSTRUCTION ====================

/**
 * Module: base_adaptation_tube()
 * Crée la base qui s'adapte au tube cylindrique du cadre
 * La base a une forme concave pour épouser le tube de 28,6 mm
 */
module base_adaptation_tube() {
    difference() {
        // Plateau rectangulaire plein
        translate([-base_largeur / 2, -base_profondeur / 2, 0])
            cube([base_largeur, base_profondeur, base_hauteur]);

        // Soustraction du cylindre négatif (tube du cadre)
        // Le cylindre doit créer une courbe concave dans la base
        // Position: le sommet du cylindre est à base_epaisseur_minimale sous le haut de la base
        surface_superieure = base_hauteur;
        point_contact_haut = surface_superieure - base_epaisseur_minimale;
        centre_cylindre_z = point_contact_haut - tube_rayon;

        translate([0, 0, centre_cylindre_z])
            rotate([0, 90, 0])  // Cylindre horizontal (axe Y)
                cylinder(
                h = base_profondeur * 3, // Largement suffisant
                r = tube_rayon,
                center = true
                );
    }
}

/**
 * Module: bloc_superieur_avec_meplats()
 * Crée le bloc supérieur carré avec deux méplats horizontaux
 * Les méplats réduisent la hauteur effective à 6,1 mm (plat à plat)
 */
module bloc_superieur_avec_meplats() {
    difference() {
        // Bloc rectangulaire plein
        translate([0, 0, base_hauteur])
            cylinder(d = bloc_largeur, h = bloc_hauteur_totale, center = false);
        //[bloc_largeur, bloc_profondeur, bloc_hauteur_totale]);

        // Méplat inférieur (réduit les 4 mm du haut)
        translate([-bloc_largeur / 2, -bloc_profondeur / 2, base_hauteur + bloc_hauteur_totale - meplat_profondeur])
            cube([bloc_largeur, (bloc_largeur - bloc_hauteur_plat_a_plat) / 2, meplat_profondeur]);

        // Méplat supérieur (réduit les 4 mm du haut)
        translate([-bloc_largeur / 2, (bloc_profondeur / 2) - (bloc_largeur - bloc_hauteur_plat_a_plat) / 2,
                    base_hauteur +
                    bloc_hauteur_totale - meplat_profondeur])
            cube([bloc_largeur, (bloc_largeur - bloc_hauteur_plat_a_plat) / 2, meplat_profondeur]);
    }
}

/**
 * Module: trou_porte_filetage()
 * Crée le trou cylindrique Ø9mm dans le bloc carré
 * Ce trou accueillera le insert fileté ou sera taraudé
 */
module trou_porte_filetage() {
    // Le trou commence au niveau du haut du méplat inférieur
    z_depart_trou = base_hauteur + meplat_profondeur;

    translate([0, 0, z_depart_trou])
        cylinder(
        h = porte_filetage_hauteur,
        d = porte_filetage_diametre,
        center = false
        );
}

/**
 * Module: filetage_m5()
 * Crée un vrai filetage M5 ISO 262 traversant
 * Utilise BOSL2/threading.scad pour générer un filetage précis
 */
module filetage_m5() {
    // Le filetage doit traverser toute la hauteur
    hauteur_totale_piece = base_hauteur + bloc_hauteur_totale;

    // Position: commence légèrement sous la base pour assurer une traversée complète
    translate([0, 0, -1]) {
        // Filetage M5 ISO 262 interne (taraudage) avec BOSL2
        threaded_rod(
            d = filetage_diametre,               // 5.0 mm - diamètre nominal
            l = hauteur_totale_piece + 2,        // Longueur totale traversante
            pitch = filetage_pas,                // 0.8 mm - pas standard M5
            internal = true,                     // Filetage interne (taraudage)
            bevel = false,                       // Pas de chanfrein
            anchor = BOTTOM,                     // Ancrage par le bas
            orient = UP                          // Orientation vers le haut
        );
    }
}

/**
 * Module: chanfrein_entree_filetage()
 * Ajoute un chanfrein à l'entrée du filetage pour faciliter le vissage
 */
module chanfrein_entree_filetage() {
    hauteur_totale_piece = base_hauteur + bloc_hauteur_totale;

    translate([0, 0, hauteur_totale_piece - 0.5])
        cylinder(
            h = 1,
            d1 = filetage_diametre,
            d2 = filetage_diametre + 1.5,
            center = false
        );
}

/**
 * Module: plot_cadre_velo()
 * Assemblage final de toutes les parties
 */
module plot_cadre_velo() {
    difference() {
        union() {
            // 1. Base adaptée au tube (plateau 12,5 × 12,5 mm avec courbe concave)
            base_adaptation_tube();

            // 2. Bloc supérieur carré avec méplats horizontaux
            bloc_superieur_avec_meplats();
        }

        // 3. Soustraction du filetage M5 interne (taraudage)
        filetage_m5();
    }
}


// ==================== RENDU PRINCIPAL ====================

plot_cadre_velo();


// ==================== INFORMATIONS DE DÉBOGAGE ====================

echo("=== DIMENSIONS CALCULÉES ===");
echo(str("Rayon du tube: ", tube_rayon, " mm"));
echo(str("Hauteur de la base: ", base_hauteur, " mm"));
echo(str("Hauteur totale du bloc avec méplats: ", bloc_hauteur_totale, " mm"));
echo(str("Hauteur plat à plat du bloc: ", bloc_hauteur_plat_a_plat, " mm"));
echo(str("Hauteur totale de la pièce: ", base_hauteur + bloc_hauteur_totale, " mm"));
echo(str("Diamètre du trou de filetage: ", filetage_diametre_trou, " mm (pour taraudage M5)"));
echo("============================");
