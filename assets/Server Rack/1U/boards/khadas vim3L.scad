include <khadas vim3L dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>



khadas_vim3L_feet();
translate(size) khadas_vim3L_bracket();
translate(size) translate(size) khadas_vim3L_drilling_template();
translate(size) translate(size) translate(size) khadas_vim3L_dimensions_verifier();

module khadas_vim3L_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module khadas_vim3L_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    
module khadas_vim3L_drilling_template() {
   drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module khadas_vim3L_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}