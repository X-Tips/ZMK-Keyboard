X.Tips X3n2 Keyboard

Keyboard Maintainer: X.Tips

URL: www.umux.com

电池开关在键盘typec插座底下，充电或使用蓝牙模式时，拨到左边打开电源。

采用ZMK固件、proMicro nrf52840模块设计，全键可编程，改键需要使用者自己掌握修改与编译代码的知识。

ZMK知识请自行B站搜视频或网上搜索资料学习，不提供关于ZMK的技术支持。

The battery switch is located under the Type-C socket on the keyboard.

When charging or using Bluetooth mode, turn on the power. 

ZMK firmware and proMicro nrf52840coreboard design, providing source code: https://github.com/X-Tips/ZMK-Keyboard.

Changing keymaps requires users to master the knowledge of modifying and compiling ZMK code themselves.

Please search for videos or knowledge about ZMK to learn. We do not provide technical support for ZMK.



keymap里设置了Bootloader按键，按一下即可进入bl状态；也可以打开后盖，快速短接两次Reset和gnd，进入bl。
The keymap has a Bootloader button—press it once to enter bootloader mode. Alternatively, open the back cover and quickly short Reset and GND twice to enter bootloader mode.
