totalWidth = 450;
numberOfUnits = 5;
sizeOfEars = 5;
moduleWidth = (totalWidth - (sizeOfEars * 2)) / numberOfUnits;
moduleLength = 150;
oneU = 43.66;
numberOfU = 1;
moduleHeight = numberOfU * oneU;

wallThickness = 5;
threadedRodDiameter = 3;
surroundingDiameter = 2;
rodSurroundingDiameter = threadedRodDiameter + surroundingDiameter;
rodEarHeight = 5;
rodEarDistanceFromSide = rodSurroundingDiameter + surroundingDiameter;

points = [ [0,0,0], [10,0,0], [0,10,0], [10,10,0] ];

union() {
    cube([moduleWidth, moduleLength, moduleHeight]);

    color ("red") {
        translate ([moduleWidth, rodEarDistanceFromSide, moduleHeight - rodEarDistanceFromSide]) rotate(a=90, v = [0,1,0]){
        #    difference() {
          #     cylinder(rodEarHeight, r=rodSurroundingDiameter, $fn=100);
        # translate ([0, 0, - wallThickness]) cylinder(rodEarHeight +            wallThickness + 1, r=threadedRodDiameter, $fn=100);
            }
        }
    }
         color ("blue") hull(){
        for (p = points){
            translate(p) cylinder(r=radius, h=height);
        }
    }
}
