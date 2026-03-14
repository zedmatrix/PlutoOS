#!/bin/bash
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=aarch64-lfs-linux-musl
LFS_ARCH=aarch64
LFS_HOST=$(uname -m)-pc-linux-gnu
ZSRC=$LFS/sources

PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site

export MAKEFLAGS=-j$(nproc)
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export LFS_ARCH LFS_HOST
# export MAKEFLAGS=-j4
