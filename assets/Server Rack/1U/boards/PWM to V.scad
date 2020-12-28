include <PWM to V dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>
 
PWM_to_V_feet();
translate(size) PWM_to_V_bracket();
translate(size) translate(size) PWM_to_V_drilling_template();
translate(size) translate(size) translate(size) PWM_to_V_dimensions_verifier();

module PWM_to_V_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module PWM_to_V_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    
module PWM_to_V_drilling_template() {
   drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module PWM_to_V_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}