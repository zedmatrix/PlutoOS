# Initialization
> Create Partition Layout
> export DRIVE=/dev/sdX
> cd stage0 && ./01_mount-create-directories.sh
> ./02_limited-packages.sh

# Source File Links
Command: `wget -P $LFS/sources -nc ${url}`

>   Cross Compile Packages
```
https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.97.tar.xz
https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz
https://ftp.gnu.org/gnu/gcc/gcc-14.3.0/gcc-14.3.0.tar.xz
https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz
https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz
https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz
https://ftp.gnu.org/gnu/m4/m4-1.4.20.tar.xz
https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz
https://ftp.gnu.org/gnu/bash/bash-5.2.37.tar.gz
https://ftp.gnu.org/gnu/coreutils/coreutils-9.7.tar.xz
https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz
https://astron.com/pub/file/file-5.46.tar.gz
https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz
https://ftp.gnu.org/gnu/gawk/gawk-5.3.1.tar.xz
https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz
https://ftp.gnu.org/gnu/gzip/gzip-1.13.tar.xz
https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz
https://ftp.gnu.org/gnu/patch/patch-2.8.tar.xz
https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz
https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz
https://github.com//tukaani-project/xz/releases/download/v5.8.1/xz-5.8.1.tar.xz
```
>   Chroot Packages
```
https://ftp.gnu.org/gnu/gettext/gettext-0.25.tar.xz
https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz
https://www.cpan.org/src/5.0/perl-5.40.1.tar.xz
https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tar.xz
https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz
https://www.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.tar.xz
https://www.greenwoodsoftware.com/less/less-678.tar.gz
https://www.nano-editor.org/dist/v8/nano-8.5.tar.xz
```
