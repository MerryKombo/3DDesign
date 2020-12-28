include <3V buckdown converter dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>

3V_buckdown_converter_feet();
translate(size) 3V_buckdown_converter_bracket();
translate(size) translate(size) 3V_buckdown_converter_drilling_template();
translate(size) translate(size) translate(size) 3V_buckdown_converter_dimensions_verifier();

module 3V_buckdown_converter_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module 3V_buckdown_converter_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    
module 3V_buckdown_converter_drilling_template() {
   drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module 3V_buckdown_converter_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}