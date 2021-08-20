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
mklabel gpt # dos for mbr
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
# mbr bios boot (and thats not a zero0)
#mkfs.ext4 -L boot -O '^64bit' /dev/sda1

# root and home
mkfs.ext4 /dev/nvme1n1p2
mkfs.ext4 /dev/nvme1n1p3


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Mount and main Install
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# set mountpoints for each partition
# start with root
mount /dev/nvme1n1p2 /mnt
mkdir /mnt/home
mount /dev/nvme1n1p3 /mnt/home
mkdir /mnt/boot
mount /dev/nvme1n1p1 /mnt/boot




# Install stage 3 Gentoo
# d to download q to quit
links https://www.gentoo.org/downloads/
cd /mnt
# x:extract p:preserve v:verbose f:filename(is next)
# xattrs-include:preserve all attributes
# numeric-owner:preserve group ids

tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

# Customize make.conf or copy a premade one
# comment out layman?
# specify cpu gpu?
# ivy to 9th+ : intel i965 iris
cp wherever/you/have/your/make.conf /mnt/etc/portage



# Repo config
mkdir --parents etc/portage/repos.conf
cp /mnt/usr/share/portage/config/repos.conf /mnt/etc/portage/repos.conf/gentoo.conf

# you may like to change to git instead of rsync
	# /etc/portage/repos.conf/gentoo.conf
[DEFAULT]
main-repo = gentoo
[gentoo]
location = /usr/portage
sync-type = git
sync-uri = https://github.com/gentoo-mirror/gentoo.git
auto-sync = yes
#priority = 1000
#sync-git-verify-commit-signature = yes
#sync-openpgp-key-path = /usr/share/openpgp-keys/gentoo-release.asc




#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Install config
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
# the next line is just for show
export PS1="(chroot) ${PS1}"

emerge-webrsync

# localization
# write in en_US.UTF-8 UTF-8
nano /etc/locale.gen
#generate localization
locale-gen
eselect locale list
eselect local set (whatever number has your entry)
env-update && source /etc/profile


# make sure our profile is correct
# hardened openrc etc..
eselect profile list
# update everything
emerge --sync
#emerge --oneshot --nodeps sys-libs/glibc
emerge --verbose --update --deep --newuse @world
# NOTE: you may want to add the -collision-protect under FEATURES inside make.conf
#emerge @preserved-rebuild

# consider adding to /etc/portage/package.license/kernel
#app-arch/unrar unRAR
#sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE
#sys-firmware/intel-microcode intel-ucode



## set timezone
echo "America/Denver" > etc/timezone
emerge --config sys-libs/timezone-data

mkdir /etc/portage/package.license
vim kernel
#sys-kernel/linux-firmware linux-fw-redistributable no-source-code
emerge --autounmask-continue sys-kernel/gentoo-sources sys-kernel/linux-firmware
emerge sys-apps/pciutils
emerge app-arch/lzop app-arch/lz4
emerge app-editors/vim


#### Kernel ###
cd /usr/src/kernel
make menuconfig

### General setup (kern ver 5+ish) ###
? set kern compression to lz4
- disable posix message queues
- disable process_vm* syscalls
- disable uselib syscall (we use glibc)
- disable auditing (unless we want selinux)
? Timers system (periodic timer lets us disable old idle and high rez)
 ### CPU/Task time & stats
  - disable bsd processs acccounting
  - disable export task/process stats
 ### RCU subsystem ###
  - disable initramfs/initrd (if we build in drivers to kernel make sure we use * instead of M)
(remove UUID from /etc/fstab and replace with root=/dev/sda2 or whatever)
(we need to tell grub where to mount /etc/default/grub GRUB_DISABLE_LINUX_UUID=true GRUB_CMDLINE_LINUX="root=/dev/sda2 rootfstype=ext4")
+ compiler opimize for performance (02)
+ slab allocator (slub)
### Processer type and features (note I am using intel) ###
- disable mps table
- disable support for extended x86
+ Processor family Core 2 (intel)
+ Max number of CPUs 8 (or however many threads you have)
? enable Multi-core scheduler (maybe for threadripper..)
- disable reroute for broken boot irq
- disable amd mce
- disable amd performance monitoring
? enable Dell i8k (m17x)
- disable amd microcode
- disable ioperm and iopl emu
- disable lv5 page
- disable numa memory allocation (maybe for threadripper..)
- disable low memory corruption (bios junk)
+ enable mtrr and mttr cleanup (nvidia)
? disable memory protection kyes (security)
? enable efi runtime
- disable kexec system call (for kernel swapping heathens)
- disable kernel crash dumps
- disable relocatable kernel
### Power Management ###
? enable suspend to ram
- disable hybernation
- disable power management debug
+ enable cpuidle driver intel
+ CPU Freq scal
  + default freq gov (performance)
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
  - set number of loop devices to 0
