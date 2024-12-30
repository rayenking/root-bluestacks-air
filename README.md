Root BlueStacks Air macOS
================

![Screenshot](bluestacks-air-root-magisk.png)



## Requirements
- [BlueStacks Air](https://www.bluestacks.com/mac)
- [Kitsune Mask](https://huskydg.github.io/magisk-files/)



## Rooting
- Install BlueStacks Air
- Open BlueStacks Air for the first time
- Close BlueStacks Air
- Download this repo and extract it
- Copy Kitsune Mask to the project folder, and rename it to `magisk.apk`
- Open **Terminal.app** or **iTerm.app** and navigate to the project folder
  ```bash
  cd ~/Downloads/root-bluestacks-air
  ```
- Execute `root.sh`
  ```bash
  bash root.sh
  ```
- Wait until BlueStacks Air starts
- Install Kitsune Mask (`magisk.apk`)
- Open Kitsune Mask and proceed with additional setup. This will reboot BlueStacks Air, causing it to crash.
- Force quit BlueStacks Air
- Execute `restore_initrd.sh` to relock the rootfs
  ```bash
  bash restore_initrd.sh
  ```
- Open BlueStacks Air and enjoy
- If you need **Zygisk**, enable it from Kitsune Mask settings and reboot BlueStacks Air



## Unrooting
- Make sure BlueStacks Air is closed
- Execute `unroot.sh`
  ```bash
  bash unroot.sh
  ```
- Done



### Buy me a coffee
[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/hanreev)
