Root BlueStacks Air macOS
================

Tested on BlueStacks Air
- 5.21.680.7532
- 5.21.695.7506


![Screenshot](bluestacks-air-root-magisk.png)



## Requirements
- [BlueStacks Air](https://www.bluestacks.com/mac)
- [Kitsune Mask](https://huskydg.github.io/magisk-files/)



## Rooting
- Install BlueStacks Air
- **!! REQUIRED !!** Open BlueStacks Air for the first time
- Close BlueStacks Air
- Download this repo and extract it
- Copy Kitsune Mask to the project folder, and rename it to `magisk.apk`
- Open **Terminal.app** or **iTerm.app** and navigate to the project folder
  ```bash
  cd ~/Downloads/root-bluestacks-air
  ```
- Execute `root.sh`
  ```bash
  sudo bash root.sh
  ```
- Wait until BlueStacks Air starts
- Install Kitsune Mask (`magisk.apk`)
- Open Kitsune Mask and proceed with additional setup. This will reboot BlueStacks Air, ~~causing it to crash~~.
- Force quit BlueStacks Air (unnecessary in the latest version of BlueStacks Air)
- Execute `restore_initrd.sh` to relock the rootfs
  ```bash
  sudo bash restore_initrd.sh
  ```
- Open BlueStacks Air and enjoy
- If you need **Zygisk**, enable it from Kitsune Mask settings and reboot BlueStacks Air



## Unrooting
- Make sure BlueStacks Air is closed
- Execute `unroot.sh`
  ```bash
  sudo bash unroot.sh
  ```
- Done



### Buy me a coffee
[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/hanreev)
