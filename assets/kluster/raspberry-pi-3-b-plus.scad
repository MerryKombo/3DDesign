include <SBC_Model_Framework/sbc_models.scad>
include <NopSCADlib/utils/core/core.scad>
include <utils.scad>

// sbc("rpi3b+");
sbc_model = ["rpi3b+"];
s = search(sbc_model, sbc_data);

// pcb and holes
// pcbsize_x, pcbsize_y, pcbsize_z, pcbcorner_radius, topmax_component_z, bottommax_component_z
pcbsize_x = sbc_data[s[0]][1];
pcbsize_y = sbc_data[s[0]][2];
pcbsize_z = sbc_data[s[0]][3];
pcbcorner_radius = sbc_data[s[0]][4];
sbc_topmax_component_z = sbc_data[s[0]][5];
// cube([pcbsize_x, pcbsize_y, sbc_topmax_component_z + pcbsize_z]);
echo("pcbsize_x: ", pcbsize_x);
echo("pcbsize_y: ", pcbsize_y);
echo("pcbsize_z: ", pcbsize_z);
echo("pcbcorner_radius: ", pcbcorner_radius);
echo("sbc_topmax_component_z: ", sbc_topmax_component_z);

module k_sbc() {
    sbc("rpi3b+");
    sbc_model = ["rpi3b+"];
    s = search(sbc_model, sbc_data);

    // pcb and holes
    // pcbsize_x, pcbsize_y, pcbsize_z, pcbcorner_radius, topmax_component_z, bottommax_component_z
    pcbsize_x = sbc_data[s[0]][1];
    pcbsize_y = sbc_data[s[0]][2];
    pcbsize_z = sbc_data[s[0]][3];
    pcbcorner_radius = sbc_data[s[0]][4];
    sbc_topmax_component_z = sbc_data[s[0]][5];
    // cube([pcbsize_x, pcbsize_y, sbc_topmax_component_z + pcbsize_z]);
    echo("pcbsize_x: ", pcbsize_x);
    echo("pcbsize_y: ", pcbsize_y);
    echo("pcbsize_z: ", pcbsize_z);
    echo("pcbcorner_radius: ", pcbcorner_radius);
    echo("sbc_topmax_component_z: ", sbc_topmax_component_z);
}

module label(custom_text = "Dami-1", custom_font_size = 5, custom_plate_thickness = 0.4, custom_text_thickness = 0.8) {
    // The model of the board
    model = "RPi 3B+";
    text = custom_text;
    echo("model: ", model);
    echo("text: ", text);
    // The size of the text
    text_size = custom_font_size;
    echo("text_size: ", text_size);
    // The font of the text
    font = "Isonorm 3098";
    echo("font: ", font);
    //Size from text
    tm = textmetrics(text, size = text_size, font = font);
    echo("tm: ", tm);
    textsize = tm.size; //array
    echo("textsize: ", textsize);
    textpos = tm.position; //array
    echo("textpos: ", textpos);
    textwidth = textsize[1];
    echo("textwidth: ", textwidth);
    shift_back = textpos[0];
    echo("shift_back: ", shift_back);

    // The thickness of the text
    text_thickness = custom_text_thickness;
    echo("text_thickness: ", text_thickness);
    // The thickness of the plate
    plateThickness = custom_plate_thickness;
    echo("plateThickness: ", plateThickness);
    // The position of the text
    text_position = [0, 0, plateThickness];
    echo("text_position: ", text_position);
    roundedRectangleLength = textsize.x * 3 / 2;
    echo("roundedRectangleLength: ", roundedRectangleLength);
    roundedRectangleWidth = textsize.y * 3 / 2;
    echo("roundedRectangleWidth: ", roundedRectangleWidth);
    // The plate that will receive the text
    difference() {
        union() {
            color("black")
                // The plate
                hull() {
                    color("black")
                        rounded_rectangle([roundedRectangleLength, roundedRectangleWidth, plateThickness], 3);
                    // We should add on the right of the plate a hole to fix the plate on the board
                    // The hole should be of the size of the screw, which is 3, and can be found in the getHoleSize() function
                    // The hole should be at the same height as the text
                    // The hole should be at the same distance from the text as the text is from the origin
                    echo("getHoleSize(): ", getHoleSize());
                    echo("hole 0", getHole());
                    translate([roundedRectangleLength / 2 + getHole().x, 0, 0])
                        color("red")
                            translate([0, 0, 0.5])
                                cylinder(h = plateThickness, r = roundedRectangleWidth / 2, center = true);
                }
            // Create the 3D text
            color("white")
                translate(text_position)
                    linear_extrude(height = text_thickness)
                        text(text = text, size = text_size, halign = "center", valign = "center", font = font);
        }
        translate([roundedRectangleLength / 2 + getHole().x, 0, plateThickness])
            color("blue")
                cylinder(h = 4, r = getHoleSize() / 2, center = true);
    }
}


