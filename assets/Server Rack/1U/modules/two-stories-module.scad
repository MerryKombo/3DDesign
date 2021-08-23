// Found there: https://openhome.cc/eGossip/OpenSCAD/SectorArc.html

radius = 8;
firstArcAngles = [0, 90];
secondArcAngles = [180, 270];
thirdArcAngles = [270, 360];
fn = 100;
trackLength = 100;
width = 2;

module sector(radius, angles, fn = 24) {
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


platePath(radius, firstArcAngles, secondArcAngles, thirdArcAngles, trackLength, width);

module sector(radius, angles, fn = 24) {
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

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
}

module platePath(radius, firstArcAngles, secondArcAngles, thirdArcAngles, trackLength, width) {
    linear_extrude(1) arc(radius, firstArcAngles, width, 100);
    translate([radius * 2 + width, 0, 0]) linear_extrude(1) arc(radius, secondArcAngles, width, 100);
    translate([0, 0, 0]) linear_extrude(1) arc(radius, thirdArcAngles, width, 100);
    trackPoints = [[0, 0], [trackLength, 0], [trackLength, width], [0, width]];
    trackPaths = [[0, 1, 2, 3]];
    downTrackPoints = [[0, 0], [0, 25], [2, 25], [2, 0]];
    downTrackPaths = [[0, 1, 2, 3]];
    translate([0, - radius - width, 0]) linear_extrude(1) polygon(points = trackPoints, paths = trackPaths,
    convexity = 1);
    //translate([radius, - radius - width*2, 0]) linear_extrude(1) polygon(points = downTrackPoints, paths = downTrackPaths,
    //convexity = 1)    ;
}