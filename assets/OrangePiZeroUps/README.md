This directory will host all the files linked to this subproject of [MerryKombo](https://github.com/MerryKombo).
The goal is to have the [OrangePi Zero](https://www.sbc-community.org/OrangePi%20Zero/#orangepi-zero) check the temperature of a module, control the fan accordingly, and give some information thanks to an I2C screen.
We want to be able to unplug the whole module and let the OrangePi Zero shutdown beautifully, hence the UPS.

The UPS is in fact really simple. We are using a very small 18650 Battery Charger from AEAK that will power the board while charging the battery.

![](https://github.com/MerryKombo/3DDesign/blob/master/assets/OrangePiZeroUps/HTB1HG.ZXjzuK1RjSspeq6ziHVXaI.jpg).

On the main power, we also plug a 5V to 3.3V buckdown converter, so that when the main power goes down, there will be a 3.3V to 0V signal on one of the GPIO pins.

We also use a PWM to V [converter](https://fr.aliexpress.com/item/33021792064.html?spm=a2g0s.9042311.0.0.27426c37a2CQxk), so that we can get from ~0 to ~10V when changing the PWM on the Pi Zero. We hope to control the non PWM fan this way. We know that's not the right way to do it, we should design a board of our own that handles the UPS and the PWM controlling fan, but time flies by...

![](https://github.com/MerryKombo/3DDesign/blob/master/assets/OrangePiZeroUps/HTB1ZJykX8Cw3KVjSZFlq6AJkFXaw.jpg)
