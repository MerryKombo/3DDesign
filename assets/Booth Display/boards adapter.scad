include <fake top board dimensions.scad>
include <boards adapter utils.scad>
feet2 = [[6.3,3,0], [44-7.7,3,0], [6.3,33,0], [44-7.7,33,0]];
size2 = [44, 36, 1.5];
holeSize2 = 2;
baseSize2 = 9;
footSize2 = 5;
baseHeight2 = 3;
totalHeight2 = 7;
linkThickness2 = 3;
linkHeight2 = 2;
verifierPlateThickness2 = 0.4;
drillTemplateThickness2 = 1;
drillTemplateGuideHeight2 = 20;
hotShoeHeightClearance2 = 5;
lengthFromBoardHarnessToEars2 = 20;
earsHoleDiameter2 = 4;

// smaller one on the top of the other
boards = [feet,feet2];
biggestBoard = getTheBiggest(boards);

echo ("The biggest board is the #", biggestBoard);
/*positionTopBoard(0, [10,10], feet, feet2);
positionTopBoard(1, [0,0], feet, feet2);
positionTopBoard(2, [0,0], feet, feet2);
positionTopBoard(3, [0,0], feet, feet2);*/
centeredTopBoard = positionTopBoard(4, [0,0], feet, feet2);
centeredBoards = [centeredTopBoard, feet2];
echo("Nearest points", getNearestPoints(getAllPoints(centeredTopBoard, feet2)));
draw_mesh(centeredBoards);

module draw_mesh(boards) {
    union() {
        translate([0, 0, totalHeight]) bracket_bracket(boards[0], holeSize, baseSize, baseHeight,
        totalHeight, linkThickness, linkHeight);
        base_bracket(boards[0], boards[1], holeSize2, baseSize2, baseHeight2, totalHeight2, linkThickness2,
        linkHeight2);
    }
}

module bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight) {
    union() {
        bracket_feet(feet,holeSize, baseSize, baseHeight, totalHeight);
        bracket_link(feet, linkThickness, linkHeight);
    }
}


module base_bracket(feet, feet2, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight) {
    union() {
        base_feet(feet2,holeSize, baseSize, baseHeight, totalHeight);
        base_link(feet, feet2, linkThickness, linkHeight);
    }
}

module bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight) {
    difference() {
      union()  {
            color("Olive") hull() {
                color("black") cylinder(r=baseSize/2, h=baseHeight, $fn=100);
                color("grey") translate([0,0,(totalHeight - baseHeight)/2]) cylinder(r=footSize/2, h=baseHeight, $fn=100);
            }
            color("white") translate([0,0,totalHeight - baseHeight]) cylinder(r=footSize/2, h=baseHeight, $fn=100);
        }
        color("red") translate([0,0,-0.5]) cylinder(r=holeSize/2, h=totalHeight+1, $fn=100);
    }
 }
 
 