? enable nvme
(lspci -kk and get block devices to enable)
### serial ATA ###
? enable ata acpi Support
? enable SATA Power optical disk drive
### Controllers with non-SFF ###
? enable AHCI SATA
+ SCSI
  + enable Asynchronous SCSI (boot junk)
- disable multiple devices driver (raid)
- disable macintosh drivers
- disable microsoft surface
 ### Input device ###
 ? disable ps2 mice and keyboards (touch pad)
 ? disable joysticks/gamepad
 ### Graphics support ###
 - Max gpu 2
 + enable intel graphics
 + enable virt box graph
### Filesystem ###
+ enable ext4
- disable misc filesystems
? disable network file systems
### Kernel Hacking ###
- set RCU cpu stall timeout to 5
- disable remote firewire debug
### Gentoo stuff ###
- Init systems
 - disable systemd (enable openrc)

### THE FOLLOWING ARE SOME EXTRAS I USE OFTEN ###
 ### for AUDIO ###
 # alsamixer not found
 Device Drivers --->
    <*> Sound card support
        <*> Advanced Linux Sound Architecture --->
            [*] PCI sound devices  --->
                Select the driver for your audio controller.
                [*] Intel/nVidia/AMD Controller
                [*] Intel/nVidia/AMD Modem
            HD-Audio  --->
               Select a codec or enable all and let the generic parse choose the right one:
               [*] Build Realtek HD-audio codec support
               [*] ...
               [*] Build Silicon Labs 3054 HD-modem codec support
               [*] Enable generic HD-audio codec parser
    [*] Pin controllers  --->
        Select Intel or Whatever
### for WIFI ###
[*] Networking support  --->
    [*] Wireless  --->
        <*>   cfg80211 - wireless configuration API
        [*]     enable powersave by default
        <*>   Generic IEEE 802.11 Networking Stack (mac80211)
        [*]   Minstrel
        [*]     Minstrel 802.11n support
Device Drivers  --->
    [*] Network device support  --->
        [*] Wireless LAN  --->
 
            Select the driver for your Wifi network device
            Try lspci and find network controller (the following are 4 my m17x) 
            <*> Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi)
            <*>    Intel Wireless WiFi DVM Firmware support                             
            <*>    Intel Wireless WiFi MVM Firmware support

-*- Cryptographic API --->
    -*- AES cipher algorithms
    -*- AES cipher algorithms (x86_64)
    <*> AES cipher algorithms (AES-NI)
### for CDROM ####
Device Drivers --->
   <*> Serial ATA and Parallel ATA drivers  --->
      [*] ATA ACPI Support
      # If the drive is connected to a SATA Port Multiplier:
      [*] SATA Port Multiplier support
      # Select the driver for the SATA controller, e.g.:
      <*> AHCI SATA support (ahci)
      # If the drive is connected to an IDE controller:
      [*] ATA SFF support
      [*] ATA BMDMA support
      # Select the driver for the IDE controller, e.g.:
        <*> Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support (ata_piix)
   SCSI device support  ---> 
      <*> SCSI device support
      <*> SCSI CDROM support
      <*> SCSI generic support
File systems  --->
   CD-ROM/DVD Filesystems  --->
      <M> ISO 9660 CDROM file system support
      [*] Microsoft Joliet CDROM extensions
      [*] Transparent decompression extension
      <M> UDF file system support
### for NVIDIA ####
[*] Enable loadable module support --->
Processor type and features --->
   [*] MTRR (Memory Type Range Register) support
Device Drivers --->
   Graphics support --->
      [*] VGA Arbitration
Device Drivers --->
   Character devices --->
      [*] IPMI top-level message handler
   Graphics support  --->
        < > Nouveau (nVidia) cards
        Frame buffer Devices --->
            <*> Support for frame buffer devices --->
            < >   nVidia Framebuffer Support
            < >   nVidia Riva support
### for WACOM ### 
Device drivers --->
   HID support --->
      HID bus support --->
         Special HID drivers --->
            <*> Wacom Intuos/Graphire tablet support (USB)
   Input device support --->
      [*] Tablets --->
         <*> Wacom protocol 4 serial tablet support--->
      [*] Touchscreens --->
         <*> Wacom W8001 penabled serial touchscreen
         <*> Wacom Tablet support (I2C)


### BUILD IN FIRMWARE ###
# this is needed since we are not doing modules
Generic Driver Options --->
    Firmware loader --->
        fill in build named firmware, for example
        (wlwifi-6000-4.ucode i915/skl_dmc_ver1_27.bin) Build named firmware blobs into the kernel binary
        (/lib/firmware) Firmware blobs root directory

#%%% YOU ARE DONE!! YOU ARE TRUE 1337 hax0r %%%#
make && make modules_install && make install
eselect kernel set 1
# initramfs would happen here if we didnt build in firmware



# Now fix your fstab, make sure mount
vim /etc/fstab
#/dev/sda1   /boot        ext4    defaults,noatime     0 2
/dev/sda2   /            ext4    noatime              0 1
/dev/sda3   /home        ext4    noatime              0 2
# if you dont want to use the sd*N format:
blkid -s UUID --o value /dev/sda1



