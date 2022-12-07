//include <../boards/khadas vim3L dimensions.scad>
include <../boards/orangepi zero dimensions.scad>
use <../utils/intersection.scad>
include <rod mount.scad>
include <BOSL2/std.scad>

bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight);
translate([- size.x, - size.y, - size.z]) vertical_bracket(feet, holeSize, baseSize, baseHeight, totalHeight,
linkThickness, linkHeight, true);

module vertical_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight, center) {
    rotate(a = [- 90, - 90, 0]) union() {
        bracket_feet(feet, holeSize, baseSize, baseHeight, totalHeight);
        bracket_link(feet, linkThickness, linkHeight);
        bracket_square_link(feet, linkThickness, linkHeight);
        bracket_middle_reinforcement(feet, linkThickness, linkHeight, center);
    }
}

module bracket_middle_reinforcement(feet, linkThickness, linkHeight, center) {
    union() {
        echo("Center is", center);
        middlePoint = IntersectionOfLines(feet[0], feet[3], feet[2], feet[1]);
        yMiddle = max(feet[0][1], feet[1][1], feet[2][1], feet[3][1]) / 2;
        xMiddle = max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) / 2;
        // How much of the board will go past the X holes?
        xOverHang = abs((size.x - (xMiddle * 2)) / 2);
        echo("The overhang is ", xOverHang);
        topPoint = [max(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) + xOverHang, center? yMiddle:middlePoint.y, 0];
        // We need to extend the link down to the board size and then add the feet width, so that it doesn't interfere with the existing feet
        bottomPoint = [min(feet[0][0], feet[1][0], feet[2][0], feet[3][0]) - (xOverHang + baseSize), center? yMiddle:
                middlePoint.y, 0];
        if (center) {
            // find the center instead of finding the intersection point
            // todo!
            mesh_link([topPoint, bottomPoint], linkThickness, linkHeight, 1);
        } else {
            mesh_link([topPoint, bottomPoint], linkThickness, linkHeight, 1);
        }
        //points = flatten([[topPoint, bottomPoint], feet]);
        //points = [topPoint, bottomPoint, feet[0], feet[2]];
        points = [topPoint, feet[1], feet[3]];
        echo("Points is ", points);
        link_harness_to_bracket(points, linkThickness, linkHeight);
        bottomPoints = [bottomPoint, feet[0], feet[2]];
        echo("Points is ", bottomPoints);
        link_harness_to_bracket(bottomPoints, linkThickness, linkHeight);
        topAndBottom_reinforcement(topPoint, bottomPoint, linkThickness, linkHeight);
    }
}

module topAndBottom_reinforcement(topPoint, bottomPoint, linkThickness, linkHeight) {
    translate([2, 0, 0])translate([topPoint[0], topPoint[1], totalHeight - baseHeight]) rotate([0, 180, 0]) rotate([90,
        0, 90]) bracket_foot([0, 0, 0], holeSize, baseSize, baseHeight,
    totalHeight);
    translate([- 2, 0, 0]) translate([bottomPoint[0], bottomPoint[1], totalHeight - baseHeight]) rotate([90, 0, 90])
        bracket_foot([0, 0, 0],
        holeSize, baseSize, baseHeight, totalHeight);
}

module bracket_bracket(feet, holeSize, baseSize, baseHeight, totalHeight, linkThickness, linkHeight) {
    union() {
        bracket_feet(feet, holeSize, baseSize, baseHeight, totalHeight);
        bracket_link(feet, linkThickness, linkHeight);
    }
}

module bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight) {
    difference() {
        union() {
            hull() {
                cylinder(r = baseSize / 2, h = baseHeight, $fn = 100);
                translate([0, 0, (totalHeight - baseHeight) / 2]) cylinder(r = footSize / 2, h = baseHeight, $fn = 100);
            }
            translate([0, 0, totalHeight - baseHeight]) cylinder(r = footSize / 2, h = baseHeight, $fn = 100);
        }
        color("red") translate([0, 0, - 0.5]) cylinder(r = holeSize / 2, h = totalHeight + 1, $fn = 100);
    }
}

module empty_bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight) {
    color("red") translate([0, 0, - 0.5]) cylinder(r = holeSize / 2, h = totalHeight + 1, $fn = 100);
}

