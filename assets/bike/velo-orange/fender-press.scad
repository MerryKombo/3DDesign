// Largeur max du garde-boue à l'endroit de la fourche: 45.2 mm
// Largeur de la fourche: 40 mm
// Indentation à imprimer sur le garde-boue pour qu'il passe: 5.2 mm, donc 2.6 mm de chaque côté.

points = [[0.000000, 0.000000], [0.314646, 0.813166], [0.629293, 1.588604], [0.943939, 2.327195], [1.258586, 3.029819],
        [1.573232, 3.697357], [1.887879, 4.330690], [2.202525, 4.930697], [2.517172, 5.498261], [2.831818, 6.034260],
        [3.146465, 6.539576], [3.461111, 7.015089], [3.775758, 7.461680], [4.090404, 7.880229], [4.405051, 8.271618],
        [4.719697, 8.636725], [5.034343, 8.976433], [5.348990, 9.291621], [5.663636, 9.583171], [5.978283, 9.851962],
        [6.292929, 10.098875], [6.607576, 10.324791], [6.922222, 10.530590], [7.236869, 10.717153], [7.551515, 10.885360
        ],
        [7.866162, 11.036093], [8.180808, 11.170231], [8.495455, 11.288655], [8.810101, 11.392246], [9.124747, 11.481884
        ],
        [9.439394, 11.558450], [9.754040, 11.622823], [10.068687, 11.675886], [10.383333, 11.718519], [10.697980,
        11.751601],
        [11.012626, 11.776013], [11.327273, 11.792637], [11.641919, 11.802352], [11.956566, 11.806040], [12.271212,
        11.804580],
        [12.585859, 11.798854], [12.900505, 11.789741], [13.215152, 11.778123], [13.529798, 11.764879], [13.844444,
        11.750892],
        [14.159091, 11.737040], [14.473737, 11.724205], [14.788384, 11.713267], [15.103030, 11.705106], [15.417677,
        11.700604],
        [15.732323, 11.700604], [16.046970, 11.705106], [16.361616, 11.713267], [16.676263, 11.724205], [16.990909,
        11.737040],
        [17.305556, 11.750892], [17.620202, 11.764879], [17.934848, 11.778123], [18.249495, 11.789741], [18.564141,
        11.798854],
        [18.878788, 11.804580], [19.193434, 11.806040], [19.508081, 11.802352], [19.822727, 11.792637], [20.137374,
        11.776013],
        [20.452020, 11.751601], [20.766667, 11.718519], [21.081313, 11.675886], [21.395960, 11.622823], [21.710606,
        11.558450],
        [22.025253, 11.481884], [22.339899, 11.392246], [22.654545, 11.288655], [22.969192, 11.170231], [23.283838,
        11.036093],
        [23.598485, 10.885360], [23.913131, 10.717153], [24.227778, 10.530590], [24.542424, 10.324791], [24.857071,
        10.098875],
        [25.171717, 9.851962], [25.486364, 9.583171], [25.801010, 9.291621], [26.115657, 8.976433], [26.430303, 8.636725
        ],
        [26.744949, 8.271618], [27.059596, 7.880229], [27.374242, 7.461680], [27.688889, 7.015089], [28.003535, 6.539576
        ],
        [28.318182, 6.034260], [28.632828, 5.498261], [28.947475, 4.930697], [29.262121, 4.330690], [29.576768, 3.697357
        ],
        [29.891414, 3.029819], [30.206061, 2.327195], [30.520707, 1.588604], [30.835354, 0.813166], [31.150000, 0.000000
        ]];

offsetPoints = [[0.000000, -3.666595], [0.314646, -2.661582], [0.629293, -1.704157], [0.943939, -0.793189], [1.258586,
    0.072457],
        [1.573232, 0.893916], [1.887879, 1.672320], [2.202525, 2.408804], [2.517172, 3.104502], [2.831818, 3.760547],
        [3.146465, 4.378073], [3.461111, 4.958215], [3.775758, 5.502106], [4.090404, 6.010880], [4.405051, 6.485671],
        [4.719697, 6.927613], [5.034343, 7.337839], [5.348990, 7.717484], [5.663636, 8.067681], [5.978283, 8.389565],
        [6.292929, 8.684269], [6.607576, 8.952927], [6.922222, 9.196672], [7.236869, 9.416640], [7.551515, 9.613964],
        [7.866162, 9.789777], [8.180808, 9.945213], [8.495455, 10.081407], [8.810101, 10.199492], [9.124747, 10.300603],
        [9.439394, 10.385872], [9.754040, 10.456434], [10.068687, 10.513423], [10.383333, 10.557973], [10.697980,
        10.591217],
        [11.012626, 10.614290], [11.327273, 10.628324], [11.641919, 10.634456], [11.956566, 10.633817], [12.271212,
        10.627542],
        [12.585859, 10.616765], [12.900505, 10.602619], [13.215152, 10.586239], [13.529798, 10.568759], [13.844444,
        10.551312],
        [14.159091, 10.535032], [14.473737, 10.521054], [14.788384, 10.510510], [15.103030, 10.504535], [15.417677,
        10.504263],
        [15.732323, 10.510604], [16.046970, 10.523017], [16.361616, 10.540384], [16.676263, 10.561585], [16.990909,
        10.585500],
        [17.305556, 10.611008], [17.620202, 10.636989], [17.934848, 10.662324], [18.249495, 10.685893], [18.564141,
        10.706574],
        [18.878788, 10.723249], [19.193434, 10.734797], [19.508081, 10.740098], [19.822727, 10.738031], [20.137374,
        10.727478],
        [20.452020, 10.707317], [20.766667, 10.676429], [21.081313, 10.633693], [21.395960, 10.577990], [21.710606,
        10.508199],
        [22.025253, 10.423200], [22.339899, 10.321874], [22.654545, 10.203100], [22.969192, 10.065757], [23.283838,
        9.908727],
        [23.598485, 9.730888], [23.913131, 9.531121], [24.227778, 9.308306], [24.542424, 9.061323], [24.857071, 8.789050
        ],
        [25.171717, 8.490370], [25.486364, 8.164160], [25.801010, 7.809302], [26.115657, 7.424675], [26.430303, 7.009158
        ],
        [26.744949, 6.561633], [27.059596, 6.080979], [27.374242, 5.566075], [27.688889, 5.015802], [28.003535, 4.429040
        ],
        [28.318182, 3.804668], [28.632828, 3.141567], [28.947475, 2.438616], [29.262121, 1.694695], [29.576768, 0.908684
        ],
        [29.891414, 0.079464], [30.206061, -0.794087], [30.520707, -1.713087], [30.835354, -2.678658], [31.150000, -
    3.691920]];

