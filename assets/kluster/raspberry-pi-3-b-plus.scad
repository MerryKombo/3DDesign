include <SBC_Model_Framework/sbc_models.scad>

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