module bracket_feet(points, holeSize, baseSize, baseHeight, totalHeight) {
    for (point = points) {
        translate(point) bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight);
    }
}

module empty_bracket_feet(points, holeSize, baseSize, baseHeight, totalHeight) {
    for (point = points) {
        translate(point) empty_bracket_foot(point, holeSize, baseSize, baseHeight, totalHeight);
    }
}

/*function getFirstPoint(points, minX, minY) = [for (currentPoint = points) currentPoint.x == minX && currentPoint.y ==
minY ? currentPoint];*/
// find the maximum value in a vector
function maxInVector(v, m = - 999999999999, i = 0, maxX = true, maxY = false) =
    (i == len(v))
    ?     m
    :     (m > (maxX? v[i].x:maxY?v[i].y:v[i].x))
    ?    maxInVector(v, m, i + 1, maxX, maxY)
    :    maxInVector(v, maxX? v[i].x:maxY?v[i].y:v[i].x, i + 1, maxX, maxY);

// find the minimum value in a vector
function minInVector(v, m = 999999999999, i = 0, minX = true, minY = false) =
    (i == len(v))
    ?     m
    :     (m < (minX? v[i].x:minY?v[i].y:v[i].x))
    ?    minInVector(v, m, i + 1, minX, minY)
    :    minInVector(v, minX? v[i].x:minY?v[i].y:v[i].x, i + 1, minX, minY);

// input : list of points
// output : sorted by x vector of points
function quicksortVectorByX(vec) = !(len(vec) > 0) ? [] : let(
    pivot = vec[floor(len(vec) / 2)],
    lesser = [for (y = vec) if (y.x < pivot.x) y],
    equal = [for (y = vec) if (y.x == pivot.x) y],
    greater = [for (y = vec) if (y.x > pivot.x) y]
) concat(
quicksortVectorByX(lesser), equal, quicksortVectorByX(greater)
);

function removeDuplicates(vector) = !(len(vector) > 0)?[] : let(
    pivot = vector[floor(len(vector) / 2)],
    lesser = [for (y = vector) if (y.x < pivot.x) y],
    equal = [for (y = vector) if ((y.x == pivot.x) && (y.y == pivot.y) && (y.z == pivot.z)) y],
    cleanedEqual = [len(equal) > 0? equal[0]:undef],
    greater = [for (y = vector) if (y.x > pivot.x) y]) concat(removeDuplicates(lesser), cleanedEqual, removeDuplicates(
greater)
);

// input : list of points
// output : sorted by x vector of points
function quicksortVectorByY(vec) = !(len(vec) > 0) ? [] : let(
    pivot = vec[floor(len(vec) / 2)],
    lesser = [for (y = vec) if (y.y < pivot.y) y],
    equal = [for (y = vec) if (y.y == pivot.y) y],
    greater = [for (y = vec) if (y.y > pivot.y) y]
) concat(
quicksortVectorByY(lesser), equal, quicksortVectorByY(greater)
);

function getFirstPoint(points, minX, minY) = len(points) > 0? (points[0].x == minX && points[0].y == minY? points[0] :
        getFirstPoint(select(points, [1:len(points) - 1]))):echo("nothing");

function getTopLineIndex(minY, index, unsortedBottomPoints) = len(unsortedBottomPoints) <= 0? 0
    : //else
            unsortedBottomPoints[0].y > minY?index:getTopLineIndex(minY, index + 1, select(unsortedBottomPoints, [index:
        1:len(unsortedBottomPoints) - 1]));

