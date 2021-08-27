// Found there: https://openhome.cc/eGossip/OpenSCAD/SectorArc.html
use <hull_polyline3d.scad>;
use <polyhedron_hull.scad>;
use <bezier_curve.scad>;
use <polyline3d.scad>;

radius = 8;
firstArcAngles = [0, 45];
secondArcAngles = [180, 225];
thirdArcAngles = [270, 275];
fn = 100;
trackLength = 100;
width = 2;
firstArcAngle = 35;

module beziersPath(radius, trackLength, wallThickness, width, pinDepth) {
    t_step = 0.05;
    startingPoint = [0, radius];
    secondPoint = [radius * 1.1, radius];
    //firstArcAnglePoint = [radius * cos(firstArcAngle), radius * sin(firstArcAngle)];
    thirdPoint = [1.3 * radius, radius * .5];
    endingPoint = [1.8 * radius, radius * .1];
    endingEndingPoint = [2 * radius, - 1.2];
    endingEndingEndingPoint = [3.4 * radius, - .4];
    bezierCurvePoints = bezier_curve(t_step, [startingPoint, secondPoint, thirdPoint,
        endingPoint, endingEndingPoint, endingEndingEndingPoint]);
    linear_extrude(height = pinDepth) projection() translate([- 0.1, 0, 0])  hull_polyline3d(
    bezierCurvePoints, diameter = width, $fn = 24);
    /*
        secondBezierCurvePoints = bezier_curve(t_step, [p2, p4, p5]);
        color("purple") linear_extrude(height = width) projection() translate([- 0.1, 0, 0])
            hull_polyline3d(secondBezierCurvePoints, diameter = 0.1, $fn = 24);*/
}


module drawSector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = - 360 / fn;

    points = concat([[0, 0]],
    [for (a = [angles[0] : step : angles[1] - 360])
        [r * cos(a), r * sin(a)]
    ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

//sector(radius, angles, fn);


//platePath(radius, firstArcAngles, secondArcAngles, thirdArcAngles, //trackLength, width);

module drawSector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = - 360 / fn;

    points = concat([[0, 0]],
    [for (a = [angles[0] : step : angles[1] - 360])
        [r * cos(a), r * sin(a)]
    ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module drawArc(radius, angles, width = 1, fn = 24) {
    difference() {
        drawSector(radius + width, angles, fn);
        drawSector(radius, angles, fn);
    }
}

module platePath(radius, trackLength, wallThickness, width, pinDepth) {
    color("purple") union() {
        translate([0, - radius, 0]) beziersPath(radius, trackLength, wallThickness, width, pinDepth);
        // First arc
        //linear_extrude(pinDepth) drawArc(radius, firstArcAngles, width, 100);
        // Second arc
        //translate([radius * 2 + width, 0, 0]) linear_extrude(pinDepth) drawArc(radius, secondArcAngles, width, 100);
        // Third arc
        //translate([0, 0, 0]) linear_extrude(pinDepth) drawArc(radius, thirdArcAngles, width, 100);
        trackPoints = [[0, 0], [trackLength, 0], [trackLength, width], [0, width]];
        trackPaths = [[0, 1, 2, 3]];
        downTrackPoints = [[0, 0], [0, 25], [2, 25], [2, 0]];
        downTrackPaths = [[0, 1, 2, 3]];
        // End of track
        translate([radius + width * 2.1, - radius * 2 + width, 0]) linear_extrude(pinDepth) polygon(points = trackPoints
        ,
        paths =
        trackPaths,
        convexity = 1);
        echo("wallthickness is ", wallThickness);
        //translate([radius, - radius - width*2, 0]) linear_extrude(1) polygon(points = downTrackPoints, paths = downTrackPaths,
        //convexity = 1)    ;
    }
}