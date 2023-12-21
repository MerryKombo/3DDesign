use <../Server Rack/1U/boards/mangopi mq-pro dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec nanopi duo2 dimensions.scad>
use <../Server Rack/1U/boards/friendlyelec R5s dimensions.scad>
use <../Server Rack/1U/parts/board.scad>
use <../Server Rack/1U/boards/friendlyelec R5s.scad>
use <openscad-extra/src/torus.scad>
include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>
include <NopSCADlib/vitamins/inserts.scad>

//
// Threaded inserts
//
//                     l    o    h    s    b     r    r    r
//                     e    u    o    c    a     i    i    i
//                     n    t    l    r    r     n    n    n
//                     g    e    e    e    r     g    g    g
//                     t    r         w    e     1    2    3
//                     h         d         l
//                          d         d          h    d    d
//                                         d
//
F1BM2 = ["F1BM2", 4.0, 3.6, 3.2, 2, 3.0, 1.0, 3.4, 3.1];
F1BM2p5 = ["F1BM2p5", 5.8, 4.6, 4.0, 2.5, 3.65, 1.6, 4.4, 3.9];
ruthexM3x5_7 = ["RX-M3x5.7", 5.7, 4.6, 4.0, 3, 3.91, 1.6, 4.4, 3.9];
F1BM4 = ["F1BM4", 8.2, 6.3, 5.6, 4, 5.15, 2.3, 6.0, 5.55];
module inserts() {

    for (i = [0: len(inserts) - 1])
    translate([10 * i, 5])
        insert(inserts[i]);

    for (i = [0: len(short_inserts) - 1])
    translate([10 * i, - 5])
        insert(short_inserts[i]);



    stl_colour(pp1_colour)
    translate([len(inserts) * 10, 0]) {
        insert_lug(inserts[0], 2, 1);

        translate([10, 0])
            insert_boss(inserts[0], z = 10, wall = 2);
    }
}

if ($preview)
    let($show_threads = true)
    insert_boss(F1BM3, z = 20, wall = 2);
//inserts();


function insertName(holeSize) = (holeSize == 3) ?
    F1BM3 : (holeSize == 2) ?
            F1BM2 : (holeSize == 2.5) ?
                    F1BM2p5: (holeSize == 4) ?
                            F1BM4 : CNCKM5;

insert_boss(F1BM3, z = 20, wall = 2);