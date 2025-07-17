#!/bin/bash
zmsg() { printf "*** %s ***\n" "${@}"; }

pkgdir="linux-6.6.97"
pkgname="linux"
pkgver="6.6.97"
pkgurl="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.97.tar.xz"
md5sum="459b0db8af84d16459ddf8a70c3abfbf"

zbuild=${zbuild:-/zbuild}
zsrc=${zsrc:-/sources}

# extract
archive=$(basename $pkgurl)

if [[ ! -f "${zsrc}/${archive}" ]]; then
    zmsg "Downloading: ${archive} "
    [ ! -x "/usr/bin/wget" ] && { zmsg "You Should Have Installed Wget. Missing. Exiting."; exit 1; }
    wget -P ${zsrc} ${pkgurl}
fi

zmsg "Extracting: ${pkgdir}"
pushd /usr/src || exit 1

tar xf ${zsrc}/${archive} || exit 1

ln -sv /usr/src/${pkgdir} linux

zmsg "Preparing: ${pkgdir}"
cd linux

make mrproper

cp -v ${ZBUILD}/stage3/config-6.6.94 .config || exit 1
make olddefconfig

zmsg "Building: ${pkgdir}"
make || exit 1
make modules_install

zmsg "Installing: ${pkgdir}"
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-${pkgver}-pluto
cp -iv System.map /boot/System.map-${pkgver}
cp -iv .config /boot/config-${pkgver}

popd