module base_foot(point, holeSize, baseSize, baseHeight, totalHeight) {
    translate([0,0,totalHeight]) rotate([0,180,0]) difference() {
      union()  {
            color("NavajoWhite") hull() {
                color("black") cylinder(r=baseSize/2, h=baseHeight, $fn=100);
                color("grey") translate([0,0,(totalHeight - baseHeight)/2]) cylinder(r=footSize/2, h=baseHeight, $fn=100);
            }
            color("white") translate([0,0,totalHeight - baseHeight]) cylinder(r=footSize/2, h=baseHeight, $fn=100);
        }
        color("red") translate([0,0,-0.5]) cylinder(r=holeSize/2, h=totalHeight+1, $fn=100);
    }
 }
 
 module bracket_feet(points,holeSize, baseSize, baseHeight, totalHeight) {
     for (point = points) {
         translate (point) bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight);
     }
 }
 
 module base_feet(points,holeSize, baseSize, baseHeight, totalHeight) {
     for (point = points) {
         translate (point) base_foot(point, holeSize, baseSize, baseHeight, totalHeight);
     }
 }
 
 module bracket_link(points, thickness, height) {
     // original
     firstSide = points[1][0] - points[0][0];
     secondSide = points[3][1] - points[0][0];
     // modified
     firstSide = points[3][0] - points[0][0];
     secondSide = points[3][1] - points[0][1];
     gap = points[1][0] - points[3][0];
     // original
     length = sqrt(pow(firstSide,2) + pow(secondSide,2)) - holeSize;
     // modified
     length = sqrt(pow(firstSide,2) + pow(secondSide,2)) - holeSize;
     // original
     atan = atan(firstSide/secondSide);
     union() {
        color("LightSteelBlue") translate([points[0].x,points[0].y,height*2]) rotate([270,0,-atan]) translate([0,0, holeSize/2]) cylinder(h=length, r=thickness/2, center=false, $fn=100);
        color("OliveDrab") translate([points[0].x + firstSide + gap,points[0].y,height*2]) rotate([270,0,atan]) translate([0,0, holeSize/2]) cylinder(h=length, r=thickness/2, center=false, $fn=100);
     }
 }
 
 module base_link(feet, feet2, thickness, height) {
     // original
     firstSide = feet2[1][0] - feet2[0][0];
     secondSide = feet2[3][1] - feet2[0][0];
     // modified
     firstSide = feet2[3][0] - feet2[0][0];
     secondSide = feet2[3][1] - feet2[0][1];
     gap = feet2[1][0] - feet2[3][0];
     // original
     length = sqrt(pow(firstSide,2) + pow(secondSide,2)) - holeSize;
     // modified
     length = sqrt(pow(firstSide,2) + pow(secondSide,2)) - holeSize;
     // original
     atan = atan(firstSide/secondSide);
     union() {
        color("LightSteelBlue") translate([0,0,totalHeight2 - thickness/2]) rotate([270,0,-atan]) translate([0,0, holeSize/2]) cylinder(h=length, r=thickness/2, center=false, $fn=100);
        color("OliveDrab") translate([firstSide + gap,0,totalHeight2 - thickness/2]) rotate([270,0,atan]) translate([0,0, holeSize/2]) cylinder(h=length, r=thickness/2, center=false, $fn=100);
     }
     topToBottomSupports(feet, feet2, firstSide, gap, height, thickness);
 }
 
module topToBottomSupports(feet, feet2, firstSide, gap, height, thickness) {
   topToBottomSupport1(feet, feet2, firstSide, gap, height, thickness);
   topToBottomSupport2(feet, feet2, firstSide, gap, height, thickness);
   topToBottomSupport3(feet, feet2, firstSide, gap, height, thickness);
   topToBottomSupport4(feet, feet2, firstSide, gap, height, thickness);
} 

module topToBottomSupport1(feet, feet2, firstSide, gap, height, thickness) {
    echo (feet2[1][0], feet[1][0],feet2[1][0] - feet[1][0]);
     if (feet2[1][0] - feet[0][0]  > feet2[1][0] - feet[1][0]) {
         color("black") translate([firstSide + gap,0,totalHeight2-thickness/2]) triangleRotation([feet2[1],feet[1]]) rotate([270,0,90]) translate([0,0, holeSize/2]) cylinder(h=feet2[1][0] - (feet[1][0]+holeSize), r=thickness/2, center=false, $fn=100); 
     } else {
         color("red") translate([firstSide + gap,0,totalHeight2-thickness/2])  rotate([270,0,90])  translate([0,0, holeSize/2]) cylinder(h=feet2[1][0] - feet[0][0], r=thickness/2, center=false, $fn=100);
     }
}

module topToBottomSupport2(feet, feet2, firstSide, gap, height, thickness) {
    echo (feet2[3][0], feet[3][0],feet2[3][0] - feet[3][0]);
    if (feet2[3][0] - feet[2][0]  > feet2[3][0] - feet[3][0]) {
        linkSize = abs(feet2[3][0] - (feet[3][0]+holeSize));
        echo ("rotation angle is", rotationAngle([feet2[3],feet[3]]));
        //color("purple") translate([feet[3][0]+linkSize+holeSize,feet[3][1]+thickness+holeSize,feet[3][2]+height*2])  rotate([0,0,90+rotationAngle([feet2[3],feet[3]])]) rotate([270,0,90]) translate([0,0, holeSize/2]) cylinder(h=linkSize, r=thickness/2, center=false, $fn=100); 
          color("purple") translate([feet[3][0]+linkSize+holeSize,feet[3][1]+thickness+holeSize,feet[3][2]+totalHeight2-thickness/2])  triangleRotation([feet2[3],feet[3]]) rotate([270,0,90]) translate([0,0, holeSize/2]) cylinder(h=linkSize, r=thickness/2, center=false, $fn=100); 
     } else {
         color("red") translate([firstSide + gap,0,totalHeight2-thickness/2])  rotate([270,0,90])  translate([0,0, holeSize/2]) cylinder(h=feet2[3][0] - feet[2][0], r=thickness/2, center=false, $fn=100);
     }
}


