# ToDo List for this project

## To Do

### Server

#### 1U

##### Zero

- Create an intersection between the Zero STL file and a cube, make it transparent so that we can see the beginning of a heatsink base

##### Cables

- Cable management, route them all 	
- Up to 6 computing modules, 1 switch, and one 2040 (?) to handle the 7 fans

##### Rear Modules

- Make a specific module for the switch
- Make a specific module for the power supply

##### Module

- Use [thin-wall](https://github.com/revarbat/BOSL2/wiki/walls.scad#module-thinning_wall) to render the walls
- Use [cuboid](https://github.com/revarbat/BOSL2/wiki/shapes3d.scad) to render the walls
- parameterize the dovetails, front and rear

##### Power Supply Module

- Find a 43mm 10A+ power supply
- Design an end side blocker pad for the threaded rod hosting the two nuts for the X rods and finishing the Y rod (sort of an ear for the rear, so a rearear? ;-) )
- Reinforce the feet of the blower (triangles like the PCB adapters, or truss, or whatever)

##### Fan Module

- Add a nut to the reinforcement
- Get the holes right
- Find a way to reroute the air flow for modules facing the PSU wall

##### Network Switch Module

- Use the eight_ports_gigabit_switch_feet_vertical_bracket as a model to build a stiffer plate to screw the PCB on
- Add "virtual feet" that would lay in the walls so that we can get a stronger platform to screw the PCB on

##### Ears

- Make cheeks so that the threaded rod doesn't hang on nothing
- Make elongated holes

##### Module

- Add the pin track on the right side
- Extract small parts as STL so that we can print and test them (sizes of the holes for the threaded rod, ear, the pin path and so on)
- Add a recess in the module to host a M5 nut, and a hole so that we can add a threaded rod to the front modules row on each wall, on top&bottom if possible
- Add a dovetail at the rear so that we can slide in back modules (with power, network, whatever)

## Done

### Server

#### 1U

##### Module

- Add a dovetail at the rear so that we can slide in back modules (with power, network, whatever)
- Add the pin track on the right side
- Extract small parts as STL so that we can print and test them (sizes of the holes for the threaded rod, ear, the pin path and so on)
- Add a recess in the module to host a M5 nut, and a hole so that we can add a threaded rod to the front modules row on each wall, on top&bottom if possible
- Add a fan module at the rear

##### Power Supply Module

- Add a rear wall to support the IEC plug
- Get the threaded rod hole to get up to front
- Add a side wall to support the PSU
- Make a T-shaped hole in the side to host some sliding pads
- Make some sliding pads to connect the PSU to the side
- Remove dovetails

##### Fan Module

- Shift the holes so that the dovetails don't get drilled
- Extend the male dovetails so that we have a complete width module
- Design a rear for the fan module so that we get a complete module

##### Ears

- Make elongated holes