module new_bracket_link(points, thickness, height) {
    // modified
    // This gives us two "points", one containing all the minimums, and one containing all the maximums
    pt_pair = pointlist_bounds(points);
    minX = pt_pair[0].x;
    minY = pt_pair[0].y;
    maxX = pt_pair[1].x;
    maxY = pt_pair[1].y;
    echo("Points bounds are ", pt_pair);
    /*echo("First point is", getFirstPoint(points, minX, minY));*/
    unsortedBottomPoints = quicksortVectorByY(points);
    topLineIndex = getTopLineIndex(minY, 0, unsortedBottomPoints);
    echo("topLineIndex is ", topLineIndex);
    echo("quick sort of the points by Y ", unsortedBottomPoints);
    bottomPoints = quicksortVectorByX(select(unsortedBottomPoints, [0, 1]));
    echo("bottom points are ", bottomPoints);
    topPoints = quicksortVectorByX(select(unsortedBottomPoints, [2, 3]));
    echo("top points are ", topPoints);
    echo("max", maxInVector(points, maxX = false, maxY = true));   // ECHO: "max", 9
    horizontalSide = topPoints[1][0] - bottomPoints[0][0];//points[3][0] - points[0][0];
    verticalSide = topPoints[1][1] - bottomPoints[0][1];//points[3][1] - points[0][1];
    gap = topPoints[0][0] - topPoints[1][0];//points[1][0] - points[3][0];
    echo("Horizontal side is ", horizontalSide);
    echo("Vertical side is ", verticalSide);
    echo("Gap is ", gap);
    // modified
    length = sqrt(pow(horizontalSide, 2) + pow(verticalSide, 2)) - holeSize;
    // original
    atan = atan(horizontalSide / verticalSide);
    union() {
        color("blue") translate([0, 0, height * 2]) rotate([270, 0, - atan]) translate([0, 0, holeSize / 2]) cylinder(h
        = length, r = thickness / 2, center = false, $fn = 100);
        color("green") translate([bottomPoints[1][0], 0, height * 2])
            /*translate([horizontalSide + gap, 0, height * 2])*/ rotate([270, 0, atan]) translate([0, 0, holeSize
                / 2]
            ) cylinder(h = length, r = thickness / 2, center = false, $fn = 100);
    }
}
//[[26.5401, 30.0688, 0], [38.9207, 0, 0], [12.3807, 30.0688, 0], [0, 0, 0]]
module bracket_link(points, thickness, height) {
    // modified
    // This gives us two "points", one containing all the minimums, and one containing all the maximums
    pt_pair = pointlist_bounds(points);
    minX = pt_pair[0].x;
    minY = pt_pair[0].y;
    maxX = pt_pair[1].x;
    maxY = pt_pair[1].y;
    echo("Points bounds are ", pt_pair);
    /*echo("First point is", getFirstPoint(points, minX, minY));*/
    unsortedBottomPoints = quicksortVectorByY(points);
    echo("quick sort of the points by Y ", unsortedBottomPoints);
    bottomPoints = quicksortVectorByX(select(unsortedBottomPoints, [0, 1]));
    echo("bottom points are ", bottomPoints);
    topPoints = quicksortVectorByX(select(unsortedBottomPoints, [2, 3]));
    echo("top points are ", topPoints);
    echo("max", maxInVector(points, maxX = false, maxY = true));   // ECHO: "max", 9
    horizontalSide = topPoints[1][0] - bottomPoints[0][0];//points[3][0] - points[0][0];
    verticalSide = topPoints[1][1] - bottomPoints[0][1];//points[3][1] - points[0][1];
    gap = topPoints[0][0] - topPoints[1][0];//points[1][0] - points[3][0];
    echo("Horizontal side is ", horizontalSide);
    echo("Vertical side is ", verticalSide);
    echo("Gap is ", gap);
    // modified
    length = sqrt(pow(horizontalSide, 2) + pow(verticalSide, 2)) - holeSize;
    // original
    atan = atan(horizontalSide / verticalSide);
    union() {
        color("blue") translate([0, 0, height * 2]) rotate([270, 0, - atan]) translate([0, 0, holeSize / 2]) cylinder(h
        = length, r = thickness / 2, center = false, $fn = 100);
        color("green") translate([bottomPoints[1][0], 0, height * 2])
            /*translate([horizontalSide + gap, 0, height * 2])*/ rotate([270, 0, atan]) translate([0, 0, holeSize
                / 2]
            ) cylinder(h = length, r = thickness / 2, center = false, $fn = 100);
    }
}

