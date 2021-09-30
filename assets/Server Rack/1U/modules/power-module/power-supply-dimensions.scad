include <NopSCADlib/lib.scad>
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/iecs.scad>
include <NopSCADlib/vitamins/iec.scad>
include <../module-dimensions.scad>

include <NopSCADlib/vitamins/blowers.scad>

powerSupplyRatio = 1.1;

iecBodyType = 1;
iecBodyWidth = iec_body_w(iecs[iecBodyType]);
iecBodyHeight = iec_body_h(iecs[iecBodyType]);
iecBodyLength = 25;

S_96_12 =
    ["S_96_12", "S_96_12", // part name
    159, 98, 38, // length, width, height,
    M3_pan_screw, M3_clearance_radius, // screw type and clearance
    false, // true if ATX style
    11, // terminals bay depth
    4.5, // heatsink bay depth
        [// terminals
        7, // count
        11, // y offset
        mw_terminals],
    // faces
        [
            [// f_bottom, bottom
                [// holes
                    [82.5, - 40], [82.5, 40], [- 37.5, - 40], [- 37.5, 40]],
            1.5, // thickness
                []], // cutouts
            [[], 0.5, [], true], // grill
            [[], 0.5, [[[- 49, - 19], [- 49, - 11.5], [- 40, - 11.5], [- 40, 5], [47.5, 5], [47.5, - 19]]]],
        // f_top, top
            [[], 1.5, [[[- 49, - 19], [- 49, - 6], [37.5, - 6], [37.5, - 12.5], [49, - 12.5], [49, - 19]]]],
        // f_left, front (terminals) after rotation
            [[[- 77.5, 1], [79.5, 9.5], [79.5, - 9.5]], 1.5, []], // f_right, back after rotation
            [[], 0.5, [], true],
        ],
        []
    ];

// This PSU, and ones very like it, are sold by LulzBot, and various sellers on eBay.
// The screw layout specified here uses the inner set of screw-mounts on the PSU, which are M4.
// The outer set don't appear to be M3, even though the datasheet claims they are.
S_300_12 = [
    "S_300_12",
    "S-300-12", // part name
    215, 115, 50, // length, width, height
    M4_cap_screw, M4_clearance_radius, // screw type and clearance
    false, // true if ATX style
    13, // terminals bay depth
    0, // heatsink bay depth
        [// terminals
        9, // count
        18, // y offset
        st_terminals
        ],
    // faces
        [
            [// f_bottom, bottom
                [// holes
                    [215 / 2 - 32.5, 115 / 2 - 82.5], [215 / 2 - 32.5, 115 / 2 - 32.5], [215 / 2 - 182.5, 115 / 2 - 82.5
                ], [215 / 2 - 182.5, 115 / 2 - 32.5]
                ],
            1.5, // thickness
                [], // cutouts
            false, // grill
                [], [], [], // fan, iec, rocker
            [// vents
            // [ [pos.x, pos.y, angle], [size.x, size.y], corner radius ]
            for (x = [0:21], y = [- 1, 1]) [[- 7 * x + 215 / 2 - 34, (115 / 2 - 5) * y, 0], [3, 25], 1.5]
            ]
            ],
            [// f_top, top
                [], // holes
            0.5, // thickness
                [], // cutouts
            false, // grill
                [215 / 2 - 47.5, 115 / 2 - 37.5, fan50x15],
                [], //iec
                [], //rocker
            [// vents
            for (x = [0:4], y = [- 1, 1]) [[- 7 * x - 215 / 2 + 48, 28 * y, 0], [3, 25], 1.5]
            ]
            ],
            [// f_left, front (terminals) after rotation
                [], // holes
            0.5, // thickness
                [// cutouts
                    [
                        [- 56, - 25], [- 56, - 17],
                        [- 60, - 17], [- 60, 0],
                        [115 / 2, 0], [115 / 2, - 25]
                    ]
                ],
            false, // grill
            ],
            [// f_right, back after rotation
                [], // holes
            1.5, // thickness
                [], // cutouts
            false, // grill
            ],
            [// f_front, right after rotation
                [// holes, offset from center
                    [215 / 2 - 32.5, - 15], [215 / 2 - 182.5, - 15],
                    [215 / 2 - 32.5, 10], [215 / 2 - 182.5, 10]
                ],
            1.5, // thickness
                [], // cutouts
            false, // grill
                [], [], [], // fan, iec, rocker
            [// vents
            for (x = [0 : 21]) [[- 7 * x + 215 / 2 - 34, - 25, 0], [3, 10], 1.5],
        for(x = [0 :  1]) [[ - 7 * x, - 1, 0], [3, 25], 1.5],
for(x = [0 :  2]) [[ - 7 * x - 215 / 2+ 20, - 1, 0], [3, 25], 1.5],
]
],
[// f_back, left after rotation
[// holes, offset from center
[215 / 2 - 32.5 - 13 / 2, 15], [215 /2 - 182.5 - 13 / 2, 15]
],
1.5, // thickness
[], // cutouts
false, // grill
[], [], [], // fan, iec, rocker
[// vents
for(x = [0 : 21]) [[ - 7 * x + 215 / 2- 34 - 13 / 2, 25, 0], [3, 10], 1.5]
]
],
],
// accessories to add to BOM
[]
];

