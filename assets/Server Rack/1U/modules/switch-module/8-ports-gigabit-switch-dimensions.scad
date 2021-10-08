include <../module-dimensions.scad>
include <../../boards/8-ports-gigabit-switch-dimensions.scad>

eightPortsGigabitSwitchModuleWidth = eightPortsGigabitSwitchWidth * 1.2 > moduleWidth?ceil(eightPortsGigabitSwitchWidth
    * 1.2 /
    moduleWidth):moduleWidth;
eightPortsGigabitSwitchLengthCeil = ceil(eightPortsGigabitSwitchLength * 1.2 / moduleLength);
eightPortsGigabitSwitchLengthFloorTemp = floor(eightPortsGigabitSwitchLength * 1.2 / moduleLength);
eightPortsGigabitSwitchLengthFloor = eightPortsGigabitSwitchLengthFloorTemp == 0? 1:
        eightPortsGigabitSwitchLengthFloorTemp;
eightPortsGigabitSwitchModuleLengthRatio = (eightPortsGigabitSwitchLengthCeil + eightPortsGigabitSwitchLengthFloor) / 2;
echo("8PortsGigabitSwitchModuleLengthCeil is ", eightPortsGigabitSwitchLengthCeil);
echo("8PortsGigabitSwitchModuleLengthFloor is ", eightPortsGigabitSwitchLengthFloor);
echo("8PortsGigabitSwitchModuleLengthRatio is ", eightPortsGigabitSwitchModuleLengthRatio);
eightPortsGigabitSwitchModuleLength = eightPortsGigabitSwitchModuleLengthRatio * moduleLength;
echo("Module length is then ", eightPortsGigabitSwitchModuleLength);