// This OpenSCAD script models a press for shaping a fender to fit around a bicycle fork.
// It includes definitions for both male and female parts of the press, designed to imprint or receive the fender shape.
// The script utilizes modular design for reusability and customization of the press components.

// Global parameters defining the dimensions of the press and the fender shape.
height = 30;
width = 40;
forkPrintWidth = 31.15; // The width of the imprint on the fender for the fork.
pressWidth = 50;
base_thickness = 10;
curve_thickness = 2;
totalHeight = 50;

// Module: curve_shape
// Draws the curve of the fender based on predefined points.
// This shape is used in both the male and female parts of the press.
module curve_shape() {
    polygon(points);
}

// Module: screw_holes
// Creates a series of holes for screws in the press parts.
// Parameters:
//   num_holes: Number of holes to create.
//   edge_distance: Distance from the edge to the first hole.
//   hole_spacing: Distance between centers of adjacent holes.
//   hole_radius: Radius of each hole.
//   hole_height: Height of the holes.
module screw_holes(num_holes, edge_distance, side_edge_distance = forkPrintWidth / 2, hole_spacing, hole_radius,
hole_height) {
    for (i = [0:num_holes - 1])
    translate([edge_distance + hole_spacing * i, side_edge_distance, -.1])
        cylinder(r = hole_radius * 1.1, h = hole_height, $fn = 100);
}

// Module: male_part
// Constructs the male part of the press.
// This part includes the base and the protruding curve that shapes the fender.
module male_part() {
    translate([pressWidth, 0, 0])
        rotate([-180, 0, 180])
            translate([forkPrintWidth + (pressWidth - forkPrintWidth) / 2, 0, 0])
                rotate([0, 0, 90])
                    difference() {
                        union() {
                            translate([0, -(pressWidth - forkPrintWidth) / 2, 0])
                                difference() {
                                    cube([width, pressWidth, base_thickness]);  // Base
                                    translate([0, pressWidth, 0])
                                        screw_holes(num_holes = 2, edge_distance = 10, side_edge_distance = -5,
                                        hole_spacing =
                                        20,
                                        hole_radius = 3, hole_height = totalHeight);
                                    screw_holes(num_holes = 2, edge_distance = 10, side_edge_distance = 5, hole_spacing
                                    = 20,
                                    hole_radius = 3, hole_height = totalHeight);
                                }
                            translate([0, 0, base_thickness])
                                rotate([90, 0, 90])
                                    linear_extrude(height = width)
                                        curve_shape();
                        }
                        // Holes for screws to assemble the press or mount it to a surface.
                        screw_holes(num_holes = 2, edge_distance = 10, hole_spacing = 20, hole_radius = 3, hole_height =
                        totalHeight);
                    }
}

// Module: female_part
// Constructs the female part of the press.
// This part includes a cavity that matches the curve of the fender, allowing it to be shaped by the male part.
module female_part() {
    rotate([0, 180, -90])
        translate([0, 0, -height])
            difference() {
                cube([width, pressWidth, height]);  // Full block
                translate([-width * .05, 10, base_thickness])
                    rotate([90, 0, 90])
                        linear_extrude(height = width * 1.1)
                            offset(r = curve_thickness) curve_shape();
                // remove the very top of the cube
                translate([-width * .05, -width * .05, -base_thickness * 0.05])
                    cube([width * 1.1, pressWidth * 1.1, base_thickness * 1.1]);  // Full block
                // To remove the upper part of the female part
                //translate([0, 0, base_thickness]) cube([width * 2, 60, base_thickness]);  // Full block
                // The middle holes
                screw_holes(num_holes = 2, edge_distance = 10, side_edge_distance = pressWidth / 2, hole_spacing = 20,
                hole_radius = 3, hole_height = totalHeight);
                // The side screw_holes
                screw_holes(num_holes = 2, edge_distance = 10, side_edge_distance = 5, hole_spacing = 20,
                hole_radius = 3, hole_height = totalHeight);
                screw_holes(num_holes = 2, edge_distance = 10, side_edge_distance = pressWidth - 5, hole_spacing = 20,
                hole_radius = 3, hole_height = totalHeight);
            }
}

// Assembly of the male and female parts to form the complete press.
// The female part is translated to sit next to the male part for visualization.
translate([0, 0, 30]) male_part();
//translate([width + 5, 0, 0])
female_part();
