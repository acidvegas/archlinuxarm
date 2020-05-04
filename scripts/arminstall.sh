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
echo "pi" > root/etc/hostname
echo -e "[Match]\nName=wlan0\n\n[Network]\nDHCP=ipv4\nMulticastDNS=yes\nAddress=10.0.0.100/24\nGateway=10.0.0.1" > root/etc/systemd/network/25-wireless.network
echo -e "[Resolve]\nDNS=8.8.4.4 8.8.8.8 2001:4860:4860::8888 2001:4860:4860::8844\nFallbackDNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001\nMulticastDNS=yes\nDNSSEC=no\nCache=yes" > root/etc/systemd/resolved.conf
ln -sf /run/systemd/resolve/stub-resolv.conf root/etc/resolv.conf
wpa_passphrase MYSSID passphrase > root/etc/wpa_supplicant/wpa_supplicant-wlan0.conf && chmod 600 root/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
ln -s /usr/lib/systemd/system/systemd-networkd.service root/etc/systemd/system/multi-user.target.wants/systemd-networkd.service
ln -s /usr/lib/systemd/system/systemd-resolved.service root/etc/systemd/system/multi-user.target.wants/systemd-resolved.service
ln -s /usr/lib/systemd/system/wpa_supplicant@.service root/etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
umount boot root && rm -r archlinuxarm.tar.gz boot root