module labelWithACrook(custom_text = "Dami-1", custom_font_size = 5, custom_plate_thickness = 0.4, custom_text_thickness = 0.8) {
    // The model of the board
    model = "RPi 3B+";
    text = custom_text;
    echo("model: ", model);
    echo("text: ", text);
    // The size of the text
    text_size = custom_font_size;
    echo("text_size: ", text_size);
    // The font of the text
    font = "Isonorm 3098";
    echo("font: ", font);
    //Size from text
    tm = textmetrics(text, size = text_size, font = font);
    echo("tm: ", tm);
    textsize = tm.size; //array
    echo("textsize: ", textsize);
    textpos = tm.position; //array
    echo("textpos: ", textpos);
    textwidth = textsize[1];
    echo("textwidth: ", textwidth);
    shift_back = textpos[0];
    echo("shift_back: ", shift_back);

    // The thickness of the text
    text_thickness = custom_text_thickness;
    echo("text_thickness: ", text_thickness);
    // The thickness of the plate
    plateThickness = custom_plate_thickness;
    echo("plateThickness: ", plateThickness);
    // The position of the text
    text_position = [0, 0, plateThickness];
    echo("text_position: ", text_position);
    roundedRectangleLength = textsize.x * 3 / 2;
    echo("roundedRectangleLength: ", roundedRectangleLength);
    roundedRectangleWidth = textsize.y * 3 / 2;
    echo("roundedRectangleWidth: ", roundedRectangleWidth);
    // The plate that will receive the text
    difference() {
        union() {
            color("black")
                // The plate
                union() {
                    color("black")
                        hull() {
                            rounded_rectangle([roundedRectangleLength, roundedRectangleWidth, plateThickness], 3);
                            // We should add on the right of the plate a hole to fix the plate on the board
                            // The hole should be of the size of the screw, which is 3, and can be found in the getHoleSize() function
                            // The hole should be at the same height as the text
                            // The hole should be at the same distance from the text as the text is from the origin
                            echo("getHoleSize(): ", getHoleSize());
                            echo("hole 0", getHole());
                            translate([roundedRectangleLength / 2 + getHole().x, 0, 0])
                                color("red")
                                    translate([0, 0, 0.5])
                                        cylinder(h = plateThickness, r = roundedRectangleWidth / 2, center = true);
                        }
                    // TODO: add a smooth edge on the elbow, as we now have a 90° angle, and that's not beautiful.
                    translate([roundedRectangleLength / 2 + getHole().x, 0, 0])
                        hull() {
                            color("red")
                                translate([0, 0, 0.5])
                                    cylinder(h = plateThickness, r = roundedRectangleWidth / 2, center = true);
                            color("red")
                                translate([0, -roundedRectangleWidth, 0.5])
                                    cylinder(h = plateThickness, r = roundedRectangleWidth / 2, center = true);
                        }
                }
            // Create the 3D text
            color("white")
                translate(text_position)
                    linear_extrude(height = text_thickness)
                        text(text = text, size = text_size, halign = "center", valign = "center", font = font);
        }
        translate([roundedRectangleLength / 2 + getHole().x, -roundedRectangleWidth, plateThickness])
            color("blue")
                cylinder(h = 4, r = getHoleSize() / 2, center = true);
    }
}

//translate([7.1904 / 2, -22.6088 / 2, -.4])     rotate([0, 0, 90])         labelWithACrook(custom_text = "Dami-1",custom_font_size = 5, custom_plate_thickness = 0.4, custom_text_thickness = 0.8);

module fosdemLabels() {
    machines = [
            ["Dami", "3B+", 3],
            ["Dami", "3B", 5],
            ["Goun", "3B+", 3]
        ];

    for (machine = [0 : len(machines) - 1]) {
        owner = machines[machine][0];
        type = machines[machine][1];
        count = machines[machine][2];

        for (i = [1 : count]) {
            label_text = str(owner, "-", type, "-", i);
            translate([15 * i, -46.5 * machine, -.4]) // Adjusted values here
                rotate([0, 0, 90])
                    labelWithACrook(custom_text = label_text, custom_font_size = 5, custom_plate_thickness = 0.4,
                    custom_text_thickness = 0.8);
        }
    }
}

// fosdemLabels();