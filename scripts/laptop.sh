#!/bin/sh
set -xev
DEVICE='/dev/sda'

wifi
timedatctl set-ntp true
fisk $DEVICE
mkfs.fat -F32 ${DEVICE}1
mkfs.ext4 ${DEVICE}2
mount ${DEVICE}2 /mnt
mkdir /mnt/boot
mount ${DEVICE}1 /mnt/boot
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && echo "LANG=en_US.UTF-8"  > /etc/locale.conf && locale-gen
echo "hacktop" > /etc/hostname
echo "127.0.0.1	localhost\n::1			localhost\n127.0.1.1	hacktop.localdomain	hacktop" > /etc/hosts
passwd
pacman -S efibootmgr nano wget wpa_supplicant
lsblk -dno PARTUUID /dev/sda1
efibootmgr --disk $DEVICE --part 1 --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX rw initrd=\amd-ucode.img initrd=\initramfs-linux.img' --verbose
efibootmgr -b 0001 -B # This is to delete a specific boot entry