#!/bin/sh
pkgdir=("linux-6.6.127")
pkgname=("linux")
pkgver=("6.6.127")
pkgurl=("https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.127.tar.xz")
sha256=('a7cd9c97b4f0b31cc030bcdc60abe5434fffb2556e293f7438ce7909dff8c9fe')
md5sum=('6d97902979bdb0b4658693cb80d38b27')
gitconfig=('https://github.com/raspberrypi/linux/blob/rpi-6.6.y/arch/arm64/configs/bcm2712_defconfig')

echo "Extracting: ${pkgdir}"
xtar /sources/linux-6.6.127.tar.xz

echo "Preparing: ${pkgdir}"
make mrproper
# real    0m34.281s
# user    0m37.036s
# sys     0m38.508s

## Raspberry Pi 4/5
# make bcm2711_defconfig, bcm2712_defconfig
# CONFIG_CMDLINE="console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait"

## zcat /proc/config.gz > /zbuild/aarch64_kernel.config
## cp -v /zbuild/aarch64_kernel.config .config
zcat /proc/config.gz > .config

make defconfig
# real    0m41.074s
# user    0m54.286s
# sys     0m15.519s

## For Systemd-Boot mount the ESP to /boot
mount --mkdir -v -t vfat /dev/vdb1 -o codepage=437,iocharset=iso8859-1 /boot/efi

echo "Building: ${pkgdir}"
make
# real    361m56.260s
# user    1247m33.497s
# sys     147m48.645s

make dtbs_install
# real    0m16.253s
# user    0m22.818s
# sys     0m32.510s

make modules_install
# real    0m41.394s
# user    0m53.261s
# sys     1m12.293s

echo "Installing: ${pkgdir}"
# cp -iv arch/arm64/boot/Image.gz /boot/vmlinuz-6.6.127
cp -iv arch/arm64/boot/Image /boot/vmlinux-6.6.127
cp -iv System.map /boot/System.map-6.6.127
cp -iv .config /boot/config-6.6.127

echo "Setting Up systemd-boot"
# During install, mount the ESP to /mnt/efi and the XBOOTLDR partition to /mnt/boot.
bootctl install
# bootctl --esp-path=/boot/efi --boot-path=/boot install

cat > /boot/loader/loader.conf << BOOT
default  lfs.conf
timeout  5
editor   no
console-mode  max
BOOT
DRIVE="/dev/vdb"; ROOT=$(blkid -o value -s PARTUUID ${DRIVE}3); echo $ROOT
cat > /boot/loader/entries/lfs.conf << BOOT
title   Aarch64 Linux From Scratch
linux   /vmlinux-6.6.127
# initrd  /initramfs-linux.img
options root=PARTUUID=56e24d8b-8f8a-4a28-9292-73df71ea2451 rw
BOOT

## Review Boot Status
bootctl update
bootctl status
efibootmgr | cut -f 1









