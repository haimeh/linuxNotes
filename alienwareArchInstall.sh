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
# to delete old header thing (just run it for a sec):
dd if=/dev/zero of=/dev/nvme1n1p1 bs=512
# fun fact, this can also be used to copy a partition
# NOTE I do much dev stuff so my root pertition is bigger

cfdisk /dev/sda
# or maybe if its a new ssd
cfdisk /dev/nvme1n1

# once partitions are written, they must be formatted
# efi
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

# edit to make sure your top mirror is closest
vim /etc/pacman.d/mirrorlist

# connect to the internet ethernet or wifi: 
systemctl enable dhcpcd@eth0.service
# or
wifi-menu

# now install arch
# base is the only requirement
# I add base-devel vim wireless_tools wpa_supplicant dialog
# the last three are needed for wifi
pacstrap /mnt base base-devel vim xf86-video-intel  wireless_tools wpa_supplicant dialog
# you may not need to add display driver (xf86-video-intel, nvidia)
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

# sound
alsa-utils pulseaudio-alsa
# for alienware m17x r4, hp needs to be unmuted
# you may also want to turn off motherboard beeper if its bothering you
echo -e 'blacklist pcspkr' >> /etc/modprobe.d/nobeep.conf

# text
noto-fonts wqy-zenhei

# window manager
xorg-server xorg-xinit xterm
# for m17x, you may need to edit xorg.conf
i3-gaps i3status dmenu
# change default xterm colors
echo -e 'xterm*background: black\nxterm*foreground: white\nxterm*selectToClipboard: true' >> ~/.Xdefaults

# images/background
feh

# you may need touchpad?
xf86-input-synaptics 

# file manager
ranger w3m

# browse
firefox surf tor

# network
net-tools nmap gnu-netcat ipcalc iw

# pdf
zathura zathura-pdf-poppler

# csv
sc

# programming things
# git gcc and python should already be installed (base-devel)
r gdb radare cuda cudnn docker nodejs
# dotnet
dotnet-sdk mono
# you may also want tk

# games
gnuchess
gnugo