# NETWORK STUFF
################ change these?? ##################
# "ip link" to see network interfaces
# wireless starts with w, ethernet with enp or etch

emerge --noreplace net-misc/netifrc
emerge net-misc/dhcpcd
emerge net-wireless/iw net-wireless/wpa_supplicant
vim /etc/conf.d/net
config_enp0s0="dhcp"
config_wlp0s0="dhcp"

# note that these wont auto start without adding junk to init.d and rc-update
# connect to the internet via wifi: 
vim /etc/wpa_supplicant/wifiName.conf
ctrl_interface=/run/wpa_supplicant
update_config=1

# now finishing touches
wpa_passphrase wifiName wifiPass >> /etc/wpa_supplicant/wifiName.conf
wpa_supplicant -B -i wInterfaceName -c /etc/wpa_supplicant/wifiName.conf
# you may need to run dhcpcd after

# connect via ethernet:
dhcpcd netwrokdevicehere
# this gets the ip lease and route and whatnot
##############################################


### network config
# decide on a network name and add via:
vim /etc/hostname
#Add matching entries to:
vim /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	myhostname.localdomain	myhostname
# NOTE, if your system has permanent ip, use it instead of 127.0.1.1


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Bootloader
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# install grub and a tool used by grub for efi
emerge sys-boot/grub:2 sys-boot/efibootmgr
#grub-install --target=i386-pc /dev/sdX
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# you may want to turn off quiet boot mode
# comment out the line containing "quiet splash"
vim /etc/default/grub
#we may need to tell grub where to mount
#GRUB_DISABLE_LINUX_UUID=true 
#GRUB_CMDLINE_LINUX="root=/dev/sda2 rootfstype=ext4")
# generate the grub config file
grub-mkconfig -o /boot/grub/grub.cfg



# USER STUFF
# set root password
passwd

emerge app-admin/sudo
# add main user (with Group wheel for sudo stuff and /bin/bash shell)
useradd -m -G users,wheel,video,audio -s /bin/bash joebob
# set the user password (for joebob)
passwd joebob
# set visudo such that group wheel does sudo stuff
EDITOR=vim visudo
# uncomment %wheel ALL=(ALL) ALL



# exit the chroot session
exit
# unmount everything
umount -a
reboot


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Nice things
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



vim /etc/portage/package.license/kernel
#NVIDIA-r2
emerge x11-drivers/nvidia-drivers
# this line is depreciated.. emerge x11-drivers/xf86-video-intel
# sudo nvidia-xconfig --cool-bits=28
# but even tty1 without xorg may not work correctly

# fan control m17x
emerge sys-apps/lm-sensors
# sudo modprobe dell_smm_hwmon ignore_dmi=1
echo -e 'dell_smm_hwmon' >> /etc/modules-load.d/fan.conf
echo -e 'options dell_smm_hwmon ignore_dmi=1' >> /etc/modprobe.d/fan.conf
app-benchmarks/i7z

# NOTE
# full update : emerge -uD @world
# pickup where left: emerge -u
# to find: emerge --search
# to install: emerge 
# to uninstall: emerge --depclean
# to see where: emerge --info
# after changing make.conf: emerge --changed-use --deep @world

# sound
emerge media-sound/alsa-utils
# for alienware m17x r4, hp needs to be unmuted
# you may also want to turn off motherboard beeper if its bothering you
echo -e 'blacklist pcspkr' >> /etc/modprobe.d/nobeep.conf

# text
#noto-fonts wqy-zenhei
media-fonts/noto-cjk

# window manager
emerge x11-base/xorg-drivers x11-apps/xinit
# you must run in order to launch without /dev/tty0 no permissions junk (x trying to skip the logind)
rc-update add elogind boot
# You may also need to edit xorg.conf for touch pad and to use modsetting 


#get from git
st-gruvy

x11-apps/xrandr
media-gfx/imagemagick
? x11-apps/xwininfo

emerge x11-wm/i3-gaps x11-misc/i3status x11-misc/i3lock x11-misc/dmenu x11-misc/redshift

# images/background
emerge media-gfx/feh

# you may need touchpad?
x11-drivers/xf86-input-synaptics 

# file manager
app-misc/vifm
app-text/tree


# browse
librewolf tor

# network
net-tools nmap gnu-netcat ipcalc iw

# pdf
app-text/zathura app-text/zathura-pdf-poppler

# csv
sc-im

# programming things
dev-python/pip
dev-lang/R

ctags cscope
git gcc python gdb radare cuda cudnn docker nodejs npm r
opencl-nvidia opencl-headers ocl-icd clinfo glslang vulkan-headers vulkan-validation-layers spirv-tools
?vulkan-icd-loader 

dev-util/nvidia-cuda-toolkit 
media-libs/vulkan-loader dev-utils/vulkan-tools
# dotnet
dotnet-sdk mono
# you may also want tk

# read things like ram
dmidecode

# games
gnuchess
gnugo
