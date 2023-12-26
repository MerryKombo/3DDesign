include <torus.scad>;
include <raspberry-pi-3-b-plus.scad>;
include <torus.scad>;
include <raspberry-pi-3-b-plus.scad>;

sbc_model = ["rpi3b+"];
s = search(sbc_model, sbc_data);
/*schema:
"model",pcbsize_x, pcbsize_y, pcbsize_z, pcbcorner_radius, topmax_component_z, bottommax_component_z
pcb_hole1_x, pcb_hole1_y, pcb1_hole_size, pcb_hole2_x, pcb_hole2_y, pcb2_hole_size
pcb_hole3_x, pcb_hole3_y, pcb3_hole_size, pcb_hole4_x, pcb_hole4_y, pcb4_hole_size
pcb_hole5_x, pcb_hole5_y, pcb5_hole_size, pcb_hole6_x, pcb_hole6_y, pcb6_hole_size
pcb_hole7_x, pcb_hole7_y, pcb7_hole_size, pcb_hole8_x, pcb_hole8_y, pcb8_hole_size
pcb_hole9_x, pcb_hole9_y, pcb9_hole_size, pcb_hole10_x, pcb_hole10_y, pcb10_hole_size
soc1size_x, soc1size_y, soc1size_z, soc1loc_x, soc1loc_y, soc1loc_z, soc1_rotation, "soc1_side",
soc2size_x, soc2size_y, soc2size_z, soc2loc_x, soc2loc_y, soc2loc_z, soc2_rotation, "soc2_side",
soc3size_x, soc3size_y, soc3size_z, soc3loc_x, soc3loc_y, soc3loc_z, soc3_rotation, "soc3_side",
soc4size_x, soc4size_y, soc4size_z, soc4loc_x, soc4loc_y, soc4loc_z, soc4_rotation, "soc4_side",
component_x, component_y, component_rotation, "component_side", "component_class","component_type"*/
// MANUFACTURER: RasberryPi Foundation
// NAME: RPi 3B+
// SOURCE: OEM Mechanical drawings
// TODO: Add SOC data
// STATUS: yellow, unverified
/* ["rpi3b+",85,56,1,3.5,16,6,                             // sbc model, pcb size and component height
3.5,3.5,3,3.5,52.5,3,                                   // pcb holes 1 and 2
61.5,3.5,3,61.5,52.5,3,                                 // pcb holes 3 and 4
0,0,0,0,0,0,                                            // pcb holes 5 and 6
0,0,0,0,0,0,                                            // pcb holes 7 and 8
0,0,0,0,0,0,                                            // pcb holes 9 and 10
13,13,1.25,23,23,0,0,"top",                             // soc1 size, location, rotation and side
0,0,0,0,0,0,0,"",                                       // soc2 size, location, rotation and side
0,0,0,0,0,0,0,"",                                       // soc3 size, location, rotation and side
0,0,0,0,0,0,0,"",                                       // soc4 size, location, rotation and side
1,21.7,270,"bottom","storage","microsdcard",            // sdcard
6.8,-1,0,"top","usb2","micro",                          // usb2 otg
24.5,-1,0,"top","video","hdmi_a",                       // hdmi
65,2.25,270,"top","network","rj45_single",              // ethernet
69.61,39.6,270,"top","usb2","double_stacked_a",         // usb2
69.61,21.6,270,"top","usb2","double_stacked_a",         // usb1
7,50,0,"top","gpio","header_40",                        // gpio
6.5,36,0,"top","ic","ic_11x13",                         // wifi
53,30,0,"top","ic","ic_7x7",                            // usbhub 5mm
1.1,17.5,90,"top","video", "mipi_csi",                  // display
43.5,1,270,"top","video", "mipi_csi",                   // camera
50.25,0,0,"top","audio", "jack_3.5",                    // audio port
1.1, 43.2, 90, "top", "misc", "led_3x1.5",              // activity led
1.1, 47, 90, "top", "misc", "led_3x1.5"],               // power led
*/
// pcb and holes
// pcbsize_x, pcbsize_y, pcbsize_z, pcbcorner_radius, topmax_component_z, bottommax_component_z
pcbsize_x = sbc_data[s[0]][1];
pcbsize_y = sbc_data[s[0]][2];
pcbsize_z = sbc_data[s[0]][3];
pcbcorner_radius = sbc_data[s[0]][4];
sbc_topmax_component_z = sbc_data[s[0]][5];
holes = [
        [sbc_data[s[0]][7], sbc_data[s[0]][8], sbc_data[s[0]][9]],
        [sbc_data[s[0]][10], sbc_data[s[0]][11], sbc_data[s[0]][12]],
        [sbc_data[s[0]][13], sbc_data[s[0]][14], sbc_data[s[0]][15]],
        [sbc_data[s[0]][16], sbc_data[s[0]][17], sbc_data[s[0]][18]]
    ];
fan_diameter = 140;
// cube([pcbsize_x, pcbsize_y, sbc_topmax_component_z + pcbsize_z]);
echo("pcbsize_x: ", pcbsize_x);
echo("pcbsize_y: ", pcbsize_y);
echo("pcbsize_z: ", pcbsize_z);
echo("pcbcorner_radius: ", pcbcorner_radius);
echo("sbc_topmax_component_z: ", sbc_topmax_component_z);
ensureBoardsFit(fan_diameter, pcbsize_y);
echo("holes: ", holes);
// translate([pcbsize_y, 0, 0])
// rotate([0, -90, 90])
// k_sbc();
baseHeight = 5;
numberOfBoards = 8;
earSize = 10;

function getTorusSize() = fan_diameter * 1.1;
function getFanDiameter() = fan_diameter;
function getBoardSize() = [pcbsize_x, pcbsize_y, pcbsize_z]; // Replace [84, 57.56] with the actual size of the board