/* this is the legacy one, that works almost for all cases... Almost. */
module bracket_link_backup(points, thickness, height) {
    // modified
    firstSide = points[3][0] - points[0][0];
    secondSide = points[3][1] - points[0][1];
    gap = points[1][0] - points[3][0];
    // modified
    length = sqrt(pow(firstSide, 2) + pow(secondSide, 2)) - holeSize;
    // original
    atan = atan(firstSide / secondSide);
    union() {
        color("blue") translate([0, 0, height * 2]) rotate([270, 0, - atan]) translate([0, 0, holeSize / 2]) cylinder(h
        = length, r = thickness / 2, center = false, $fn = 100);
        color("green") translate([firstSide + gap, 0, height * 2]) rotate([270, 0, atan]) translate([0, 0, holeSize / 2]
        ) cylinder(h = length, r = thickness / 2, center = false, $fn = 100);
    }
}


module new_mesh_link(points, thickness, height, number) {
    echo("In new_mesh_link, points are ", points);
    firstPoint = points[0];
    secondPoint = points[1];
    firstXPoint = points[0][0];
    secondXPoint = points[1][0];
    firstYPoint = points[0][1];
    secondYPoint = points[1][1];
    // Biggest first
    sortedByXPoints = firstXPoint > secondXPoint ? [firstPoint, secondPoint]:[secondPoint, firstPoint];
    sortedByYPoints = firstYPoint > secondYPoint ? [firstPoint, secondPoint]:[secondPoint, firstPoint];
    echo("Sorted by X Points is ", sortedByXPoints);
    echo("Sorted by Y Points is ", sortedByYPoints);

    pt_pair = pointlist_bounds(points);
    minX = pt_pair[0].x;
    minY = pt_pair[0].y;
    maxX = pt_pair[1].x;
    maxY = pt_pair[1].y;
    unsortedBottomPoints = quicksortVectorByY(points);
    topLineIndex = getTopLineIndex(minY, 0, unsortedBottomPoints);
    echo("top Line Index is ", topLineIndex);

    horizontalSize = sortedByXPoints[0][0] - sortedByXPoints[1][0];
    verticalSide = sortedByYPoints[0][1] - sortedByYPoints[1][1];
    echo("horizontalSize is ", horizontalSize);
    echo("verticalSide is ", verticalSide);
    linkLength = sqrt(pow(horizontalSize, 2) + pow(verticalSide, 2)) - holeSize;
    // We sorted them earlier, so of course it's the second one
    minX = sortedByXPoints[1][0];
    echo("minX is ", minX);
    minY = sortedByYPoints[1][1];
    maxY = sortedByYPoints[0][1];
    echo("minY is ", minY, "and maxY is ", maxY);
    tempAtan = atan(horizontalSize / verticalSide);
    xIsNegative = sortedByYPoints[0][0] + sortedByYPoints[1][0] < 0;
    yIsNegative = sortedByYPoints[0][1] + sortedByYPoints[1][1] < 0;
    echo("xIsNegative ", xIsNegative);
    echo("yIsNegative ", yIsNegative);
    // {\displaystyle m={y_{b}-y_{a} \over x_{b}-x_{a}}} ;
    atanTest = (secondYPoint - firstYPoint) / (secondXPoint - firstXPoint) < 0;//yIsNegative && !xIsNegative;
    atan = atanTest? 180 - tempAtan:tempAtan;
    echo("atan is ", atan, ", atantTest (negative slope) is ", atanTest);
    biggestXIsZero = sortedByXPoints[0][0] == 0;
    biggestYIsZero = sortedByYPoints[0][1] == 0;
    xMove = biggestXIsZero? minX:minX;
    // yMove = biggestYIsZero? minY:0;
    yPointsAreAtTheSameHeight = minY == maxY;
    yMove = atanTest? maxY: (yIsNegative && xIsNegative) || yPointsAreAtTheSameHeight || minY < 0 || maxY - minY > 0?
        minY:0;
    //yMove = biggestYIsZero? minY: minY;
    //******************************************************************************************************************
    // Clean that up, please
    meshColor = xMove == 0 && yMove == 0 ? "white": "WhiteSmoke";
    echo("mesh_link treating", sortedByXPoints);
    echo("moving X : ", xMove);
    echo("moving Y : ", yMove);
    union() {
        //debugColor = linkLength < 46? [10 * number / 255, 10 * number / 255, 10 * number / 255]: meshColor;
        //"purple"
        echo("I will move ", xMove, " and ", yMove, " with height ", height * 2);
        echo("I will rotate ", 270, 0, - atan);
        color(meshColor) translate([xMove, yMove, height * 2]) rotate([270, 0, - atan])
            translate([0, 0, holeSize / 2]) cylinder(h = linkLength, r = thickness / 2, center = false, $fn = 100)
                ;
        echo("Finished treating mesh_link ", sortedByXPoints, " with length ", linkLength);

    }
    // *****************************************************************************************************************
    // end of the mess to clean up
}

