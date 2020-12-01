include <orangepi zero dimensions.scad>
use <../parts/feet.scad>
use <../parts/bracket.scad>
use <../parts/drilling templates.scad>
use <../parts/dimensions verifier.scad>



orangepi_zero_feet();
translate(size) orangepi_zero_bracket();
translate(size) translate(size) orangepi_zero_drilling_template();
translate(size) translate(size) translate(size) orangepi_zero_dimensions_verifier();

module orangepi_zero_feet() {
    feet_feet(feet,holeSize, baseSize, baseHeight, totalHeight) ;
}

module orangepi_zero_bracket() {
    bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
}
    
module orangepi_zero_drilling_template() {
   drillTemplate(feet, holeSize, drillTemplateThickness, drillTemplateGuideHeight);
}

module orangepi_zero_dimensions_verifier() {
    verifier_checkDimensions(feet, holeSize, verifierPlateThickness);
}