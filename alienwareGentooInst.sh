# these notes assume uefi mobo and are particular to:
# Alienware m17x r4 
# Alienware 51m
# my machines have much  ram so swap is skipped


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Partitions
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# first find the drive you wish to mount to
lsblk -f
# or to see partitions another way 
fdisk -l

# next we partition the disk for efi, root, and home
# efi will be EFI system and later formatted vfat (550M)
# root will be Linux root (x86-64) amd formatted ext4 (128G)
# home will be Linux home and formatted ext4 (remainder)
# NOTE you may need to choose gpt as the header thing first
mklabel gpt
# also do it by, to delete old header thing (just run it for a sec):
dd if=/dev/zero of=/dev/nvme1n1p1 bs=512
# fun fact, this can also be used to copy a partition
# NOTE I do much dev stuff so my root pertition is bigger

cfdisk /dev/sda
# or maybe if its a new ssd
cfdisk /dev/nvme1n1

# once partitions are written, they must be formatted
# efi (dosfstools)
mkfs.msdos -F32 /dev/nvme1n1p1
# root and home
mkfs.ext4 /dev/nvme1n1p2
mkfs.ext4 /dev/nvme1n1p3


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Mount and main Install
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# set mountpoints for each partition
# start with root
# mnt is usually already there
mount /dev/nvme1n1p2 /mnt
mkdir /mnt/home
mount /dev/nvme1n1p3 /mnt/home
mkdir /mnt/efi
mount /dev/nvme1n1p1 /mnt/efi


# "ip link" to see network interfaces
# wireless starts with w, ethernet with enp or etch
# connect to the internet via wifi: 
vim /etc/wpa_supplicant/wifiName.conf
ctrl_interface=/run/wpa_supplicant
update_config=1

# now finishing touches
wpa_passphrase wifiName wifiPass >> /etc/wpa_supplicant/wifiName.conf
wpa_supplicant -B -i wInterface123 -c /etc/wpa_supplicant/wifiName.conf
# you may need to run dhcpcd after

# connect via ethernet:
dhcpcd enpOReth
# this gets the ip lease and route and whatnot

# Unpack stage 3 Gentoo

# Customize make.conf

# Compile Kernel
cd /usr/src/kernel
make menuconfig

### General setup (kern ver 5ish) ###
+ set kern compression to lz4
- disable posix message queues
- disable process_vm* syscalls
- disable uselib syscall (we use glibc)
- disable auditing (unless we want selinux)
? Timers system (periodic timer lets us disable old idle and high rez)
- disable bsd processs acccounting
- disable export task/process stats
- disable initramfs/initrd (if we build in drivers to kernel make sure we use * instead of M)
( we need to tell grub where to mount vim /etc/default/grub GRUB_CMDLINE_LINUX="root=/dev/sda1 rootfstype=ext4")
+ compiler opimize for performance
+ slab allocator (slub)
### Processer type and features ###
- disable mps
- disable support for extended x86
+ Processor family Core 2
+ Max number of CPUs 8 (or however many threads you have)
? disable Multi-core scheduler (maybe for threadripper..)
- disable reroute for broken boot irq
- disable amd mce
- disable amd performance monitoring
- disable amd microcode
- disable ioperm and iopl emu
- disable lv5 page
- disable numa memory allocation (maybe for threadripper..)
- disable low memory corruption (bios junk)
+ enable mtrr and mttr cleanup (nvidia)
? disable memory protection
? enable efi runtime
- disable kexec system call (for kernel swapping heathens)
- disable kernel crash dumps
- disable relocatable kernel
? enable suspend to ram
- disable hybernation
- disable power management debug
+ enable cpuidle driver intel
### Virtualization ###
+ enable host kernel accelerator (virtual machines) (*)
### Enable Loadable module ###
- disable forced module unloading
### Enable block layer ###
- disable block layer debug
### Network ###
- disable am radio
? disable bluetooth
### Device drivers ###
- disable pccard
- block devices 
- - set number of loop devices to 0
? enable nvme
+ SCSI
  + enable Asynchronous SCSI (boot junk)