module mesh_link(points, thickness, height, number) {
    // modified
    signedFirstSide = points[1][0] - points[0][0];
    firstSide = abs(signedFirstSide);
    signedSecondSide = points[1][1] - points[0][1];
    secondSide = abs(signedSecondSide);
    echo("Signed First side is ", signedFirstSide);
    echo("First side is ", firstSide);
    echo("Second side is ", secondSide);
    gap = abs(points[1][0] - points[0][0]);
    // modified
    mesh_link_length = sqrt(pow(firstSide, 2) + pow(secondSide, 2)) - holeSize;
    // original
    atan = atan(firstSide / secondSide);
    minX = min(points[1][0], points[0][0]);
    echo("minX is ", minX);
    minY = min(points[1][1], points[0][1]);
    echo("minY is ", minY);
    // xMove = firstSide < 0? abs(firstSide) + minX:0;
    //xMove = firstSide < 0? abs(firstSide) + minX:points[0][0] > 0? points[0][0]:0;
    echo("Signed First side is", signedFirstSide);
    echo("Signed Second side is", signedSecondSide);
    echo("minX is ", minX);
    echo("minY is ", minY);
    echo("points[0][0] is", points[0][0]);
    echo("points[0][1] is", points[0][1]);
    echo("abs(firstSide) + minX", abs(firstSide) + minX);
    echo("abs(secondSide) + minY", abs(secondSide) + minY);
    // le problème est là
    //xMove = signedFirstSide < 0 ? abs(firstSide) + minX:points[0][0] > 0? points[0][0]:0;
    xMove = signedFirstSide < 0 && points[1][0] != 0? abs(firstSide) + minX:points[0][0] > 0 && points[1][0] != 0 > 0?
        points[0][0]:minX;
    //yMove = secondSide < 0? abs(secondSide) + minY:0;
    //yMove = secondSide < 0? abs(secondSide) + minY:points[0][1] > 0? points[0][1]:0;
    yMove = signedSecondSide < 0? abs(secondSide) + minY:points[0][1] > 0? points[0][1]:minY;
    meshColor = xMove == 0 && yMove == 0 ? "white": "WhiteSmoke";
    echo("mesh_link treating", points);
    echo("moving X : ", xMove);
    echo("moving Y : ", yMove);
    union() {
        debugColor = mesh_link_length < 46? [10 * number / 255, 10 * number / 255, 10 * number / 255]: meshColor;
        //"purple"
        echo("I will move ", xMove, " and ", yMove, " with height ", height * 2);
        echo("I will rotate ", 270, 0, - atan);
        color(meshColor) translate([xMove, yMove, height * 2]) rotate([270, 0, - atan])
            translate([0, 0, holeSize / 2]) cylinder(h = mesh_link_length, r = thickness / 2, center = false, $fn = 100)
                ;
        echo("Finished treating mesh_link ", points, " with length ", mesh_link_length);

    }
}

