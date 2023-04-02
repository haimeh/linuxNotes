#!/bin/bash

# the input is the drive to mount
mount /dev/$12 /mnt
mount /dev/$13 /mnt/home
mount /dev/$11 /mnt/boot

# DNS junk
# make sure we can still access the network after chroot
cp --dereference /etc/resolv.conf /mnt/etc/

mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /dev /mnt/dev

# note that /dev/shm is a symbolic link to /run/shm which wont work
# if that is the case, do the following:
#test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
#mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
#chmod 1777 /dev/shm

chroot /mnt /bin/bash
source /etc/profile
