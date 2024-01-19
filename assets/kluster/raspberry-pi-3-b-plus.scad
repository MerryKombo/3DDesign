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

module label() {
    // The model of the board
    model = "RPi 3B+";
    text = "Dami-1";
    echo("model: ", model);
    echo("text: ", text);
    // The size of the text
    text_size = 5;
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
    text_thickness = .8;
    echo("text_thickness: ", text_thickness);
    // The thickness of the plate
    plateThickness = .4;
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
// translate([7.1904 / 2, -22.6088 / 2, -.4])     rotate([0, 0, 90])         label();