module topToBottomSupport3(feet, feet2, firstSide, gap, height, thickness) {
    echo (feet2[2], feet[2],feet2[2][0] - feet[2][0],feet2[2][1] - feet[2][1],feet2[3][0] - feet[2][0]);
    if (feet2[2][0] - feet[2][0]  > feet2[3][0] - feet[2][0]) {
        linkSize = abs(feet2[2][0] - (feet[2][0]+holeSize));
        echo ("rotation angle is", rotationAngle([feet2[2],feet[2]]));
        color("silver") translate([feet[2][0]+linkSize+holeSize,feet[2][1]+thickness+holeSize,feet[2][2]+totalHeight2-thickness/2])  rotate([0,0,90+rotationAngle([feet2[2],feet[2]])]) rotate([270,0,90]) translate([0,0, holeSize/2]) cylinder(h=linkSize, r=thickness/2, center=false, $fn=100); 
     } else {
         linkSize = abs(feet2[2][0] - (feet[2][0]+holeSize));
         
         rotationAngle = getTriangleAngle([feet[2],feet2[2]]);
         echo("Function says :", getTriangleAngle([feet[2],feet2[2]]));
         echo ("rotation angle is", rotationAngle);
         //rotationAngle = 21.0567;
         color("BurlyWood") translate([feet[2][0]+linkSize+holeSize,feet[2][1]+thickness+holeSize,feet[2][2]+totalHeight2-thickness/2]) triangleRotation([feet[2],feet2[2]]) rotate([270,0,90]) translate([0,0, holeSize/2]) cylinder(h=linkSize, r=thickness/2, center=false, $fn=100); 
     }
}


module topToBottomSupport4(feet, feet2, firstSide, gap, height, thickness) {
    echo (feet2[2], feet[3],feet2[2][0] - feet[3][0],feet2[2][1] - feet[3][1],feet2[3][0] - feet[3][0]);
    if (feet2[2][0] - feet[3][0]  > feet2[3][0] - feet[3][0]) {
        linkSize = abs(feet2[2][0] - (feet[3][0]+holeSize));
        echo ("rotation angle is", rotationAngle([feet2[2],feet[3]]));
        color("DodgerBlue") translate([feet[3][0]+linkSize,feet[3][1]+thickness+holeSize,feet[3][2]+totalHeight2-thickness/2])  rotate([0,0,90+rotationAngle([feet2[2],feet[3]])]) rotate([270,0,90]) translate([0,0, holeSize/2]) cylinder(h=linkSize, r=thickness/2, center=false, $fn=100); 
     } else {
         linkSize = abs(feet2[2][0] - (feet[3][0]+holeSize)) - 2*holeSize;
         
         rotationAngle = getTriangleAngle([feet[3],feet2[2]]);
         echo("Function says :", getTriangleAngle([feet[3],feet2[2]]));
         echo ("rotation angle is", rotationAngle);
         //rotationAngle = 21.0567;
         color("Seashell") translate([feet[3][0],feet[3][1],feet[3][2]+totalHeight2-thickness/2]) triangleRotation([feet[3],feet2[2]]) rotate([270,0,90]) translate([0,0, holeSize/2]) cylinder(h=linkSize, r=thickness/2, center=false, $fn=100); 
     }
}

module triangleRotation(points) {
    echo("Point 1 is :", points[0], " and point 2 is: ", points[1]);
    xSide = points[1][0] - points[0][0];
    echo("X distance is :", xSide);
    ySide = points[1][1] - points[0][1];
    echo("Y distance is :", ySide);
    length = sqrt(pow(xSide,2) + pow(ySide,2));
    echo("Length would be: ", length);
    atan = atan(ySide/xSide);
    echo("Angle would be :",atan);
    echo(getTriangleAngle(points));
    echo(rotationAngle(points));
    rotate([0,0,atan]) children();
}


function getTriangleAngle(p) = atan([p[1][1] - p[0][1]]/[p[1][0] - p[0][0]]);

function rotationAngle(points) = atan(points[1][0] - points[0][0]/points[1][1] - points[0][1]);

echo(point_to_line(   [150,50,0],   [0,0,0],   [100,0,0]  ));
// found there: https://openscadsnippetpad.blogspot.com/2017/05/euclidean-distance-between-point-and.html
function point_to_line(p,a,b)=

let(
pa = p - a, 
ba = b - a,
h = clamp( (pa*ba)/ (ba*ba)))
norm( pa - ba*h ) ;
function clamp(a, b = 0, c = 1) = min(max(a, b), c); 


