include <../module-dimensions.scad>
include <../module.scad>
include <../switch-module/8-ports-gigabit-switch-dimensions.scad>
include <../../boards/8-ports-gigabit-switch.scad>

eightPortsGigabitSwitchModule(true);
//eightPortsGigabitSwitchPCB();

module eightPortsGigabitSwitchModule(displayPCB = false) {
    union() {
        basicModule(eightPortsGigabitSwitchModuleWidth, eightPortsGigabitSwitchModuleLength, moduleHeight, pinsPath =
        false, nutRecess = false, rearDovetails = false, frontDovetails = true);
        xMove = (eightPortsGigabitSwitchModuleWidth - eightPortsGigabitSwitchWidth - wallThickness * 2) / 2;
        yMove = (eightPortsGigabitSwitchModuleLength - eightPortsGigabitSwitchLength - (rodSurroundingDiameter +
            surroundingDiameter) * 2) / 2;
        translate([wallThickness + xMove, rodSurroundingDiameter + surroundingDiameter + yMove, 0])
            eightPortsGigabitSwitchPCB(displayPCB);
    }
}

module eightPortsGigabitSwitchPCB(displayPCB = false) {
    translate([eightPortsGigabitSwitchWidth, 0, 0])
        rotate([0, 0, 90])
            union() {
                translate([0, 0, totalHeight])
                    if (displayPCB) {
                        color("#296E01") difference() {
                            cube([eightPortsGigabitSwitchLength, eightPortsGigabitSwitchWidth, 1.6]);
                            for (currentPoint = eightPortsGigabitSwitchHoles) {
                                translate([currentPoint.x, currentPoint.y, - moduleHeight / 2]) cylinder(d =
                                eightPortsGigabitSwitchHolesDiameter, h = moduleHeight, $fn = 100);
                            }
                        }
                    }
                eightPortsGigabitSwitchPCBFeet();
            }
}

module eightPortsGigabitSwitchPCBFeet() {
    translate([eightPortsGigabitSwitchDistanceFromEdgeX, eightPortsGigabitSwitchDistanceFromEdgeY, 0])
        difference() {
            union() {
                eight_ports_gigabit_switch_feet_bracket();
                //bracket_middle_reinforcement(feet, linkThickness, linkHeight, true);
                //new_link_everyone(new_feet, linkThickness, linkHeight);
                //new_link_everyone([[- 28.0819, - 5, 0], [0, 0, 0]], linkThickness, linkHeight);
                //new_link_everyone([[121.918, - 5, 0], [0, 0, 0]], linkThickness, linkHeight);
                //new_link_everyone([[- 28.0819, - 5, 0], [121.918, - 5, 0]], linkThickness, linkHeight);
                //new_link_everyone([[- 28.0819, - 5, 0], [121.918, - 5, 0], [0, 0, 0]], linkThickness, linkHeight);
                /* all_feet = [[[- 28.0819, - 5, 0], [121.918, - 5, 0]], [[- 28.0819, - 5, 0], [0, 0, 0]], [[- 28.0819, - 5
                     , 0]
                     , [
                         121.918, 53.1966, 0]], [[- 28.0819, - 5, 0], [- 28.0819, 53.1966, 0]], [[121.918, - 5, 0], [0, 0
                     , 0]
                     ], [[
                     121.918, - 5, 0], [121.918, 53.1966, 0]], [[121.918, - 5, 0], [- 28.0819, 53.1966, 0]], [[0, 0, 0],
                         [
                         121.918
                         , 53.1966, 0]], [[0, 0, 0], [- 28.0819, 53.1966, 0]], [[121.918, 53.1966, 0], [- 28.0819,
                     53.1966, 0]]];
                 currentFeet = [[- 28.0819, - 5, 0], [121.918, - 5, 0], [0, 0, 0], [121.918, 53.1966, 0]];*/
                //new_link_everyone(new_feet, linkThickness, linkHeight);
                //bracket_feet(new_feet, holeSize, baseSize, baseHeight, totalHeight);
                echo("New Feet is ", new_feet);


                threeByThree();
            }
            empty_bracket_feet(new_feet, holeSize, baseSize, baseHeight, totalHeight);
        }
    /*currentFeet = [[113.097, 56.2019, 0], [100.193, 45.3288, 0]];
    new_link_everyone(currentFeet, linkThickness, linkHeight);*/
}

// input : nested list
// output : list with the outer level nesting removed
function flatten(l) = [for (a = l) for (b = a) b] ;

module threeByThree() {
    numberOfPointsLinked = 4;
    for (i = [0:len(new_feet) - 1]) {
        indices = vector_nearest(new_feet[i], numberOfPointsLinked, new_feet);

        for (j = [1:numberOfPointsLinked - 1]) {

            echo("First three points for ", new_feet[i], ", are ", indices);
            echo("Treating indice ", indices[j], ", which is ", new_feet[indices[j]]);
            resultingVector = [new_feet[i], new_feet[indices[j]]];
            echo("Resulting vector is ", resultingVector);
            new_mesh_link([new_feet[i], new_feet[indices[j]]], linkThickness, linkHeight, 10/*i + 1*/);
            echo([new_feet[i], new_feet[j]]);
        }
        //new_mesh_link(resultingVector, thickness, height, i);
    }
}