PD_150_12 =
["PD_150_12", "PD-150-12", 199, 98, 38, M3_pan_screw, M3_clearance_radius, false, 11, 4.5, [7, 11, mw_terminals],
[
[[[82.5, - 40], [82.5, 40], [ - 37.5, - 40], [ - 37.5, 40]], 1.5, []],
[[], 0.5, [], true],
[[], 0.5, [[[ -49, - 19], [ - 49, - 11.5], [ - 40, - 11.5], [ - 40, 5], [47.5, 5], [47.5, - 19]]]],
[[], 1.5, [[[ - 49, - 19], [ - 49, - 6], [37.5, - 6], [37.5, -12.5], [49, - 12.5], [49, - 19]]]],
[[[ - 77.5, 1], [79.5, 9.5], [79.5, - 9.5]], 1.5, []],
[[], 0.5, [], true],
],
[]
];

powerSupplyBase = PD_150_12;

powerSupplyWidth = powerSupplyBase[3];
powerSupplyHeight = powerSupplyBase[4];;
powerSupplyLength = powerSupplyBase[2];
powerSupplyModuleBlower = PE4020;

powerSupplyModuleLength = powerSupplyLength + iecBodyLength;

psuLength = psu_length(powerSupplyBase);
psuModuleWidth = ceil(psuLength / (moduleWidth - 2 * wallThickness));
powerSupplyModuleFanSize = blower_length(powerSupplyModuleBlower);
echo("powerSupplyModuleFanSize is ", powerSupplyModuleFanSize);
// Let's try to make this module as long as a multiple of the basic module
psuModuleRatioBase = ((powerSupplyWidth + powerSupplyModuleFanSize) * powerSupplyRatio) / (moduleLength - 2 * (
rodSurroundingDiameter + surroundingDiameter));

// Ok, everything can fit, but will that be practical? Let's give a little bit of space
psuNeedRoomRatio = 1.1;

echo("The psu module floor is ", floor(psuModuleRatioBase));
echo("The psu module ratio is ", ceil(psuModuleRatioBase));
psuTempModuleRatio = (ceil(psuModuleRatioBase) + floor(psuModuleRatioBase)) / 2;
psuModuleRatio = psuTempModuleRatio * moduleLength * psuNeedRoomRatio > psuTempModuleRatio? ceil(psuModuleRatioBase):
psuTempModuleRatio;

echo("The psu module ratio is ", psuModuleRatio);

psuModuleLength = psuModuleRatio * moduleLength;
if (psuModuleLength > printerMaxSize) {
echo("ERROR ! psuModuleLength is bigger than printerMaxSize!!!");
}
echo("PSU module length will be ", psuModuleLength, " (", psuModuleRatio, ")");