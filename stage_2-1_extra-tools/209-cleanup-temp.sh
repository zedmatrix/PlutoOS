#!/bin/sh

echo "Cleaning Up Temporary Cross Tools"

rm -rf /usr/share/{info,man,doc}/*

find /usr/{lib,libexec} -name \*.la -delete

rm -rf /tools

#	Exit From CH Root

echo "Swapping Sources Drive"
umount -v /mnt/lfs/sources
mount -v /dev/vdc1 /mnt/sources

echo "Saving Temporary System"

cd $LFS
tar -cJpf /mnt/sources/Zlfs-crosstools-arm64-musl-sysv.tar.xz .

echo "Finished Cleaning Up From Temporary Tools"
umount -v /mnt/sources
sleep 1
mount -v /dev/vdc1 /mnt/lfs/sources
