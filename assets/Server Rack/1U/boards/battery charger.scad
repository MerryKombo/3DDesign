include <battery charger dimensions.scad>
use <../parts/feet.scad>
use <../parts/generic bracket.scad>
use <../parts/generic drilling templates.scad>
use <../parts/dimensions verifier.scad>

battery_charger_feet();
translate(size) battery_charger_bracket();
translate(size) translate(size) battery_charger_drilling_template();
translate(size) translate(size) translate(size) battery_charger_dimensions_verifier();

module battery_charger_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module battery_charger_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    
  
module battery_charger_drilling_template() {
   drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module battery_charger_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}