module harness_mesh_link(points, thickness, height, number) {
    // modified
    firstSide = points[1][0] - points[0][0];
    secondSide = points[1][1] - points[0][1];
    echo("First side is ", firstSide);
    echo("Second side is ", secondSide);
    gap = points[1][0] - points[0][0];
    // modified
    mesh_link_length = sqrt(pow(firstSide, 2) + pow(secondSide, 2)) - holeSize;
    // original
    atan = atan(firstSide / secondSide);
    minX = min(points[1][0], points[0][0]);
    minY = min(points[1][1], points[0][1]);
    echo("min X: ", minX);
    echo("min Y: ", minY);
    // xMove = firstSide < 0? abs(firstSide) + minX:0;
    //xMove = firstSide < 0? abs(firstSide) + minX:firstSide + minX;
    xMove = firstSide < 0? abs(firstSide) + minX:atan < 0? firstSide + minX:minX;
    //yMove = secondSide < 0? abs(secondSide) + minY:0;
    yMove = secondSide < 0? minY:minY;
    meshColor = xMove == 0 && yMove == 0 ? "Khaki": "LightSeaGreen";
    echo("harness mesh_link treating", points);
    echo("harness moving X : ", xMove);
    echo("harness moving Y : ", yMove);
    union() {
        debugColor = mesh_link_length < 46? [10 * number / 255, 10 * number / 255, 10 * number / 255]: meshColor;
        //"purple"
        echo("harness I will move ", xMove, " and ", yMove, " with height ", height * 2);
        echo("harness I will rotate ", 270, 0, - atan);
        color(meshColor) translate([xMove, yMove, height * 2]) rotate([270, 0, - atan])
            translate([0, 0, holeSize / 2]) cylinder(h = mesh_link_length, r = thickness / 2, center = false, $fn = 100)
                ;
        echo("harness Finished treating mesh_link ", points, " with length ", mesh_link_length);

    }
}

module bracket_square_link(points, thickness, height) {
    echo("Bracket square link");
    firstSide = points[3][0] - points[0][0];
    secondSide = points[3][1] - points[0][1];
    gap = points[1][0] - points[3][0];
    // modified
    horizontalLength = firstSide - holeSize * 2;
    verticalLength = secondSide - holeSize / 2 ;
    // original
    atan = atan(firstSide / secondSide);
    union() {
        echo("UNION");
        /*  horizontalLink(height, thickness, horizontalLength);
          translate([verticalLength + holeSize, 0, 0])horizontalLink(height, thickness, horizontalLength);
          verticalLink(height, thickness, verticalLength);
          translate([0, horizontalLength + holeSize, 0])verticalLink(height, thickness, verticalLength);
        */
        link_everyone(points, thickness, height);
    }
}

module link_everyone(points, thickness, height) {
    echo("Link everyone");
    allLinks = superCombinations(points, 2);
    echo("All links are: ", allLinks);
    for (idx = [0 : len(allLinks) - 1]) {
        //for (p = allLinks) {
        //   stroke(p, endcap2 = "arrow2");
        //p = sort(allLinks[idx]);
        p = allLinks[idx];
        echo("P is now: ", p);
        mesh_link(p, thickness, height, idx);
    }
}

module new_link_everyone(points, thickness, height) {
    echo("Link everyone");
    allLinks = superCombinations(points, 2);
    echo("All links are: ", allLinks);
    for (idx = [0 : len(allLinks) - 1]) {
        //for (p = allLinks) {
        //   stroke(p, endcap2 = "arrow2");
        //p = sort(allLinks[idx]);
        p = allLinks[idx];
        echo("P is now: ", p);
        new_mesh_link(p, thickness, height, idx);
    }
}

module link_harness_to_bracket(points, thickness, height) {
    echo("Link everyone");
    allLinks = superCombinations(points, 2);
    echo("All links are: ", allLinks);
    for (idx = [0 : len(allLinks) - 1]) {
        //for (p = allLinks) {
        //   stroke(p, endcap2 = "arrow2");
        p = sort(allLinks[idx]);
        //p = allLinks[idx];
        echo("P is now: ", p);
        harness_mesh_link(p, thickness, height, idx);
    }
}

module horizontalLink(height, thickness, horizontalLength) {
    color("black")  translate([0, holeSize / 2, height * 2]) rotate([270, 0, 0]) cylinder(h = horizontalLength, r =
        thickness / 2, center = false, $fn = 100);
}

module  verticalLink(height, thickness, verticalLength) {
    color("white") translate([holeSize / 2, - 0, height * 2]) rotate([0, 90, 0]) cylinder(h = verticalLength, r =
        thickness / 2, center = false, $fn = 100);
}

