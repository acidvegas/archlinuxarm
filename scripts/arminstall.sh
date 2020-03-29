#!/bin/sh
set -xev
DEVICE="/dev/sda"
pacman -S dosfstools
echo -e "o\nn\np\n1\n+100M\nt\nc\nn\np\n2\n\nw\n" | fdisk -w always -W always $DEVICE
mkdir boot root
mkfs.vfat ${DEVICE}1 && mount ${DEVICE}1 boot
mkfs.ext4 ${DEVICE}2 && mount ${DEVICE}2 root
wget -O archlinuxarm.tar.gz http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
bsdtar -xpf archlinuxarm.tar.gz -C root
sync
mv root/boot/* boot
umount boot root && rm -r archlinuxarm.tar.gz boot root