- disable multiple devices driver (raid)
- disable macintosh drivers
 ### Input device ###
 - disable ps2 mice and keyboards
 ? disable joysticks/gamepad
 - tablets/touchscreens
   + enable wacom 
 ### Input device ###
 + HID support
  + HID bus support
   + Special HID driver
    + enable wacom
 ### Graphics support ###
 + enable vga arbitration (nvidia)
 - Max gpu 2
 + enable intel graphics
 + enable virt box graph
### Filesystem ###
+ enable ext4
- disable misc filesystems
? disable network file systems
### Kernel Hacking ###
- set RCU cpu stall timeout to 5
### Gentoo stuff ###
- Init systems
 - disable systemd (enable openrc)

#%%% YOU ARE DONE!! YOU ARE TRUE 1337 haxor %%%#
make && make modules_install && make install






sudo nvidia-xconfig --cool-bits=28
# but even tty1 without xorg may not work correctly

# now that we have the needed files setup
# we need the mounting of these drives to be fully auto
# genfstab -U generates the mount commands by id for /mnt
# >> copies the output to the specified file
genfstab -U /mnt >> /mnt/etc/fstab


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Install config
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

arch-chroot /mnt

# set timezone
ln -sf /usr/share/zoneinfo/America/bigcity /etc/localtime
hwclock --systohc
# you may wish to synchronize
timedatectl set-ntp true


# localization
# uncomment en_US.UTF-8 UTF-8
vim /etc/locale.gen
#generate localization
locale-gen

# add LANG=en_US.UTF-8 via:
vim /etc/locale.conf
# or
export LANG=en_US.UTF-8

# network config
# decide on a network name and add via:
vim /etc/hostname

#Add matching entries to:
vim /etc/hosts
# should look like :
127.0.0.1	localhost
::1		localhost
127.0.1.1	myhostname.localdomain	myhostname
# NOTE, if your system has permanent ip, use it instead of 127.0.1.1

# set root password
passwd

# add main user (with Group wheel for sudo stuff and /bin/bash shell)
useradd -m -G wheel,power -s /bin/bash joebob
# set the user password (for joebob)
passwd joebob

# set visudo such that group wheel does sudo stuff
EDITOR=vim visudo
# uncomment %wheel ALL=(ALL) ALL


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Bootloader
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# install grub and a tool used by grub for efi
# as a ref for no efi: i386-pc /dev/nvmeMeh
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
# you may want to turn off quiet boot mode
# comment out the line containing "quiet splash"
vim /etc/default/grub
# generate the grub config file
grub-mkconfig -o /boot/grub/grub.cfg


# exit the chroot session
exit
# unmount everything
umount -a
reboot


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Nice things
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


# fan control
# sudo modprobe dell_smm_hwmon ignore_dmi=1
echo -e 'dell_smm_hwmon' >> /etc/modules-load.d/fan.conf
echo -e 'options dell_smm_hwmon ignore_dmi=1' >> /etc/modprobe.d/fan.conf

# NOTE
# to install: pacman -S
# to uninstall: pacman -Rsun (removes any orphaned dependencies)
# to see where: pacman -Ql

# sound
alsa-utils pulseaudio-alsa
# for alienware m17x r4, hp needs to be unmuted
# you may also want to turn off motherboard beeper if its bothering you
echo -e 'blacklist pcspkr' >> /etc/modprobe.d/nobeep.conf

# text
noto-fonts wqy-zenhei

# window manager
xorg-server xorg-xinit st-gruvy
# for m17x, you may need to edit xorg.conf
i3-gaps i3status dmenu
# change default xterm colors
# echo -e 'xterm*background: black\nxterm*foreground: white\nxterm*selectToClipboard: true' >> ~/.Xdefaults

# images/background
feh

# you may need touchpad?
xf86-input-synaptics 

# file manager
vifm

# browse
firefox tor

# network
net-tools nmap gnu-netcat ipcalc iw

# pdf
zathura zathura-pdf-poppler

# csv
sc-im

# programming things
ctags cscope
# git gcc and python should already be installed (base-devel)
gdb radare cuda cudnn docker nodejs npm r
opencl-nvidia opencl-headers ocl-icd clinfo vulkan-headers vulkan-validation-layers spirv-tools
?vulkan-icd-loader 
# dotnet
dotnet-sdk mono
# you may also want tk

# read things like ram
dmidecode

# games
gnuchess
gnugo
