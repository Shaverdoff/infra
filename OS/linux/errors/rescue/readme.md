```
https://unix.stackexchange.com/questions/392591/why-booting-into-rescue-mode-menu-doesnt-do-anything
1) in GRUB menu press "e"
2) Use cursor to scroll down and look for line with linux 16, when there move till you see the """""""""ro""""""""""" option and modify that to be:
rw init=/sysroot/bin/sh
Then click CTRL-x to start
3) in root system Now mount the root filesystem with:
chroot /sysroot/
4) when all is done
reboot -f
```