module earsForScrewingIntoAPlank(points, thickness, height, baseSize, baseHeight, totalHeight) {
    //new_mesh_link(points, thickness, height, number);
    maxYPoint = maxInVector(points, maxX = false, maxY = true);
    minYPoint = minInVector(points, minX = false, minY = true);
    maxXPoint = maxInVector(points, maxX = true, maxY = false);
    minXPoint = minInVector(points, minX = true, minY = false);
    leftScrewPoint = [minXPoint - lengthFromBoardHarnessToEars, (maxYPoint - minYPoint) / 2, 0];
    rightScrewPoint = [maxXPoint + lengthFromBoardHarnessToEars, (maxYPoint - minYPoint) / 2, 0];
    pointsWithEars = concat(points, [leftScrewPoint], [rightScrewPoint]);
    echo("Points with ears ", pointsWithEars);
    difference() {
        union() {
            new_link_everyone(pointsWithEars, thickness, height);
            translate(leftScrewPoint) bracket_foot(leftScrewPoint, earsHoleDiameter, baseSize, baseHeight, totalHeight);
            translate(rightScrewPoint) bracket_foot(rightScrewPoint, earsHoleDiameter, baseSize, baseHeight, totalHeight
            );
        }
        translate(rightScrewPoint) cylinder(d = earsHoleDiameter, h = lengthFromBoardHarnessToEars, $fn = 100);
        translate(leftScrewPoint) cylinder(d = earsHoleDiameter, h = lengthFromBoardHarnessToEars, $fn = 100);
    }
}

// Function: combinations()
// Usage:
//   list = combinations(l, [n]);
//   for (p = combinations(l, [n])) ...
// Topics: List Handling, Iteration
// See Also: idx(), enumerate(), pair(), triplet(), permutations()
// Description:
//   Returns an ordered list of every unique permutation of `n` items out of the given list `l`.
//   For the list `[1,2,3,4]`, with `n=2`, this will return `[[1,2], [1,3], [1,4], [2,3], [2,4], [3,4]]`.
//   For the list `[1,2,3,4]`, with `n=3`, this will return `[[1,2,3], [1,2,4], [1,3,4], [2,3,4]]`.
// Arguments:
//   l = The list to provide permutations for.
//   n = The number of items in each permutation. Default: 2
// Example:
//   pairs = combinations([3,4,5,6]);  // Returns: [[3,4],[3,5],[3,6],[4,5],[4,6],[5,6]]
//   triplets = combinations([3,4,5,6],n=3);  // Returns: [[3,4,5],[3,4,6],[3,5,6],[4,5,6]]
// Example(2D):
//   for (p=combinations(regular_ngon(n=7,d=100))) stroke(p);
function superCombinations(l, n = 2, _s = 0) =
assert(is_finite(n) && n >= 1 && n <= len(l), "Invalid number `n`.")
n == 1
? [for (i = [_s:1:len(l)- 1]) [l[i]]]
: [for (i = [_s:1:len(l)- n], p = superCombinations(l, n = n - 1, _s =i + 1)) concat([l[i]], p)];

// Function: pair()
// Usage:
//   p = pair(list, [wrap]);
//   for (p = pair(list, [wrap])) ...  // On each iteration, p contains a list of two adjacent items.
// Topics: List Handling, Iteration
// See Also: idx(), enumerate(), triplet(), combinations(), permutations()
// Description:
//   Takes a list, and returns a list of adjacent pairs from it, optionally wrapping back to the front.
// Arguments:
//   list = The list to iterate.
//   wrap = If true, wrap back to the start from the end.  ie: return the last and first items as the last pair.  Default: false
// Example(2D): Does NOT wrap from end to start,
//   for (p = pair(circle(d=40, $fn=12)))
//       stroke(p, endcap2="arrow2");
// Example(2D): Wraps around from end to start.
//   for (p = pair(circle(d=40, $fn=12), wrap=true))
//       stroke(p, endcap2="arrow2");
// Example:
//   l = ["A","B","C","D"];
//   echo([for (p=pair(l)) str(p.y,p.x)]);  // Outputs: ["BA", "CB", "DC"]
function megaPair(list, wrap = false) =
assert(is_list(list)|| is_string(list), "Invalid input." )
assert(is_bool(wrap))
let(
ll = len(list)
) wrap
? [for (i = [0:1:ll - 1]) [list[i], list[(i + 1) % ll]]]
: [for (i = [0:1:ll - 2]) [list[i], list[i +1]]];


function getMinPoint(points) =
[min(subindex(points, 0)), min(subindex(points, 1))];

function getMaxPoint(points) =
[max(subindex(points, 0)), max(subindex(points, 1))];